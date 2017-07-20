//
//  CreateBillboardViewController.m
//  Jwalkin
//
//  Created by Asai on 4/16/17.
//  Copyright © 2017 fox. All rights reserved.
//

#import "CreateBillboardViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AFNetworking.h"
#import "UrlFile.h"
#import "Reachability.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "MBProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
#import <Social/Social.h>
#import "KGModal.h"
#import "SocialShareUIView.h"
#import "RegexKitLite.h"

@interface CreateBillboardViewController ()<FBSDKSharingDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate, UINavigationControllerDelegate>
{
    BOOL isCheckedType;
    NSString *billboardType;
    NSArray *arrExpDate;
    SocialShareUIView *socialShareModalView;
    UITapGestureRecognizer *tap;
    NSString *video_extension;
    //BOOL shareFB,shareTW, sharePT;
}
@property     PDKUser *user;
@property (copy, nonatomic) NSString *lastChosenMediaType;
@end

@implementation CreateBillboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isCheckedType = NO;
    video_extension = @"mp4";
    arrExpDate = [[NSArray alloc]initWithObjects:@"30",@"7",@"3",@"1" ,nil];
    socialShareModalView = [SocialShareUIView customView];
    [self setEdgesInsectForTextField:_txtTitle];
    whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    [_viewMedia.layer setBorderColor:UIColorFromRGB(0x1C7D65).CGColor];
    _viewMedia.layer.cornerRadius = 5;
    [_viewMedia.layer setBorderWidth:2];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self.view addGestureRecognizer:tap];
    [tap setNumberOfTapsRequired:1];
    [self.view setUserInteractionEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tapView:(UITapGestureRecognizer*)recognizer{
    [self.view endEditing:YES];
    [_txtTitle resignFirstResponder];
    [_textViewText resignFirstResponder];
    if(_txtTitle.text.length > 0){
        [_lsTitle setHidden:YES];
    }else{
        [_lsTitle setHidden:NO];
    }
    if(_textViewText.text.length > 0){
        [_lsText setHidden:YES];
    }else{
        [_lsText setHidden:NO];
    }
}

#pragma mark - PrivateMethod Implimentation

-(void)setEdgesInsectForTextField:(UITextField *)txt
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    txt.leftView = paddingView;
    txt.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark Validation
- (BOOL) validateUrl: (NSString *) candidate {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx]; 
    return [urlTest evaluateWithObject:candidate];
}

