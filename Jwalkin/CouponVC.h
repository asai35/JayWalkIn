//
//  CouponVC.h
//  Jwalkin
//
//  Created by Asai on 12/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkUtills.h"
#import "WrapperClass.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import <MediaPlayer/MediaPlayer.h>
#import "RemoteImageView.h"
#import "ZBarSDK.h"

@interface CouponVC : UIViewController<UIScrollViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate, ZBarReaderDelegate>
{
    IBOutlet UIPageControl *pgCtrl;
    
    int CurrentPage;
    int oldPageNumber;
    int ratingVal;
    int likeVal;
    int likeValBefore;
    float oldoffset_y;
    
    NetworkUtills *netUtills;
    WrapperClass *wrpr;
    MBProgressHUD *progressView;

    NSMutableDictionary *mainDict;
    NSMutableDictionary *dataDictionary;
    
    NSMutableArray *arrAllData;
    NSMutableArray *arrLikeLable;
    NSMutableArray *arrLikeValue;
    NSMutableArray *arrLikeBtn;
    
    UIView *view1;
    UIView *view2;
    UIView *view3;
    
    UIActivityIndicatorView *loading;

    UILabel *lblLike;
    IBOutlet UILabel *lblRate;
    
    IBOutlet UIImageView *imgVRateBig;
    IBOutlet UIImageView *imgVRateSmall;
    IBOutlet UIButton *btnCall;
    IBOutlet UIButton *btnFavBottom;
    IBOutlet UIButton *btnDirection;
    
    IBOutlet UIButton *btnRateRed;
    IBOutlet UIButton *btnRateYellow;
    IBOutlet UIButton *btnRateGreen;
    IBOutlet UIButton *btnLikeBillBoard;
    
    IBOutlet UILabel *lblBusinessHours;
    //Chanchal
    
    int imagecount;
    
     double totallength;
    double currentlength;
     NSMutableData *videoData;
    
    NSURL *urlOfImage;
    
    NSMutableArray *arrVideoUrl;
    int urlCount;
    
    IBOutlet UIView *viewPlayer;
    IBOutlet UIView *viewInfo;
    MPMoviePlayerController *moviePlayer;
    
    IBOutlet UIButton *btnOffer;
    IBOutlet UIButton *btn_back;

    IBOutlet UIImageView *imgViewBackImg;
    NSString *ImagLinkStr;
    IBOutlet UILabel *lblPreMerchant;
    IBOutlet UILabel *lblNextMerchant;
    IBOutlet UIView *viewPrev;
    IBOutlet UIView *viewNext;
    
    IBOutlet UIView *viewsubPunch;
    IBOutlet UIView *viewPunch;
    IBOutlet UITableView *tbl_punch;
    IBOutlet UILabel *lblPunchTitle;
    IBOutlet UIButton *btnPunch;
    IBOutlet UIImageView *viewpunchback;
    
    
    IBOutlet UIView *scanView;
    ZBarReaderViewController *reader;
    NSString *resultText;
    NSString *name;
    NSString *strOfferId;

}
- (IBAction)ActionBtnPunch:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;
-(IBAction)btnBackMediaPlayerClick:(id)sender;
-(IBAction)btnCommentClick:(id)sender;
-(IBAction)btnOfferClicked:(id)sender;
@property(nonatomic,strong)IBOutlet UIButton *btnDirection;
@property(nonatomic,strong)IBOutlet UIScrollView *scrlBG;
@property(nonatomic,strong)IBOutlet UIButton *btnInfo;
@property(nonatomic,strong)IBOutlet UIButton *btnFav;
@property(nonatomic,strong)IBOutlet UIScrollView *scrl;
@property(nonatomic,strong)NSString *strMName;
@property(nonatomic,strong)NSString *strMId;
@property(nonatomic, strong)NSMutableArray *arrTempMerchantDetail;
@property int tempMerchantTag;

@property(nonatomic,strong)IBOutlet UILabel *lblTotalWalkin;
@property(nonatomic,strong)IBOutlet UILabel *lblPercentage;
@property(nonatomic,strong)IBOutlet UILabel *lblCouponMName;
@property(nonatomic,strong)IBOutlet UILabel *lblCouponMAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnlink;
- (IBAction)BtnlinkClicked:(id)sender;
-(IBAction)ShowMeDirections:(id)sender;

@end
