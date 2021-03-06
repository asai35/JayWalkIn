//
//  CouponVC.m
//  Jwalkin
//
//  Created by Asai on 12/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//

#import "CouponVC.h"
#import "UrlFile.h"
#import "SBJson5.h"
#import "InfoVC.h"
#import "DirectionMapVC.h"
#import "CommentVC.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "Reachability.h"
#import "ManageOfferVC.h"
#import "SignupVC.h"
#import "ImageWebViewController.h"
#import "DirectionMapVC.h"
#import "RegexKitLite.h"
#import "PunchCardCellTableViewCell.h"
@interface CouponVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *uid;
    NSString *rating;
    NSMutableDictionary *merchant_punches;
    ZBarReaderViewController *codeReader;
}
@end

@implementation CouponVC
@synthesize scrl,strMName,btnFav,btnInfo,scrlBG,strMId;
@synthesize arrTempMerchantDetail;
@synthesize tempMerchantTag;
@synthesize lblCouponMAddress,lblCouponMName,lblPercentage,lblTotalWalkin, btnDirection;


- (void)viewDidLoad
{
    [super viewDidLoad];
    imgViewBackImg.layer.cornerRadius = 5.0;
    merchant_punches =[[NSMutableDictionary alloc] init];
    UITapGestureRecognizer *tvp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(prevSelect:)];
    [tvp setNumberOfTapsRequired:1];
    [viewPrev addGestureRecognizer:tvp];
    UITapGestureRecognizer *tvn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextSelect:)];
    [tvn setNumberOfTapsRequired:1];
    [viewNext addGestureRecognizer:tvn];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self getdata];
}
- (void)getdata{
    
    arrLikeLable=[[NSMutableArray alloc]init];
    arrLikeValue=[[NSMutableArray alloc]init];
    arrLikeBtn=[[NSMutableArray alloc]init];
    NSString *str =[[NSUserDefaults standardUserDefaults] valueForKey:@"fbname"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"loggedin"] || str.length != 0)
    {
        uid = [[NSUserDefaults standardUserDefaults] valueForKey:@"user-Id"];
    }
    else
    {
        uid =@"0";
    }
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    NSUserDefaults *De = [NSUserDefaults standardUserDefaults];
    NSString *curmerchantid = [De objectForKey:@"merchantid"];
    if ([strMId isEqualToString:curmerchantid])
    {  //dp
        //btnOffer.hidden = YES;
        btnRateGreen.hidden=YES;
        btnRateRed.hidden=YES;
        btnRateYellow.hidden=YES;
        lblRate.hidden=YES;
        imgVRateBig.hidden=YES;
        imgVRateSmall.hidden=YES;
        
    }
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"" message:@"Please check your internet connection." cancel:@"OK" other:nil];
        //        [btnBack setEnabled:YES];
        //        [btnCheckIn setEnabled:YES];
    }
    else
    {
        wrpr = [[WrapperClass alloc] initwithDev];
        NSMutableDictionary *dic_K = [arrTempMerchantDetail objectAtIndex:tempMerchantTag];
        NSString * mid = [dic_K valueForKey:@"merchant_id"];
        NSMutableArray *arrIDs = [wrpr GetIds];
        
        if ([arrIDs containsObject:mid])
        {
            [btnFavBottom setImage:[UIImage imageNamed:@"btn_favourite_touch"] forState:UIControlStateNormal];
        }
        else
        {
            [btnFavBottom setImage:[UIImage imageNamed:@"btn_favourite_normal"] forState:UIControlStateNormal];
        }
        arrVideoUrl = [[NSMutableArray alloc] init];
        urlCount=0;
        imagecount = 0;
        if (appdelegate().isFromFav == 1)
        {
            [btnFav setImage:[UIImage imageNamed:@"btn_favourite_touch"] forState:UIControlStateNormal];
        }
        else
        {
            [btnFav setImage:[UIImage imageNamed:@"btn_favourite_normal"] forState:UIControlStateNormal];
        }
        
        arrAllData = [[NSMutableArray alloc] init];
        dataDictionary = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [_navTitle setTitle:self.strMName];
        if (tempMerchantTag == ([arrTempMerchantDetail count] - 1)) {
            [viewNext setHidden:YES];
        }else{
            [viewNext setHidden:NO];
            [lblNextMerchant setText:[arrTempMerchantDetail objectAtIndex:tempMerchantTag + 1][@"merchant_name"]];
        }
        if (tempMerchantTag == 0) {
            [viewPrev setHidden:YES];
        }else{
            [viewPrev setHidden:NO];
            [lblPreMerchant setText:[arrTempMerchantDetail objectAtIndex:tempMerchantTag - 1][@"merchant_name"]];
        }
        
        netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponse:) WithCallBackObject:self];
        netUtills.tag = 1;
        [dict setObject:strMId forKey:@"merchant_id"];
        [dict setObject:uid forKey:@"userid"];
        [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl, bilboards] WithDictionary:dict];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- API Response

-(void)ParseResponseUserLike:(id)sender
{
    NetworkUtills *utills=(NetworkUtills *)sender;
    [self ParseResultLike:utills.strResponse];
}

-(void)ParseResultLike:(NSString *)strResponse
{
    NSError *error = nil;
    NSData *data = [strResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    //    NSMutableDictionary *dict = [strResponse JSONValue];
    if ([[dict valueForKey:@"status"] isEqualToString:@"1"])
    {
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Jaywalk.In" message:@"Like  successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        alert.tag = 91;
        //        [alert show];
        
        UIButton *btn = [arrLikeBtn objectAtIndex:CurrentPage];//(UIButton *)sender;
        UILabel *lbl = [arrLikeLable objectAtIndex:CurrentPage];
        int val=[[arrLikeValue objectAtIndex:CurrentPage] intValue];
        if ([btn isSelected])
        {
            [btn setSelected:NO];
            val--;
            lbl.text = [NSString stringWithFormat:@"%d Likes",val];
            [arrLikeValue replaceObjectAtIndex:CurrentPage withObject:[NSNumber numberWithInt:val]];
        }
        else
        {
            [btn setSelected:YES];
            val++;
            lbl.text = [NSString stringWithFormat:@"%d Likes",val];
            [arrLikeValue replaceObjectAtIndex:CurrentPage withObject:[NSNumber numberWithInt:val]];
        }
        
    }
    else
    {
        [self showAlert:@"Jaywlak.In" message:[dict valueForKey:@"message"] cancel:@"OK" other:nil];
    }
}

-(void)ParseResponse:(id)sender
{
    NetworkUtills *utills=(NetworkUtills *)sender;
    [self ParseResult:utills.strResponse];
}

-(void)ParseResult:(NSString *)strResponse
{
    if (netUtills.tag == 1)
    {
        NSError *error = nil;
        NSData *data = [strResponse dataUsingEncoding:NSUTF8StringEncoding];
        mainDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        rating =[NSString stringWithFormat:@"%@",[mainDict objectForKey:@"User_rating"]];
        if (([mainDict valueForKey:@"Billboards"] == [NSNull null]) )
        {
        }
        else
        {
            arrAllData = [mainDict valueForKey:@"Billboards"];
            if ([arrAllData isKindOfClass:[NSString class]])
            {
                
                //                [btnBack setEnabled:YES];
                //                [btnCheckIn setEnabled:YES];
                [btnRateGreen setEnabled:NO];
                [btnRateRed setEnabled:NO];
                [btnRateYellow setEnabled:NO];
                [self showAlert:@"Empower Main Street" message:@"Offers and more Coming soon!" cancel:@"OK" other:nil];
                
                return;
            }
        }
    }
    else if (netUtills.tag == 2)
    {
        NSError *error = nil;
        NSData *data = [strResponse dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[d valueForKey:@"messsage"] isEqualToString:@"success"])
        {
            [self showAlert:@"Empower Main Street" message:@"Check In registered." cancel:@"OK" other:nil];
        }
        else
        {
            [self showAlert:@"Empower Main Street" message:@"You have already checked In." cancel:@"OK" other:nil];
        }
    }
    else if (netUtills.tag == 3)
    {
        NSError *error = nil;
        NSData *data = [strResponse dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[dict valueForKey:@"message"] isEqualToString:@"Success"])
        {
            [self showAlert:@"Jaywlak.In" message:@"Rating registered successfully" cancel:@"OK" other:nil];
        }
        else
        {
            [self showAlert:@"Jaywlak.In" message:[dict valueForKey:@"message"] cancel:@"OK" other:nil];
        }
    }
    [self SetPageControl];
    //    btnBack.userInteractionEnabled=YES;
    //    btnCheckIn.userInteractionEnabled=YES;
}
- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
    // Ignore NSURLErrorDomain error -999.
    if (error.code == NSURLErrorCancelled) return;

    // Ignore "Fame Load Interrupted" errors. Seen after app store links.
    if (error.code == 102 && [error.domain isEqual:@"WebKitErrorDomain"]) {
        
        return;
    }

    // Normal error handlingÉ
}