-(BOOL)checkValidPostData
{
    if ([_txtTitle.text stringByTrimmingCharactersInSet:whitespace].length == 0 || [[_txtTitle.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        [self showAlert:@"Alert" message:@"Please enter title." cancel:@"OK" other:nil];
        return NO;
    }
    else if([_textViewText.text stringByTrimmingCharactersInSet:whitespace].length == 0 || [[_textViewText.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        [self showAlert:@"Alert" message:@"Please enter description." cancel:@"OK" other:nil];
        return NO;
    }
    else if( !([billboardType isEqualToString:@"Website"]) && (UIImagePNGRepresentation(imageSelected) == nil && videoUrl == nil))
    {
        [self showAlert:@"Alert" message:@"Please select Image or Video." cancel:@"OK" other:nil];
        return NO;
    }
    else if(!isCheckedType)
    {
        [self showAlert:@"Alert" message:@"Please select category." cancel:@"OK" other:nil];
        return NO;
    }else if([billboardType isEqualToString:@"Website"]){
        NSArray *urls = [_textViewText.text componentsMatchedByRegex:@"http://[^\\s]*"];
        NSArray *urls1= [_textViewText.text componentsMatchedByRegex:@"https://[^\\s]*"];
        NSArray *urltext = [_textViewText.text componentsMatchedByRegex:@"[^\\s]*"];
        if(urls.count == 0 && urls1.count == 0 && urltext.count == 0){
            [self showAlert:@"Alert" message:@"Please valid website url." cancel:@"OK" other:nil];
            return NO;
        }
        [_lsTitle setHidden:YES];
        [_lsText setHidden:YES];
        [_lsType setHidden:YES];
        [_lsMedia setHidden:YES];
        return YES;
    }
    else
    {
        [_lsTitle setHidden:YES];
        [_lsText setHidden:YES];
        [_lsType setHidden:YES];
        [_lsMedia setHidden:YES];
        return YES;
    }
    return YES;
}


- (IBAction)ActionNews:(id)sender {
    [_btnNews setBackgroundColor:UIColorFromRGB(0xFF3300)];
    [_btnDeals setBackgroundColor:UIColorFromRGB(0x1C7D65)];
    [_btnEvent setBackgroundColor:UIColorFromRGB(0x1C7D65)];
    [_btnWebsite setBackgroundColor:UIColorFromRGB(0x1C7D65)];
    billboardType = @"News";
    isCheckedType = YES;
    [_imvPostImage setHidden:NO];
    [_webView setHidden:YES];
    [_lsType setHidden:YES];
}

- (IBAction)ActionDeal:(id)sender {
    [_btnNews setBackgroundColor:UIColorFromRGB(0x1C7D65)];
    [_btnDeals setBackgroundColor:UIColorFromRGB(0xFF3300)];
    [_btnEvent setBackgroundColor:UIColorFromRGB(0x1C7D65)];
    [_btnWebsite setBackgroundColor:UIColorFromRGB(0x1C7D65)];
    billboardType = @"Deal";
    isCheckedType = YES;
    [_imvPostImage setHidden:NO];
    [_webView setHidden:YES];
    [_lsType setHidden:YES];
}

- (IBAction)ActionEvent:(id)sender {
    [_btnNews setBackgroundColor:UIColorFromRGB(0x1C7D65)];
    [_btnDeals setBackgroundColor:UIColorFromRGB(0x1C7D65)];
    [_btnEvent setBackgroundColor:UIColorFromRGB(0xFF3300)];
    [_btnWebsite setBackgroundColor:UIColorFromRGB(0x1C7D65)];
    billboardType = @"Event";
    isCheckedType = YES;
    [_imvPostImage setHidden:NO];
    [_webView setHidden:YES];
    [_lsType setHidden:YES];
}

- (IBAction)ActionWebsite:(id)sender {
    [_btnNews setBackgroundColor:UIColorFromRGB(0x1C7D65)];
    [_btnDeals setBackgroundColor:UIColorFromRGB(0x1C7D65)];
    [_btnEvent setBackgroundColor:UIColorFromRGB(0x1C7D65)];
    [_btnWebsite setBackgroundColor:UIColorFromRGB(0xFF3300)];
    billboardType = @"Website";
    isCheckedType = YES;
    [_imvPostImage setHidden:YES];
    [_webView setHidden:NO];
    [_lsType setHidden:YES];
}

- (IBAction)ActionMedia:(id)sender {
    [_txtTitle resignFirstResponder];
    [_textViewText resignFirstResponder];
    if(_txtTitle.text.length > 0){
        [_lsTitle setHidden:YES];
    }else{
        [_lsTitle setHidden:NO];
    }
    if(_textViewText.text.length > 0){
        [_lsText setHidden:YES];
    }else{
        [_lsText setHidden:NO];
    }

    [self.view endEditing:YES];
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photolibrary = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        flagPicker = 1;
        picker.delegate = (id)self;
        picker.allowsEditing = YES;
        [[picker navigationBar]setTintColor:[UIColor whiteColor]];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    [alert addAction:photolibrary];
    UIAlertAction *videolibray = [UIAlertAction actionWithTitle:@"Video Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        flagPicker = 1;
        picker.delegate = (id)self;
        picker.allowsEditing = YES;
        [[picker navigationBar]setTintColor:[UIColor whiteColor]];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = @[(NSString *)kUTTypeMovie, (NSString *)kUTTypeMPEG4];
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    [alert addAction:videolibray];
    UIAlertAction *camera_photo = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        flagPicker = 1;
        picker.delegate = (id)self;
        picker.allowsEditing = YES;
        [[picker navigationBar]setTintColor:[UIColor whiteColor]];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    [alert addAction:camera_photo];
    UIAlertAction *camera_video = [UIAlertAction actionWithTitle:@"Take Video" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        flagPicker = 1;
        picker.delegate = (id)self;
        picker.allowsEditing = YES;
        [[picker navigationBar]setTintColor:[UIColor whiteColor]];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = @[(NSString *)kUTTypeMovie, (NSString *)kUTTypeMPEG4];
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    [alert addAction:camera_video];
    UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:^{
        }];
    }];
    [alert addAction:btn_cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark imagepicker delegate

#pragma mark - Image Picker Controller delegate methods


- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //Check whether an image or video was chosen
    self.lastChosenMediaType = info[UIImagePickerControllerMediaType];
    
    //If it's an image shrink it to our view
    if ([self.lastChosenMediaType isEqual:(NSString *)kUTTypeImage])
    {
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//        UIImage *shrunkenImage = [self shrinkImage:chosenImage toSize:self.imvPostImage.bounds.size];
        imageSelected = chosenImage;
        _imvPostImage.image = imageSelected;
        [_lsMedia setHidden:YES];
        
    }
    else if ([self.lastChosenMediaType isEqual:(NSString *)kUTTypeMovie])   //If it's a movie get the URL
    {
        videoUrl = info[UIImagePickerControllerMediaURL];
        NSString *lastPath = [videoUrl lastPathComponent];
        NSString *fileExtension = [lastPath pathExtension];
        if ([[fileExtension lowercaseString] isEqualToString:@"mov"]) {
            video_extension = @"mov";
        }else{
            video_extension = @"mp4";
        }
        AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:videoUrl options:nil];
        AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        generator.appliesPreferredTrackTransform=TRUE;
        
        CMTime thumbTime = CMTimeMakeWithSeconds(30,30);
        
        AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
            if (result != AVAssetImageGeneratorSucceeded)
            {
                // NSLog(@"couldn't generate thumbnail, error:%@", error);
            }
            thumbImg = [UIImage imageWithCGImage:im] ;
            _imvPostImage.image = thumbImg;
        };
        CGSize maxSize = CGSizeMake(128, 128);
        generator.maximumSize = maxSize;
        [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
        _imvPostImage.image = thumbImg;
        [_lsMedia setHidden:YES];
    }
    
    //dismiss the image/video picker
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

//If the picker is cancelled just dismiss it
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

//Both actions will call this method
-(void)pickMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediaTypes count] > 0)
    {
        //Get all media types to an array
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else
    {
        [self showAlert:@"Error accessing media" message:@"Device doesn't support that media source" cancel:@"Fine..." other:nil];
    }
}

//Shrink the image down to the size of the view in which we’re going to show it.
- (UIImage *)shrinkImage:(UIImage *)original toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [original drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return final;
}



- (void)updateDisplay
{
    //Check what the user selected
    if ([self.lastChosenMediaType isEqual:(NSString *)kUTTypeImage])
    {
        self.imvPostImage.image = imageSelected;
        
        //Hide the movie player controller (it's an image)
    }
    else if ([self.lastChosenMediaType isEqual:(NSString *)kUTTypeMovie])
    {
        //If it's a movie
//        [self.moviePlayerController.view removeFromSuperview];
//        
//        self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:self.movieURL];
//        
//        [self.moviePlayerController play];
//        
//        UIView *movieView = self.moviePlayerController.view;
//        movieView.frame = self.imageView.frame;
//        movieView.clipsToBounds = YES;
//        
//        [self.view addSubview:movieView];
//        self.imageView.hidden = YES;
        self.imvPostImage.image = thumbImg;

    }
}
#pragma mark TextFeild Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark TextView Delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView commitAnimations];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake( self.view.frame.origin.x,0 , self.view.frame.size.width,  self.view.frame.size.height);
    [UIView commitAnimations];
}



- (IBAction)ActionShare:(id)sender {
    [self showSocialShareModalView:nil];
}
- (IBAction)ActionExpireDays:(id)sender {
    
}

- (IBAction)ActionSubmit:(id)sender {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"" message:@"Please check your internet connection." cancel:@"OK" other:nil];
    }
    else
    {
        [_txtTitle resignFirstResponder];
        [_textViewText resignFirstResponder];
        if(_txtTitle.text.length > 0){
            [_lsTitle setHidden:YES];
        }else{
            [_lsTitle setHidden:NO];
        }
        if(_textViewText.text.length > 0){
            [_lsText setHidden:YES];
        }else{
            [_lsText setHidden:NO];
        }

        if ([self checkValidPostData])
        {
            if (imageSelected != nil) {
                NSDictionary *parameters;
                parameters =@{@"billboard_type": billboardType,
                              @"merchant_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"merchantid"],
                              @"title": _txtTitle.text,
                              @"exp_date":@"",
                              @"description":_textViewText.text
                              };
                
                
                [appdelegate() showHUD];
                NSMutableDictionary *parameter = [[NSMutableDictionary alloc] initWithDictionary:parameters];
                NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                NSString *imageName = [NSString stringWithFormat:@"image_%d.png",appdelegate().imageNo];
                NSString *filePath = [documentsDirectory stringByAppendingPathComponent:imageName];
                NSData *imageData = UIImagePNGRepresentation(imageSelected);
                [imageData writeToFile:filePath atomically:YES];
                [parameter setObject:@{@"data": imageData, @"name":imageName} forKey:@"image"];
                appdelegate().imageNo ++;
                
                [[JWNetWorkManager sharedManager] POST:@"addbill_board.php" data:parameter completion:^(id data, NSError *error) {
                    [appdelegate() hideHUD];
                    if (error) {
                        NSLog(@"Error: %@", error);
                    } else {
                        NSLog(@"%@ %@", error, data);
                        if ([[data valueForKey:@"status"] intValue]== 1)
                        {
                            if(socialShareModalView.switchFB.isOn){
                                
                                [self postImageToFB:imageData];
                            }
                            if(socialShareModalView.switchTW.isOn){
                                
                                [self shareTwitterImage:imageData];
                            }
                            if(socialShareModalView.switchPT.isOn){
                                
                                [self postImageToPT:[NSURL URLWithString:@""]];
                            }
                            if(socialShareModalView.switchIST.isOn){
                                
                                [self postImageToIST:imageData];
                            }
                            if(socialShareModalView.switchIN.isOn){
                                
                                [self postImageToIN:imageData];
                            }
                            if(socialShareModalView.switchGG.isOn){
                                
                                [self postImageToGG:imageData];
                            }
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Successfull" message:@"Your Billboard was created successfully." preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    [self.navigationController popViewControllerAnimated:YES];
                                }];
                                [alert addAction:btn_ok];
                            [self presentViewController:alert animated:YES completion:nil];
                        }
                        else
                        {
                            [self showAlert:@"Error" message:@"Please try again." cancel:@"OK" other:nil];
                        }
                    }
                }];
            }else{
                NSDictionary *parameters;
                parameters =@{@"billboard_type":billboardType ,
                              @"merchant_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"merchantid"],
                              @"title":_txtTitle.text,
                              @"exp_date":@"",
                              @"description":_textViewText.text
                              };
                NSMutableDictionary *parameter = [[NSMutableDictionary alloc] initWithDictionary:parameters];
                
                NSMutableArray *arrData = [[NSMutableArray alloc] init];
                NSMutableArray *arrFileName = [[NSMutableArray alloc]init];
                NSMutableArray *arrFileType = [[NSMutableArray alloc]init];
                NSData *videoData = [NSData dataWithContentsOfURL:videoUrl];
                if (videoData != nil)
                {
                    NSString *path = [NSString stringWithFormat:@"%@/Documents/video1_%d",NSHomeDirectory(),appdelegate().imageNo];
                    //NSString *videoName = [NSString stringWithFormat:@"video1_%d.mp4",app.imageNo];
                    [videoData writeToFile:path atomically:NO];
                    NSData *thumbnailData = UIImagePNGRepresentation(thumbImg);
                    [arrData addObject:videoData];
                    [arrData addObject:thumbnailData];
                    [arrFileName addObject:@"video_name"];
                    [arrFileName addObject:@"video_thumb"];
                    if ([video_extension isEqualToString:@"mov"]) {
                        [arrFileType addObject:@"video/quicktime"];
                    }else{
                        [arrFileType addObject:@"video/mp4"];
                    }
                    [arrFileType addObject:@"image/png"];
                    [parameter setObject:@{@"data":arrData, @"name": arrFileName, @"type":arrFileType} forKey:@"videos"];
                }
                
                [appdelegate() showHUD];
                [[JWNetWorkManager sharedManager] POST:@"addbill_board.php" data:parameter completion:^(id data, NSError *error) {
                    [appdelegate() hideHUD];
                    if (error) {
                        NSLog(@"Error: %@", error);
                    } else {
                        NSLog(@"%@ %@", error, data);
                        if ([[data valueForKey:@"status"] intValue]== 1)
                        {
                            if(socialShareModalView.switchFB.isOn){
                                
                                [self postImageToFB:arrData[0]];
                            }
                            if(socialShareModalView.switchTW.isOn){
                                
                                [self shareTwitterImage:arrData[0]];
                            }
                            if(socialShareModalView.switchPT.isOn){
                                
                                [self postImageToPT:[NSURL URLWithString:@""]];
                            }
                            if(socialShareModalView.switchIST.isOn){
                                
                                [self postImageToIST:arrData[0]];
                            }
                            if(socialShareModalView.switchIN.isOn){
                                
                                [self postImageToIN:arrData[0]];
                            }
                            if(socialShareModalView.switchGG.isOn){
                                
                                [self postImageToGG:arrData[0]];
                            }
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Successfull" message:@"Your Billboard was created successfully." preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
                            [alert addAction:btn_ok];
                            [self presentViewController:alert animated:YES completion:nil];
                        }
                        else
                        {
                            [self showAlert:@"Error" message:@"Please try again." cancel:@"OK" other:nil];
                        }
                    }
                }];
            }
            
        }
    }

}

