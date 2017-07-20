//
//  MainScreenViewController.m
//  Jwalkin
//
//  Created by Asai on 4/14/17.
//  Copyright © 2017 fox. All rights reserved.
//

#import "MainScreenViewController.h"
#import "SubCatCell.h"
#import "SubCatNameCell.h"
#import "SBJson5.h"
#import "UrlFile.h"
#import "UIImageView+WebCache.h"
#import "DirectionMapVC.h"
#import "ShowLocationsVC.h"
#import "CouponVC.h"
#import "WrapperClass.h"
#import "MyFavVC.h"
#import "Reachability.h"
#import "SubCategoriesVC.h"
#import "UrlFile.h"
#import "InfoVC.h"
#import "SignupVC.h"
#import "BillBoardVC.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "ManageBillBoardVC.h"
#import "TownInfoCenterVC.h"
#import "ManageOfferVC.h"
#import "MyFavVC.h"
#import "TutorialVC.h"
#import "AddOfferVC.h"

@interface MainScreenViewController ()
{
    NSString *uid;
}
@end

@implementation MainScreenViewController
@synthesize lblDListSubCatName,lblCouponMName,lblCouponMAddress,mainDict,catId,lblPercentage;
@synthesize lblTotalWalkin;


- (void)viewDidLoad
{
    [super viewDidLoad];
    mainArray = [[NSMutableArray alloc] init];
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"" message:@"Please check your internet connection." cancel:@"OK" other:nil];
    }
    else
    {
        netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponse:) WithCallBackObject:self];
        netUtills.tag = 1;
        [netUtills GetResponseByASIHttpRequest:[NSString stringWithFormat:@"%@%@",mainUrl,allcatagories]];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"loggedin"])
    {
        uid = [[NSUserDefaults standardUserDefaults] valueForKey:@"user-Id"];
    }
    else
    {
        uid =@"0";
    }

//
//    
//    // Do any additional setup after loading the view from its nib.
}
- (void)getWhatsHappening{
    NSString *radius =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"radius"]];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:[NSString stringWithFormat:@"%f",appdelegate().clLocation.coordinate.latitude] forKey:@"latitude"];
    [dict setValue:[NSString stringWithFormat:@"%f",appdelegate().clLocation.coordinate.longitude] forKey:@"longitude"];
    
    [dict setObject:uid forKey:@"userid"];
    [dict setValue:radius forKey:@"radius"];
    [dict setValue:@"All" forKey:@"filter"];
    netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponse:) WithCallBackObject:self];
    netUtills.tag = 4;
    [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,getmerchantallbyradius] WithDictionary:dict];
}

- (void)viewDidAppear:(BOOL)animated
{
    [picker selectRow:0 inComponent:0 animated:YES];
    [picker reloadComponent:0];
    
}