#pragma mark- Set Page

-(void)SetPageControl
{
    
    
    self.scrl.pagingEnabled = YES;
    self.scrl.delegate = self;
    self.scrl.backgroundColor = [ UIColor clearColor];
    
    
    
    self.scrl.contentSize = CGSizeMake(self.scrl.frame.size.width,self.scrl.frame.size.height*[arrAllData count]);
    for (UIView *v in scrl.subviews)
    {
        if (![v isKindOfClass:[UIImageView class]])
        {
            [v removeFromSuperview];
        }
    }
    
    if ([arrAllData count] > 0)
    {
        for (int i=0; i<[arrAllData count]; i++)
            
        {
            view1 =[[UIView alloc] init];
            view1.frame=CGRectMake(0, self.scrl.frame.size.height*i, self.scrl.frame.size.width-4,self.scrl.frame.size.height-40);
            view1.backgroundColor=[UIColor clearColor];
            dataDictionary = [arrAllData objectAtIndex:i];
            UILabel *lblTitle = [[UILabel alloc] init];
            lblTitle.frame = CGRectMake(10, 0, 220, 20);
            lblTitle.backgroundColor = [UIColor clearColor];
            lblTitle.font = [UIFont fontWithName:@"Helvetica" size:16.0];
            lblTitle.textColor = [UIColor whiteColor];
            
            btnLikeBillBoard = [[UIButton alloc] init];
            //            if (self.view.frame.size.height > 568)
            //            {
            //                btnLikeBillBoard.frame =CGRectMake(300, 0, 20, 20);
            //
            //            }
            //            else
            //            {
            //                btnLikeBillBoard.frame =CGRectMake(220, 0, 20, 20);
            //
            //            }
            btnLikeBillBoard.frame =CGRectMake(self.scrl.frame.size.width-75, 0, 20, 20);
            
            [btnLikeBillBoard setImage:[UIImage imageNamed:@"light_glow"] forState:UIControlStateNormal];
            [btnLikeBillBoard setImage:[UIImage imageNamed:@"light_g"] forState:UIControlStateSelected];
            lblLike = [[UILabel alloc] init];
            lblLike.frame = CGRectMake(self.scrl.frame.size.width-64, 0, 60, 20);
            lblLike.backgroundColor = [UIColor clearColor];
            lblLike.font = [UIFont fontWithName:@"Helvetica" size:12.0];
            lblLike.textColor = [UIColor whiteColor];
            lblLike.textAlignment = NSTextAlignmentRight;
            
            btnLikeBillBoard.selected=NO;
            
            
            [view1 addSubview:lblLike];
            [view1 addSubview:btnLikeBillBoard];
            if ([[dataDictionary valueForKey:@"BillboardType"] isEqualToString:@"Discount"])
            {
                view1.tag=1;
                lblTitle.text = [dataDictionary valueForKey:@"Title"];
                likeVal =[[dataDictionary valueForKey:@"Likecount"] intValue];
                lblLike.text = [NSString stringWithFormat:@"%d Likes",likeVal];
                likeValBefore= likeVal;
                int isLikeStatus = [[dataDictionary valueForKey:@"Userlike"] intValue];
                if (isLikeStatus)
                {
                    [btnLikeBillBoard setSelected:YES];
                }
                else
                {
                    [btnLikeBillBoard setSelected:NO];
                }
                
                [btnLikeBillBoard addTarget:self action:@selector(btnLikeClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doDoubleTap)];
                doubleTap.numberOfTapsRequired = 2;
                doubleTap.delegate =self;
                [view1 addGestureRecognizer:doubleTap];
                
                UIWebView *wb;
                if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Discount_image"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"]  || ![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Discount_thumb"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"] )
                {
                    wb = [[UIWebView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-10, 70)];
                }
                else
                {
                    wb = [[UIWebView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-10, view1.frame.size.height-8)];
                }
                wb.backgroundColor = [UIColor clearColor];
                wb.opaque=NO;
                wb.delegate = self;
                [wb loadHTMLString:[NSString stringWithFormat:@"<html><body text=\"#FFFFFF\">%@</body></html>",[dataDictionary valueForKey:@"Description"]] baseURL:nil];
                [view1 addSubview:lblTitle];
                [view1 addSubview:wb];
                [self.scrl addSubview:view1];
                //cp
                BOOL isImage =NO;
                //image
                if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Discount_image"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                {
                    UIImageView *img=[[UIImageView alloc] init];
                    if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Discount_thumb"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-7, view1.frame.size.height/2-50);
                    }
                    else
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-7, view1.frame.size.height-70);
                    }
                    img.backgroundColor=[UIColor blackColor];
                    img.tag=999;
                    //img.contentMode = UIViewContentModeScaleToFill;
                    [img setContentMode:UIViewContentModeScaleAspectFit];
                    
                    NSString *thumbURL=[[dataDictionary valueForKey:@"Discount_image"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
                    NSURL *url = [NSURL URLWithString:thumbURL];
                    [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
                    [view1 addSubview:img];
                    [self.scrl addSubview:view1];
                    isImage =YES;
                }
                //video
                if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Discount_thumb"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                {
                    UIImageView *img=[[UIImageView alloc] init];
                    if (isImage)
                    {
                        img.frame=CGRectMake(5,view1.frame.size.height/2+70, view1.frame.size.width-7, view1.frame.size.height/2-50);
                    }
                    else
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-7, view1.frame.size.height-70);
                    }
                    img.backgroundColor=[UIColor blackColor];
                    img.tag=999;
                    //img.contentMode = UIViewContentModeScaleToFill;
                    [img setContentMode:UIViewContentModeScaleAspectFit];
                    NSString *thumbURL=[[dataDictionary valueForKey:@"Discount_thumb"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
                    NSURL *url = [NSURL URLWithString:thumbURL];
                    [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
                    NSString *urlVideo = [dataDictionary valueForKey:@"Discount_video"];
                    [arrVideoUrl addObject:urlVideo];
                    UIButton *button = [[UIButton alloc] init];
                    [ button setImage:[UIImage imageNamed:@"btn_video_play" ] forState:UIControlStateNormal];
                    [button setBackgroundColor:[UIColor clearColor]];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    button.frame = CGRectMake((img.frame.size.width/2)-37, (img.frame.size.height/2)-37,75, 75);
                    button.tag= urlCount;
                    urlCount++;
                    button.enabled = YES;
                    button.userInteractionEnabled = YES;
                    [button addTarget:self action:@selector(btnPlayVideoClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [self.scrl addSubview:view1];
                    [view1 addSubview:lblTitle];
                    [img addSubview:button];
                    [view1 addSubview:img];
                    [view1 bringSubviewToFront:button];
                    img.userInteractionEnabled=YES;
                }
                //cp
            }
            if ([[dataDictionary valueForKey:@"BillboardType"] isEqualToString:@"Promos"])
            {
                view1.tag=2;
                lblTitle.text = [dataDictionary valueForKey:@"Title"];
                likeVal =[[dataDictionary valueForKey:@"Likecount"] intValue];
                lblLike.text = [NSString stringWithFormat:@"%d Likes",likeVal];
                likeValBefore= likeVal;
                int isLikeStatus = [[dataDictionary valueForKey:@"Userlike"] intValue];
                if (isLikeStatus)
                {
                    [btnLikeBillBoard setSelected:YES];
                }
                else
                {
                    [btnLikeBillBoard setSelected:NO];
                }
                
                [btnLikeBillBoard addTarget:self action:@selector(btnLikeClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doDoubleTap)];
                doubleTap.numberOfTapsRequired = 2;
                doubleTap.delegate =self;
                [view1 addGestureRecognizer:doubleTap];
                
                UIWebView *wb;
                if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Promo_image"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"]  || ![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Promo_thumb"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"] )
                {
                    wb = [[UIWebView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-10, 70)];
                }
                else
                {
                    wb = [[UIWebView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-10, view1.frame.size.height-8)];
                }
                wb.backgroundColor = [UIColor clearColor];
                wb.opaque=NO;
                wb.delegate = self;
                
                [wb loadHTMLString:[NSString stringWithFormat:@"<html><body text=\"#FFFFFF\">%@</body></html>",[dataDictionary valueForKey:@"Description"]] baseURL:nil];
                [view1 addSubview:lblTitle];
                [view1 addSubview:wb];
                [self.scrl addSubview:view1];
                BOOL isImage =NO;
                //cp
                //image
                if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Promo_image"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                {
                    UIImageView *img=[[UIImageView alloc] init];
                    if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Promo_thumb"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-7, view1.frame.size.height/2-50);
                    }
                    else
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-7, view1.frame.size.height-70);
                    }
                    img.backgroundColor=[UIColor blackColor];
                    img.tag=999;
                    img.contentMode = UIViewContentModeScaleToFill;
                    [img setContentMode:UIViewContentModeScaleAspectFit];
                    NSString *thumbURL=[[dataDictionary valueForKey:@"Promo_image"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
                    NSURL *url = [NSURL URLWithString:thumbURL];
                    [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
                    [view1 addSubview:img];
                    [self.scrl addSubview:view1];
                    isImage =YES;
                }
                //video
                if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Promo_thumb"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                {
                    UIImageView *img=[[UIImageView alloc] init];
                    if (isImage)
                    {
                        img.frame=CGRectMake(5,view1.frame.size.height/2+70, view1.frame.size.width-7, view1.frame.size.height/2-50);
                    }
                    else
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-7, view1.frame.size.height-70);
                    }
                    img.backgroundColor=[UIColor blackColor];
                    img.tag=999;
                    img.contentMode = UIViewContentModeScaleToFill;
                    [img setContentMode:UIViewContentModeScaleAspectFit];
                    NSString *thumbURL=[[dataDictionary valueForKey:@"Promo_thumb"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
                    NSURL *url = [NSURL URLWithString:thumbURL];
                    [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
                    NSString *urlVideo = [dataDictionary valueForKey:@"Promo_video"];
                    [arrVideoUrl addObject:urlVideo];
                    UIButton *button = [[UIButton alloc] init];
                    [ button setImage:[UIImage imageNamed:@"btn_video_play" ] forState:UIControlStateNormal];
                    [button setBackgroundColor:[UIColor clearColor]];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    button.frame = CGRectMake((img.frame.size.width/2)-37, (img.frame.size.height/2)-37,75, 75);
                    button.tag= urlCount;
                    urlCount++;
                    button.enabled = YES;
                    button.userInteractionEnabled = YES;
                    [button addTarget:self action:@selector(btnPlayVideoClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [self.scrl addSubview:view1];
                    [view1 addSubview:lblTitle];
                    [img addSubview:button];
                    [view1 addSubview:img];
                    [view1 bringSubviewToFront:button];
                    img.userInteractionEnabled=YES;
                }
                //cp
            }
            if ([[dataDictionary valueForKey:@"BillboardType"] isEqualToString:@"News"] || [[dataDictionary valueForKey:@"BillboardType"] isEqualToString:@"Deal"] || [[dataDictionary valueForKey:@"BillboardType"] isEqualToString:@"Event"] || [[dataDictionary valueForKey:@"BillboardType"] isEqualToString:@"Website"])
            {
                view1.tag=9;
                lblTitle.text = [dataDictionary valueForKey:@"Title"];
                likeVal =[[dataDictionary valueForKey:@"Likecount"] intValue];
                lblLike.text = [NSString stringWithFormat:@"%d Likes",likeVal];
                likeValBefore= likeVal;
                int isLikeStatus = [[dataDictionary valueForKey:@"Userlike"] intValue];
                if (isLikeStatus)
                {
                    [btnLikeBillBoard setSelected:YES];
                }
                else
                {
                    [btnLikeBillBoard setSelected:NO];
                }
                
                [btnLikeBillBoard addTarget:self action:@selector(btnLikeClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doDoubleTap)];
                doubleTap.numberOfTapsRequired = 2;
                doubleTap.delegate =self;
                [view1 addGestureRecognizer:doubleTap];
                UIWebView *wb;
                if ([[dataDictionary valueForKey:@"BillboardType"] isEqualToString:@"Website"]) {
                    wb = [[UIWebView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+15, view1.frame.size.width-10, view1.frame.size.height-8)];
                    wb.backgroundColor = [UIColor whiteColor];
                    
                    wb.opaque=NO;
                    wb.delegate = self;
                    NSArray *urls = [[dataDictionary valueForKey:@"Description"] componentsMatchedByRegex:@"http://[^\\s]*"];
                    NSArray *urls1= [[dataDictionary valueForKey:@"Description"] componentsMatchedByRegex:@"https://[^\\s]*"];
                    NSArray *urltext = [[dataDictionary valueForKey:@"Description"] componentsMatchedByRegex:@"[^\\s]*"];
                    NSURL *url;
                    if (urltext.count != 0) {
                        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@",urltext[0]]];
                    }else if(urls.count != 0){
                        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urls[0]]];
                    }else if(urls1.count != 0){
                        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urls1[0]]];
                    }
                    [wb loadRequest:[NSURLRequest requestWithURL:url] ];
                    
                }else if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Image"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]] isEqualToString:@""]  || ![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Video_thumb"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]] isEqualToString:@""] )
                {
                    wb = [[UIWebView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-10, 70)];
                    wb.backgroundColor = [UIColor clearColor];
                    wb.opaque=NO;
                    wb.delegate = self;
                    [wb loadHTMLString:[NSString stringWithFormat:@"<html><body text=\"#FFFFFF\">%@</body></html>",[dataDictionary valueForKey:@"Description"]] baseURL:nil];
                }
                else
                {
                    wb = [[UIWebView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-10, view1.frame.size.height-8)];
                    wb.backgroundColor = [UIColor clearColor];
                    wb.opaque=NO;
                    wb.delegate = self;
                    [wb loadHTMLString:[NSString stringWithFormat:@"<html><body text=\"#FFFFFF\">%@</body></html>",[dataDictionary valueForKey:@"Description"]] baseURL:nil];
                }
                [view1 addSubview:lblTitle];
                [view1 addSubview:wb];
                [self.scrl addSubview:view1];
                //cp
                BOOL isImage =NO;
                //image
                if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Image"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]] isEqualToString:@""])
                {
                    UIImageView *img=[[UIImageView alloc] init];
                    if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Video_thumb"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]] isEqualToString:@""])
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-7, view1.frame.size.height/2-50);
                    }
                    else
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-7, view1.frame.size.height-70);
                    }
                    img.backgroundColor=[UIColor blackColor];
                    img.tag=999;
                    img.contentMode = UIViewContentModeScaleToFill;
                    [img setContentMode:UIViewContentModeScaleAspectFit];
                    NSString *thumbURL=[[dataDictionary valueForKey:@"Image"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
                    NSURL *url = [NSURL URLWithString:thumbURL];
                    [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
                    [view1 addSubview:img];
                    [self.scrl addSubview:view1];
                    isImage =YES;
                }
                //video
                if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Video_thumb"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]] isEqualToString:@""])
                {
                    UIImageView *img=[[UIImageView alloc] init];
                    if (isImage)
                    {
                        img.frame=CGRectMake(5,view1.frame.size.height/2+70, view1.frame.size.width-7, view1.frame.size.height/2-50);
                    }
                    else
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-7, view1.frame.size.height-70);
                    }
                    img.backgroundColor=[UIColor blackColor];
                    img.tag=999;
                    img.contentMode = UIViewContentModeScaleToFill;
                    [img setContentMode:UIViewContentModeScaleAspectFit];
                    NSString *thumbURL=[[dataDictionary valueForKey:@"Video_thumb"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
                    NSURL *url = [NSURL URLWithString:thumbURL];
                    [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
                    NSString *urlVideo = [dataDictionary valueForKey:@"Video"];
                    [arrVideoUrl addObject:urlVideo];
                    UIButton *button = [[UIButton alloc] init];
                    [ button setImage:[UIImage imageNamed:@"btn_video_play" ] forState:UIControlStateNormal];
                    [button setBackgroundColor:[UIColor clearColor]];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    button.frame = CGRectMake((img.frame.size.width/2)-37, (img.frame.size.height/2)-37,75, 75);
                    button.tag= urlCount;
                    urlCount++;
                    button.enabled = YES;
                    button.userInteractionEnabled = YES;
                    [button addTarget:self action:@selector(btnPlayVideoClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [self.scrl addSubview:view1];
                    [view1 addSubview:lblTitle];
                    [img addSubview:button];
                    [view1 addSubview:img];
                    [view1 bringSubviewToFront:button];
                    img.userInteractionEnabled=YES;
                }
                //cp
            }
            if ([[dataDictionary valueForKey:@"BillboardType"] isEqualToString:@"Image"])
            {
                view1.tag=4;
                lblTitle.text = [dataDictionary valueForKey:@"Title"];
                likeVal =[[dataDictionary valueForKey:@"Likecount"] intValue];
                lblLike.text = [NSString stringWithFormat:@"%d Likes",likeVal];
                likeValBefore= likeVal;
                int isLikeStatus = [[dataDictionary valueForKey:@"Userlike"] intValue];
                if (isLikeStatus)
                {
                    [btnLikeBillBoard setSelected:YES];
                }
                else
                {
                    [btnLikeBillBoard setSelected:NO];
                }
                [btnLikeBillBoard addTarget:self action:@selector(btnLikeClicked:) forControlEvents:UIControlEventTouchUpInside];
                UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doDoubleTap)];
                doubleTap.numberOfTapsRequired = 2;
                doubleTap.delegate =self;
                [view1 addGestureRecognizer:doubleTap];
                
                UIImageView *img=[[UIImageView alloc] init];
                if (self.view.frame.size.height == 480)
                {
                    img.frame=CGRectMake(30, lblTitle.frame.size.height+30, view1.frame.size.width-50, view1.frame.size.width-50);
                }
                else
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+30, view1.frame.size.width-7, view1.frame.size.width-10);
                }
                
                img.backgroundColor=[UIColor blackColor];
                img.tag=999;
                img.contentMode = UIViewContentModeScaleToFill;
                [img setContentMode:UIViewContentModeScaleAspectFit];
                NSString *thumbURL=[[dataDictionary valueForKey:@"Image_Name"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
                NSURL *url = [NSURL URLWithString:thumbURL];
                [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
                [view1 addSubview:lblTitle];
                [view1 addSubview:img];
                [self.scrl addSubview:view1];
            }
            if ([[dataDictionary valueForKey:@"BillboardType"] isEqualToString:@"Video"])
            {
                view1.tag=5;
                lblTitle.text = [dataDictionary valueForKey:@"Title"];
                likeVal =[[dataDictionary valueForKey:@"Likecount"] intValue];
                lblLike.text = [NSString stringWithFormat:@"%d Likes",likeVal];
                likeValBefore= likeVal;
                int isLikeStatus = [[dataDictionary valueForKey:@"Userlike"] intValue];
                if (isLikeStatus)
                {
                    [btnLikeBillBoard setSelected:YES];
                }
                else
                {
                    [btnLikeBillBoard setSelected:NO];
                }
                
                [btnLikeBillBoard addTarget:self action:@selector(btnLikeClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doDoubleTap)];
                doubleTap.numberOfTapsRequired = 2;
                doubleTap.delegate =self;
                [view1 addGestureRecognizer:doubleTap];
                
                UIImageView *img=[[UIImageView alloc] init];
                if (self.view.frame.size.height == 480)
                {
                    img.frame=CGRectMake(30, lblTitle.frame.size.height+30, view1.frame.size.width-50, view1.frame.size.width-50);
                }
                else
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+30, view1.frame.size.width-7, view1.frame.size.width-10);
                }
                
                img.backgroundColor=[UIColor blackColor];
                img.tag=999;
                img.contentMode = UIViewContentModeScaleToFill;
                [img setContentMode:UIViewContentModeScaleAspectFit];
                NSString *thumbURL=[[dataDictionary valueForKey:@"video_thumb"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
                NSURL *url = [NSURL URLWithString:thumbURL];
                [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
                NSString *urlVideo = [dataDictionary valueForKey:@"Embed_Code"];
                [arrVideoUrl addObject:urlVideo];
                UIButton *button = [[UIButton alloc] init];
                [ button setImage:[UIImage imageNamed:@"btn_video_play" ] forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor clearColor]];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.frame = CGRectMake((img.frame.size.width/2)-37, (img.frame.size.height/2)-37,75, 75);
                button.tag= urlCount;
                urlCount++;
                button.enabled = YES;
                button.userInteractionEnabled = YES;
                [button addTarget:self action:@selector(btnPlayVideoClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.scrl addSubview:view1];
                [view1 addSubview:lblTitle];
                [img addSubview:button];
                [view1 addSubview:img];
                [view1 bringSubviewToFront:button];
                img.userInteractionEnabled=YES;
            }
            if ([[dataDictionary valueForKey:@"BillboardType"] isEqualToString:@"Social"])
            {
                view1.tag=6;
                lblTitle.text = @"Connect with us";
                likeVal =[[dataDictionary valueForKey:@"Likecount"] intValue];
                lblLike.text = [NSString stringWithFormat:@"%d Likes",likeVal];
                likeValBefore= likeVal;
                int isLikeStatus = [[dataDictionary valueForKey:@"Userlike"] intValue];
                if (isLikeStatus)
                {
                    [btnLikeBillBoard setSelected:YES];
                }
                else
                {
                    [btnLikeBillBoard setSelected:NO];
                }
                
                [btnLikeBillBoard addTarget:self action:@selector(btnLikeClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doDoubleTap)];
                doubleTap.numberOfTapsRequired = 2;
                doubleTap.delegate =self;
                [view1 addGestureRecognizer:doubleTap];
                
                UIWebView *wb = [[UIWebView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+15, view1.frame.size.width-10, view1.frame.size.height-8)];
                wb.backgroundColor = [UIColor clearColor];
                wb.opaque=NO;
                wb.delegate = self;
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dataDictionary valueForKey:@"social"]]];
                //                [wb loadHTMLString:[NSString stringWithFormat:@"<html><body text=\"#FFFFFF\">%@</body></html>",[dataDictionary valueForKey:@"social"]] baseURL:nil];
                [wb loadRequest:[NSURLRequest requestWithURL:url]];
                
                [view1 addSubview:lblTitle];
                [view1 addSubview:wb];
                [self.scrl addSubview:view1];
            }
            [arrLikeLable addObject:lblLike];
            [arrLikeValue addObject:[NSNumber numberWithInt:likeValBefore]];
            [arrLikeBtn addObject:btnLikeBillBoard];
            
        }
    }
    else
    {
        UIAlertController *alert = [[UIAlertController alloc] init];
        alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:@"Offers and more Coming Soon!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        }];
        [alert addAction:btn_cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)doDoubleTap
{
    [self btnLikeClicked:nil];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize contentSize = webView.scrollView.contentSize;
    CGSize viewSize = webView.bounds.size;
    viewSize.width = viewSize.width -250 ;
    float rw = viewSize.width / contentSize.width;
    NSString *deviceWidth = NSStringFromCGSize(viewSize);
    //    [NSString stringWithFormat:NSStringFromCGSize(webView.bounds.size)];
    NSString *zoomScale = [NSString stringWithFormat:@"%f",rw];
    NSString* js = [NSString stringWithFormat:@"var meta = document.createElement('meta'); " \
                    "meta.setAttribute( 'name', 'viewport' ); " \
                    "meta.setAttribute( 'content', 'width = %@, initial-scale = %@, user-scalable = yes' ); " \
                    "document.getElementsByTagName('head')[0].appendChild(meta)",deviceWidth,zoomScale];
    
    [webView stringByEvaluatingJavaScriptFromString: js];
    [loading stopAnimating];
    [loading setHidden:YES];
}

#pragma mark- ScrollView Delegates

- (void)scrollViewDidScroll:(UIScrollView *)scrollview
{
    oldoffset_y=scrollview.contentOffset.y;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1
{
    CurrentPage=scrollView1.contentOffset.y/scrollView1.frame.size.height;
    pgCtrl.currentPage = CurrentPage;
}

#pragma mark- Button Action

-(IBAction)CheckIn:(id)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"" message:@"Please check your internet connection." cancel:@"OK" other:nil];
        //        [btnBack setEnabled:YES];
        //        [btnCheckIn setEnabled:YES];
    }
    else
    {
        netUtills.tag = 1;
        NSString *str = [NSString stringWithFormat:@"%@%@",mainUrl,checkin];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"MerchentId"] forKey:@"merchantid"];
        [dic setValue:[NSString stringWithFormat:@"%f",appdelegate().clLocation.coordinate.latitude] forKey:@"latitude"];
        [dic setValue:[NSString stringWithFormat:@"%f",appdelegate().clLocation.coordinate.longitude] forKey:@"longitude"];
        
        netUtills.tag = 2;
        [netUtills GetResponseByASIFormDataRequest:str WithDictionary:dic];
    }
}

