//
//  HomeVC.m
//  Jwalkin
//
//  Created by Asai on 06/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//

#import "HomeVC.h"
#import "SBJson5.h"
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



@interface HomeVC ()
{
    AppDelegate *app;
}
@end

@implementation HomeVC
@synthesize imgBtnView,imglogo,btnInfo;


- (void)viewDidLoad
{
    [super viewDidLoad];
    mainArray = [[NSMutableArray alloc] init];
    btnMenu.hidden=YES;
    app = (AppDelegate*)[UIApplication sharedApplication].delegate ;
    btnSetting.enabled=NO;
    [self performSelector:@selector(TransFormBtns) withObject:nil afterDelay:1.0];
//      scrl.contentSize = CGSizeMake(scrl.frame.size.width,560);
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"" message:@"Please check your internet connection." cancel:@"OK" other:nil];
        btnSetting.enabled =YES;
    }
    else
    {
        netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponse:) WithCallBackObject:self];
        [netUtills GetResponseByASIHttpRequest:[NSString stringWithFormat:@"%@%@",mainUrl,allcatagories]];
    }
    NSString *radius =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"radius"]];
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"radius"])
    {
        if ([radius isEqualToString:@"1"])//dp change(22Dec)
        {
            [btnRadio10Mile setImage:[UIImage imageNamed:@"radio-button_touch"] forState:UIControlStateNormal];
            [btnRadio20Mile setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
            [btnRadio30Mile setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
            [btnRadio100Meter setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
            [btnRadio200Meter setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
        }
        else if ([radius isEqualToString:@"5"])//dp change(22Dec)
        {
            [btnRadio20Mile setImage:[UIImage imageNamed:@"radio-button_touch"] forState:UIControlStateNormal];
            [btnRadio10Mile setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
            [btnRadio30Mile setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
            [btnRadio100Meter setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
            [btnRadio200Meter setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
        }
        else if([radius isEqualToString:@"10"])//dp change(22Dec)
        {
            [btnRadio30Mile setImage:[UIImage imageNamed:@"radio-button_touch"] forState:UIControlStateNormal];
            [btnRadio20Mile setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
            [btnRadio10Mile setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
            [btnRadio100Meter setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
            [btnRadio200Meter setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
        }
      else if ([radius isEqualToString:@"0.06"])
      {
          [btnRadio30Mile setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
          [btnRadio20Mile setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
          [btnRadio10Mile setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
          [btnRadio100Meter setImage:[UIImage imageNamed:@"radio-button_touch"] forState:UIControlStateNormal];
          [btnRadio200Meter setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];

      }
      else if ([radius isEqualToString:@"0.12"])
      {
          [btnRadio30Mile setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
          [btnRadio20Mile setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
          [btnRadio10Mile setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
          [btnRadio100Meter setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
          [btnRadio200Meter setImage:[UIImage imageNamed:@"radio-button_touch"] forState:UIControlStateNormal];

      }

    }
}

-(void)viewWillAppear:(BOOL)animated
{
    NSString *str =[[NSUserDefaults standardUserDefaults] valueForKey:@"fbname"];
    if ( [[NSUserDefaults standardUserDefaults] objectForKey:@"loggedin"])
    {
        imgBtnView.image = [UIImage imageNamed:@"jwakin_login"];
        btnSignup.tag = 13;
        btnMenu.hidden=NO;
    }
    else if(str.length != 0)
    {
        imgBtnView.image = [UIImage imageNamed:@"jwaker"];
        btnSignup.tag = 14;
        btnMenu.hidden = NO;//dp
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)TransFormBtns
{
    if ([[UIScreen mainScreen] bounds].size.height > 500)
    {
        if (IS_IPHONE_6_IOS7 || IS_IPHONE_6_IOS8 || IS_IPHONE_6)
        {
            btnCommunity.frame =CGRectMake(btnCommunity.frame.origin.x,btnCommunity.frame.origin.y-20, btnCommunity.frame.size.width, btnCommunity.frame.size.height);
            btnHealth.frame=CGRectMake(btnHealth.frame.origin.x,btnHealth.frame.origin.y-20,btnHealth.frame.size.width, btnHealth.frame.size.height);
            btnNightLife.frame=CGRectMake(btnNightLife.frame.origin.x,btnNightLife.frame.origin.y-20,btnNightLife.frame.size.width, btnNightLife.frame.size.height);
            btnShopping.frame=CGRectMake( btnShopping.frame.origin.x, btnShopping.frame.origin.y-20,btnShopping.frame.size.width, btnShopping.frame.size.height+5);
            btnTownInfoCenter.frame=CGRectMake(btnTownInfoCenter.frame.origin.x+10,btnTownInfoCenter.frame.origin.y-20, btnTownInfoCenter.frame.size.width, btnTownInfoCenter.frame.size.height+5);
            btnPersonal.frame=CGRectMake( btnPersonal.frame.origin.x, btnPersonal.frame.origin.y-20,  btnPersonal.frame.size.width,  btnPersonal.frame.size.height);
            btnFood.frame=CGRectMake(btnFood.frame.origin.x,btnFood.frame.origin.y-20,  btnFood.frame.size.width,  btnFood.frame.size.height);
            btnTravel.frame=CGRectMake(btnTravel.frame.origin.x,btnTravel.frame.origin.y-20, btnTravel.frame.size.width,  btnTravel.frame.size.height);
            btnTrade.frame=CGRectMake(btnTrade.frame.origin.x,btnTrade.frame.origin.y-20,btnTrade.frame.size.width, btnTrade.frame.size.height);
            btnSignup.frame=CGRectMake(btnSignup.frame.origin.x,btnSignup.frame.origin.y-10,btnSignup.frame.size.width, btnSignup.frame.size.height);
          
        }
        else if (IS_IPHONE_6P || IS_IPHONE_6P_IOS7 || IS_IPHONE_6P_IOS8)
        {
            btnCommunity.frame =CGRectMake(btnCommunity.frame.origin.x,btnCommunity.frame.origin.y-20, btnCommunity.frame.size.width, btnCommunity.frame.size.height);
            btnHealth.frame=CGRectMake(btnHealth.frame.origin.x,btnHealth.frame.origin.y-20,btnHealth.frame.size.width, btnHealth.frame.size.height);
            btnNightLife.frame=CGRectMake(btnNightLife.frame.origin.x,btnNightLife.frame.origin.y-20,btnNightLife.frame.size.width, btnNightLife.frame.size.height);
            btnShopping.frame=CGRectMake( btnShopping.frame.origin.x, btnShopping.frame.origin.y-20,btnShopping.frame.size.width, btnShopping.frame.size.height+5);
            btnTownInfoCenter.frame=CGRectMake(btnTownInfoCenter.frame.origin.x+10,btnTownInfoCenter.frame.origin.y-20, btnTownInfoCenter.frame.size.width, btnTownInfoCenter.frame.size.height+5);
            btnPersonal.frame=CGRectMake( btnPersonal.frame.origin.x, btnPersonal.frame.origin.y-20,  btnPersonal.frame.size.width,  btnPersonal.frame.size.height);
            btnFood.frame=CGRectMake(btnFood.frame.origin.x,btnFood.frame.origin.y-20,  btnFood.frame.size.width,  btnFood.frame.size.height);
            btnTravel.frame=CGRectMake(btnTravel.frame.origin.x,btnTravel.frame.origin.y-20, btnTravel.frame.size.width,  btnTravel.frame.size.height);
            btnTrade.frame=CGRectMake(btnTrade.frame.origin.x,btnTrade.frame.origin.y-20,btnTrade.frame.size.width, btnTrade.frame.size.height);
            btnSignup.frame=CGRectMake(btnSignup.frame.origin.x,btnSignup.frame.origin.y-10,btnSignup.frame.size.width, btnSignup.frame.size.height);
        }
        btnCommunity.transform=CGAffineTransformMakeRotation(M_PI / +12);
        btnPersonal.transform=CGAffineTransformMakeRotation(M_PI / -14);
        btnHealth.transform=CGAffineTransformMakeRotation(M_PI / +14);
        btnFood.transform=CGAffineTransformMakeRotation(M_PI / -20);
        btnNightLife.transform=CGAffineTransformMakeRotation(M_PI / +14);
        btnTravel.transform=CGAffineTransformMakeRotation(M_PI / -20);
        btnShopping.transform=CGAffineTransformMakeRotation(M_PI / +20);
        btnTownInfoCenter.transform=CGAffineTransformMakeRotation(M_PI / +22);

        btnFinantial.transform=CGAffineTransformMakeRotation(M_PI / +11);
        btnTrade.transform=CGAffineTransformMakeRotation(M_PI / -13);
        btnSignup.transform=CGAffineTransformMakeRotation(M_PI / -20);
     
    }
    
    else
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.1)
            
        {   btnCommunity.frame =CGRectMake(60,110, 120, 33);
            
            btnCommunity.transform=CGAffineTransformMakeRotation(M_PI / +20);//14
            
            btnHealth.frame=CGRectMake(60,190,120, 33);
            
            btnHealth.transform=CGAffineTransformMakeRotation(M_PI / +23);    //14
             btnNightLife.frame=CGRectMake(59,255,130,28);
            btnNightLife.transform=CGAffineTransformMakeRotation(M_PI / +23);  //14
             btnShopping.frame=CGRectMake(40,325,135,32);
            btnShopping.transform=CGAffineTransformMakeRotation(M_PI / +18);
            // btnFinantial.frame=CGRectMake(160, 140, 135, 30);
            btnFinantial.transform=CGAffineTransformMakeRotation(M_PI / +20);//11
            
             btnTownInfoCenter.frame=CGRectMake(52,395, 135, 30);
            
            btnTownInfoCenter.transform=CGAffineTransformMakeRotation(M_PI / +20);//11
            btnPersonal.frame=CGRectMake(155, 145, 125, 33);
            btnPersonal.transform=CGAffineTransformMakeRotation(M_PI/-20);//12
             btnFood.frame=CGRectMake(155,223, 125, 28);
            btnFood.transform=CGAffineTransformMakeRotation(M_PI /-18); //12
             btnTravel.frame=CGRectMake(162, 285, 140, 33);
            btnTravel.transform=CGAffineTransformMakeRotation(M_PI /-20);//12
            
           btnTrade.frame=CGRectMake(160,360, 135, 30);
           
            btnTrade.transform=CGAffineTransformMakeRotation(M_PI /-20);//12
            btnSignup.frame=CGRectMake(135,437,140, 30);
            btnSignup.transform=CGAffineTransformMakeRotation(M_PI / -22);//12
        }
        else
        {
            btnCommunity.transform=CGAffineTransformMakeRotation(M_PI / +14);
            btnHealth.transform=CGAffineTransformMakeRotation(M_PI / +14);
            btnNightLife.transform=CGAffineTransformMakeRotation(M_PI / +14);
            btnShopping.transform=CGAffineTransformMakeRotation(M_PI / +18);
            btnFinantial.transform=CGAffineTransformMakeRotation(M_PI / +11);
            btnTownInfoCenter.transform=CGAffineTransformMakeRotation(M_PI / +11);
            btnPersonal.transform=CGAffineTransformMakeRotation(M_PI/-12);
            btnFood.transform=CGAffineTransformMakeRotation(M_PI /-12);
            btnTravel.transform=CGAffineTransformMakeRotation(M_PI /-12);
           
            btnTrade.transform=CGAffineTransformMakeRotation(M_PI /-12);
            btnSignup.transform=CGAffineTransformMakeRotation(M_PI / -12);
        }
    }
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
    mainArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//    mainArray = [strResponse JSONValue];
    btnSetting.enabled=YES;
}

#pragma mark- Button Action

-(IBAction)ButtonClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    SubCategoriesVC *sub = [self.storyboard instantiateViewControllerWithIdentifier:@"SubCategoriesVC"];
    switch (btn.tag)
    {
        case 1:
        {
            if (mainArray.count != 0)
            {
                sub.mainDict = [mainArray objectAtIndex:0];
            }
            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
            
        case 2:
        {
            if (mainArray.count != 0)
            {
                sub.mainDict = [mainArray objectAtIndex:1];
            }
            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
            
        case 3:
        {
            if (mainArray.count != 0)
            {
                sub.mainDict = [mainArray objectAtIndex:2];
            }
            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
            
        case 4:
        {
            if (mainArray.count != 0)
            {
                sub.mainDict = [mainArray objectAtIndex:3];
            }
            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
            
        case 5:
        {
            if (mainArray.count != 0)
            {
                sub.mainDict = [mainArray objectAtIndex:4];
            }
            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
            
        case 6:
        {
            if (mainArray.count != 0)
            {
                sub.mainDict = [mainArray objectAtIndex:5];
            }
            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
            
        case 7:
        {
            if (mainArray.count != 0)
            {
                sub.mainDict = [mainArray objectAtIndex:6];
            }
            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
            
        case 9:
        {
            if (mainArray.count != 0)
            {
                sub.mainDict = [mainArray objectAtIndex:8];
            }
            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
            
        case 10:
        {
            if (mainArray.count != 0)
            {
                sub.mainDict = [mainArray objectAtIndex:7];
            }
            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
        case 11:
        {
            TownInfoCenterVC *townInfo =[[TownInfoCenterVC alloc]initWithNibName:@"TownInfoCenterVC" bundle:nil];
            [self.navigationController pushViewController:townInfo animated:YES];
        }
            break;
        
        case 12:
        {
            SignupVC *signup = [self.storyboard instantiateViewControllerWithIdentifier:@"SignupVC"];//[[SignupVC alloc] initWithNibName:@"SignupVC" bundle:nil];
            [self.navigationController pushViewController:signup animated:YES];
        }
            break;
           
        case 13:
        {
            
             viewBgPopup.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:viewBgPopup];
            viewPopUp.frame = CGRectMake((self.view.frame.size.width / 2)-(viewPopUp.frame.size.width/2), (self.view.frame.size.height /2)-(viewPopUp.frame.size.height/2), viewPopUp.frame.size.width, viewPopUp.frame.size.height);
            [self.view addSubview:viewPopUp];
            viewBgPopup.alpha = 0;
            viewPopUp.alpha = 0;
            [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseIn  animations:^
             {
                 viewPopUp.alpha = 1;
                 viewBgPopup.alpha = 0.5;
                 
                 viewPopUp.center = self.view.center;
             }
                             completion:nil];
            //UIViewAnimationOptionCurveLinear
                [UIView commitAnimations];
          }
            break;
        case 14:
        {
            MyFavVC *my = [self.storyboard instantiateViewControllerWithIdentifier:@"MyFavVC"];
            [self.navigationController pushViewController:my animated:YES];
        }
        default:
            break;
    }
}
-(IBAction)btnSwitchAccountClicked:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"switchVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)btnLogoutClicked:(id)sender
{
    
    
    // *****  Dp 22Dec
    
//    if ( [[NSUserDefaults standardUserDefaults] objectForKey:@"loggedin"])
//    {
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:@"Are you sure you want to logout?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [app showHUD];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loggedin"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"merchantid"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user-Id"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accounts"];
        //[[NSUserDefaults standardUserDefaults] synchronize];
        [NSThread sleepForTimeInterval:0.5];
        imgBtnView.image = [UIImage imageNamed:@"jwakin_logout"];
        btnSignup.tag = 12;
        [app hideHUD];
        btnMenu.hidden = YES;
        
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
 //   }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Jaywalk.In" message:@"You are already logged Out." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }
}

-(IBAction)InfoClicked:(id)sender
{
//    InfoVC *info = [[InfoVC alloc] initWithNibName:@"InfoVC" bundle:nil];
    InfoVC *info = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoVC"];
    [self.navigationController pushViewController:info animated:YES];
}

-(IBAction)btnSettingClicked:(id)sender
{
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
    [btnRadio100Meter setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
    [btnRadio200Meter setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];

    [sender setImage:[UIImage imageNamed:@"radio-button_touch"] forState:UIControlStateNormal];

    NSUserDefaults *rad = [NSUserDefaults standardUserDefaults];
    [rad setObject:radius forKey:@"radius"];
}

-(IBAction)btnManageBilBoardClicked:(id)sender
{
    ManageBillBoardVC *manageBB = [self.storyboard instantiateViewControllerWithIdentifier:@"ManageBillBoardVC"];
    [self.navigationController pushViewController:manageBB animated:YES];
}

-(IBAction)btnUpdateProfileClicked:(id)sender
{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"updateproVC"];
    [self presentViewController:vc animated:YES completion:nil];
}

-(IBAction)btnManageOfferClicked:(id)sender
{
    ManageOfferVC *manageOffer = [self.storyboard instantiateViewControllerWithIdentifier:@"ManageOfferVC"];//[[ManageOfferVC alloc] initWithNibName:@"ManageOfferVC" bundle:nil];
    [self.navigationController pushViewController:manageOffer animated:YES];
}

-(IBAction)btnMenuClicked:(id)sender
{
    
    NSString *str =[[NSUserDefaults standardUserDefaults] valueForKey:@"fbname"];
    if ( [[NSUserDefaults standardUserDefaults] objectForKey:@"loggedin"])
    {
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Jaywalk.In"
//                                                                 delegate:self
//                                                        cancelButtonTitle:@"Cancel"
//                                                   destructiveButtonTitle:nil
//                                                        otherButtonTitles:@"Manage Profile", @"Manage Billboards", @"Manage Offers", @"Logout",nil];
//        actionSheet.actionSheetStyle =UIActionSheetStyleBlackTranslucent;
//        actionSheet.tintColor = [UIColor redColor];
//        [actionSheet showInView:self.view];
        UIAlertController *alert = [[UIAlertController alloc] init];
        alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *manageprofile = [UIAlertAction actionWithTitle:@"Manage Profile" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ( [[NSUserDefaults standardUserDefaults] objectForKey:@"loggedin"])
                {
                    [self btnUpdateProfileClicked:nil];
                }
        }];
        [alert addAction:manageprofile];
        UIAlertAction *managebillboards = [UIAlertAction actionWithTitle:@"Manage Billboards" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ( [[NSUserDefaults standardUserDefaults] objectForKey:@"loggedin"])
                {
                    [self btnManageBilBoardClicked:nil];
                }
        }];
        [alert addAction:managebillboards];
/*        UIAlertAction *manageoffers = [UIAlertAction actionWithTitle:@"Manage Punch Card" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self btnManageOfferClicked:nil];
        }];
        [alert addAction:manageoffers];*/
        UIAlertAction *switchAccount = [UIAlertAction actionWithTitle:@"Switch Account" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self btnSwitchAccountClicked:nil];
        }];
        [alert addAction:switchAccount];
        UIAlertAction *logout = [UIAlertAction actionWithTitle:@"Logout" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self btnLogoutClicked:nil];
        }];
        [alert addAction:logout];
        UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:^{
            }];
            
        }];
        [alert addAction:btn_cancel];
        [self presentViewController:alert animated:YES completion:nil];
        

    }
   
    //Dp 22Dec
    
    else if(str.length != 0)
    {
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Jaywalker.In"
//                                                                 delegate:self
//                                                        cancelButtonTitle:@"Cancel"
//                                                   destructiveButtonTitle:nil
//                                                        otherButtonTitles: @"Logout",nil];
//        actionSheet.actionSheetStyle =UIActionSheetStyleBlackTranslucent;
//        actionSheet.tintColor = [UIColor redColor];
//        [actionSheet showInView:self.view];
        UIAlertController *alert = [[UIAlertController alloc] init];
        alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *logout = [UIAlertAction actionWithTitle:@"Logout" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self btnLogoutClicked:nil];
        }];
        [alert addAction:logout];
        UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:^{
            }];
            
        }];
        [alert addAction:btn_cancel];
        [self presentViewController:alert animated:YES completion:nil];

    }

    

}
//
//#pragma mark- Action sheet delegates
//
//- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    switch (buttonIndex)
//    {
//        case 0:
//        {
//            NSString *str =[[NSUserDefaults standardUserDefaults] valueForKey:@"fbname"];
//            if ( [[NSUserDefaults standardUserDefaults] objectForKey:@"loggedin"])
//            {
//
//            [self btnUpdateProfileClicked:nil];
//            }
//            else if(str.length != 0)
//            {
//                [self btnLogoutClicked:nil];
//            }
//        }
//            break;
//        case 1:
//        {
//            if ( [[NSUserDefaults standardUserDefaults] objectForKey:@"loggedin"])
//            {
//                [self btnManageBilBoardClicked:nil];
//            }
//         }
//            break;
//        case 2:
//            [self btnManageOfferClicked:nil];
//            break;
//        case 3:
//            [self btnLogoutClicked:nil];
//            break;
//        case 4:
//            break;
//        default:
//            break;
//    }
//}
//

#pragma mark BillBoardButton

-(IBAction)billBoardOption:(id)sender
{
    UIButton *button = (UIButton *)sender;
    BillBoardVC *board = [[BillBoardVC alloc]initWithNibName:@"BillBoardVC" bundle:nil];
    if (button.tag == 11)
    {
        board.billBoardNo =11;
    }
    else if (button.tag == 12)
    {
        board.billBoardNo =12;
    }
    else if (button.tag == 13)
    {
        board.billBoardNo =13;
    }
    else  if (button.tag == 14)
    {
        board.billBoardNo =14;
    }
    else if (button.tag == 15)
    {
        board.billBoardNo =15;
    }
    else
    {
        board.billBoardNo = 16;
    }
    [viewPopUp removeFromSuperview];
    [viewBgPopup removeFromSuperview];
    [self.navigationController pushViewController:board animated:YES];
}

-(IBAction)btnCancelBillBoard
{
    [viewPopUp removeFromSuperview];
    [viewBgPopup removeFromSuperview];
}

-(IBAction)bttnSttngSubmitClicked:(id)sender
{
    [viewSettingPopUp removeFromSuperview];
    [viewBgPopup removeFromSuperview];
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
