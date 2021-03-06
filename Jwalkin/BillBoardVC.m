//
//  BillBoardVC.m
//  Jwalkin
//
//  Created by Asai on 5/18/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import "BillBoardVC.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AFNetworking.h"
#import "UrlFile.h"
#import "Reachability.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "MBProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
#import <Social/Social.h>
#import "KGModal.h"
#import "SocialShareUIView.h"
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) // iPhone and       iPod touch style UI

#define IS_IPHONE_5_IOS7 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_6_IOS7 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS_IPHONE_6P_IOS7 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0f)
#define IS_IPHONE_4_AND_OLDER_IOS7 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0f)

#define IS_IPHONE_5_IOS8 (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) == 568.0f)
#define IS_IPHONE_6_IOS8 (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) == 667.0f)
#define IS_IPHONE_6P_IOS8 (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) == 736.0f)
#define IS_IPHONE_4_AND_OLDER_IOS8 (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) < 568.0f)

#define IS_IPHONE_5 ( ( [ [ UIScreen mainScreen ] respondsToSelector: @selector( nativeBounds ) ] ) ? IS_IPHONE_5_IOS8 : IS_IPHONE_5_IOS7 )
#define IS_IPHONE_6 ( ( [ [ UIScreen mainScreen ] respondsToSelector: @selector( nativeBounds ) ] ) ? IS_IPHONE_6_IOS8 : IS_IPHONE_6_IOS7 )
#define IS_IPHONE_6P ( ( [ [ UIScreen mainScreen ] respondsToSelector: @selector( nativeBounds ) ] ) ? IS_IPHONE_6P_IOS8 : IS_IPHONE_6P_IOS7 )
#define IS_IPHONE_4_AND_OLDER ( ( [ [ UIScreen mainScreen ] respondsToSelector: @selector( nativeBounds ) ] ) ? IS_IPHONE_4_AND_OLDER_IOS8 : IS_IPHONE_4_AND_OLDER_IOS7 )
#define _IS_IPHONE_5 (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) == 568.0f)
#define _IS_IPHONE_6 (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) == 667.0f)
#define _IS_IPHONE_6P (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) == 736.0f)
#define _IS_IPHONE_4_AND_OLDER (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) < 568.0f)


@interface BillBoardVC ()<FBSDKSharingDelegate>
{
    BOOL isCheckDis;
    BOOL isCheckPro;
    BOOL isCheckEve;
    BOOL isCheckImg;
    BOOL isCheckVdo;
    BOOL isCheckSocial;
    NSArray *arrExpDate;
    SocialShareUIView *socialShareModalView;
    //BOOL shareFB,shareTW, sharePT;
}
@property     PDKUser *user;

@end
@implementation BillBoardVC
@synthesize billBoardNo;

- (void)viewDidLoad
{
    
   
    [super viewDidLoad];
    socialShareModalView = [SocialShareUIView customView];
    //cp
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"status_bar"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    arrExpDate = [[NSArray alloc]initWithObjects:@"30",@"7",@"3",@"1" ,nil];
    
    imgViewPromoSelected.layer.cornerRadius = 5.0;
    imgViewPromoSelected.layer.borderColor = [[UIColor grayColor] CGColor];
    imgViewPromoSelected.layer.borderWidth =0.5;
    
    imgViewVideoThumbnailPromo.layer.cornerRadius = 5.0;
    imgViewVideoThumbnailPromo.layer.borderColor = [[UIColor grayColor] CGColor];
    imgViewVideoThumbnailPromo.layer.borderWidth =0.5;
    
    imgViewEventSelected.layer.cornerRadius = 5.0;
    imgViewEventSelected.layer.borderColor = [[UIColor grayColor] CGColor];
    imgViewEventSelected.layer.borderWidth =0.5;
    
    imgViewVideoThumbnailEvent.layer.cornerRadius = 5.0;
    imgViewVideoThumbnailEvent.layer.borderColor = [[UIColor grayColor] CGColor];
    imgViewVideoThumbnailEvent.layer.borderWidth =0.5;
    
    imgViewDiscountSelected.layer.cornerRadius = 5.0;
    imgViewDiscountSelected.layer.borderColor = [[UIColor grayColor] CGColor];
    imgViewDiscountSelected.layer.borderWidth =0.5;
    
    imgViewVideoThumbnailDiscout.layer.cornerRadius = 5.0;
    imgViewVideoThumbnailDiscout.layer.borderColor = [[UIColor grayColor] CGColor];
    imgViewVideoThumbnailDiscout.layer.borderWidth =0.5;
    
    imgViewVideoThumbnail.layer.cornerRadius = 5.0;
    imgViewVideoThumbnail.layer.borderColor = [[UIColor grayColor] CGColor];
    imgViewVideoThumbnail.layer.borderWidth =0.5;
    
    imgViewSelected.layer.cornerRadius = 5.0;
    imgViewSelected.layer.borderColor = [[UIColor grayColor] CGColor];
    imgViewSelected.layer.borderWidth =0.5;
    if ([self.navigationController.navigationBar respondsToSelector:@selector(barTintColor)])
    {
        // we're running iOS 7
    }
    else
    {
        // we're on iOS 6 and before
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 40.0f)];
        [btn addTarget:self action:@selector(btnCancel) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor clearColor]];
        UIBarButtonItem *eng_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = eng_btn;
    }
    [self setEdgesInsectForTextField:tfTitleDiscount];
    [self setEdgesInsectForTextField:tfTitlePromo];
    [self setEdgesInsectForTextField:tfTitleEvents];
    [self setEdgesInsectForTextField:tfTitleImage];
    [self setEdgesInsectForTextField:tfTitleVideo];
    [self setEdgesInsectForTextField:tfTitleSocial];
    [self setEdgesInsectForTextField:tfLocationEvent];
    [self setEdgesInsectForTextField:tfGoogle];
    [self setEdgesInsectForTextField:tfFacebook];
    [self setEdgesInsectForTextField:tfTwitter];
    [self setEdgesInsectForTextField:tfWebsite];
    
    //    scrollViewPromo.contentSize  = CGSizeMake(self.view.frame.size.width,btnSubmitPromo.frame.origin.y+btnSubmitPromo.frame.size.height+40);//Dp
    // scrollReg.contentSize  = CGSizeMake(self.view.frame.size.width,btnUpdate.frame.origin.y+btnUpdate.frame.size.height+25);
    
    
    //Dp


        
        if (IS_IPHONE_4_AND_OLDER)
        {
            scrollViewPromo.contentSize  = CGSizeMake(self.view.frame.size.width,btnSubmitPromo.frame.origin.y+btnSubmitPromo.frame.size.height);
            scrollViewDisc.contentSize =CGSizeMake(self.view.frame.size.width,btnSubmitDiscount.frame.origin.y+btnSubmitDiscount.frame.size.height);
            scrollViewEvent.contentSize =CGSizeMake(self.view.frame.size.width,btnSubmitEvent.frame.origin.y+btnSubmitEvent.frame.size.height);
        }
        else
        { scrollViewDisc.contentSize =CGSizeMake(self.view.frame.size.width,btnSubmitDiscount.frame.origin.y+btnSubmitDiscount.frame.size.height+200);
            scrollViewEvent.contentSize =CGSizeMake(self.view.frame.size.width,btnSubmitEvent.frame.origin.y+btnSubmitEvent.frame.size.height+200);
            scrollViewPromo.contentSize  = CGSizeMake(self.view.frame.size.width,btnSubmitPromo.frame.origin.y+btnSubmitPromo.frame.size.height+205);;
        }