-(IBAction)BackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)InfoClicked:(id)sender
{
    
    
    //InfoVC *info = [[InfoVC alloc] initWithNibName:@"InfoVC" bundle:nil];
    //[self.navigationController pushViewController:info animated:YES];
    NSMutableDictionary *dic_K = [arrTempMerchantDetail objectAtIndex:tempMerchantTag];
    lblCouponMName.text = [dic_K valueForKey:@"merchant_name"];
    lblCouponMAddress.text = [NSString stringWithFormat:@"%@  \nPh.No.%@",[dic_K valueForKey:@"merchant_address"],[dic_K valueForKey:@"Phoneno"]];
    
    //[dic_K valueForKey:@"logo"]
    NSDictionary *userInfo  = dic_K;
    NSString *busihours = [userInfo objectForKey:@"business_hours"];
    if (busihours.length > 0) {
        busihours = [busihours stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
        busihours = [busihours stringByReplacingOccurrencesOfString:@"/" withString:@" "];
    }
    lblBusinessHours.text = busihours;
    ImagLinkStr = @"";
    if ([userInfo objectForKey:@"website"] && [[userInfo objectForKey:@"website"] isKindOfClass:[NSString class]] && [[userInfo objectForKey:@"website"] length]>0) {
        ImagLinkStr = [userInfo objectForKey:@"website"];
    }
    else     if ([userInfo objectForKey:@"fb_link"] && [[userInfo objectForKey:@"fb_link"] isKindOfClass:[NSString class]] && [[userInfo objectForKey:@"fb_link"] length]>0) {
        ImagLinkStr = [userInfo objectForKey:@"fb_link"];
    }
    else     if ([userInfo objectForKey:@"logo"] && [[userInfo objectForKey:@"logo"] isKindOfClass:[NSString class]] && [[userInfo objectForKey:@"logo"] length]>0) {
        ImagLinkStr = [userInfo objectForKey:@"logo"];
    }
    
    [self.btnlink setTitle:ImagLinkStr forState:UIControlStateNormal];
    self.btnlink.titleLabel.numberOfLines=2;
    //self.btnlink.titleLabel.textAlignment=NSTextAlignmentCenter;
    lblPercentage.text = [dic_K valueForKey:@"Percentage"];
    lblTotalWalkin.text = [NSString stringWithFormat:@"%@",[dic_K valueForKey:@"walkins"]];
    //    //midForUnFavurite=[mainDict valueForKey:@"merchant_id"];
    
    if ([rating isEqualToString:@"1"])
    {
        [btnRateRed setSelected:YES];
    }
    else if([rating isEqualToString:@"2"])
    {
        [btnRateYellow setSelected:YES];
        
    }
    else if([rating isEqualToString:@"3"])
    {
        [btnRateGreen setSelected:YES];
    }
    else
    {
        
    }
    viewInfo.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:viewInfo];
    UITapGestureRecognizer *tap;
    tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(RemoveSubView)];
    tap.numberOfTapsRequired = 1;
    [viewInfo addGestureRecognizer:tap];
    
}
-(void)RemoveSubView
{
    if (viewInfo) {
        [viewInfo removeFromSuperview];
    }
    if (viewsubPunch) {
        [viewsubPunch removeFromSuperview];
    }
}


