//
//  ManageOffersViewController.h
//  Jwalkin
//
//  Created by Asai on 4/16/17.
//  Copyright © 2017 fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatePunchCardViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UIButton *radio5punches;
@property (weak, nonatomic) IBOutlet UIButton *radio10punches;
@property (weak, nonatomic) IBOutlet UIButton *radio15punches;
@property (weak, nonatomic) IBOutlet UITextView *txtComplete;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UILabel *lblcomplete;
- (IBAction)radioClicked:(id)sender;
- (IBAction)saveButtonClicked:(id)sender;
- (IBAction)backButtonClicked:(id)sender;
@property (retain, nonatomic) NSString *user_id;
@property (retain, nonatomic) NSString *user_type;

@end
