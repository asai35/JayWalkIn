//
//  AddOfferVC.h
//  Jwalkin
//
//  Created by Asai on 22/07/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkUtills.h"
#import "AppDelegate.h"
#import "RemoteImageView.h"

@interface AddOfferVC : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate, UITextViewDelegate>
{
    IBOutlet UIScrollView *scrollOffer;
    IBOutlet UIView *contentView;
    
    IBOutlet UITextField *txtTitle;
    IBOutlet UITextField *txtMaxCount;
    
    IBOutlet UITextView *txtVDescription;
    
    IBOutlet RemoteImageView *imgView;
    
    IBOutlet UILabel *lblStartOn;
    IBOutlet UILabel *lblExpireOn;
    
    IBOutlet UIButton *btnAdd;
    IBOutlet UIButton *btnSelectImage;
    IBOutlet UIButton *btnStartOn;
    IBOutlet UIButton *btnExpireOn;
    
    IBOutlet UIView *viewPicker;
    IBOutlet UIDatePicker *pickerDate;
    IBOutlet UIButton *btnPickerCancel;
    IBOutlet UIButton *btnPickerDone;
    UIButton *btnTemp;
    
    UIImage *imageSelected;
    
    AppDelegate *app;
    NSCharacterSet *whitespace ;

}
@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;
@property(nonatomic,strong)NSDictionary *dictOffer;
@property(nonatomic)BOOL isUpdate;
-(IBAction)btnBackClicked:(id)sender;
-(IBAction)btnAddClicked:(id)sender;
-(IBAction)btnSelectImageClicked:(id)sender;
-(IBAction)btnDateClicked:(id)sender;
-(IBAction)btnCancel:(id)sender;
-(IBAction)btnPickerDone:(id)sender;
@end