-(IBAction)ShowMeDirections:(id)sender
{
    
    [self  FindLocation:@"" location:@""];
    
    //    return;
    
    //    NSMutableDictionary *dic_K = [arrTempMerchantDetail objectAtIndex:tempMerchantTag];
    //    DirectionMapVC *direction = [self.storyboard instantiateViewControllerWithIdentifier:@"DirectionMapVC"];
    //    direction.strTitle = [dic_K valueForKey:@"merchant_name"];
    //    direction.address = [dic_K valueForKey:@"merchant_address"];
    //
    //    [self.navigationController pushViewController:direction animated:YES];
}

-(IBAction)AddToFav:(id)sender
{
    NSMutableDictionary *dic_K = [arrTempMerchantDetail objectAtIndex:tempMerchantTag];
    NSString * mid = [dic_K valueForKey:@"merchant_id"];
    NSMutableArray *arrIDs = [wrpr GetIds];
    if (![arrIDs containsObject:mid])
    {
        int K = [wrpr InsertToFavorite:mid];
        if (K > 0)
        {
            [self showAlert:@"Empower Main Street" message:@"Added to favorites." cancel:@"OK" other:nil];
            [btnFavBottom setImage:[UIImage imageNamed:@"btn_favourite_touch"] forState:UIControlStateNormal];
        }
        else
        {
            [self showAlert:@"Empower Main Street" message:@"Unable to add to favorites." cancel:@"OK" other:nil];
        }
    }
    else
    {
        BOOL k=[wrpr RemoveFromfav:mid];
        if(k==YES)
        {
            [btnFavBottom setImage:[UIImage imageNamed:@"btn_favourite_normal"] forState:UIControlStateNormal];
            [self showAlert:@"Empower Main Street" message:@"Removed from favorites." cancel:@"OK" other:nil];
        }
    }
}