-(void)viewWillAppear:(BOOL)animated
{
        [btnFav bringSubviewToFront:self.view];
        [btnHome bringSubviewToFront:self.view];
        [btnMenu bringSubviewToFront:self.view];
        [btnMap bringSubviewToFront:self.view];
        [btnSearch bringSubviewToFront:self.view];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- API Response

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
        mainArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        [self getWhatsHappening];
    }else if (netUtills.tag == 2){
        if (![strResponse isEqualToString:@"Requested Data not found"])
        {
            NSError *error = nil;
            NSData *data = [strResponse dataUsingEncoding:NSUTF8StringEncoding];
            arrMerchantDetail = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            //            arrMerchantDetail = [strResponse JSONValue];
            arrAllMerchantCopy = arrMerchantDetail;
            
        }
        if ([arrMerchantDetail count] > 0)
        {
            tblMrchnt.hidden = NO;
            [tblMrchnt reloadData];
            btnFav.userInteractionEnabled=YES;
            btnHome.userInteractionEnabled=YES;
            btnMenu.userInteractionEnabled=YES;
            btnMap.userInteractionEnabled=YES;
            btnSearch.userInteractionEnabled=YES;
        }
        else
        {
            [self showAlert:@"Empower Main Street" message:@"No Data Found" cancel:@"OK" other:nil];
            tblMrchnt.hidden = YES;
            btnFav.userInteractionEnabled=YES;
            btnHome.userInteractionEnabled=YES;
            btnMenu.userInteractionEnabled=YES;
            btnMap.userInteractionEnabled=YES;
            btnSearch.userInteractionEnabled=YES;
        }
    }
    else if (netUtills.tag == 3)
    {
        NSError *error = nil;
        NSData *data = [strResponse dataUsingEncoding:NSUTF8StringEncoding];
        arrMerchantDetail = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        //        arrMerchantDetail = [strResponse JSONValue];
        if ([arrMerchantDetail count] > 0)
        {
            tblMrchnt.hidden = NO;
            [tblMrchnt reloadData];
        }
        else
        {
            tblMrchnt.hidden = YES;
            [self showAlert:@"Empower Main Street" message:@"No Match Found" cancel:@"OK" other:nil];
            if ([arrAllMerchantCopy count] > 0)
            {
                arrMerchantDetail = arrAllMerchantCopy;
                tblMrchnt.hidden = NO;
                [tblMrchnt reloadData];
            }
        }
    }
    else if (netUtills.tag == 4)
    {
        NSError *error = nil;
        NSData *data = [strResponse dataUsingEncoding:NSUTF8StringEncoding];
        arrMerchantDetail = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        //        arrMerchantDetail = [strResponse JSONValue];
        lblDListSubCatName.text = @"What's Happening";
        if ([arrMerchantDetail count] > 0)
        {
            tblMrchnt.hidden = NO;
            [tblMrchnt reloadData];
        }
        else
        {
            tblMrchnt.hidden = YES;
            [self showAlert:@"Empower Main Street" message:@"No Match Found" cancel:@"OK" other:nil];
            if ([arrAllMerchantCopy count] > 0)
            {
                arrMerchantDetail = arrAllMerchantCopy;
                tblMrchnt.hidden = NO;
                [tblMrchnt reloadData];
            }
        }
    }
    else if (netUtills.tag == 5)
    {
        NSError *error = nil;
        NSData *data = [strResponse dataUsingEncoding:NSUTF8StringEncoding];
        arrMerchantDetail = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        //        arrMerchantDetail = [strResponse JSONValue];
        lblDListSubCatName.text = [arrSubCatNames objectAtIndex:[picker selectedRowInComponent:0]];
        if ([arrMerchantDetail count] > 0)
        {
            tblMrchnt.hidden = NO;
            [tblMrchnt reloadData];
        }
        else
        {
            tblMrchnt.hidden = YES;
            [self showAlert:@"Empower Main Street" message:@"No Match Found" cancel:@"OK" other:nil];
            if ([arrAllMerchantCopy count] > 0)
            {
                arrMerchantDetail = arrAllMerchantCopy;
                tblMrchnt.hidden = NO;
                [tblMrchnt reloadData];
            }
        }
    }
}

-(void)GetAllVals
{
    for (int i = 0; i < [arrSubcatagories count]; i++)
    {
        NSMutableDictionary *dict = [arrSubcatagories objectAtIndex:i];
        [arrSubCatNames addObject:[dict objectForKey:@"subcategory"]];
        [arrSubCatIDs addObject:[dict objectForKey:@"subcategoryid"]];
        lblDListSubCatName.text = [NSString stringWithFormat:@"%@", [mainDict objectForKey:@"category_name"]]; //cp
        [picker reloadAllComponents];
//        [tblDrList reloadData];
    }
    [arrSubCatNames addObject:[NSString stringWithFormat:@"%@", [mainDict objectForKey:@"category_name"]]];//cp
}

