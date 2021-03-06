//
//  MyFavVC.m
//  Jwalkin
//
//  Created by Asai on 22/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//

#import "MyFavVC.h"

#import "UrlFile.h"
#import "SBJson5.h"
#import "SubCatCell.h"
#import "UIImageView+WebCache.h"
#import "DirectionMapVC.h"
#import "CouponVC.h"
#import "ShowLocationsVC.h"
#import "HomeVC.h"
#import "AppDelegate.h"
#import "Reachability.h"

@interface MyFavVC ()

@end

@implementation MyFavVC
@synthesize lblCouponMName,lblCouponMAddress,lblPercentage,lblTotalWalkin;

- (void)viewDidLoad
{
    [super viewDidLoad];
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeToLeft:)];
    //There is a direction property on UISwipeGestureRecognizer. You can set that to both right and left swipes
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
    [self getfavoritelist];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Swipe Method

-(IBAction)SwipeToLeft:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- API Response

-(void)ParseResponse:(id)sender
{
    NetworkUtills *utills=(NetworkUtills *)sender;
    [self ParseResult:utills.strResponse];
}

-(void)ParseResult:(NSString *)strResponse
{
    NSError *error = nil;
    NSData *data = [strResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//    NSMutableDictionary *d = [strResponse JSONValue];
    arrMerchantDetail = [d valueForKey:@"favorites"];
    if ([arrMerchantDetail count] > 0)
    {
        [tblFav reloadData];
    }
    else
    {
        UIAlertController *alert = [[UIAlertController alloc] init];
        alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:@"No Data Found." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:btn_cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark- TableView Delegates

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = @"SubCatCell";
    SubCatCell *cell = (SubCatCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            NSArray *toplevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SubCatCell" owner:nil options:nil];
            for(id currentObject in toplevelObjects)
            {
                if([currentObject isKindOfClass:[UITableViewCell class]])
                {
                    cell = (SubCatCell *)currentObject;
                    break;
                }
            }
        }
    }
    NSInteger IndexRow = indexPath.row+1;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    endindex = IndexRow *2;
    startindex = endindex-2;
    currentCounter=0;
    if(endindex > [arrMerchantDetail count])
    {
        endindex=[arrMerchantDetail count];
    }
    for(NSInteger Counter=startindex;Counter<endindex;Counter++)
    {
        NSMutableDictionary *dic_K = [arrMerchantDetail objectAtIndex:Counter];
        currentCounter++;
        if (currentCounter < 2 )
        {
            cell.lblMerchant2.hidden = YES;
            cell.imgMerchant2.hidden = YES;
            cell.imgBorder2.hidden = YES;
        }
        else
        {
            cell.lblMerchant1.hidden = NO;
            cell.imgMerchant1.hidden = NO;
            cell.lblMerchant2.hidden = NO;
            cell.imgMerchant2.hidden = NO;
            cell.imgBorder1.hidden = NO;
            cell.imgBorder2.hidden = NO;
        }
        if(currentCounter == 1)
        {
            cell.btnM1.tag = Counter;
            NSString *thumbURL = [[dic_K valueForKey:@"logo"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            NSURL *url = [NSURL URLWithString:thumbURL];
            [cell.imgMerchant1 sd_setImageWithURL:url];
            cell.lblMerchant1.text = [dic_K valueForKey:@"merchant_name"];
            cell.imgBorder1.hidden = NO;
            [cell.btnM1 addTarget:self action:@selector(SlectedMerchentDetail:) forControlEvents:UIControlEventTouchUpInside];
            NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
            [de setObject:[NSString stringWithFormat:@"%@",[dic_K valueForKey:@"merchant_id"]] forKey:@"MerchentId"];
            [de synchronize];
        }
        if(currentCounter == 2)
        {
            cell.btnM2.tag = Counter;
            NSString *thumbURL=[[dic_K valueForKey:@"logo"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            cell.imgBorder1.hidden = NO;
            cell.imgBorder2.hidden = NO;
            NSURL *url = [NSURL URLWithString:thumbURL];
            [cell.imgMerchant2 sd_setImageWithURL:url];
            cell.lblMerchant2.text = [dic_K valueForKey:@"merchant_name"];
            [cell.btnM2 addTarget:self action:@selector(SlectedMerchentDetail:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return cell;
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([arrMerchantDetail count]+1)/2;;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1)
    {
        return 115;
    }
    if (tableView.tag == 2)
    {
        return 44;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(IBAction)SlectedMerchentDetail:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    merchantTag = btn.tag;
    NSMutableDictionary *dic_K = [arrMerchantDetail objectAtIndex:btn.tag];
    lblCouponMName.text = [dic_K valueForKey:@"merchant_name"];
    lblCouponMAddress.text = [NSString stringWithFormat:@"%@ %@",[dic_K valueForKey:@"merchant_address"],[dic_K valueForKey:@"Phoneno"]];
    lblPercentage.text = [dic_K valueForKey:@"Percentage"];
    lblTotalWalkin.text = [NSString stringWithFormat:@"%@",[dic_K valueForKey:@"walkins"]];
    midForUnFavurite=[dic_K valueForKey:@"merchant_id"];
    
    //Dp
    subView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    
    [self.view addSubview:subView];
    tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(RemoveSubView)];
    tap.numberOfTapsRequired = 1;
    [subView addGestureRecognizer:tap];
}


#pragma mark- Button Action

-(IBAction)HomeClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)MakeACall:(id)sender
{
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:@"Call local business?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableDictionary *dic_K = [arrMerchantDetail objectAtIndex:merchantTag];
            NSString * phoneNumber = [NSString stringWithFormat:@"tel://%@",[dic_K valueForKey:@"Phoneno"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]options:@{} completionHandler:nil];
        }];
        [alert addAction:btn_ok];
        UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:^{
                
            }];
            
        }];
        [alert addAction:btn_cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(IBAction)ShowMeDirections:(id)sender
{
    NSMutableDictionary *dic_K = [arrMerchantDetail objectAtIndex:merchantTag];
    DirectionMapVC *direction = [self.storyboard instantiateViewControllerWithIdentifier:@"DirectionMapVC"];//[[DirectionMapVC alloc] initWithNibName:@"DirectionMapVC" bundle:nil];
    direction.address = [dic_K valueForKey:@"merchant_address"];
    direction.strTitle = [dic_K valueForKey:@"merchant_name"];
    [self.navigationController pushViewController:direction animated:YES];
}

-(IBAction)ShowCoupons:(id)sender
{
    NSMutableDictionary *dic_K = [arrMerchantDetail objectAtIndex:merchantTag];
    CouponVC *c = (CouponVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"CouponVC"];
    c.strMName = [dic_K valueForKey:@"merchant_name"];
    c.strMId = [dic_K valueForKey:@"merchant_id"];
    c.tempMerchantTag = currentCounter - 1;
    c.arrTempMerchantDetail = arrMerchantDetail;
    [self.navigationController pushViewController:c animated:YES];
}

-(IBAction)ShowAllLocations:(id)sender
{
    ShowLocationsVC *direction = (ShowLocationsVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"ShowLocationsVC"];//[[ShowLocationsVC alloc] initWithNibName:@"ShowLocationsVC" bundle:nil];
    direction.arrMapPoints = arrMerchantDetail;
    direction.strTitle = @"Favorite";
    [self.navigationController pushViewController:direction animated:YES];
}

- (IBAction)unFavorite:(id)sender
{
    if (midForUnFavurite.length!=0)
    {
        BOOL k=[wrpr RemoveFromfav:midForUnFavurite];
        if(k==YES)
        {
            [self getfavoritelist];
            [subView removeFromSuperview];
            [self showAlert:@"Empower Main Street" message:@"Removed from favotites." cancel:@"OK" other:nil];
        }
    }
}
#pragma mark- other Method

-(void)RemoveSubView
{
    [subView removeFromSuperview];
}

#pragma mark- API Call

-(void)getfavoritelist
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"" message:@"Please check your internet connection." cancel:@"OK" other:nil];
    }
    else
    {
        wrpr = [[WrapperClass alloc] initwithDev];
        arrMerchantDetail = [[NSMutableArray alloc] init];
        appdelegate().isFromFav = 1;
        NSMutableArray *arrIDs = [wrpr GetIds];
        NSString *allids = [arrIDs componentsJoinedByString:@","];
        netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponse:) WithCallBackObject:self];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:allids forKey:@"merchants"];
        [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,favMerchants] WithDictionary:dic];
    }
}
- (void)showAlert:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel other:(NSString *)other{
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (other) {
        UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:other style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
        [alert addAction:btn_ok];
    }
    if (cancel) {
        UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:^{
                
            }];
            
        }];
        [alert addAction:btn_cancel];
    }
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