- (IBAction)ActionCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ActionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showSocialShareModalView:(id)sender {
    
    [socialShareModalView.switchFB addTarget:self action:@selector(checkFBShare) forControlEvents:UIControlEventTouchUpInside];
    [socialShareModalView.switchTW addTarget:self action:@selector(checkTWShare) forControlEvents:UIControlEventTouchUpInside];
    [socialShareModalView.switchPT addTarget:self action:@selector(checkPTShare) forControlEvents:UIControlEventTouchUpInside];
    [socialShareModalView.switchGG addTarget:self action:@selector(checkGGShare) forControlEvents:UIControlEventTouchUpInside];
    [socialShareModalView.switchIN addTarget:self action:@selector(checkINShare) forControlEvents:UIControlEventTouchUpInside];
    [socialShareModalView.switchIST addTarget:self action:@selector(checkISTShare) forControlEvents:UIControlEventTouchUpInside];
    [[KGModal sharedInstance] setCloseButtonType:KGModalCloseButtonTypeNone];
    [[KGModal sharedInstance] showWithContentView:socialShareModalView];
}
- (void) checkTWShare {
    [[Twitter sharedInstance] logInWithViewController:self completion:^(TWTRSession *session, NSError *error) {
        if (!error) {
            //            [[[Twitter sharedInstance] APIClient] loadUserWithID:session.userID completion:^(TWTRUser *user, NSError *error) {
            //
            //                if (!error) {
            //                    TWTRShareEmailViewController *emailController = [[TWTRShareEmailViewController alloc] initWithCompletion:^(NSString *email, NSError *error) {
            //
            //                    }];
            //                    [self presentViewController:emailController animated:YES completion:nil];
            //                }
            //            }];
        } else {
            
        }
    }];
    
}
- (void)shareTwitterImage:(NSData *)image
{
    UIImage *postImage = [UIImage imageWithData:image];
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error)
     {
         if(granted)
         {
             NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
             
             if ([accountsArray count] > 0)
             {
                 ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                 
                 TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://upload.twitter.com/1/statuses/update_with_media.json"] parameters:[NSDictionary dictionaryWithObject:@"" forKey:@"status"] requestMethod:TWRequestMethodPOST];
                 
                 [postRequest addMultiPartData:UIImagePNGRepresentation(postImage) withName:@"media" type:@"multipart/png"];
                 
                 [postRequest setAccount:twitterAccount];
                 
                 [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      //show status after done
                      NSString *output = [NSString stringWithFormat:@"HTTP response status: %li", (long)[urlResponse statusCode]];
                      NSLog(@"Twiter post status : %@", output);
                  }];
             }
         }
     }];
}
- (void) checkPTShare {
    __weak typeof (self) weakSelf = self;
    [[PDKClient sharedInstance] authenticateWithPermissions:@[PDKClientReadPublicPermissions]
                                         fromViewController:self
                                                withSuccess:^(PDKResponseObject *responseObject)
     {
         weakSelf.user = [responseObject user];
         NSLog(@"%@", [NSString stringWithFormat:@"%@ authenticated!", weakSelf.user]);
     } andFailure:^(NSError *error) {
         NSLog(@"authentication failed!");
     }];
}
- (void) checkISTShare {
    //    __weak typeof (self) weakSelf = self;
    //    [[PDKClient sharedInstance] authenticateWithPermissions:@[PDKClientReadPublicPermissions]
    //                                         fromViewController:self
    //                                                withSuccess:^(PDKResponseObject *responseObject)
    //     {
    //         weakSelf.user = [responseObject user];
    //         NSLog(@"%@", [NSString stringWithFormat:@"%@ authenticated!", weakSelf.user]);
    //     } andFailure:^(NSError *error) {
    //         NSLog(@"authentication failed!");
    //     }];
}
- (void) checkGGShare {
    //    __weak typeof (self) weakSelf = self;
    //    [[PDKClient sharedInstance] authenticateWithPermissions:@[PDKClientReadPublicPermissions]
    //                                         fromViewController:self
    //                                                withSuccess:^(PDKResponseObject *responseObject)
    //     {
    //         weakSelf.user = [responseObject user];
    //         NSLog(@"%@", [NSString stringWithFormat:@"%@ authenticated!", weakSelf.user]);
    //     } andFailure:^(NSError *error) {
    //         NSLog(@"authentication failed!");
    //     }];
}
- (void) checkINShare {
    //    __weak typeof (self) weakSelf = self;
    //    [[PDKClient sharedInstance] authenticateWithPermissions:@[PDKClientReadPublicPermissions]
    //                                         fromViewController:self
    //                                                withSuccess:^(PDKResponseObject *responseObject)
    //     {
    //         weakSelf.user = [responseObject user];
    //         NSLog(@"%@", [NSString stringWithFormat:@"%@ authenticated!", weakSelf.user]);
    //     } andFailure:^(NSError *error) {
    //         NSLog(@"authentication failed!");
    //     }];
}
- (void)postImageToPT:(NSURL *)imageurl
{
    
    [PDKPin pinWithImageURL:imageurl
                       link:[NSURL URLWithString:@"https://www.pinterest.com"]
         suggestedBoardName:@"EmpowerMainStreet"
                       note:@"Empower Main Street"
         fromViewController:self
                withSuccess:^
     {
         NSLog(@"%@", [NSString stringWithFormat:@"successfully pinned pin"]);
     }
                 andFailure:^(NSError *error)
     {
         NSLog(@"pin it failed");
     }];
}