//  
//     if(IS_IPHONE_5)
//    {
//        scrollViewDisc.contentSize =CGSizeMake(self.view.frame.size.width,btnSubmitDiscount.frame.origin.y+btnSubmitDiscount.frame.size.height+160);
//        scrollViewEvent.contentSize =CGSizeMake(self.view.frame.size.width,btnSubmitEvent.frame.origin.y+btnSubmitEvent.frame.size.height+160);
//        scrollViewPromo.contentSize  = CGSizeMake(self.view.frame.size.width,btnSubmitPromo.frame.origin.y+btnSubmitPromo.frame.size.height+160);;
//    }
//     if (IS_IPHONE_6)
//    {
//        scrollViewDisc.contentSize =CGSizeMake(self.view.frame.size.width,btnSubmitDiscount.frame.origin.y+btnSubmitDiscount.frame.size.height+200);
//        scrollViewEvent.contentSize =CGSizeMake(self.view.frame.size.width,btnSubmitEvent.frame.origin.y+btnSubmitEvent.frame.size.height+160);
//        scrollViewPromo.contentSize  = CGSizeMake(self.view.frame.size.width,btnSubmitPromo.frame.origin.y+btnSubmitPromo.frame.size.height+160);
//        
//    }
//    if(IS_IPHONE_6P )
//    {
//        
//        scrollViewDisc.contentSize =CGSizeMake(self.view.frame.size.width,btnSubmitDiscount.frame.origin.y+btnSubmitDiscount.frame.size.height+270);
//        scrollViewEvent.contentSize =CGSizeMake(self.view.frame.size.width,btnSubmitEvent.frame.origin.y+btnSubmitEvent.frame.size.height+270);//Dp
//        scrollViewPromo.contentSize  = CGSizeMake(self.view.frame.size.width,btnSubmitPromo.frame.origin.y+btnSubmitPromo.frame.size.height+270);
//    }
//    
    //temp
    //scrollViewDisc.contentSize =CGSizeMake(self.view.frame.size.width,btnSubmitDiscount.frame.origin.y+btnSubmitDiscount.frame.size.height+200);
    
    
    
    //scrollViewVideo.contentSize =CGSizeMake(self.view.frame.size.width, btnSubmitVideo.frame.origin.y+btnSubmitVideo.frame.size.height+20);//Dp
    scrollViewImage.contentSize =CGSizeMake(self.view.frame.size.width, btnSubmitImage.frame.origin.y + btnSubmitImage.frame.size.height + 20+ 64);//Dp
    //cp
    arrSubCatTownInfo=[[NSMutableArray alloc]initWithObjects:@"Contest",@"Happy Hour",@"Breakfast Specials",@"Lunch Specials",@"Dinner Specials",@"Kids Activites",@"Events",@"Local Sales",@"School News",@"Town News",@"Holiday", nil];
    app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (billBoardNo == 11)
    {
        [self.view addSubview:viewDiscount];
    }
    else if (billBoardNo == 12)
    {
        [self.view addSubview:viewPromos];
    }
    else if (billBoardNo == 13)
    {
        [self.view addSubview:viewEvents];
    }
    else  if (billBoardNo == 14)
    {
        [self.view addSubview:viewImage];
    }
    else if (billBoardNo == 15)
    {
        [self.view addSubview:viewVideo];
    }
    else
    {
        [self.view addSubview:viewSocial];
    }
    whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    // Do any additional setup after loading the view from its nib.
    isCheckDis=NO;
    isCheckPro=NO;
    isCheckEve =NO;
    isCheckImg=NO;
    isCheckVdo=NO;
    isCheckSocial=NO;
    btnSubCategoryDisVu.enabled=NO;
    btnSubCategoryEventVu.enabled=NO;
    btnSubCategoryPromoVu.enabled=NO;
    btnSubCategoryVideoVu.enabled=NO;
    btnSubCategoryImageVu.enabled=NO;
}

#pragma mark API Call

-(IBAction)submitDicountBoard:(id)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"Empower Main Street" message:@"Please check your internet connection." cancel:@"OK" other:nil];
    }
    else
    {
        [tfTitleDiscount resignFirstResponder];
        [tvDescDiscount resignFirstResponder];
        if ([self validDiscountData])
        {
                    //billboard_type = D , title, description   , optional parameter : exp_date
            NSDictionary *parameters;
            if (!isCheckDis)
            {
                parameters =@{ @"billboard_type" :@"D" ,
                               @"merchant_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"merchantid"],
                               @"title":tfTitleDiscount.text,
                               @"description":tvDescDiscount.text,
                               @"exp_date":btnDiscountExpDate.titleLabel.text
                               };
            }
            else
            {
                NSString *strCatName=btnSubCategoryDisVu.titleLabel.text;
                parameters =@{ @"billboard_type" :@"D" ,
                               @"merchant_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"merchantid"],
                               @"title":tfTitleDiscount.text,
                               @"description":tvDescDiscount.text,
                               @"exp_date":btnDiscountExpDate.titleLabel.text,
                               @"towncat_name":strCatName
                               };
            }
            [app showHUD];
            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *imageName = [NSString stringWithFormat:@"image_%d.png",app.imageNo];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:imageName];
            NSData *imageData = UIImagePNGRepresentation(imageSelected);
            if (imageData != nil)
            {
                [imageData writeToFile:filePath atomically:YES];
                app.imageNo ++;
            }
            //video
            NSMutableDictionary *parameter = [[NSMutableDictionary alloc] initWithDictionary:parameters];
       
            NSMutableArray *arrData = [[NSMutableArray alloc] init];
            NSMutableArray *arrFileName = [[NSMutableArray alloc]init];
            NSMutableArray *arrFileType = [[NSMutableArray alloc]init];
            NSData *videoData = [NSData dataWithContentsOfURL:videoUrl];
            if (videoData != nil)
            {
                NSString *path = [NSString stringWithFormat:@"%@/Documents/video1_%d",NSHomeDirectory(),app.imageNo];
                //NSString *videoName = [NSString stringWithFormat:@"video1_%d.mp4",app.imageNo];
                [videoData writeToFile:path atomically:NO];
                NSData *thumbnailData = UIImagePNGRepresentation(thumbImg);
                [arrData addObject:videoData];
                [arrData addObject:thumbnailData];
                [arrFileName addObject:@"video_name"];
                [arrFileName addObject:@"video_thumb"];
                [arrFileType addObject:@"video/mp4"];
                [arrFileType addObject:@"image/png"];
                [parameter setObject:@{@"data":arrData, @"name": arrFileName, @"type":arrFileType} forKey:@"videos"];
            }
            if (imageData != nil) {
                [parameter setObject:@{@"data": imageData, @"name": imageName} forKey:@"image"];
            }

            [app showHUD];
            [[JWNetWorkManager sharedManager] POST:@"addbill_board.php" data:parameters completion:^(id data, NSError *error) {
                [app hideHUD];
                if (error) {
                    NSLog(@"Error: %@", error);
                } else {
                    NSLog(@"%@ %@", error, data);
                    if ([[data valueForKey:@"status"] intValue]== 1)
                    {
                        [self showAlert:@"Successfull" message:@"Discount billboard created successfully." cancel:@"OK" other:nil];
                    }
                    else
                    {
                        [self showAlert:@"Error" message:@"Please try again." cancel:@"OK" other:nil];
                    }
                }
            }];
        }
    }
}
-(IBAction)submitPromoBoard:(id)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"" message:@"Please check your internet connection." cancel:@"OK" other:nil];
    }
    else
    {
        [tfTitlePromo resignFirstResponder];
        [tvDescPromo resignFirstResponder];
        if ([self validPromoData])
        {
            // billboard_type = P , title , description
            NSDictionary *parameters;
            if (!isCheckPro)
            {
                parameters =@{@"billboard_type" :@"P",
                              @"merchant_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"merchantid"],
                              @"title": tfTitlePromo.text ,
                              @"description":tvDescPromo.text,
                              @"exp_date":btnPromoExpDate.titleLabel.text
                              };
            }
            else
            {
                NSString *strCatName=btnSubCategoryPromoVu.titleLabel.text;
                parameters =@{@"billboard_type" :@"P",
                              @"merchant_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"merchantid"],
                              @"title": tfTitlePromo.text ,
                              @"description":tvDescPromo.text,
                              @"towncat_name":strCatName,
                              @"exp_date":btnPromoExpDate.titleLabel.text
                              };
            }
            [app showHUD];
            //cp
            //image
            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *imageName = [NSString stringWithFormat:@"image_%d.png",app.imageNo];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:imageName];
            NSData *imageData = UIImagePNGRepresentation(imageSelected);
            if (imageData != nil)
            {
                [imageData writeToFile:filePath atomically:YES];
                app.imageNo ++;
            }
            NSMutableDictionary *parameter = [[NSMutableDictionary alloc] initWithDictionary:parameters];
            
            NSMutableArray *arrData = [[NSMutableArray alloc] init];
            NSMutableArray *arrFileName = [[NSMutableArray alloc]init];
            NSMutableArray *arrFileType = [[NSMutableArray alloc]init];
            NSData *videoData = [NSData dataWithContentsOfURL:videoUrl];
            if (videoData != nil)
            {
                NSString *path = [NSString stringWithFormat:@"%@/Documents/video1_%d",NSHomeDirectory(),app.imageNo];
                //NSString *videoName = [NSString stringWithFormat:@"video1_%d.mp4",app.imageNo];
                [videoData writeToFile:path atomically:NO];
                NSData *thumbnailData = UIImagePNGRepresentation(thumbImg);
                [arrData addObject:videoData];
                [arrData addObject:thumbnailData];
                [arrFileName addObject:@"video_name"];
                [arrFileName addObject:@"video_thumb"];
                [arrFileType addObject:@"video/mp4"];
                [arrFileType addObject:@"image/png"];
                [parameter setObject:@{@"data":arrData, @"name": arrFileName, @"type":arrFileType} forKey:@"videos"];
            }
            if (imageData != nil) {
                [parameter setObject:imageData forKey:@"image"];
            }
            
            [app showHUD];
            [[JWNetWorkManager sharedManager] POST:@"addbill_board.php" data:parameters completion:^(id data, NSError *error) {
                [app hideHUD];
                if (error) {
                    NSLog(@"Error: %@", error);
                } else {
                    NSLog(@"%@ %@", error, data);
                    if ([[data valueForKey:@"status"] intValue]== 1)
                    {
                        [self showAlert:@"Successfull" message:@"Discount billboard created successfully." cancel:@"OK" other:nil];
                    }
                    else
                    {
                        [self showAlert:@"Error" message:@"Please try again." cancel:@"OK" other:nil];
                    }
                }
            }];
        }
    }
}