-(IBAction)MakeACall:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:@"Call local business?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *dic_K = [arrTempMerchantDetail objectAtIndex:tempMerchantTag];
        NSString * phoneNumber = [NSString stringWithFormat:@"tel://%@",[dic_K valueForKey:@"Phoneno"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber] options:@{} completionHandler:nil];
    }];
    [alert addAction:btn_ok];
    UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:^{
        }];
        
    }];
    [alert addAction:btn_cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(IBAction)RatingButtonClicked:(id)sender
{
    NSString *str =[[NSUserDefaults standardUserDefaults] valueForKey:@"fbname"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"loggedin"] || str.length != 0)
    {
        if ([btnRateGreen isSelected] || [btnRateRed isSelected] || [btnRateYellow isSelected])
        {
            [self showAlert:@"Empower Main Street" message:@"Merchant already rated by you" cancel:@"OK" other:nil];
        }
        else
        {
            [self rating:sender];
        }
    }
    else if(str.length == 0)
    {
        UIAlertController *alert = [[UIAlertController alloc] init];
        alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:@"Sorry! you are not Login. You want to login with facebook?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            SignupVC *signup = [self.storyboard instantiateViewControllerWithIdentifier:@"SignupVC"];//[[SignupVC alloc] initWithNibName:@"SignupVC" bundle:nil];
            [self.navigationController pushViewController:signup animated:YES];
            
        }];
        [alert addAction:btn_ok];
        UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:^{
            }];
            
        }];
        [alert addAction:btn_cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)rating:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag)
    {
        case 41:
            ratingVal = 1;
            if (![btnRateGreen isSelected])
            {
                if (![btnRateYellow isSelected])
                {
                    [btnRateRed setSelected:YES];
                }
            }
            
            break;
            
        case 42:
            ratingVal = 2;
            if (![btnRateGreen isSelected])
            {
                if (![btnRateRed isSelected])
                {
                    [btnRateYellow setSelected:YES];
                }
            }
            break;
            
        case 43:
            ratingVal = 3;
            if (![btnRateYellow isSelected])
            {
                if (![btnRateRed isSelected])
                {
                    [btnRateGreen setSelected:YES];
                }
            }
            break;
            
        default:
            break;
    }
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"" message:@"Please check your internet connection." cancel:@"OK" other:nil];
        //        [btnBack setEnabled:YES];
        //        [btnCheckIn setEnabled:YES];
    }
    else
    {
        netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponse:) WithCallBackObject:self];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"merchant_id"] forKey:@"merchantid"];
        [dict setValue:uid forKey:@"userid"];
        [dict setValue:[NSString stringWithFormat:@"%d",ratingVal] forKey:@"rating"];
        netUtills.tag = 3;
        [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,merchantRating] WithDictionary:dict];
    }
    
}