#pragma mark- TableView Delegates

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1)
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
                cell.lblMerchant1.text = [dic_K valueForKey:@"merchant_name"];
                NSURL *url = [NSURL URLWithString:thumbURL];
                [cell.imgMerchant1 sd_setImageWithURL:url];
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
                cell.lblMerchant2.text = [dic_K valueForKey:@"merchant_name"];
                NSURL *url = [NSURL URLWithString:thumbURL];
                [cell.imgMerchant2 sd_setImageWithURL:url];
                [cell.btnM2 addTarget:self action:@selector(SlectedMerchentDetail:) forControlEvents:UIControlEventTouchUpInside];
            }
            cell.backgroundView = nil;
            cell.backgroundColor = [UIColor clearColor];
        }
        return cell;
    }
    if (tableView.tag == 2)
    {
        static NSString *CellIdentifier;
        CellIdentifier = @"SubCatNameCell";
        SubCatNameCell *cell = (SubCatNameCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                NSArray *toplevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SubCatNameCell" owner:nil options:nil];
                for(id currentObject in toplevelObjects)
                {
                    if([currentObject isKindOfClass:[UITableViewCell class]])
                    {
                        cell = (SubCatNameCell *)currentObject;
                        break;
                    }
                }
            }
        }
        cell.lblSubCatName.text = [arrSubCatNames objectAtIndex:indexPath.row];
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];

        return cell;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1)
    {
        return ([arrMerchantDetail count]+1)/2;
    }
    if (tableView.tag == 2)
    {
        return [arrSubCatNames count];
    }
    return 0;
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
    if (tableView.tag == 2)
    {
        lblDListSubCatName.text = [arrSubCatNames objectAtIndex:indexPath.row];
        NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
        [de setObject:[arrSubcatagories objectAtIndex:indexPath.row] forKey:@"Subcatid"];
        [de synchronize];
        isTableShowing = 0;
        NSString *radius =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"radius"]];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setValue:self.catId forKey:@"categoryid"];
        [dict setValue:[arrSubCatIDs objectAtIndex:indexPath.row] forKey:@"subcategoryid"];
        [dict setValue:[NSString stringWithFormat:@"%f",appdelegate().clLocation.coordinate.latitude] forKey:@"latitude"];
        [dict setValue:[NSString stringWithFormat:@"%f",appdelegate().clLocation.coordinate.longitude] forKey:@"longitude"];
        
        [dict setObject:uid forKey:@"userid"];
        [dict setValue:radius forKey:@"radius"];
        netUtills.tag = 2;
        [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,subcatagories] WithDictionary:dict];
    }
}

-(IBAction)SlectedMerchentDetail:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    merchantTag = btn.tag;
    NSMutableDictionary *dic_K = [arrMerchantDetail objectAtIndex:btn.tag];
    NSUserDefaults *d1 = [NSUserDefaults standardUserDefaults];
    [d1 setObject:[dic_K valueForKey:@"merchant_id"] forKey:@"merchant_id"];
    [d1 synchronize];
    lblCouponMName.text = [dic_K valueForKey:@"merchant_name"];
    lblCouponMAddress.text = [NSString stringWithFormat:@"%@\n%@\n%@",[dic_K valueForKey:@"merchant_address"],[dic_K valueForKey:@"Phoneno"],[dic_K valueForKey:@"business_hours"]];
    lblPercentage.text = [dic_K valueForKey:@"Percentage"];
    lblTotalWalkin.text = [NSString stringWithFormat:@"(%@)",[dic_K valueForKey:@"walkins"]];
    [self ShowCoupons];
}

#pragma mark- Button Action

