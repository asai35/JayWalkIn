//
//  MainScreenViewController.h
//  Jwalkin
//
//  Created by Asai on 4/14/17.
//  Copyright © 2017 fox. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NetworkUtills.h"
#import "AppDelegate.h"
#import "WrapperClass.h"

@interface MainScreenViewController : UIViewController<UIApplicationDelegate, UISearchBarDelegate>{
    NSMutableArray *mainArray;

    IBOutlet UITableView *tblMrchnt;
    IBOutlet UIButton *btnDropdown;
    IBOutlet UIButton *btnHome;
    IBOutlet UIButton *btnSearch;
    IBOutlet UIButton *btnFav;
    IBOutlet UIButton *btnMap;
    
    IBOutlet UIButton *btnMenu;
    IBOutlet UITableView *tblDrList;
    
    // SubView
    
    IBOutlet UIView *subView;
    
    
    NSMutableArray *arrSubcatagories;
    NSMutableArray *arrSubCatNames;
    NSMutableArray *arrSubCatIDs;
    
    int isTableShowing;
    
    NetworkUtills *netUtills;
    NSMutableArray *arrMerchantDetail;
    
    
    NSInteger endindex;
    NSInteger startindex;
    int currentCounter;
    
    UITapGestureRecognizer *tap;
    NSInteger merchantTag;
    WrapperClass *wrpr;
    
    IBOutlet UIView *topView;
    
    IBOutlet UISearchBar *searchBar;
    IBOutlet UIView *searchView;
    NSMutableArray *arrAllMerchantCopy;
    IBOutlet UIView *picView;
    IBOutlet UIPickerView *picker;
    
    
    IBOutlet UIView *viewBgPopup;
    IBOutlet UIView *viewSettingPopUp;
    IBOutlet UIButton *btnSttngSubmit;
    IBOutlet UIButton *btnRadio10Mile;
    IBOutlet UIButton *btnRadio20Mile;
    IBOutlet UIButton *btnRadio30Mile;

}
@property(nonatomic,strong)IBOutlet UILabel *lblTotalWalkin;
@property(nonatomic,strong)IBOutlet UILabel *lblPercentage;
@property(nonatomic,strong)NSString *catId;
@property(nonatomic,strong)IBOutlet UILabel *lblDListSubCatName;

@property(nonatomic,retain)IBOutlet UILabel *lblCouponMName;
@property(nonatomic,retain)IBOutlet UILabel *lblCouponMAddress;

@property(nonatomic,strong)NSMutableDictionary *mainDict;

- (IBAction)settingSubmitClicked:(id)sender;

-(IBAction)pickerDoneClicked:(id)sender;
-(IBAction)pickerCancelClicked:(id)sender;
@end
