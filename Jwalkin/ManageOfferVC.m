//
//  ManageOfferVC.m
//  Jwalkin
//
//  Created by Asai on 22/07/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import "ManageOfferVC.h"
#import "OffersCell.h"
#import "Reachability.h"
#import "UrlFile.h"
#import "SBJson5.h"
#import "AddOfferVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Bolts/Bolts.h>
#import "SignupVC.h"

@interface ManageOfferVC ()
{
    ZBarReaderViewController *codeReader;
}
@end

@implementation ManageOfferVC
@synthesize isOffer,strMid;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrOffers = [[NSMutableArray alloc]init];
    if (isOffer)
    {
        lblBarTitle.text = @"Offers";
        btnAddNew.hidden = YES;
        [self getAllOfferApiCall];
    }
    imgViewBackImage.layer.cornerRadius = 5.0;
    imgViewBackImage.clipsToBounds=YES;
    btnRedeem.layer.cornerRadius = 5.0;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    if (!isOffer)
    {
        [self getAllOfferApiCall];
    }
}

#pragma mark- Button Action

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnAddOfferClicked:(id)sender
{
    AddOfferVC *addOffer = [self.storyboard instantiateViewControllerWithIdentifier:@"AddOfferVC"];
    [self.navigationController pushViewController:addOffer animated:YES];
}

-(IBAction)btnRedeamClicked:(id)sender
{
    NSString *str =[[NSUserDefaults standardUserDefaults] valueForKey:@"fbname"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"loggedin"])
    {
        [self scanCode];
    }
    else if(str.length == 0)
    {
        UIAlertController *alert = [[UIAlertController alloc] init];
        alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:@"Sorry! you are not Login. You want to login with facebook?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            SignupVC *signup = [self.storyboard instantiateViewControllerWithIdentifier: @"SignupVC"];//[[SignupVC alloc] initWithNibName:@"SignupVC" bundle:nil];
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
    else
    {
        [self scanCode];
    }
}

-(IBAction)btnCancelClicked:(id)sender
{
    [viewDetail removeFromSuperview];
}

- (IBAction)btnRedeem:(id)sender {
    NSString *str =[[NSUserDefaults standardUserDefaults] valueForKey:@"fbname"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"loggedin"])
    {
        [self scanCode];
    }
    else if(str.length == 0)
    {
        UIAlertController *alert = [[UIAlertController alloc] init];
        alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:@"Sorry! you are not Login. You want to login with facebook?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            SignupVC *signup = [self.storyboard instantiateViewControllerWithIdentifier: @"SignupVC"];//[[SignupVC alloc] initWithNibName:@"SignupVC" bundle:nil];
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
    else
    {
        [self scanCode];
    }
}

#pragma mark- TableView Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrOffers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = @"offerCell";
    OffersCell *cell = (OffersCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OffersCell" owner:self options:nil] objectAtIndex:0];
    }
    NSDictionary *dict = [arrOffers objectAtIndex:indexPath.row];
    NSString *imgUrl =[dict valueForKey:@"image"];
    cell.lblTitle.text = [dict valueForKey:@"title"];
    cell.lblDescription.text =[dict valueForKey:@"description"];
    cell.lbValid.text = [@"Active: " stringByAppendingString:[dict valueForKey:@"is_active"]];
    cell.imgOffer.imageURL = [NSURL URLWithString:imgUrl];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    strOfferId = nil;
    if (isOffer)
    {
        NSDictionary *dict = [arrOffers objectAtIndex:indexPath.row];
        NSString *imgUrl =[dict valueForKey:@"image"];
        strOfferId = [dict valueForKey:@"id"];
        viewDetail.frame =self.view.frame;
        viewDetail.alpha = 0;
        lblTitleDetail.text = [dict valueForKey:@"title"];;
        txtViewDescription.text =[dict valueForKey:@"description"];
        txtViewDescription.textColor = [UIColor whiteColor] ;
        imgViewOfferImg.imageURL = [NSURL URLWithString:imgUrl];
        [self.view addSubview:viewDetail];
        [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseIn  animations:^
         {
             viewDetail.alpha = 1;
         }
                         completion:nil];
        [UIView commitAnimations];
    }
    else
    {
        AddOfferVC *addOffer = [self.storyboard instantiateViewControllerWithIdentifier:@"AddOfferVC"];//[[AddOfferVC alloc]initWithNibName:@"AddOfferVC" bundle:nil];
        NSDictionary *dict = [arrOffers objectAtIndex:indexPath.row];
        addOffer.dictOffer = dict;
        addOffer.isUpdate = YES;
        [self.navigationController pushViewController:addOffer animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 99;
}

#pragma mark- Api Call and response

-(void)getAllOfferApiCall
{
    //http://198.57.247.185/~jwalkin/admin/api/get_all_offer.php?merchant_id=2
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    NSString *mId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"merchantid"]];
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"" message:@"Pelase check your internet connection." cancel:@"OK" other:nil];
    }
    else
    {
        if (isOffer)
        {
            netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponseGetOffer:) WithCallBackObject:self];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:strMid forKey:@"merchant_id"];
            [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,getalloffer] WithDictionary:dict];
        }
        else
        {
            netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponseGetOffer:) WithCallBackObject:self];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:mId forKey:@"merchant_id"];
            [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,getalloffer] WithDictionary:dict];
        }
    }
}