-(IBAction)HomeClicked:(id)sender
{
    [self getWhatsHappening];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)MenuClicked:(id)sender {
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    if ([de objectForKey:@"loggedin"])
    {
        uid = [[NSUserDefaults standardUserDefaults] valueForKey:@"user-Id"];
        
        UIAlertController *alert = [[UIAlertController alloc] init];
        alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actioncreate = [UIAlertAction actionWithTitle:@"CREATE BILLBOARD" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self createBillboard];
            UIViewController *createBillboardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"createBillboardVC"];
            [self.navigationController pushViewController:createBillboardVC animated:YES];

        }];
        [alert addAction:actioncreate];
        UIAlertAction *actionManageProfile = [UIAlertAction actionWithTitle:@"MANAGE PROFILE" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"updateproVC"];
            [self presentViewController:vc animated:YES completion:nil];
        }];
        [alert addAction:actionManageProfile];
        UIAlertAction *actionManageBilloard = [UIAlertAction actionWithTitle:@"MANAGE BILLBOARDS" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ManageBillBoardVC *manageBB = [self.storyboard instantiateViewControllerWithIdentifier:@"ManageBillBoardVC"];
            [self.navigationController pushViewController:manageBB animated:YES];
        }];
        [alert addAction:actionManageBilloard];
/*       UIAlertAction *actionManageOffer = [UIAlertAction actionWithTitle:@"MANAGE PUNCH CARD" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self manageOffer];
        }];
        [alert addAction:actionManageOffer];*/
        UIAlertAction *actionSwitchAccount = [UIAlertAction actionWithTitle:@"SWITCH ACCOUNT" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"switchVC"];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [alert addAction:actionSwitchAccount];
        UIAlertAction *actionLogout = [UIAlertAction actionWithTitle:@"LOGOUT" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self btnLogoutClicked];
        }];
        [alert addAction:actionLogout];
        UIAlertAction *cancelbtn = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelbtn];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
    else
    {
        uid =@"0";
        UIAlertController *alert = [[UIAlertController alloc] init];
        alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionsignup = [UIAlertAction actionWithTitle:@"SIGN-UP/LOG-IN" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignupVC"];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [alert addAction:actionsignup];
        UIAlertAction *actionsearch = [UIAlertAction actionWithTitle:@"SEARCH RAIDUS" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self setRadius];
        }];
        [alert addAction:actionsearch];
        UIAlertAction *actionabout = [UIAlertAction actionWithTitle:@"ABOUT APP" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:actionabout];
        UIAlertAction *actioncontact = [UIAlertAction actionWithTitle:@"CONTACT EMS" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:actioncontact];
        UIAlertAction *cancelbtn = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelbtn];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
}
-(void)btnLogoutClicked
{
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:@"Are you sure you want to logout?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [appdelegate() showHUD];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loggedin"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"merchantid"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user-Id"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accounts"];
        //[[NSUserDefaults standardUserDefaults] synchronize];
        [NSThread sleepForTimeInterval:0.5];
        [appdelegate() hideHUD];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fbname"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    [alert addAction:btn_ok];
    UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }];
    [alert addAction:btn_cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)createBillboard{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:@{@"merchant_id": uid}];
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
                    UIViewController *createBillboardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"createBillboardVC"];
                    [self.navigationController pushViewController:createBillboardVC animated:YES];
                });
                
            }
            else if ([[data valueForKey:@"status"] intValue]== 0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIViewController *createBillboardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreatePunchCardViewController"];
                    [self.navigationController pushViewController:createBillboardVC animated:YES];
                });
            }
            else if ([[data valueForKey:@"status"] intValue]== 2)
            {
                UIAlertController *alert = [[UIAlertController alloc] init];
                alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:@"Your punch card was expired!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actioncreate = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UIViewController *createBillboardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreatePunchCardViewController"];
                    [self.navigationController pushViewController:createBillboardVC animated:YES];
                }];
                [alert addAction:actioncreate];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        
    }];
    
}

-(void)manageOffer{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:@{@"merchant_id": uid}];
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
                    UIViewController *manageOffer = [self.storyboard instantiateViewControllerWithIdentifier:@"ManageOfferVC"];
                    [self.navigationController pushViewController:manageOffer animated:YES];
                });
                
            }
            else if ([[data valueForKey:@"status"] intValue]== 0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIViewController *createBillboardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreatePunchCardViewController"];
                    [self.navigationController pushViewController:createBillboardVC animated:YES];
                });
            }
            else if ([[data valueForKey:@"status"] intValue]== 2)
            {
                UIAlertController *alert = [[UIAlertController alloc] init];
                alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:@"Your punch card was expired!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actioncreate = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UIViewController *createBillboardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreatePunchCardViewController"];
                    [self.navigationController pushViewController:createBillboardVC animated:YES];
                }];
                [alert addAction:actioncreate];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        
    }];
    
}

