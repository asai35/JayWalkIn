//
//  SignupCustomerViewController.m
//  Jwalkin
//
//  Created by Asai on 5/14/17.
//  Copyright © 2017 fox. All rights reserved.
//

#import "SignupCustomerViewController.h"
#import "HomeVC.h"
#import "RegisterMerchantVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Bolts/Bolts.h>
#import "AFNetworking.h"
#import "UrlFile.h"
#import "Reachability.h"
#import "SBJson5.h"


@interface SignupCustomerViewController ()

@end

@implementation SignupCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"status_bar"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)ActionSignupFB:(id)sender {
    [self loginWithFb];
}

- (IBAction)ActionSubmit:(id)sender {
    if ([nameField.text isEqualToString:@""]) {
        [self showAlert:@"" message:@"Please fill in the blank" cancel:@"Ok" other:@"Cancel"];
        return;
    }
    if ([emailField.text isEqualToString:@""]) {
        [self showAlert:@"" message:@"Please fill in the blank" cancel:@"Ok" other:@"Cancel"];
        return;
    }
    if ([passwordField.text isEqualToString:@""]) {
        [self showAlert:@"" message:@"Please fill in the blank" cancel:@"Ok" other:@"Cancel"];
        return;
    }
    if (![passwordField.text isEqualToString:confirmpasswordField.text]) {
        [self showAlert:@"" message:@"Confirm password doesn't match the password" cancel:@"Ok" other:@"Cancel"];
        return;
    }
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"Error" message:@"Please check your internet connection." cancel:@"Ok" other:nil];
    }else{
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        dict[@"name"] = nameField.text;
        dict[@"password"] =passwordField.text;
        dict[@"email"] = emailField.text;
        [dict setValue: App_Delegate.udid forKey:@"udid"];
        [dict setValue: @"IOS" forKey:@"platform"];
        netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponseRegister:) WithCallBackObject:self];
        [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,userRegister] WithDictionary:dict];

    }
}

- (IBAction)ActionClose:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark TextFeild Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == nameField)
    {
        [emailField becomeFirstResponder];
    }
    if (textField == emailField)
    {
        [passwordField becomeFirstResponder];
    }
    if (textField == passwordField)
    {
        [confirmpasswordField becomeFirstResponder];
    }
    if (textField == confirmpasswordField)
    {
        [textField resignFirstResponder];
        [self ActionSubmit:nil];
    }
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [nameField resignFirstResponder];
    [emailField resignFirstResponder];
    [passwordField resignFirstResponder];
    [confirmpasswordField resignFirstResponder];
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

- (void)signupClicked{
    
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