-(IBAction)submitEventBoard:(id)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"" message:@"Please check your internet connection." cancel:@"OK" other:nil];
    }
    else
    {
        [tfTitleEvents resignFirstResponder];
        [tfLocationEvent resignFirstResponder];
        [tvDescEvent resignFirstResponder];
        if ([self validEventData])
        {
            if (strDate == nil)
            {
                strDate = @"";
            }
            //  billboard_type = E , title , description, event_location, optional parameter : event_time
            NSDictionary *parameters;
            if (!isCheckEve)
            {
                parameters =@{@"billboard_type" :@"E",
                              @"merchant_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"merchantid"],
                              @"title": tfTitleEvents.text ,
                              @"description":tvDescEvent.text ,
                              @"event_location":tfLocationEvent.text,
                              @"event_time":strDate,
                              @"exp_date":btnEventExpDate.titleLabel.text
                              };
            }
            else
            {
                NSString *strCatName=btnSubCategoryEventVu.titleLabel.text;
                parameters =@{@"billboard_type" :@"E",
                              @"merchant_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"merchantid"],
                              @"title": tfTitleEvents.text ,
                              @"description":tvDescEvent.text ,
                              @"event_location":tfLocationEvent.text,
                              @"event_time":strDate,
                              @"towncat_name":strCatName,
                              @"exp_date":btnEventExpDate.titleLabel.text
                              };
            }
            //cp
            //image
            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
            NSString *imageName = [NSString stringWithFormat:@"image_%d.png",app.imageNo];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:imageName];
            NSData *imageData = UIImagePNGRepresentation(imageSelected);
            if (imageData != nil)
            {
                [imageData writeToFile:filePath atomically:YES];
                app.imageNo ++;
            }
            //video
            NSMutableDictionary *parameter = [[NSMutableDictionary alloc] initWithDictionary:parameters];
            NSMutableArray *arrData = [[NSMutableArray alloc] init];
            NSMutableArray *arrFileName = [[NSMutableArray alloc]init];
            NSMutableArray *arrFileType = [[NSMutableArray alloc]init];
            NSData *videoData = [NSData dataWithContentsOfURL:videoUrl];
            if (videoData != nil)
            {
                NSString *path = [NSString stringWithFormat:@"%@/Documents/video1_%d",NSHomeDirectory(),app.imageNo];
                //NSString *videoName = [NSString stringWithFormat:@"video1_%d.mp4",app.imageNo];
                [videoData writeToFile:path atomically:NO];
                NSData *thumbnailData = UIImagePNGRepresentation(thumbImg);
                [arrData addObject:videoData];
                [arrData addObject:thumbnailData];
                [arrFileName addObject:@"video_name"];
                [arrFileName addObject:@"video_thumb"];
                [arrFileType addObject:@"video/mp4"];
                [arrFileType addObject:@"image/png"];
                [parameter setObject:@{@"data":arrData, @"name": arrFileName, @"type":arrFileType} forKey:@"videos"];
            }
            if (imageData != nil) {
                [parameter setObject:imageData forKey:@"image"];
            }
            
            [app showHUD];
            [[JWNetWorkManager sharedManager] POST:@"addbill_board.php" data:parameters completion:^(id data, NSError *error) {
                [app hideHUD];
                if (error) {
                    NSLog(@"Error: %@", error);
                } else {
                    NSLog(@"%@ %@", error, data);
                    if ([[data valueForKey:@"status"] intValue]== 1)
                    {
                        [self showAlert:@"Successfull" message:@"Discount billboard created successfully." cancel:@"OK" other:nil];
                    }
                    else
                    {
                        [self showAlert:@"Error" message:@"Please try again." cancel:@"OK" other:nil];
                    }
                }
            }];
        }
    }
}