- (void) checkFBShare {
    
    if(socialShareModalView.switchFB.isOn){
        if([FBSDKAccessToken currentAccessToken]){
            NSLog(@"FBToken=>%@", [FBSDKAccessToken currentAccessToken]);
        }else {
            [self loginWithFb];
        }
        
    }
    
}
- (void)authenticateButtonTapped:(UIButton *)button
{
}
- (void)postImageToIST:(NSData *)imageurl
{
}
- (void)postImageToGG:(NSData *)imageurl
{
}
- (void)postImageToIN:(NSData *)imageurl
{
}

-(void)loginWithFb
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"" message:@"Please check your internet connection." cancel:@"OK" other:nil];
    }
    else
    {
        //NSString *strUserId =  [FBSDKAccessToken currentAccessToken].userID;
        //NSLog(@"Facebook user id %@",strUserId);
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        login.loginBehavior = FBSDKLoginBehaviorWeb;
        
        [login logInWithPublishPermissions:@[@"publish_actions"] fromViewController:self.view.window.rootViewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error)
            {
                [self showAlert:@"Error" message:@"Please try again." cancel:@"OK" other:nil];
            }
            else if (result.isCancelled)
            {
                [self showAlert:@"Error" message:@"Please try again." cancel:@"OK" other:nil];
            }
            else
            {
                if ([FBSDKAccessToken currentAccessToken])
                {
                    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                    [parameters setValue:@"id,name,email,gender" forKey:@"fields"];
                    
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
                     
                     
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                     {
                         if (!error)
                         {
                             NSLog(@"Facebook user id %@",[FBSDKAccessToken currentAccessToken]);
                         }
                     }];
                }
            }
        }];
    }
}