-(IBAction)btnCommentClick:(id)sender
{
    CommentVC *cmmt = [self.storyboard instantiateViewControllerWithIdentifier:@"CommentVC"];
    [self.navigationController pushViewController:cmmt animated:YES];
}

-(IBAction)btnOfferClicked:(id)sender
{
    NSMutableDictionary *dic_K = [arrTempMerchantDetail objectAtIndex:tempMerchantTag];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:@{@"merchant_id": [dic_K valueForKey:@"merchant_id"]}];
    [appdelegate() showHUD];
    [[JWNetWorkManager sharedManager] POST:@"get_merchant_punchcard.php" data:parameters completion:^(id data, NSError *error) {
        [appdelegate() hideHUD];
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", error, data);
            if ([[data valueForKey:@"status"] intValue] == 1)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    merchant_punches = [[data valueForKey:@"data"] objectAtIndex:0];
                    [lblPunchTitle setText:[merchant_punches valueForKey:@"punch_title"]];
                    [tbl_punch reloadData];
                    viewsubPunch.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                    
                    [self.view addSubview:viewsubPunch];
                    UITapGestureRecognizer *tap;
                    tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(RemoveSubView)];
                    tap.numberOfTapsRequired = 1;
                    [viewpunchback addGestureRecognizer:tap];
                });

            }
            else if ([[data valueForKey:@"status"] intValue]== 0)
            {
                [self showAlert:@"" message:@"Sorry, try again." cancel:@"OK" other:nil];
            }
            else if ([[data valueForKey:@"status"] intValue]== 2)
            {
                [self showAlert:@"" message:@"This merchant punch card expired." cancel:@"OK" other:nil];
            }
        }
        
    }];

    
}

-(IBAction)btnLikeClicked:(id)sender
{
    //UIButton *btn = (UIButton *)sender;
    
    UIButton *btn = [arrLikeBtn objectAtIndex:CurrentPage];
    NSString *str =[[NSUserDefaults standardUserDefaults] valueForKey:@"fbname"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"loggedin"] || str.length != 0)
    {
        if ([strMId isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"merchantid"]])
        {
            [self showAlert:@"Empower Main Street" message:@"You can't like your own billboard." cancel:@"OK" other:nil];
        }
        else
        {
            [self billboardlike:btn];
        }
    }
    else if(str.length == 0)
    {
        UIAlertController *alert = [[UIAlertController alloc] init];
        alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:@"Sorry! you are not Login. You want to login with facebook?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            SignupVC *signup = [self.storyboard instantiateViewControllerWithIdentifier:@"SignupVC"];//[[SignupVC alloc] initWithNibName:@"SignupVC" bundle:nil];
            [self.navigationController pushViewController:signup animated:YES];
            
        }];
        [alert addAction:btn_ok];
        UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:^{
            }];
            
        }];
        [alert addAction:btn_cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)billboardlike :(id)sender
{
    //http://198.57.247.185/~jwalkin/admin/api/user_like.php?userid=6&billid=7&islike=1
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"" message:@"Please check your internet connection." cancel:@"OK" other:nil];
        //        [btnBack setEnabled:YES];
        //        [btnCheckIn setEnabled:YES];
    }
    else
    {
        NSString *isLike;
        UIButton *btn = (UIButton *)sender;
        if ([btn isSelected])
        {
            isLike = @"0";
        }
        else
        {
            isLike = @"1";
        }
        netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponseUserLike:) WithCallBackObject:self];
        netUtills.tag = 1;
        NSString *billId =[[arrAllData objectAtIndex:CurrentPage]valueForKey:@"BillboardId"];
        NSString *btype =[[arrAllData objectAtIndex:CurrentPage]valueForKey:@"BillboardType"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:uid forKey:@"userid"];
        [dict setObject:billId forKey:@"billid"];
        [dict setObject:btype forKey:@"btype"];
        [dict setObject:isLike forKey:@"islike"];
        [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl, user_like] WithDictionary:dict];
    }
}

#pragma mark Playing Video