-(IBAction)submitImageBoard:(id)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"" message:@"Please check your internet connection." cancel:@"OK" other:nil];
    }
    else
    {
        [tfTitleImage resignFirstResponder];
        if ([self validImageData])
        {
            // billboard_type = I, title , image_name
            NSDictionary *parameters;
            if (!isCheckImg)
            {
                parameters =@{@"billboard_type": @"I",
                              @"merchant_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"merchantid"],
                              @"title": tfTitleImage.text,
                              @"exp_date":btnImageExpDate.titleLabel.text
                              };
            }
            else
            {
                NSString *strCatName=btnSubCategoryImageVu.titleLabel.text;
                parameters =@{@"billboard_type": @"I",
                              @"merchant_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"merchantid"],
                              @"title": tfTitleImage.text,
                              @"towncat_name":strCatName,
                              @"exp_date":btnImageExpDate.titleLabel.text
                              };
                
            }
            

            [app showHUD];
            NSMutableDictionary *parameter = [[NSMutableDictionary alloc] initWithDictionary:parameters];
            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *imageName = [NSString stringWithFormat:@"image_%d.png",app.imageNo];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:imageName];
            NSData *imageData = UIImagePNGRepresentation(imageSelected);
            [imageData writeToFile:filePath atomically:YES];
            [parameter setObject:@{@"data": imageData, @"name":imageName} forKey:@"image"];
            app.imageNo ++;

            [[JWNetWorkManager sharedManager] POST:@"addbill_board.php" data:parameter completion:^(id data, NSError *error) {
                [app hideHUD];
                if (error) {
                    NSLog(@"Error: %@", error);
                } else {
                    NSLog(@"%@ %@", error, data);
                    if ([[data valueForKey:@"status"] intValue]== 1)
                    {
                        if(socialShareModalView.switchFB.isOn){
                            
                            [self postImageToFB:imageData];
                        }
                        if(socialShareModalView.switchIST.isOn){
                            
                            [self postImageToIST:imageData];
                        }
                        if(socialShareModalView.switchIN.isOn){
                            
                            [self postImageToIN:imageData];
                        }
                        if(socialShareModalView.switchGG.isOn){
                            
                            [self postImageToGG:imageData];
                        }
                        if(socialShareModalView.switchTW.isOn){
                            
                            [self shareTwitterImage:imageData];
                        }
                        if(socialShareModalView.switchPT.isOn){
                            
                            [self postImageToPT:[NSURL URLWithString:@""]];
                        }
                        [self showAlert:@"Successfull" message:@"Discount billboard created successfully." cancel:@"OK" other:nil];
                    }
                    else
                    {
                        [self showAlert:@"Error" message:@"Please try again." cancel:@"OK" other:nil];
                    }
                }
            }];
        }
    }
}

-(IBAction)submitVideoBoard:(id)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
       [self showAlert:@"" message:@"Please check your internet connection." cancel:@"OK" other:nil];
    }
    else
    {
        [tfTitleVideo resignFirstResponder];
        if ([self validVideoData])
        {
            // billboard_type = V, title , video_name
            NSDictionary *parameters;
            if (!isCheckVdo)
            {
                parameters =@{@"billboard_type":@"V" ,
                              @"merchant_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"merchantid"],
                              @"title":tfTitleVideo.text,
                              @"exp_date":btnVideoExpDate.titleLabel.text
                              };
            }
            else
            {
                NSString *strCatName=btnSubCategoryVideoVu.titleLabel.text;
                parameters =@{@"billboard_type":@"V" ,
                              @"merchant_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"merchantid"],
                              @"title":tfTitleVideo.text,
                              @"towncat_name":strCatName,
                              @"exp_date":btnVideoExpDate.titleLabel.text
                              };
            }
            NSMutableDictionary *parameter = [[NSMutableDictionary alloc] initWithDictionary:parameters];
            
            NSMutableArray *arrData = [[NSMutableArray alloc] init];
            NSMutableArray *arrFileName = [[NSMutableArray alloc]init];
            NSMutableArray *arrFileType = [[NSMutableArray alloc]init];
            NSData *videoData = [NSData dataWithContentsOfURL:videoUrl];
            if (videoData != nil)
            {
                NSString *path = [NSString stringWithFormat:@"%@/Documents/video1_%d",NSHomeDirectory(),app.imageNo];
                //NSString *videoName = [NSString stringWithFormat:@"video1_%d.mp4",app.imageNo];
                [videoData writeToFile:path atomically:NO];
                NSData *thumbnailData = UIImagePNGRepresentation(thumbImg);
                [arrData addObject:videoData];
                [arrData addObject:thumbnailData];
                [arrFileName addObject:@"video_name"];
                [arrFileName addObject:@"video_thumb"];
                [arrFileType addObject:@"video/mp4"];
                [arrFileType addObject:@"image/png"];
                [parameter setObject:@{@"data":arrData, @"name": arrFileName, @"type":arrFileType} forKey:@"videos"];
            }
            
            [app showHUD];
            [[JWNetWorkManager sharedManager] POST:@"addbill_board.php" data:parameters completion:^(id data, NSError *error) {
                [app hideHUD];
                if (error) {
                    NSLog(@"Error: %@", error);
                } else {
                    NSLog(@"%@ %@", error, data);
                    if ([[data valueForKey:@"status"] intValue]== 1)
                    {
                        [self showAlert:@"Successfull" message:@"Discount billboard created successfully." cancel:@"OK" other:nil];
                    }
                    else
                    {
                        [self showAlert:@"Error" message:@"Please try again." cancel:@"OK" other:nil];
                    }
                }
            }];
            
        }
    }
}

-(IBAction)submitSocialBoard:(id)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"" message:@"Please check your internet connection." cancel:@"OK" other:nil];
    }
    else
    {
        [tfTitleSocial resignFirstResponder];
        [tfGoogle resignFirstResponder];
        [tfFacebook resignFirstResponder];
        [tfTwitter resignFirstResponder];
        [tfWebsite resignFirstResponder];
        if ([self validSocialData])
        {
            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            NSMutableDictionary *fbData =[[NSMutableDictionary alloc] init];
            NSMutableDictionary *googleData =[[NSMutableDictionary alloc] init];
            NSMutableDictionary *twitterData =[[NSMutableDictionary alloc] init];
            NSMutableDictionary *websiteData =[[NSMutableDictionary alloc] init];
            
            if (tfFacebook.text.length != 0)
            {
                [fbData setValue:@"facebook" forKey:@"title"];
                [fbData setValue:tfFacebook.text forKey:@"url"];
                [data setObject:fbData forKey:@"fb"];
            }
            if (tfTwitter.text.length != 0)
            {
                [twitterData setValue:@"twitter" forKey:@"title"];
                [twitterData setValue:tfTwitter.text forKey:@"url"];
                [data setObject:twitterData forKey:@"tw"];
            }
            if (tfGoogle.text.length != 0)
            {
                [googleData setValue:@"google" forKey:@"title"];
                [googleData setValue:tfGoogle.text forKey:@"url"];
                [data setObject:googleData forKey:@"g+"];
            }
            if (tfWebsite.text.length != 0)
            {
                [websiteData setValue:@"website" forKey:@"title"];
                [websiteData setValue:tfWebsite.text forKey:@"url"];
                [data setObject:websiteData forKey:@"web"];
            }
            if (data.count==0)
            {
                [data setValue:@"" forKey:@""];
            }
            // billboard_type = S, title , url [dict] social={site: FB,url=http://fb.com}
            NSDictionary *parameters;
            parameters =@{@"billboard_type" : @"S" ,
                          @"merchant_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"merchantid"],
                          @"social":data,
                          @"exp_date":btnSocialExpDate.titleLabel.text
                          };
            [app showHUD];
            [[JWNetWorkManager sharedManager] POST:@"addbill_board.php" data:parameters completion:^(id data, NSError *error) {
                [app hideHUD];
                if (error) {
                    NSLog(@"Error: %@", error);
                } else {
                    NSLog(@" %@", data);
                    if ([[data valueForKey:@"status"] intValue]== 1)
                    {
                        [self showAlert:@"Successfull" message:@"Social billboard created successfully." cancel:@"OK" other:nil];
                    }
                    else
                    {
                        [self showAlert:@"Error" message:@"Please try again." cancel:@"OK" other:nil];
                    }
                }
            }];

        }
    }
}

#pragma mark Validation