-(IBAction)DropDownClicked:(id)sender
{
    if (![lblDListSubCatName.text isEqualToString:@"What's Happening"]) {
        [self PickerClicked:nil];
    }else{
        arrSubCatNames = [[NSMutableArray alloc] initWithArray:@[@"News", @"Deal", @"Event", @"Website", @"What's Happening"]];
        lblDListSubCatName.text = @"What's Happening"; //cp
        [picker reloadAllComponents];
        [self PickerClicked:nil];
    }
}

-(void)setRadius{
    viewBgPopup.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);//Dp
    [self.view addSubview:viewBgPopup];
    
    viewSettingPopUp.frame = CGRectMake((self.view.frame.size.width / 2)-(viewSettingPopUp.frame.size.width/2), (self.view.frame.size.height /2)-(viewSettingPopUp.frame.size.height/2), viewSettingPopUp.frame.size.width, viewSettingPopUp.frame.size.height);
    [self.view addSubview:viewSettingPopUp];
    viewBgPopup.alpha = 0;
    viewSettingPopUp.alpha = 0;
    
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseIn  animations:^
     {
         viewSettingPopUp.alpha = 1;
         viewBgPopup.alpha = 0.5;
         
         viewSettingPopUp.center = self.view.center;
     }
                     completion:nil];
    //UIViewAnimationOptionCurveLinear
    [UIView commitAnimations];
    
    
    
    UITapGestureRecognizer *tapges;
    tapges=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(RemoveSubView)];
    tapges.numberOfTapsRequired = 1;
    [viewBgPopup addGestureRecognizer:tapges];
    
}

-(void)RemoveSubView
{
    [viewSettingPopUp removeFromSuperview];
    viewBgPopup.alpha = 0;
    viewSettingPopUp.alpha = 0;
    [subView removeFromSuperview];
 
}

