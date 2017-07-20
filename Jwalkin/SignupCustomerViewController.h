//
//  SignupCustomerViewController.h
//  Jwalkin
//
//  Created by Asai on 5/14/17.
//  Copyright © 2017 fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NetworkUtills.h"
@interface SignupCustomerViewController : UIViewController<UITextFieldDelegate>
{
    
    IBOutlet UIButton *btnFBSignup;
    IBOutlet UITextField *nameField;
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *passwordField;
    IBOutlet UITextField *confirmpasswordField;
    IBOutlet UIButton *btnSubmit;
    AppDelegate *app;
    NetworkUtills *netUtills,*utllForgotP;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    NSString *name;
}
- (IBAction)ActionSignupFB:(id)sender;
- (IBAction)ActionSubmit:(id)sender;
- (IBAction)ActionClose:(id)sender;
@end