- (void)postImageToFB:(NSData *)imageData
{
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        
        //NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:3];
        
        UIImage *img = [UIImage imageWithData:imageData];
        //NSURL *imgURL = [NSURL URLWithString:imageURL];
        NSString *strTitle = _txtTitle.text;
        //NSString *strCatName =btnSubCategoryVideoVu.titleLabel.text;
        
        NSString *strMessage = [@"Title: " stringByAppendingString:strTitle];
        
        
        //FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
        //content.photos = @[[FBSDKSharePhoto photoWithImage:img userGenerated:YES] ];
        FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
        photo.image = img;
        photo.caption = strMessage;
        photo.userGenerated = YES;
        FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
        content.photos = @[photo];
        
        
        // Assuming self implements <FBSDKSharingDelegate>
        [FBSDKShareAPI shareWithContent:content delegate:self];
    }else{
        UIAlertController *alert = [[UIAlertController alloc] init];
        alert = [UIAlertController alertControllerWithTitle:@"Facebook Post" message:@"Missing Facebook Token!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:btn_ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}
#pragma Mark: FBSDKSharingDelegate

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    NSLog(@"FBShare==>%@",results);
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert = [UIAlertController alertControllerWithTitle:@"Success!" message:[@"Facebook Post ID = " stringByAppendingString:[results objectForKey:@"postId"]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:btn_ok];
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 Sent to the delegate when the sharer encounters an error.
 - Parameter sharer: The FBSDKSharing that completed.
 - Parameter error: The error.
 */
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    NSLog(@"FBShare==>%@",error);
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert = [UIAlertController alertControllerWithTitle:@"Error!" message:error.description preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:btn_ok];
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 Sent to the delegate when the sharer is cancelled.
 - Parameter sharer: The FBSDKSharing that completed.
 */
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    NSLog(@"FBShare==>%@",sharer);
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert = [UIAlertController alertControllerWithTitle:@"Warnning!" message:@"Something went wrong!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:btn_ok];
    [self presentViewController:alert animated:YES completion:nil];
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