-(IBAction)radioBtnClicked:(UIButton *)sender
{
    NSString *radius =@"10";
    switch (sender.tag) {
        case 1001:
        {
            radius=@"1"; //dp change(22Dec)
            
        }
            break;
        case 1002:
        {
            radius=@"5"; //dp change(22Dec)
            
        }
            break;
        case 1003:
        {
            radius=@"10"; //dp change(22Dec)
            
        }
            break;
        case 1004:
        {
            radius =@"0.06";
            
        }
            break;
        case 1005:
        {
            radius =@"0.12";
            
        }
            break;
            
        default:
            break;
    }
    [btnRadio10Mile setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
    [btnRadio20Mile setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
    [btnRadio30Mile setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
    
    [sender setImage:[UIImage imageNamed:@"radio-button_touch"] forState:UIControlStateNormal];
    
    NSUserDefaults *rad = [NSUserDefaults standardUserDefaults];
    [rad setObject:radius forKey:@"radius"];
}

-(IBAction)MakeACall:(id)sender
{
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:@"Call local business?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *dic_K = [arrMerchantDetail objectAtIndex:merchantTag];
        NSString * phoneNumber = [NSString stringWithFormat:@"tel://%@",[dic_K valueForKey:@"Phoneno"]];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber] options:@{} completionHandler:nil];
    }];
    [alert addAction:btn_ok];
    UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }];
    [alert addAction:btn_cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(IBAction)AddToFav:(id)sender
{
    NSMutableDictionary *dic_K = [arrMerchantDetail objectAtIndex:merchantTag];
    NSString * mid = [dic_K valueForKey:@"merchant_id"];
    NSMutableArray *arrIDs = [wrpr GetIds];
    
    if (![arrIDs containsObject:mid])
    {
        int K = [wrpr InsertToFavorite:mid];
        if (K > 0)
        {
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Jaywalk.In" message:@"Added to favorites." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //            alert.tag = 3333;
            [self showAlert:@"Empower Main Street" message:@"Added to favorites." cancel:@"OK" other:nil];
        }
        else
        {
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Jaywalk.In" message:@"Unable to add to favorites." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //            alert.tag = 4444;
            [self showAlert:@"Empower Main Street" message:@"Unable to add to favorites." cancel:@"OK" other:nil];
        }
    }
    else
    {
        BOOL k=[wrpr RemoveFromfav:mid];
        if(k==YES)
        {
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Jaywalk.In" message:@"Removed from favorites." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //            alert.tag = 5555;
            [self showAlert:@"Empower Main Street" message:@"Removed from favorites." cancel:@"OK" other:nil];
        }
    }
}

-(IBAction)ShowMeDirections:(id)sender
{
    NSMutableDictionary *dic_K = [arrMerchantDetail objectAtIndex:merchantTag];
    DirectionMapVC *direction = [self.storyboard instantiateViewControllerWithIdentifier:@"DirectionMapVC"];//[[DirectionMapVC alloc] initWithNibName:@"DirectionMapVC" bundle:nil];
    direction.strTitle = [dic_K valueForKey:@"merchant_name"];
    direction.address = [dic_K valueForKey:@"merchant_address"];
    [self.navigationController pushViewController:direction animated:YES];
}

-(IBAction)ShowCoupons
{
    NSMutableDictionary *dic_K = [arrMerchantDetail objectAtIndex:merchantTag];
//    CouponVC *c = [[CouponVC alloc] initWithNibName:@"CouponVC" bundle:nil];
    CouponVC *c = (CouponVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"CouponVC"];
    c.arrTempMerchantDetail = arrMerchantDetail;
    c.tempMerchantTag = (int)merchantTag;
    c.strMName = [dic_K valueForKey:@"merchant_name"];
    c.strMId = [dic_K valueForKey:@"merchant_id"];
    [self.navigationController pushViewController:c animated:YES];
}

-(IBAction)ShowAllLocations:(id)sender
{
    ShowLocationsVC *direction = [self.storyboard instantiateViewControllerWithIdentifier: @"ShowLocationsVC"];//[[ShowLocationsVC alloc] initWithNibName:@"ShowLocationsVC" bundle:nil];
    if (mainDict) {
        direction.strTitle = [mainDict valueForKey:@"category_name"];
    }else{
        direction.strTitle = @"What's Happening";
    }
    direction.arrMapPoints = arrMerchantDetail;
    [self.navigationController pushViewController:direction animated:YES];
}

-(IBAction)SearchClicked:(id)sender
{
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    for (NSDictionary *dict in mainArray) {
        NSString *str = [dict[@"category_name"] uppercaseString];
        UIAlertAction *actionbtn = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            mainDict = [dict mutableCopy];
            [self searchForCategory];
        }];
        [alert addAction:actionbtn];
    }
    UIAlertAction *actionbtn = [UIAlertAction actionWithTitle:@"SEARCHBAR" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        searchView.frame  = CGRectMake(0,0, self.view.frame.size.width, 44);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        //Dp 28Dec
        searchView.frame = CGRectMake(0, (self.view.frame.size.height * 0.1)+10,  self.view.frame.size.width, 44);
        [UIView commitAnimations];
        [self.view addSubview:searchView];
    }];
    [alert addAction:actionbtn];
    UIAlertAction *cancelbtn = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancelbtn];

    [self presentViewController:alert animated:YES completion:nil];

}
- (void)searchForCategory{
        NSString *radius =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"radius"]];
    //
    //
    isTableShowing = 0;
    wrpr = [[WrapperClass alloc] initwithDev];
    arrAllMerchantCopy = [[NSMutableArray alloc] init];
    //
    NSString *str =[[NSUserDefaults standardUserDefaults] valueForKey:@"fbname"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"loggedin"] || str.length != 0)
    {
        uid = [[NSUserDefaults standardUserDefaults] valueForKey:@"user-Id"];
    }
    else
    {
        uid =@"0";
    }
    //
    //    appdelegate().isFromFav = 0;
    arrSubCatNames = [[NSMutableArray alloc] init];
    arrSubCatIDs = [[NSMutableArray alloc] init];
    arrMerchantDetail = [[NSMutableArray alloc] init];
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"" message:@"Please check your internet connection." cancel:@"OK" other:nil];
        btnFav.userInteractionEnabled=YES;
        btnHome.userInteractionEnabled=YES;
        btnMap.userInteractionEnabled=YES;
        btnSearch.userInteractionEnabled=YES;
        btnMenu.userInteractionEnabled=YES;
    }
    else
    {
        self.catId = [mainDict objectForKey:@"categoryid"];
        arrSubcatagories = [mainDict objectForKey:@"subcategory_info"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:self.catId forKey:@"categoryid"];
        [dict setValue:[[arrSubcatagories objectAtIndex:0] valueForKey:@"subcategoryid"] forKey:@"subcategoryid"];
        [dict setValue:[NSString stringWithFormat:@"%f",appdelegate().clLocation.coordinate.latitude] forKey:@"latitude"];
        [dict setValue:[NSString stringWithFormat:@"%f",appdelegate().clLocation.coordinate.longitude] forKey:@"longitude"];

        [self GetAllVals];
        if ([lblDListSubCatName.text isEqual:[NSString stringWithFormat:@"%@", [mainDict objectForKey:@"category_name"]]])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:self.catId forKey:@"categoryid"];
            isTableShowing = 0;
            NSString *radius =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"radius"]];

            [dict setValue:radius forKey:@"radius"];
            [dict setValue:[NSString stringWithFormat:@"%f",appdelegate().clLocation.coordinate.latitude] forKey:@"latitude"];
            [dict setValue:[NSString stringWithFormat:@"%f",appdelegate().clLocation.coordinate.longitude] forKey:@"longitude"];

            [dict setObject:uid forKey:@"userid"];
            netUtills.tag = 2;
            [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl, subcatagories] WithDictionary:dict];
        }
        else
        {
            btnFav.userInteractionEnabled=YES;
            btnHome.userInteractionEnabled=YES;
            btnMenu.userInteractionEnabled=YES;
            btnMap.userInteractionEnabled=YES;
            btnSearch.userInteractionEnabled=YES;
        }
    }

}
-(IBAction)ShowFav:(id)sender
{
    MyFavVC *my = [self.storyboard instantiateViewControllerWithIdentifier:@"MyFavVC"];
    [self.navigationController pushViewController:my animated:YES];
}