-(void)ParseResponseGetOffer:(id)sender
{
    NetworkUtills *utills=(NetworkUtills *)sender;
    NSError *error = nil;
    NSData *data = [utills.strResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *resDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

//    NSDictionary *resDic =[utills.strResponse JSONValue];
    NSString *st = [resDic objectForKey:@"status"];
    if ([st isEqualToString:@"1"])
    {
        NSArray *arr =[resDic valueForKey:@"data"];
//        arrOffers =[resDic valueForKey:@"data"];
        if ([arr isKindOfClass:[NSString class]])
        {
            if (isOffer)
            {
                NSString *msg = [NSString stringWithFormat:@"%@",[resDic valueForKey:@"data"]];
                UIAlertController *alert = [[UIAlertController alloc] init];
                alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    
                }];
                [alert addAction:btn_cancel];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            else
            {
                NSString *msg = [NSString stringWithFormat:@"%@",[resDic valueForKey:@"data"]];
                [self showAlert:@"Empower Main Street" message:msg cancel:@"OK" other:nil];
                return;
 
            }
        }
        else
        {
            arrOffers =[resDic valueForKey:@"data"];
        }
        [tblOffers reloadData];
    }
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
                [viewDetail removeFromSuperview];
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
                [viewDetail removeFromSuperview];
        }];
        [alert addAction:btn_cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark - QR code scan

-(void)scanCode
{
   // NSLog(@"Scanning..");
    //resultTextView.text = @"Scanning..";
    
    codeReader = [ZBarReaderViewController new];
    codeReader.readerDelegate=self;
    codeReader.supportedOrientationsMask = ZBarOrientationMaskAll;
    [self.scanView setFrame:self.view.frame];
    [codeReader setCameraOverlayView:self.scanView];
    
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
            if ([strMidd isEqualToString:strMid])
            {
                [codeReader dismissViewControllerAnimated:YES completion:nil];
                [self callRedeamApi];
            }
            else
            {
                UIAlertController *alert = [[UIAlertController alloc] init];
                alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:@"QR image is not match with this offer." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [viewDetail removeFromSuperview];
                }];
                [alert addAction:btn_cancel];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        
    }
    //resultImageView.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // dismiss the controller
    [reader dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark- loginWIthFb Api And Response

-(void)loginWithFb
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSString *strUserId =  [FBSDKAccessToken currentAccessToken].userID;
        NSLog(@"Facebook user id %@",strUserId);
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        login.loginBehavior = FBSDKLoginBehaviorWeb;
        [login logOut];
        [login logInWithReadPermissions:@[@"email",@"public_profile",@"user_hometown"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if (result.isCancelled)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                if ([FBSDKAccessToken currentAccessToken])
                {
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         if (!error)
                         {
                             App_Delegate.dictUserInfoFB1 =[[NSMutableDictionary alloc]init];
                             [App_Delegate.dictUserInfoFB1 setObject: [result objectForKey:@"email"] forKey:@"email"];
                             [App_Delegate.dictUserInfoFB1 setObject: [result objectForKey:@"gender"] forKey:@"gender"];
                             [App_Delegate.dictUserInfoFB1 setObject: [result objectForKey:@"name"] forKey:@"name"];
                             [App_Delegate.dictUserInfoFB1 setObject:[result objectForKey:@"id"] forKey:@"fbId"];
                             name = [App_Delegate.dictUserInfoFB1 valueForKey:@"name"];
                             [[NSUserDefaults standardUserDefaults]setObject:name forKey:@"fbname"];
                             [[NSUserDefaults standardUserDefaults]synchronize];
 
                             // http://198.57.247.185/~jwalkin/admin/api/user_register.php?facebook_id=56466&name=sohan&email=sohan@fox.com
 
                             NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                             [dict setObject:[App_Delegate.dictUserInfoFB1 valueForKey:@"fbId"]forKey:@"facebook_id"];
                             [dict setObject:name forKey:@"name"];
                             [dict setValue:[App_Delegate.dictUserInfoFB1 valueForKey:@"email"] forKey:@"email"];
                             netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponseRegister:) WithCallBackObject:self];
                             [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,userRegister] WithDictionary:dict];
                         }
                     }];
                }
            }
        }];
    }
}

-(void)ParseResponseRegister:(id)sender
{
    NetworkUtills *utills=(NetworkUtills *)sender;
    [self ParseResultRegister:utills.strResponse];
}

-(void)ParseResultRegister:(NSString *)strResponse
{
    NSDictionary *dictRegister = [strResponse JSONValue];
    NSString *uid = [dictRegister valueForKey:@"user_id"];
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSString *sts =[dictRegister valueForKey:@"status"] ;
    if ([sts isEqualToString:@"1"])
    {
        [self scanCode];
    }
}
*/
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
