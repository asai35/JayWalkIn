//
//  SignupVC.m
//  Jwalkin
//
//  Created by Asai on 5/13/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import "SignupVC.h"
#import "HomeVC.h"
#import "RegisterMerchantVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Bolts/Bolts.h>
#import "AFNetworking.h"
#import "UrlFile.h"
#import "Reachability.h"
#import "SBJson5.h"
#import "SignupCustomerViewController.h"
@interface SignupVC ()

@end

@implementation SignupVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    //for testing has to delete value
    //[[NSUserDefaults standardUserDefaults] setObject:@"registered" forKey:@"loggedin"];
    btnSignup.layer.cornerRadius = 5.0;
    app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"status_bar"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [app hideHUD];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark- Button Action
/*

-(IBAction)btnSignUpClicked
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
        //NSLog(@"Facebook user id %@",strUserId);
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
                    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                    [parameters setValue:@"id,name,email,gender" forKey:@"fields"];

                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters] //dp 19 Dec 2015
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                     {
                         if (!error)
                         {
                             //NSLog(@"Fetched user %@",result);
                             
                             App_Delegate.dictUserInfoFB =[[NSMutableDictionary alloc]init];
                             [App_Delegate.dictUserInfoFB setObject: [result objectForKey:@"email"] forKey:@"email"];
                             [App_Delegate.dictUserInfoFB setObject: [result objectForKey:@"gender"] forKey:@"gender"];
                             [App_Delegate.dictUserInfoFB setObject: [result objectForKey:@"name"] forKey:@"name"];
                             RegisterMerchantVC *registerVC = [[RegisterMerchantVC alloc] initWithNibName:@"RegisterMerchantVC" bundle:nil];
                             registerVC.isViaFB=YES;
                             registerVC.dictFacebookData=App_Delegate.dictUserInfoFB;
                             [self.navigationController pushViewController:registerVC animated:YES];
                         }
                     }];
                }
            }
        }];
    }
}
*/
- (IBAction)BtnSignUp:(id)sender
{
    
    NSURL *url = [NSURL URLWithString:@"http://emsbapp.com/jwalkin_new_work/signup.php"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];

}