//-(void)RemoveSubView
//{
//    [subView removeFromSuperview];
//}


#pragma mark - Searchbar Delegates

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar
{
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText
{
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)theSearchBar
{
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)theSearchBar
{
    // if a valid search was entered but the user wanted to cancel, bring back the main list filteredcontent
    [searchView removeFromSuperview];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    [self searchData:theSearchBar.text];
    [searchBar resignFirstResponder];
}

-(void)searchData:(NSString *)searchText
{
    netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponse:) WithCallBackObject:self];
    netUtills.tag = 3;
    [netUtills GetResponseByASIHttpRequest:[NSString stringWithFormat:@"%@%@?merchant=%@",mainUrl,findMerchants,searchText]];
}

-(IBAction)SearchCloseClicked:(id)sender
{
    [searchBar resignFirstResponder];
    [searchView removeFromSuperview];
}

#pragma mark - picker view delegates- Select the subcategories

-(IBAction)PickerClicked:(id)sender
{
    if ([UIScreen mainScreen].bounds.size.height > 500)
    {
        
        //dp 28 Dec
        //        picView.frame  = CGRectMake(0, 568, 320, 568);
        //        [UIView beginAnimations:nil context:NULL];
        //        [UIView setAnimationDuration:0.5];
        //        picView.frame  = CGRectMake(0, 0, 320, 568);
        //        picView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        
        // [UIView commitAnimations];
        picView.frame = CGRectMake(self.view.frame.origin.x, 580, self.view.frame.size.width, self.view.frame.size.height+15);
        [self.view addSubview:picView];
        
        [UIView animateWithDuration:0.5 animations:^{
            picView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height+15);
        }];
        
    }
    else
    {
        //        picView.frame  = CGRectMake(0, 460, 320, 460);
        //        [UIView beginAnimations:nil context:NULL];
        //        [UIView setAnimationDuration:0.5];
        //        picView.frame  = CGRectMake(0, 0, 320, 480);
        //        [UIView commitAnimations];
        
        picView.frame = CGRectMake(self.view.frame.origin.x, 580, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:picView];
        
        [UIView animateWithDuration:0.5 animations:^{
            picView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    
    [picker reloadAllComponents];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [arrSubCatNames count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [arrSubCatNames objectAtIndex:row];
}

- (IBAction)settingSubmitClicked:(id)sender {
    [viewSettingPopUp removeFromSuperview];
    [viewBgPopup removeFromSuperview];
}

-(IBAction)pickerDoneClicked:(id)sender
{
    if (self.catId) {
        lblDListSubCatName.text = [arrSubCatNames objectAtIndex:[picker selectedRowInComponent:0]];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:self.catId forKey:@"categoryid"];
        isTableShowing = 0;
        if (![[arrSubCatNames objectAtIndex:[picker selectedRowInComponent:0]] isEqualToString:[NSString stringWithFormat:@"%@", [mainDict objectForKey:@"category_name"]]])
        {
            NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
            [de setObject:[arrSubcatagories objectAtIndex:[picker selectedRowInComponent:0]] forKey:@"Subcatid"];
            [de synchronize];
            [dict setValue:[arrSubCatIDs objectAtIndex:[picker selectedRowInComponent:0]] forKey:@"subcategoryid"];
        }
        NSString *radius =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"radius"]];
        [dict setValue:radius forKey:@"radius"];
        [dict setValue:[NSString stringWithFormat:@"%f",appdelegate().clLocation.coordinate.latitude] forKey:@"latitude"];
        [dict setValue:[NSString stringWithFormat:@"%f",appdelegate().clLocation.coordinate.longitude] forKey:@"longitude"];
        
        [dict setObject:uid forKey:@"userid"];
        
        netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponse:) WithCallBackObject:self];
        netUtills.tag = 2;
        [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,subcatagories] WithDictionary:dict];
    }else{
        lblDListSubCatName.text = [arrSubCatNames objectAtIndex:[picker selectedRowInComponent:0]];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if ([lblDListSubCatName.text isEqualToString:@"What's Happening"]) {
            [dict setValue:@"All" forKey:@"filter"];
        }else{
            [dict setValue:lblDListSubCatName.text forKey:@"filter"];
        }
        NSString *radius =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"radius"]];
        [dict setValue:radius forKey:@"radius"];
        [dict setValue:[NSString stringWithFormat:@"%f",appdelegate().clLocation.coordinate.latitude] forKey:@"latitude"];
        [dict setValue:[NSString stringWithFormat:@"%f",appdelegate().clLocation.coordinate.longitude] forKey:@"longitude"];
        [dict setObject:uid forKey:@"userid"];
        netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponse:) WithCallBackObject:self];
        netUtills.tag = 5;
        [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl, getmerchantby_billboardtype] WithDictionary:dict];
        
    }
    [UIView animateWithDuration:0.5 animations:^{
        picView.frame = CGRectMake(self.view.frame.origin.x, 580, self.view.frame.size.width, self.view.frame.size.height+15);
    }];
    
}

-(IBAction)pickerCancelClicked:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        picView.frame = CGRectMake(self.view.frame.origin.x, 580, self.view.frame.size.width, self.view.frame.size.height+15);
    }];
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
