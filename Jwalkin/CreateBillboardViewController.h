//
//  CreateBillboardViewController.h
//  Jwalkin
//
//  Created by Asai on 4/16/17.
//  Copyright © 2017 fox. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NIDropDown.h"
#import "RemoteImageView.h"

@interface CreateBillboardViewController : UIViewController<UITextViewDelegate, UITextFieldDelegate>{
    UIImage *thumbImg;
    int flagPicker;
    NSURL *videoUrl;
    NSCharacterSet *whitespace ;
    UIButton *btnTemp;
    NSString *strDate;
    UIImage *imageSelected;
}
@property(strong,nonatomic) RemoteImageView *tempImg;
@property int billBoardNo;

@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UILabel *lsTitle;
@property (weak, nonatomic) IBOutlet UILabel *lsType;
@property (weak, nonatomic) IBOutlet UILabel *lsMedia;
@property (weak, nonatomic) IBOutlet UILabel *lsText;
@property (weak, nonatomic) IBOutlet UIButton *btnNews;
@property (weak, nonatomic) IBOutlet UIButton *btnDeals;
@property (weak, nonatomic) IBOutlet UIButton *btnEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnWebsite;
@property (weak, nonatomic) IBOutlet UIButton *btnAddMedia;
@property (weak, nonatomic) IBOutlet UIView *viewMedia;
@property (weak, nonatomic) IBOutlet UITextView *textViewText;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet RemoteImageView *imvPostImage;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)ActionNews:(id)sender;
- (IBAction)ActionDeal:(id)sender;
- (IBAction)ActionEvent:(id)sender;
- (IBAction)ActionWebsite:(id)sender;
- (IBAction)ActionMedia:(id)sender;
- (IBAction)ActionShare:(id)sender;
- (IBAction)ActionSubmit:(id)sender;
- (IBAction)ActionCancel:(id)sender;
- (IBAction)ActionBack:(id)sender;

@end