-(IBAction)btnPlayVideoClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSURL *url=[[NSURL alloc] initWithString:[arrVideoUrl objectAtIndex:button.tag]];
    moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:url];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
    moviePlayer.controlStyle=MPMovieControlStyleDefault;
    moviePlayer.shouldAutoplay=YES;
    [self.view addSubview:moviePlayer.view];
    [moviePlayer setFullscreen:YES animated:YES];
}
-(void)moviePlayBackDidFinish:(NSNotification*)notification
{
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    if ([player respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player.view removeFromSuperview];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self.scrl bringSubviewToFront:loading];
    [loading setHidden:NO];
    [loading startAnimating];
    return YES;
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    [loading stopAnimating];
//    [loading setHidden:YES];
//}

-(IBAction)btnBackMediaPlayerClick:(id)sender
{
    [viewPlayer removeFromSuperview];
}
- (IBAction)BtnlinkClicked:(id)sender
{
    ImageWebViewController *Web = [[ImageWebViewController alloc] init];
    if ([ImagLinkStr isEqualToString:@"null"])
    {
        [self.btnlink setEnabled:YES];
        return;
    }
    Web.Strlink=[ImagLinkStr mutableCopy];
    [self.navigationController pushViewController:Web   animated:YES];
    
}


#pragma mark got to safari location on clicking on direction buttions


-(IBAction)FindLocation:(NSString*)add_annSubtitle location:(NSString*)loc_annTitle
{
    [appdelegate() showHUD];
    NSMutableDictionary *dic_K = [arrTempMerchantDetail objectAtIndex:tempMerchantTag];
    loc_annTitle = [dic_K valueForKey:@"merchant_name"];
    add_annSubtitle = [dic_K valueForKey:@"merchant_address"];
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:add_annSubtitle
                 completionHandler:^(NSArray *placemarks, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(),^ {
             // do stuff with placemarks on the main thread
             [appdelegate() hideHUD];
             if (placemarks.count == 0)
             {
//                 [self dismissViewControllerAnimated:YES completion:nil];
             }
             else
             {
                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                 CLLocation *location = placemark.location;
                 CLLocationCoordinate2D coordinate = location.coordinate;
                 //NSString *myadd=add_annSubtitle;
                 NSNumber *lat = [NSNumber numberWithDouble:coordinate.latitude];
                 NSNumber *lon = [NSNumber numberWithDouble:coordinate.longitude];
                 NSDictionary *userLocation=@{@"lat":lat,@"long":lon,@"title":loc_annTitle,@"subTitle":add_annSubtitle};
                 [self performSelectorOnMainThread:@selector(calculateRoutesFrom:) withObject:userLocation waitUntilDone:YES];
             }
         });
     }];
}


-(void) calculateRoutesFrom:(NSDictionary*) locationdict
{
    
    
    CLLocationCoordinate2D t = CLLocationCoordinate2DMake([[locationdict valueForKey:@"lat"] doubleValue],[[locationdict valueForKey:@"long"] doubleValue]);
    CLLocationCoordinate2D CurrentLoc;
    CurrentLoc.latitude= appdelegate().clLocation.coordinate.latitude;
    CurrentLoc.longitude= appdelegate().clLocation.coordinate.longitude;
    //    [dict setValue:[NSString stringWithFormat:@"%f",26.2389469] forKey:@"latitude"];
    //    [dict setValue:[NSString stringWithFormat:@"%f",73.0243094] forKey:@"longitude"];
    
    NSString* saddr = [NSString stringWithFormat:@"%f,%f", CurrentLoc.latitude, CurrentLoc.longitude];
    NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
    
    NSMutableString *mapURL = [NSMutableString stringWithString:@"http://maps.google.com/maps?"];
    [mapURL appendFormat:@"saddr=%@",saddr];
    [mapURL appendFormat:@"&daddr=%@", daddr];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[mapURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]options:@{} completionHandler:nil];
    
    
}
- (void)showAlert:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel other:(NSString *)other{
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (cancel) {
        UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
        [alert addAction:btn_ok];
    }
    if (other) {
        UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:other style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:^{
                
            }];
            
        }];
        [alert addAction:btn_cancel];
    }
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)prevSelect:(UITapGestureRecognizer*)recog{
    NSMutableDictionary *dic_K = [arrTempMerchantDetail objectAtIndex:tempMerchantTag - 1];
    tempMerchantTag = tempMerchantTag - 1;
    strMName = [dic_K valueForKey:@"merchant_name"];
    strMId = [dic_K valueForKey:@"merchant_id"];
    [self getdata];
}
-(void)nextSelect:(UITapGestureRecognizer*)recog{
    NSMutableDictionary *dic_K = [arrTempMerchantDetail objectAtIndex:tempMerchantTag + 1];
    tempMerchantTag = tempMerchantTag + 1;
    strMName = [dic_K valueForKey:@"merchant_name"];
    strMId = [dic_K valueForKey:@"merchant_id"];
    [self getdata];
}
- (IBAction)ActionBtnPunch:(id)sender {
    
    [self RemoveSubView];
    [self scanCode];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (merchant_punches != nil) {
        NSString *punch_type = [merchant_punches valueForKey:@"punch_type"];
        if ([punch_type isEqualToString:@"5_punch"]) {
            return 1;
        }else if([punch_type isEqualToString:@"10_punch"]){
            return 2;
        }else{
            return 3;
        }
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"punchcell";
    PunchCardCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    if (merchant_punches) {
        long current_punches = [[merchant_punches valueForKey:@"current_punches"] integerValue];
        if (current_punches == 1) {
            if (indexPath.row == 0) {
                [cell.btnPC1 setSelected:YES];
            }
        }
        if (current_punches == 2) {
            if (indexPath.row == 0) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
            }
        }
        if (current_punches == 3) {
            if (indexPath.row == 0) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
            }
        }
        if (current_punches == 4) {
            if (indexPath.row == 0) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
                [cell.btnPC4 setSelected:YES];
            }
        }
        if (current_punches == 5) {
            if (indexPath.row == 0) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
                [cell.btnPC4 setSelected:YES];
                [cell.btnPC5 setSelected:YES];
            }
        }
        if (current_punches == 6) {
            if (indexPath.row == 0) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
                [cell.btnPC4 setSelected:YES];
                [cell.btnPC5 setSelected:YES];
            }
            if (indexPath.row == 1) {
                [cell.btnPC1 setSelected:YES];
            }
        }
        if (current_punches == 7) {
            if (indexPath.row == 0) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
                [cell.btnPC4 setSelected:YES];
                [cell.btnPC5 setSelected:YES];
            }
            if (indexPath.row == 1) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
            }
        }
        if (current_punches == 8) {
            if (indexPath.row == 0) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
                [cell.btnPC4 setSelected:YES];
                [cell.btnPC5 setSelected:YES];
            }
            if (indexPath.row == 1) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
            }
        }
        if (current_punches == 9) {
            if (indexPath.row == 0) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
                [cell.btnPC4 setSelected:YES];
                [cell.btnPC5 setSelected:YES];
            }
            if (indexPath.row == 1) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
                [cell.btnPC4 setSelected:YES];
            }
        }
        if (current_punches == 10) {
            if (indexPath.row == 0) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
                [cell.btnPC4 setSelected:YES];
                [cell.btnPC5 setSelected:YES];
            }
            if (indexPath.row == 1) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
                [cell.btnPC4 setSelected:YES];
                [cell.btnPC5 setSelected:YES];
            }
        }
        if (current_punches == 11) {
            if (indexPath.row == 0) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
                [cell.btnPC4 setSelected:YES];
                [cell.btnPC5 setSelected:YES];
            }
            if (indexPath.row == 1) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
                [cell.btnPC4 setSelected:YES];
                [cell.btnPC5 setSelected:YES];
            }
            if (indexPath.row == 2) {
                [cell.btnPC1 setSelected:YES];
            }
        }
        if (current_punches == 12) {
            if (indexPath.row == 0) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
                [cell.btnPC4 setSelected:YES];
                [cell.btnPC5 setSelected:YES];
            }
            if (indexPath.row == 1) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
                [cell.btnPC4 setSelected:YES];
                [cell.btnPC5 setSelected:YES];
            }
            if (indexPath.row == 2) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
            }
        }
        if (current_punches == 13) {
            if (indexPath.row == 0) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
                [cell.btnPC4 setSelected:YES];
                [cell.btnPC5 setSelected:YES];
            }
            if (indexPath.row == 1) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
                [cell.btnPC4 setSelected:YES];
                [cell.btnPC5 setSelected:YES];
            }
            if (indexPath.row == 2) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
            }
        }
        if (current_punches == 14) {
            if (indexPath.row == 0) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
                [cell.btnPC4 setSelected:YES];
                [cell.btnPC5 setSelected:YES];
            }
            if (indexPath.row == 1) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
                [cell.btnPC4 setSelected:YES];
                [cell.btnPC5 setSelected:YES];
            }
            if (indexPath.row == 2) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
                [cell.btnPC4 setSelected:YES];
            }
        }
        if (current_punches == 15) {
            if (indexPath.row == 0) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
                [cell.btnPC4 setSelected:YES];
                [cell.btnPC5 setSelected:YES];
            }
            if (indexPath.row == 1) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
                [cell.btnPC4 setSelected:YES];
                [cell.btnPC5 setSelected:YES];
            }
            if (indexPath.row == 2) {
                [cell.btnPC1 setSelected:YES];
                [cell.btnPC2 setSelected:YES];
                [cell.btnPC3 setSelected:YES];
                [cell.btnPC4 setSelected:YES];
                [cell.btnPC5 setSelected:YES];
            }
        }
    }

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
#pragma mark - QR code scan