- (IBAction)btnForgetClick:(id)sender
{
    
//    UIAlertView * forgotPassword=[[UIAlertView alloc] initWithTitle:@"Forgot Password"      message:@"Please enter your email id" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
//    forgotPassword.tag = 1;
//    forgotPassword.alertViewStyle=UIAlertViewStylePlainTextInput;
//    [forgotPassword textFieldAtIndex:0].delegate=self;
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert = [UIAlertController alertControllerWithTitle:@"Forgot Password" message:@"Please enter your email id" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.delegate = (id)self;
    }];
    UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"Subscribe" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"ok button clicked in forgot password alert view");
            NSString *femailId=alert.textFields[0].text;
                if (femailId.length>0)
                {
                    [self callApiForForgotPassword:femailId];
                }
                else
                {
                    [self showAlert:@"Alert!" message:@"Please enter the email id" cancel:@"Ok" other:nil];
                }
    }];
    [alert addAction:btn_ok];
    UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }];
    [alert addAction:btn_cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(IBAction)btnLoginClicked
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"" message:@"Please check your internet connection." cancel:@"OK" other:nil];
    }
    else
    {
        if (tfEmail.text.length == 0   )
        {
            [self showAlert:@"" message:@"Enter email." cancel:@"OK" other:nil];
        }
        else if(tfPassword.text.length == 0 )
        {
            [self showAlert:@"" message:@"Enter password." cancel:@"OK" other:nil];
        }
        else
        {
            NSDictionary *parameters = @{@"email_id": tfEmail.text,
                                         @"password": tfPassword.text };
            
            [app showHUD];
            [[JWNetWorkManager sharedManager] POST:@"login.php" data:parameters completion:^(id data, NSError *error) {
                if (error) {
                    [app hideHUD];
                    NSLog(@"Error: %@", error);
                } else {
                    NSLog(@"%@ %@", error, data);
                    if ([[data valueForKey:@"status"] intValue]== 1)
                    {
                        NSArray *arrData = [data valueForKey:@"data"];
                        NSMutableDictionary *dictData= [[NSMutableDictionary alloc]init];
                        dictData = [[arrData objectAtIndex:0] mutableCopy];
                        NSMutableDictionary *newinfo = [[NSMutableDictionary alloc]init];
                        for(id ss in dictData)
                        {
                            NSString *str  =[dictData objectForKey:ss];
                            if (![str isKindOfClass:[NSNull class]])
                            {
                                [newinfo setObject:str forKey:ss];
                            }
                        }
                        NSLog(@"dictdata %@",newinfo);
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        if ([defaults objectForKey:@"loggedin"]) {
                            NSMutableArray *arrayAccounts = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"accounts"]];
                            NSMutableDictionary *account = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"userInfo"]];
                            if (![arrayAccounts containsObject:account]) {
                                [arrayAccounts addObject:account];
                            }
                            [defaults setObject:arrayAccounts forKey:@"accounts"];
                        }else{
                            [defaults setObject:@[newinfo] forKey:@"accounts"];
                        }
                        [defaults setObject:newinfo forKey:@"userInfo"];
                        NSString *merchantid = [dictData valueForKey:@"id"];
                        NSString *merchantName = [dictData valueForKey:@"name"];
                        NSString *FbLink = [dictData valueForKey:@"fb_link"];
                        NSString *WebLink = [dictData valueForKey:@"website"];
                        [defaults setObject:merchantName forKey:@"merchantName"];
                        [defaults synchronize];
                        [defaults setObject:merchantid forKey:@"merchantid"];
                        [defaults synchronize];
                        [defaults setObject:merchantid forKey:@"user-Id"];
                        [defaults synchronize];
                        [defaults setObject:@"registered" forKey:@"loggedin"];
                        [defaults synchronize];
                        [defaults setObject:FbLink forKey:@"fb_link"];
                        [defaults synchronize];
                        [defaults setObject:WebLink forKey:@"Website"];
                        [defaults synchronize];
                        [appdelegate() hideHUD];

                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        });
//                        NSArray *vcs = self.navigationController.viewControllers;
//                        for (UIViewController *vc in vcs) {
//                            if ([vc isEqual:[HomeVC class]]) {
//                                [self.navigationController popToViewController:vc animated:YES];
//                            }
//                        }
                    }
                    else if([[data valueForKey:@"status"] intValue]== 0)
                    {
                        [self showAlert:@"Message" message:[NSString stringWithFormat:@"%@",[data objectForKey:@"data"]] cancel:@"Ok" other:nil];
                        [appdelegate() hideHUD];
                    }
                    else if([[data valueForKey:@"status"] intValue] == 2)
                    {
                        UIAlertController *alert = [[UIAlertController alloc] init];
                        alert = [UIAlertController alertControllerWithTitle:@"Message" message:[NSString stringWithFormat:@"%@",[data objectForKey:@"data"]] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"Subscribe" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                NSURL *url = [NSURL URLWithString:@"http://emsbapp.com/jwalkin_new_work/signup.php"];
                                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                        }];
                        [alert addAction:btn_ok];
                        UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [alert dismissViewControllerAnimated:YES completion:^{
                                
                            }];
                            
                        }];
                        [alert addAction:btn_cancel];
                        [self presentViewController:alert animated:YES completion:nil];
                        [app hideHUD];
                    }
                    
                    else
                    {
                        [self showAlert:@"" message:@"Incorrect email id or password." cancel:@"Ok" other:nil];
                        [app hideHUD];
                    }
                }
            }];
            

            
            
        }
    }
}


-(IBAction)btnSignInFBClicked:(id)sender
{
//    [self loginWithFb];
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"signupcustomerVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnCancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ActionInfo:(id)sender {
    viewInfo.frame = self.view.frame;
    viewInfo.alpha = 0;
    [self.view addSubview:viewInfo];
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseIn  animations:^
     {
         viewInfo.alpha = 1;
     }
                     completion:nil];
    //UIViewAnimationOptionCurveLinear
    [UIView commitAnimations];
}

