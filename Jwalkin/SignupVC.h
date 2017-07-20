//
//  SignupVC.h
//  Jwalkin
//
//  Created by Asai on 5/13/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NetworkUtills.h"

@interface SignupVC : UIViewController<UIAlertViewDelegate>
{
    IBOutlet UIButton *btnSignup;
    IBOutlet UIButton *btnSkip;
    IBOutlet UIButton *btnCancel;
    IBOutlet UIButton *btnLogin;
    IBOutlet UIButton *btnSingInFB;
    
    IBOutlet UITextField *tfEmail;
    IBOutlet UITextField *tfPassword;
    
    
    IBOutlet UIView *viewActivity;
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UIButton *btn_info;
    
    NSString *name;
    IBOutlet UIView *viewInfo;
    
    IBOutlet UILabel *lblInfo;
    AppDelegate *app;
    NetworkUtills *netUtills,*utllForgotP;
}
- (IBAction)BtnSignUp:(id)sender;
- (IBAction)btnForgetClick:(id)sender;
-(IBAction)btnLoginClicked;
-(IBAction)btnSignInFBClicked:(id)sender;
-(IBAction)btnCancel;
- (IBAction)ActionInfo:(id)sender;
@end