-(void)scanCode
{
    // NSLog(@"Scanning..");
    //resultTextView.text = @"Scanning..";
    
    codeReader = [ZBarReaderViewController new];
    codeReader.readerDelegate=self;
    codeReader.supportedOrientationsMask = ZBarOrientationMaskAll;
    [scanView setFrame:self.view.frame];
    [codeReader setCameraOverlayView:scanView];
    
    ZBarImageScanner *scanner = codeReader.scanner;
    [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
    [self presentViewController:codeReader animated:YES completion:nil];
    
    
}

- (void) imagePickerController: (UIImagePickerController*) picker didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    //  get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // just grab the first barcode
        break;
    
    // showing the result on textview
    resultText = symbol.data;
    //NSLog(@"%@",resultText);
    NSString *strMidd ;
    NSArray *arrCode = [resultText componentsSeparatedByString:@"_"];
    if (arrCode.count > 1)
    {
        strMidd = [arrCode objectAtIndex:1];
    }
    NSString *strJw = [arrCode objectAtIndex:0];
    // NSString *strMidd = [arrCode objectAtIndex:1];
    // NSString *strQRCode = [arrCode objectAtIndex:2];
    if (resultText.length != 0)
    {
        
        if ([strJw isEqualToString:@"jwalin"])
        {
            NSMutableDictionary *dic_K = [arrTempMerchantDetail objectAtIndex:tempMerchantTag];
            NSString *mid = [dic_K valueForKey:@"merchant_id"];

            if ([strMidd isEqualToString:mid])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [reader dismissViewControllerAnimated:YES completion:nil];
                    [codeReader dismissViewControllerAnimated:YES completion:nil];
                    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddOfferVC"];
                    [self.navigationController pushViewController:vc animated:YES];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [reader dismissViewControllerAnimated:YES completion:nil];
                   [codeReader dismissViewControllerAnimated:YES completion:nil];
                    UIAlertController *alert = [[UIAlertController alloc] init];
                    alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:@"QR image is not match with this offer." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        //                    [viewDetail removeFromSuperview];
                    }];
                    [alert addAction:btn_cancel];
                    [self presentViewController:alert animated:YES completion:nil];
                });
            }
        }
        
    }
    //resultImageView.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // dismiss the controller
}

- (void) updatePunch{
    NSMutableDictionary *dic_K = [arrTempMerchantDetail objectAtIndex:tempMerchantTag];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:@{@"merchant_id": [dic_K valueForKey:@"merchant_id"]}];
    [appdelegate() showHUD];
    [[JWNetWorkManager sharedManager] POST:@"update_punch_card.php" data:parameters completion:^(id data, NSError *error) {
        [appdelegate() hideHUD];
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            if ([[data valueForKey:@"status"] isEqualToString:@"1"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ManageOfferVC *manageOffer = [self.storyboard instantiateViewControllerWithIdentifier:@"ManageOfferVC"];
                    manageOffer.isOffer = YES;
                    manageOffer.strMid = strMId;
                    [self.navigationController pushViewController:manageOffer animated:YES];
                });
            }
            else if ([[data valueForKey:@"status"] isEqualToString:@"0"])
            {
                [self showAlert:@"" message:@"Sorry, try again." cancel:@"OK" other:nil];
            }
        }
        
    }];

}

-(void)callRedeamApi
{
    //Redeam offer
    //http://198.57.247.185/~jwalkin/admin/api/redeam_offer.php parametre:userid , offerid
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    NSString *userId;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"loggedin"])
    {
        userId =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"merchantid"]];
    }
    else
    {
        userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"user-Id"]];
    }
    
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"" message:@"Please check your internet connection." cancel:@"OK" other:nil];
    }
    else
    {
        netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponseRedeam:) WithCallBackObject:self];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:userId forKey:@"userid"];
        [dict setObject:strOfferId forKey:@"offerid"];
        [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,redeam_offer] WithDictionary:dict];
    }
}

-(void)ParseResponseRedeam:(id)sender
{
    NetworkUtills *utills=(NetworkUtills *)sender;
    NSError *error = nil;
    NSData *data = [utills.strResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *resDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    //    NSDictionary *resDic =[utills.strResponse JSONValue];
    NSString *sts =[NSString stringWithFormat:@"%@",[resDic valueForKey:@"status"]] ;
    if ([sts isEqualToString:@"10"])
    {
        //NSString *msg = [resDic valueForKey:@""];
        UIAlertController *alert = [[UIAlertController alloc] init];
        alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:@"You got this offer" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            [viewDetail removeFromSuperview];
        }];
        [alert addAction:btn_cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if([sts isEqualToString:@"11"])
    {
        //NSString *msg = [resDic valueForKey:@""];
        UIAlertController *alert = [[UIAlertController alloc] init];
        alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:@"You redeem is locked you want to reset your redeem?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self callResetRedeamApi];
        }];
        [alert addAction:btn_ok];
        UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:^{
            }];
            
        }];
        [alert addAction:btn_cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)callResetRedeamApi
{
    //reset redeam
    //http://198.57.247.185/~jwalkin/admin/api/reset_redeam.php parametre:userid , offerid
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    NSString *userId;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"loggedin"])
    {
        userId =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"merchantid"]];
    }
    else
    {
        userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"user-Id"]];
    }
    
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"" message:@"Pelase check your internet connection." cancel:@"OK" other:nil];
    }
    else
    {
        netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponseResetRedeam:) WithCallBackObject:self];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:userId forKey:@"userid"];
        [dict setObject:strOfferId forKey:@"offerid"];
        [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,reset_redeam] WithDictionary:dict];
    }
}

-(void)ParseResponseResetRedeam:(id)sender
{
    NetworkUtills *utills=(NetworkUtills *)sender;
    NSError *error = nil;
    NSData *data = [utills.strResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *resDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    //    NSDictionary *resDic =[utills.strResponse JSONValue];
    NSString *sts = [NSString stringWithFormat:@"%@",[resDic valueForKey:@"status"]];
    if ([sts isEqualToString:@"1"])
    {
        UIAlertController *alert = [[UIAlertController alloc] init];
        alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:@"Your redeem is updated successfully." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            [viewDetail removeFromSuperview];
        }];
        [alert addAction:btn_cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


@end