-(BOOL)validDiscountData
{
    if ([tfTitleDiscount.text stringByTrimmingCharactersInSet:whitespace].length == 0 || [[tfTitleDiscount.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        [self showAlert:@"Alert" message:@"Please enter title." cancel:@"OK" other:nil];
        return NO;
    }
    else if([tvDescDiscount.text stringByTrimmingCharactersInSet:whitespace].length == 0 || [[tvDescDiscount.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        [self showAlert:@"Alert" message:@"Please enter description." cancel:@"OK" other:nil];
        return NO;
    }
    else if(isCheckDis && [btnSubCategoryDisVu.titleLabel.text stringByTrimmingCharactersInSet:whitespace].length == 0)
    {
        [self showAlert:@"Alert" message:@"Please select category." cancel:@"OK" other:nil];
        return NO;
    }
    else
    {
        return YES;
    }
}

-(BOOL)validPromoData
{
    if ([tfTitlePromo.text stringByTrimmingCharactersInSet:whitespace].length == 0 || [[tfTitlePromo.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        [self showAlert:@"Alert" message:@"Please enter title." cancel:@"OK" other:nil];
        return NO;
    }
    else if([tvDescPromo.text stringByTrimmingCharactersInSet:whitespace].length == 0 || [[tvDescPromo.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        [self showAlert:@"Alert" message:@"Please enter description." cancel:@"OK" other:nil];
        return NO;
    }
    else if(isCheckPro && [btnSubCategoryPromoVu.titleLabel.text stringByTrimmingCharactersInSet:whitespace].length == 0)
    {
        [self showAlert:@"Alert" message:@"Please select category." cancel:@"OK" other:nil];
        return NO;
    }
    else
    {
        return YES;
    }
}

-(BOOL)validEventData
{
    if ([tfTitleEvents.text stringByTrimmingCharactersInSet:whitespace].length == 0 || [[tfTitleEvents.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        [self showAlert:@"Alert" message:@"Please enter title." cancel:@"OK" other:nil];
        return NO;
    }
    if ([tfLocationEvent.text stringByTrimmingCharactersInSet:whitespace].length == 0 || [[tfLocationEvent.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        [self showAlert:@"Alert" message:@"Please enter location of event." cancel:@"OK" other:nil];
        return NO;
    }
    else if([tvDescEvent.text stringByTrimmingCharactersInSet:whitespace].length == 0 || [[tvDescEvent.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        [self showAlert:@"Alert" message:@"Please enter description." cancel:@"OK" other:nil];
        return NO;
    }
    else if(isCheckEve && [btnSubCategoryEventVu.titleLabel.text stringByTrimmingCharactersInSet:whitespace].length == 0)
    {
        [self showAlert:@"Alert" message:@"Please select category." cancel:@"OK" other:nil];
        return NO;
    }
    else
    {
        return YES;
    }
}

-(BOOL)validImageData
{
    if ([tfTitleImage.text stringByTrimmingCharactersInSet:whitespace].length == 0 || [[tfTitleImage.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        [self showAlert:@"Alert" message:@"Please enter title." cancel:@"OK" other:nil];
        return NO;
    }
    else if( UIImagePNGRepresentation(imageSelected) == nil)
    {
        
        [self showAlert:@"Alert" message:@"Please select image." cancel:@"OK" other:nil];
        return NO;
    }
    else if(isCheckImg && [btnSubCategoryImageVu.titleLabel.text stringByTrimmingCharactersInSet:whitespace].length == 0)
    {
        [self showAlert:@"Alert" message:@"Please select category." cancel:@"OK" other:nil];
        return NO;
    }
    else
    {
        return YES;
    }
}

-(BOOL)validVideoData
{
    if ([tfTitleVideo.text stringByTrimmingCharactersInSet:whitespace].length == 0 || [[tfTitleVideo.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        [self showAlert:@"Alert" message:@"Please enter title." cancel:@"OK" other:nil];
        return NO;
    }
    else if (videoUrl == nil)
    {
        [self showAlert:@"Alert" message:@"Please select video." cancel:@"OK" other:nil];
        return NO;
    }
    else if(isCheckVdo && [btnSubCategoryVideoVu.titleLabel.text stringByTrimmingCharactersInSet:whitespace].length == 0)
    {
        [self showAlert:@"Alert" message:@"Please select category." cancel:@"OK" other:nil];
        return NO;
    }
    else
    {
        return YES;
    }
}

-(BOOL)validSocialData
{
    if ([tfTitleSocial.text stringByTrimmingCharactersInSet:whitespace].length == 0 || [[tfTitleSocial.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        [self showAlert:@"Alert" message:@"Please enter title." cancel:@"OK" other:nil];
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark- Other Methods

-(IBAction)btnCheckPressed:(id)sender
{
    if (billBoardNo == 11)
    {
        if ([btnCheckDisVu isSelected])
        {
            [btnCheckDisVu setSelected:NO];
            [btnSubCategoryDisVu setEnabled:NO];
            //cp
            btnSubCategoryDisVu.titleLabel.text =@"";
            [dropDown hideDropDown:btnSubCategoryDisVu];
            dropDown = nil;
            isCheckDis=NO;
        }
        else
        {
            [btnCheckDisVu setSelected:YES];
            [btnSubCategoryDisVu setEnabled:YES];
            isCheckDis=YES;
        }
    }
    else if (billBoardNo == 12)
    {
        if ([btnCheckPromoVu isSelected])
        {
            [btnCheckPromoVu setSelected:NO];
            [btnSubCategoryPromoVu setEnabled:NO];
            
            btnSubCategoryPromoVu.titleLabel.text =@"";
            [dropDown hideDropDown:btnSubCategoryPromoVu];
            dropDown = nil;
            isCheckPro=NO;
        }
        else
        {
            [btnCheckPromoVu setSelected:YES];
            [btnSubCategoryPromoVu setEnabled:YES];
            isCheckPro=YES;
        }
    }
    else if (billBoardNo == 13)
    {
        if ([btnCheckEventVu isSelected])
        {
            [btnCheckEventVu setSelected:NO];
            [btnSubCategoryEventVu setEnabled:NO];
            
            btnSubCategoryEventVu.titleLabel.text =@"";
            [dropDown hideDropDown:btnSubCategoryEventVu];
            dropDown = nil;
            isCheckEve=NO;
        }
        else
        {
            [btnCheckEventVu setSelected:YES];
            [btnSubCategoryEventVu setEnabled:YES];
            isCheckEve=YES;
        }
    }
    else  if (billBoardNo == 14)
    {
        if ([btnCheckImageVu isSelected])
        {
            [btnCheckImageVu setSelected:NO];
            [btnSubCategoryImageVu setEnabled:NO];
            
            btnSubCategoryImageVu.titleLabel.text =@"";
            [dropDown hideDropDown:btnSubCategoryImageVu];
            dropDown = nil;
            isCheckImg=NO;
        }
        else
        {
            [btnCheckImageVu setSelected:YES];
            [btnSubCategoryImageVu setEnabled:YES];
            isCheckImg=YES;
        }
    }
    else if (billBoardNo == 15)
    {
        if ([btnCheckVideoVu isSelected])
        {
            [btnCheckVideoVu setSelected:NO];
            [btnSubCategoryVideoVu setEnabled:NO];
            
            btnSubCategoryVideoVu.titleLabel.text =@"";
            [dropDown hideDropDown:btnSubCategoryVideoVu];
            dropDown = nil;
            isCheckVdo=NO;
        }
        else
        {
            [btnCheckVideoVu setSelected:YES];
            [btnSubCategoryVideoVu setEnabled:YES];
            isCheckVdo=YES;
        }
    }
}

-(IBAction)btnSelectSubCategoryPressed:(id)sender
{
    if (billBoardNo == 11)
    {
        if ([btnCheckDisVu isSelected])
        {
            CGFloat f = 100;
            if(dropDown == nil)
            {   dropDown = [[NIDropDown alloc]showDropDown:btnSubCategoryDisVu height:&f arr:arrSubCatTownInfo imgArr:nil direction:@"up"];
                dropDown.delegate = self;
            }
            else
            {
                [dropDown hideDropDown:btnSubCategoryDisVu];
                dropDown = nil;
            }
        }
    }
    else if (billBoardNo == 12)
    {
        if ([btnCheckPromoVu isSelected])
        {
            CGFloat f = 100;
            if(dropDown == nil)
            {   dropDown = [[NIDropDown alloc]showDropDown:btnSubCategoryPromoVu height:&f arr:arrSubCatTownInfo imgArr:nil direction:@"up"];
                dropDown.delegate = self;
            }
            else
            {
                [dropDown hideDropDown:btnSubCategoryPromoVu];
                dropDown = nil;
            }
        }
        
    }
    else if (billBoardNo == 13)
    {
        if ([btnCheckEventVu isSelected])
        {
            CGFloat f = 100;
            if(dropDown == nil)
            {   dropDown = [[NIDropDown alloc]showDropDown:btnSubCategoryEventVu height:&f arr:arrSubCatTownInfo imgArr:nil direction:@"up"];
                dropDown.delegate = self;
            }
            else
            {
                [dropDown hideDropDown:btnSubCategoryEventVu];
                dropDown = nil;
            }
        }
    }
    else  if (billBoardNo == 14)
    {
        if ([btnCheckImageVu isSelected])
        {
            CGFloat f = 100;
            if(dropDown == nil)
            {   dropDown = [[NIDropDown alloc]showDropDown:btnSubCategoryImageVu height:&f arr:arrSubCatTownInfo imgArr:nil direction:@"up"];
                dropDown.delegate = self;
            }
            else
            {
                [dropDown hideDropDown:btnSubCategoryImageVu];
                dropDown = nil;
            }
        }
    }
    else if (billBoardNo == 15)
    {
        if ([btnCheckVideoVu isSelected])
        {
            CGFloat f = 100;
            if(dropDown == nil)
            {   dropDown = [[NIDropDown alloc]showDropDown:btnSubCategoryVideoVu height:&f arr:arrSubCatTownInfo imgArr:nil direction:@"up"];
                dropDown.delegate = self;
            }
            else
            {
                [dropDown hideDropDown:btnSubCategoryVideoVu];
                dropDown = nil;
            }
        }
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender
{
    dropDown=nil;
}

#pragma mark IBAction Select Image

-(IBAction)selectImage:(id)sender
{
    [tfTitleDiscount resignFirstResponder];
    [tfTitleEvents resignFirstResponder];
    [tfTitleImage resignFirstResponder];
    [tfTitlePromo resignFirstResponder];
    [tfTitleVideo resignFirstResponder];
    [tvDescDiscount resignFirstResponder];
    [tvDescEvent resignFirstResponder];
    [tvDescPromo resignFirstResponder];
    [tfLocationEvent resignFirstResponder];
    [dropDown hideDropDown:btnSubCategoryDisVu];
    [dropDown hideDropDown:btnSubCategoryPromoVu];
    [dropDown hideDropDown:btnSubCategoryEventVu];
    [dropDown hideDropDown:btnSubCategoryImageVu];
    [dropDown hideDropDown:btnSubCategoryVideoVu];
    dropDown = nil;

    UIAlertController *alert = [[UIAlertController alloc] init];
    alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photolibrary = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            flagPicker = 1;
            picker.delegate = self;
            picker.allowsEditing = YES;
            [[picker navigationBar]setTintColor:[UIColor whiteColor]];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:NULL];
    }];
    [alert addAction:photolibrary];
    UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            flagPicker = 1;
            picker.delegate = self;
            picker.allowsEditing = YES;
            [[picker navigationBar]setTintColor:[UIColor whiteColor]];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
    }];
    [alert addAction:btn_ok];
    UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:^{
        }];
    }];
    [alert addAction:btn_cancel];
    [self presentViewController:alert animated:YES completion:nil];

}

-(IBAction)selectVideo:(id)sender
{
    [tfTitleDiscount resignFirstResponder];
    [tfTitleEvents resignFirstResponder];
    [tfTitleImage resignFirstResponder];
    [tfTitlePromo resignFirstResponder];
    [tfTitleVideo resignFirstResponder];
    [tvDescDiscount resignFirstResponder];
    [tvDescEvent resignFirstResponder];
    [tvDescPromo resignFirstResponder];
    [tfLocationEvent resignFirstResponder];
    [dropDown hideDropDown:btnSubCategoryDisVu];
    [dropDown hideDropDown:btnSubCategoryPromoVu];
    [dropDown hideDropDown:btnSubCategoryEventVu];
    [dropDown hideDropDown:btnSubCategoryImageVu];
    [dropDown hideDropDown:btnSubCategoryVideoVu];
    dropDown = nil;
//    UIActionSheet *actionSheet = [[UIActionSheet alloc]
//                                  initWithTitle:nil
//                                  delegate:self
//                                  cancelButtonTitle:@"Cancel"
//                                  destructiveButtonTitle:@"Video Library"
//                                  otherButtonTitles:@"Camera", nil];
//    actionSheet.tag = 2;
//    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
//    [actionSheet showInView:self.view];
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photolibrary = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            flagPicker = 2;
            picker.delegate = self;
            picker.allowsEditing = YES;
            [[picker navigationBar]setTintColor:[UIColor whiteColor]];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:NULL];
    }];
    [alert addAction:photolibrary];
    UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            flagPicker = 2;
            picker.delegate = self;
            picker.allowsEditing = YES;
            [[picker navigationBar]setTintColor:[UIColor whiteColor]];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
    }];
    [alert addAction:btn_ok];
    UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:^{
        }];
    }];
    [alert addAction:btn_cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark imagepicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
  
    picker.allowsEditing = YES;
    if(flagPicker == 1)
    {
        
        if (picker.allowsEditing)
        {
            imageSelected =info[UIImagePickerControllerEditedImage];
            NSData *imageData = UIImageJPEGRepresentation([self fixOrientation:imageSelected], 0.3);
            //    [imageData writeToFile:filePath atomically:YES];
            imageSelected = [UIImage imageWithData:imageData];

        }
        else
        {
            imageSelected =info[UIImagePickerControllerOriginalImage];
            NSData *imageData = UIImageJPEGRepresentation([self fixOrientation:imageSelected], 0.3);
        //    [imageData writeToFile:filePath atomically:YES];
           imageSelected = [UIImage imageWithData:imageData];
        }
        
     //   imageSelected = [self fixOrientation:imageSelected];
        imgViewPromoSelected.image =imageSelected;
        imgViewEventSelected.image=imageSelected;
        imgViewDiscountSelected.image=imageSelected;
        imgViewSelected.image = imageSelected;
        imgViewPromoSelected.hidden=NO;
        imgViewDiscountSelected.hidden=NO;
        imgViewEventSelected.hidden=NO;
        imgViewSelected.hidden = NO;
        lblImage.hidden = NO;
        
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else if (flagPicker == 2)
    {
        videoUrl= [info objectForKey:UIImagePickerControllerMediaURL];
        AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:videoUrl options:nil];
        AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        generator.appliesPreferredTrackTransform=TRUE;
        
        CMTime thumbTime = CMTimeMakeWithSeconds(30,30);
        
        AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
            if (result != AVAssetImageGeneratorSucceeded)
            {
                // NSLog(@"couldn't generate thumbnail, error:%@", error);
            }
            thumbImg = [UIImage imageWithCGImage:im] ;
             imgViewPlay.center=imgViewVideoThumbnail.center;
            imgViewVideoThumbnail.image = thumbImg;
            imgViewVideoThumbnailDiscout.image=thumbImg;
            imgViewVideoThumbnailEvent.image=thumbImg;
            imgViewVideoThumbnailPromo.image=thumbImg;
        };
        CGSize maxSize = CGSizeMake(128, 128);
        generator.maximumSize = maxSize;
        [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
        imgViewVideoThumbnail.image = thumbImg;
        imgViewPlay.hidden=NO;
        imgViewVideoThumbnailDiscout.image=thumbImg;
        imgViewPlayDiscount.hidden=NO;
        imgViewVideoThumbnailEvent.image=thumbImg;
        imgViewPlayEvent.hidden=NO;
        imgViewVideoThumbnailPromo.image=thumbImg;
        imgViewPlayPromo.hidden=NO;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark Comman method

-(IBAction)btnExpDateClicked:(id)sender
{
    [tfTitleDiscount resignFirstResponder];
    [tfTitleEvents resignFirstResponder];
    [tvDescDiscount resignFirstResponder];
    [tvDescEvent resignFirstResponder];
    [tfLocationEvent resignFirstResponder];
    btnTemp = (UIButton *)sender;
    viewDatePicker.frame = self.view.frame;
    viewDatePicker.alpha = 0;
    [self.view addSubview:viewDatePicker];
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseIn  animations:^
     {
         viewDatePicker.alpha = 1;
     }
                     completion:nil];
    //UIViewAnimationOptionCurveLinear
    [UIView commitAnimations];
}

#pragma mark- Picker View Method

-(IBAction)btnExpiredClicked:(id)sender
{
    [tfTitleDiscount resignFirstResponder];
    [tfTitleEvents resignFirstResponder];
    [tvDescDiscount resignFirstResponder];
    [tvDescEvent resignFirstResponder];
    [tfLocationEvent resignFirstResponder];
    btnTemp = (UIButton *)sender;
    viewPicker.frame =self.view.frame;
    viewPicker.alpha = 0;
    [self.view addSubview:viewPicker];
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseIn  animations:^
     {
         viewPicker.alpha = 1;
     }
                     completion:nil];
    //UIViewAnimationOptionCurveLinear
    [UIView commitAnimations];
}

-(IBAction)btnPickerDone:(id)sender
{
    NSString *text = [arrExpDate objectAtIndex:[pickerExpDate selectedRowInComponent:0]];
    [btnVideoExpDate setTitle:text forState:UIControlStateNormal];
    [btnDiscountExpDate setTitle:text forState:UIControlStateNormal];
    [btnPromoExpDate setTitle:text forState:UIControlStateNormal];
    [btnEventDate setTitle:text forState:UIControlStateNormal];
    [btnImageExpDate setTitle:text forState:UIControlStateNormal];
    [btnSocialExpDate setTitle:text forState:UIControlStateNormal];
    [viewPicker removeFromSuperview];
}

#pragma mark- PickerView Delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [arrExpDate count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [arrExpDate objectAtIndex:row];
}

#pragma mark TextFeild Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark TextView Delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView commitAnimations];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [dropDown hideDropDown:btnSubCategoryDisVu];
    [dropDown hideDropDown:btnSubCategoryPromoVu];
    [dropDown hideDropDown:btnSubCategoryEventVu];
    [dropDown hideDropDown:btnSubCategoryImageVu];
    [dropDown hideDropDown:btnSubCategoryVideoVu];
    dropDown = nil;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake( self.view.frame.origin.x,0 , self.view.frame.size.width,  self.view.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark Date Picker method

-(IBAction)btnPickerCancel
{
    [viewDatePicker removeFromSuperview];
    [viewPicker removeFromSuperview];
}

-(IBAction)btnPickerDone
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString * strExpDateSel = [dateFormatter stringFromDate:datePicker.date];
    if (btnTemp.tag ==1)
    {
        lblEventDate.hidden = NO;
        lblEventDate.text = strExpDateSel;
        strDate = strExpDateSel;
    }
    else
    {
        lblExpDateDiscount.hidden = NO;
        lblExpDateDiscount.text = strExpDateSel;
        strDate = strExpDateSel;
    }
    [viewDatePicker removeFromSuperview];
}

-(IBAction)btnCancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Touch Event

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tvDescDiscount resignFirstResponder];
    [tvDescEvent resignFirstResponder];
    [tvDescPromo resignFirstResponder];
    [tfFacebook resignFirstResponder];
    [tfGoogle resignFirstResponder];
    [tfLocationEvent resignFirstResponder];
    [tfTitleDiscount resignFirstResponder];
    [tfTitleEvents resignFirstResponder];
    [tfTitleImage resignFirstResponder];
    [tfTitlePromo resignFirstResponder];
    [tfTitleSocial resignFirstResponder];
    [tfTitleVideo resignFirstResponder];
    [tfTwitter resignFirstResponder];
    [tfWebsite resignFirstResponder];
    [dropDown hideDropDown:btnSubCategoryDisVu];
    [dropDown hideDropDown:btnSubCategoryPromoVu];
    [dropDown hideDropDown:btnSubCategoryEventVu];
    [dropDown hideDropDown:btnSubCategoryImageVu];
    [dropDown hideDropDown:btnSubCategoryVideoVu];
    dropDown = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PrivateMethod Implimentation

-(void)setEdgesInsectForTextField:(UITextField *)txt
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    txt.leftView = paddingView;
    txt.leftViewMode = UITextFieldViewModeAlways;
}


//Dp Image raoate

- (UIImage *)fixOrientation:(UIImage *)imgLocal
{
    
    // No-op if the orientation is already correct
    if (imgLocal.imageOrientation == UIImageOrientationUp) return imgLocal;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (imgLocal.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imgLocal.size.width, imgLocal.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, imgLocal.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, imgLocal.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (imgLocal.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imgLocal.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, imgLocal.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, imgLocal.size.width, imgLocal.size.height,
                                             CGImageGetBitsPerComponent(imgLocal.CGImage), 0,
                                             CGImageGetColorSpace(imgLocal.CGImage),
                                             CGImageGetBitmapInfo(imgLocal.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (imgLocal.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,imgLocal.size.height,imgLocal.size.width), imgLocal.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,imgLocal.size.width,imgLocal.size.height), imgLocal.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


// Social Share Process
- (IBAction)showSocialShareModalView:(id)sender {
    
    [socialShareModalView.switchFB addTarget:self action:@selector(checkFBShare) forControlEvents:UIControlEventTouchUpInside];
    [socialShareModalView.switchTW addTarget:self action:@selector(checkTWShare) forControlEvents:UIControlEventTouchUpInside];
    [socialShareModalView.switchPT addTarget:self action:@selector(checkPTShare) forControlEvents:UIControlEventTouchUpInside];
    [socialShareModalView.switchGG addTarget:self action:@selector(checkGGShare) forControlEvents:UIControlEventTouchUpInside];
    [socialShareModalView.switchIST addTarget:self action:@selector(checkISTShare) forControlEvents:UIControlEventTouchUpInside];
    [socialShareModalView.switchIN addTarget:self action:@selector(checkINShare) forControlEvents:UIControlEventTouchUpInside];
    [[KGModal sharedInstance] setCloseButtonType:KGModalCloseButtonTypeNone];
    [[KGModal sharedInstance] showWithContentView:socialShareModalView];
}
- (void) checkTWShare {
    [[Twitter sharedInstance] logInWithViewController:self completion:^(TWTRSession *session, NSError *error) {
        if (!error) {
//            [[[Twitter sharedInstance] APIClient] loadUserWithID:session.userID completion:^(TWTRUser *user, NSError *error) {
//                
//                if (!error) {
//                    TWTRShareEmailViewController *emailController = [[TWTRShareEmailViewController alloc] initWithCompletion:^(NSString *email, NSError *error) {
//                        
//                    }];
//                    [self presentViewController:emailController animated:YES completion:nil];
//                }
//            }];
        } else {
            
        }
    }];
    
}
- (void)shareTwitterImage:(NSData *)image
{
    UIImage *postImage = [UIImage imageWithData:image];
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error)
     {
         if(granted)
         {
             NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
             
             if ([accountsArray count] > 0)
             {
                 ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                 
                 TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://upload.twitter.com/1/statuses/update_with_media.json"] parameters:[NSDictionary dictionaryWithObject:@"" forKey:@"status"] requestMethod:TWRequestMethodPOST];
                 
                 [postRequest addMultiPartData:UIImagePNGRepresentation(postImage) withName:@"media" type:@"multipart/png"];
                 
                 [postRequest setAccount:twitterAccount];
                 
                 [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      //show status after done
                      NSString *output = [NSString stringWithFormat:@"HTTP response status: %li", (long)[urlResponse statusCode]];
                      NSLog(@"Twiter post status : %@", output);
                  }];
             }
         }
     }];
}
- (void) checkPTShare {
    __weak typeof (self) weakSelf = self;
    [[PDKClient sharedInstance] authenticateWithPermissions:@[PDKClientReadPublicPermissions]
                                         fromViewController:self
                                                withSuccess:^(PDKResponseObject *responseObject)
     {
         weakSelf.user = [responseObject user];
         NSLog(@"%@", [NSString stringWithFormat:@"%@ authenticated!", weakSelf.user]);
     } andFailure:^(NSError *error) {
         NSLog(@"authentication failed!");
     }];
}
- (void) checkISTShare {
//    __weak typeof (self) weakSelf = self;
//    [[PDKClient sharedInstance] authenticateWithPermissions:@[PDKClientReadPublicPermissions]
//                                         fromViewController:self
//                                                withSuccess:^(PDKResponseObject *responseObject)
//     {
//         weakSelf.user = [responseObject user];
//         NSLog(@"%@", [NSString stringWithFormat:@"%@ authenticated!", weakSelf.user]);
//     } andFailure:^(NSError *error) {
//         NSLog(@"authentication failed!");
//     }];
}
- (void) checkGGShare {
//    __weak typeof (self) weakSelf = self;
//    [[PDKClient sharedInstance] authenticateWithPermissions:@[PDKClientReadPublicPermissions]
//                                         fromViewController:self
//                                                withSuccess:^(PDKResponseObject *responseObject)
//     {
//         weakSelf.user = [responseObject user];
//         NSLog(@"%@", [NSString stringWithFormat:@"%@ authenticated!", weakSelf.user]);
//     } andFailure:^(NSError *error) {
//         NSLog(@"authentication failed!");
//     }];
}
- (void) checkINShare {
//    __weak typeof (self) weakSelf = self;
//    [[PDKClient sharedInstance] authenticateWithPermissions:@[PDKClientReadPublicPermissions]
//                                         fromViewController:self
//                                                withSuccess:^(PDKResponseObject *responseObject)
//     {
//         weakSelf.user = [responseObject user];
//         NSLog(@"%@", [NSString stringWithFormat:@"%@ authenticated!", weakSelf.user]);
//     } andFailure:^(NSError *error) {
//         NSLog(@"authentication failed!");
//     }];
}
- (void)postImageToIST:(NSData *)imageurl
{
}
- (void)postImageToGG:(NSData *)imageurl
{
}
- (void)postImageToIN:(NSData *)imageurl
{
}
- (void)postImageToPT:(NSURL *)imageurl
{
    
    [PDKPin pinWithImageURL:imageurl
                       link:[NSURL URLWithString:@"https://www.pinterest.com"]
         suggestedBoardName:@"EmpowerMainStreet"
                       note:@"Empower Main Street"
         fromViewController:self
                withSuccess:^
     {
         NSLog(@"%@", [NSString stringWithFormat:@"successfully pinned pin"]);
     }
                 andFailure:^(NSError *error)
     {
         NSLog(@"pin it failed");
     }];
}

- (void) checkFBShare {
    
    if(socialShareModalView.switchFB.isOn){
        if([FBSDKAccessToken currentAccessToken]){
            NSLog(@"FBToken=>%@", [FBSDKAccessToken currentAccessToken]);
        }else {
            [self loginWithFb];
        }

    }
    
}
- (void)authenticateButtonTapped:(UIButton *)button
{
}

-(void)loginWithFb
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"" message:@"Please check your internet connection." cancel:@"OK" other:nil];
    }
    else
    {
        //NSString *strUserId =  [FBSDKAccessToken currentAccessToken].userID;
        //NSLog(@"Facebook user id %@",strUserId);
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        login.loginBehavior = FBSDKLoginBehaviorWeb;
        
        [login logInWithPublishPermissions:@[@"publish_actions"] fromViewController:self.view.window.rootViewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error)
            {
                [self showAlert:@"Error" message:@"Please try again." cancel:@"OK" other:nil];
            }
            else if (result.isCancelled)
            {
                [self showAlert:@"Error" message:@"Please try again." cancel:@"OK" other:nil];
            }
            else
            {
                if ([FBSDKAccessToken currentAccessToken])
                {
                    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                    [parameters setValue:@"id,name,email,gender" forKey:@"fields"];
                    
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
                     
                     
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                     {
                         if (!error)
                         {
                             NSLog(@"Facebook user id %@",[FBSDKAccessToken currentAccessToken]);
                         }
                     }];
                }
            }
        }];
    }
}