#pragma mark TextFeild Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == tfEmail)
    {
        [tfPassword becomeFirstResponder];
    }
    if (textField == tfPassword)
    {
        [textField resignFirstResponder];
        [self btnLoginClicked];
    }
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tfPassword resignFirstResponder];
    [tfEmail resignFirstResponder];
    [viewInfo removeFromSuperview];
}

-(void)loginWithFb
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"Error" message:@"Please check your internet connection." cancel:@"Ok" other:nil];
    }
    else
    {
        NSString *strUserId =  [FBSDKAccessToken currentAccessToken].userID;
        NSLog(@"Facebook user id %@",strUserId);
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        login.loginBehavior = FBSDKLoginBehaviorWeb;
        [login logOut];

        [login logInWithReadPermissions:@[@"public_profile", @"email"] fromViewController:self.view.window.rootViewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//        }];
//        [login logInWithReadPermissions:@[@"email",@"public_profile",@"user_hometown",@"publish_action"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error)
            {
                [self showAlert:@"Error" message:@"Please try again." cancel:@"Ok" other:nil];
            }
            else if (result.isCancelled)
            {
                [self showAlert:@"Error" message:@"Please try again." cancel:@"Ok" other:nil];
            }
            else
            {
                if ([FBSDKAccessToken currentAccessToken])
                {
                    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                    [parameters setValue:@"id,name,email,gender" forKey:@"fields"];
                    
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
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
                             /*
                              http://198.57.247.185/~jwalkin/admin/api/user_register.php?facebook_id=56466&name=sohan&email=sohan@fox.com
                              */
                             NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                             [dict setObject:[App_Delegate.dictUserInfoFB1 valueForKey:@"fbId"]forKey:@"facebook_id"];
                             [dict setObject:name forKey:@"name"];
                             [dict setValue:[App_Delegate.dictUserInfoFB1 valueForKey:@"email"] forKey:@"email"];
                             [dict setValue: App_Delegate.udid forKey:@"udid"];
                             [dict setValue: @"IOS" forKey:@"platform"];
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
    NSError *error = nil;
    NSData *data = [strResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dictRegister = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSString *uid = [dictRegister valueForKey:@"user_id"];
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"user-Id"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSString *sts =[dictRegister valueForKey:@"status"] ;
    if ([sts isEqualToString:@"200"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag == 5001)
//    {
//        if (buttonIndex == 1)
//        {
//            NSURL *url = [NSURL URLWithString:@"http://emsbapp.com/jwalkin_new_work/signup.php"];
//            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
//        }
//    }
//    
//    if (alertView.tag ==1)
//    {
//        NSLog(@"ok button clicked in forgot password alert view");
//        NSString *femailId=[alertView textFieldAtIndex:0].text;
//        if (buttonIndex == 1)
//        { 
//        if (femailId.length>0)
//        {
//            [self callApiForForgotPassword:femailId];
//        }
//        else
//        {
//            [self showAlert:@"Alert!" message:@"Please enter the email id" cancel:@"Ok" other:nil];
//            }
//            
//        }
//    }
//}
-(void)callApiForForgotPassword:(NSString*)Email
{
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    
    [dict setObject:Email forKey:@"email" ];
    utllForgotP = [[NetworkUtills alloc] initWithSelector:@selector(callBackForgotPassword) WithCallBackObject:self];
    [utllForgotP GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,forgotPasswordAPi] WithDictionary:dict];

}
-(void)callBackForgotPassword
{
    NSLog(@"Str Response of forgot password api %@",utllForgotP.strResponse);
    NSError *error = nil;
    NSData *data = [utllForgotP.strResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

//    NSDictionary *dict=[utllForgotP.strResponse JSONValue];
    
    if ([[dict objectForKey:@"status"]integerValue]==1) {
        [self showAlert:@"Alert!" message:[dict objectForKey:@"message"] cancel:@"Ok" other:nil];
    }
    else
    {
        [self showAlert:@"Alert!" message:[dict objectForKey:@"message"] cancel:@"Ok" other:nil];
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