- (void)postImageToFB:(NSData *)imageData
{
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        
        //NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:3];
        
        UIImage *img = [UIImage imageWithData:imageData];
        //NSURL *imgURL = [NSURL URLWithString:imageURL];
        NSString *strTitle = tfTitleImage.text;
        //NSString *strCatName =btnSubCategoryVideoVu.titleLabel.text;
        NSString *strExpireDate = btnImageExpDate.titleLabel.text;
        
        NSString *strMessage = [[[@"Title: " stringByAppendingString:strTitle] stringByAppendingString:@" |Expire Date: "] stringByAppendingString:strExpireDate];
        
       
        //FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
        //content.photos = @[[FBSDKSharePhoto photoWithImage:img userGenerated:YES] ];
        FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
        photo.image = img;
        photo.caption = strMessage;
        photo.userGenerated = YES;
        FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
        content.photos = @[photo];
        
        
        // Assuming self implements <FBSDKSharingDelegate>
        [FBSDKShareAPI shareWithContent:content delegate:self];
    }else{
        UIAlertController *alert = [[UIAlertController alloc] init];
        alert = [UIAlertController alertControllerWithTitle:@"Facebook Post" message:@"Missing Facebook Token!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:btn_ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}
#pragma Mark: FBSDKSharingDelegate

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    NSLog(@"FBShare==>%@",results);
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert = [UIAlertController alertControllerWithTitle:@"Success!" message:[@"Facebook Post ID = " stringByAppendingString:[results objectForKey:@"postId"]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:btn_ok];
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 Sent to the delegate when the sharer encounters an error.
 - Parameter sharer: The FBSDKSharing that completed.
 - Parameter error: The error.
 */
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    NSLog(@"FBShare==>%@",error);
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert = [UIAlertController alertControllerWithTitle:@"Error!" message:error.description preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:btn_ok];
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 Sent to the delegate when the sharer is cancelled.
 - Parameter sharer: The FBSDKSharing that completed.
 */
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    NSLog(@"FBShare==>%@",sharer);
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert = [UIAlertController alertControllerWithTitle:@"Warnning!" message:@"Something went wrong!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:btn_ok];
    [self presentViewController:alert animated:YES completion:nil];
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

@end
