//
//  UpdateProfileViewController.m
//  Jwalkin
//
//  Created by Asai on 4/17/17.
//  Copyright © 2017 fox. All rights reserved.dropDown
//

#import "UpdateProfileViewController.h"
#import "AFNetworking.h"
#import "UrlFile.h"
#import "HomeVC.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
@interface UpdateProfileViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableDictionary *dictSubCatId;
    NSMutableDictionary *dictUserInfo;
    NSMutableArray *hoursArray;
    NSMutableArray *arr1, *arr2, *arr3;
    NSIndexPath *selectedIndex;
}

@end

@implementation UpdateProfileViewController
@synthesize imgviewDP,imgviewLogo;

- (void)viewDidLoad {
    [super viewDidLoad];
    strExpDate = @" ";
    strCardExpDate = @" ";
    mapView.showsUserLocation = YES;
    temoImageData = UIImagePNGRepresentation([UIImage imageNamed:@"img_add_photos"]);
    dictUserInfo = [[NSMutableDictionary alloc]init];
    btnUpdate.layer.cornerRadius = 5.0;
    hoursArray = [[NSMutableArray alloc] init];
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    scrollReg.contentSize  = CGSizeMake(self.view.frame.size.width,btnUpdate.frame.origin.y+btnUpdate.frame.size.height+25);
    // scrollReg.contentSize  = CGSizeMake(self.view.frame.size.width,btnUpdate.frame.origin.y+btnUpdate.frame.origin.y+btnUpdate.frame.size.height);
    arr1 = [[NSMutableArray alloc] initWithArray:@[@"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", @"Sun", @"Mon ~ Fri", @"Mon ~ Thu", @"Mon ~ Wed", @"Daily", @"by appointment"]];
     arr2 = [[NSMutableArray alloc] initWithArray:@[@"6:00 am", @"6:30 am", @"7:00 am", @"7:30 am", @"8:00 am", @"8:30 am", @"9:00 am", @"9:30 am", @"10:00 am", @"10:30 am", @"11:00 am", @"11:30 am", @"12:00 pm", @"12:30 pm", @"1:00 pm", @"1:30 pm", @"2:00 pm", @"2:30 pm", @"3:00 pm", @"3:30 pm", @"4:00 pm", @"4:30 pm", @"5:00 pm", @"5:30 pm", @"6:00 pm", @"6:30 pm", @"7:00 pm",@"7:30 pm", @"8:00 pm", @"8:30 pm", @"9:00 pm", @"9:30 pm", @"10:00 pm", @"10:30 pm", @"11:00 pm", @"11:30 pm", @"0:00 am", @"0:30 am", @"1:00 am", @"1:30 am", @"2:00 am", @"2:30 am", @"3:00 am", @"3:30 am", @"4:00 am", @"4:30 am", @"5:00 am", @"5:30 am"]];
    arr3 = [[NSMutableArray alloc] initWithArray:@[@"6:00 am", @"6:30 am", @"7:00 am", @"7:30 am", @"8:00 am", @"8:30 am", @"9:00 am", @"9:30 am", @"10:00 am", @"10:30 am", @"11:00 am", @"11:30 am", @"12:00 pm", @"12:30 pm", @"1:00 pm", @"1:30 pm", @"2:00 pm", @"2:30 pm", @"3:00 pm", @"3:30 pm", @"4:00 pm", @"4:30 pm", @"5:00 pm", @"5:30 pm", @"6:00 pm", @"6:30 pm", @"7:00 pm",@"7:30 pm", @"8:00 pm", @"8:30 pm", @"9:00 pm", @"9:30 pm", @"10:00 pm", @"10:30 pm", @"11:00 pm", @"11:30 pm", @"0:00 am", @"0:30 am", @"1:00 am", @"1:30 am", @"2:00 am", @"2:30 am", @"3:00 am", @"3:30 am", @"4:00 am", @"4:30 am", @"5:00 am", @"5:30 am"]];

    
    whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    UITapGestureRecognizer *gestureLogo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    gestureLogo.numberOfTapsRequired = 1;
    gestureLogo.delegate = self;
    [imgviewLogo addGestureRecognizer:gestureLogo];
    
    UITapGestureRecognizer *gestureImageDP = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    gestureImageDP.numberOfTapsRequired = 1;
    gestureImageDP.delegate = self;
    [imgviewDP addGestureRecognizer:gestureImageDP];
    
    UITapGestureRecognizer *gestureMap = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(mapGestureHandler:)];
    gestureMap.delegate = self;
    gestureMap.numberOfTapsRequired = 1;
    [mapView addGestureRecognizer:gestureMap];
    
    //    [self performSelectorInBackground:@selector(getState) withObject:nil];
    //    [self performSelectorInBackground:@selector(getCategary) withObject:nil];
    
    
    UITapGestureRecognizer *gestureView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    gestureView.numberOfTapsRequired = 1;
    
    [gestureView setNumberOfTouchesRequired:1];
    gestureView.delegate = self;
    
    //    [scrollReg addGestureRecognizer:gestureView];
    //pading in textfield //cp
    [self setEdgesInsectForTextField:tfName];
    [self setEdgesInsectForTextField:tfEmail];
    [self setEdgesInsectForTextField:tfPassword];
    [self setEdgesInsectForTextField:tfPhNO];
    [self setEdgesInsectForTextField:tfAdd1];
    [self setEdgesInsectForTextField:tfAdd2];
    [self setEdgesInsectForTextField:tfCity];
    [self setEdgesInsectForTextField:tfZipcode];
//    [self setEdgesInsectForTextField:tfPromoCode];
//    [self setEdgesInsectForTextField:tfBusinesshour];
//    [self setEdgesInsectForTextField:tfCreditCardNo];
//    [self setEdgesInsectForTextField:tfCreditcardType];
//    [self setEdgesInsectForTextField:tfCVVNo];
    [self setEdgesInsectForTextField:tfAverageRating];
    [self setEdgesInsectForTextField:tfFBLink];
    [self setEdgesInsectForTextField:tfWebLink];
    
    
    
    imgviewDP.layer.borderWidth=1.0;
    imgviewDP.layer.borderColor =[[UIColor lightGrayColor] CGColor];
    imgviewLogo.layer.borderWidth=1.0;
    imgviewLogo.layer.borderColor =[[UIColor lightGrayColor] CGColor];
//    [contentProView needsUpdateConstraints];
//    [contentProView setNeedsLayout];
    CGRect contentFrame = contentProView.frame;
    contentFrame.size.width = self.view.frame.size.width * 0.9 -1;
    contentFrame.origin.x = 0;
    contentFrame.origin.y = 0;
    contentProView.frame = contentFrame;
    [viewBusinessHours registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [viewBusinessHours registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    [viewBusinessHours setDelegate:(id)self];
    [viewBusinessHours setDataSource:(id)self];
    [scrollReg addSubview:contentProView];
    [self resizeScriollview];
    [self performSelectorInBackground:@selector(apiLoad) withObject:nil];
    [self loadData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [pickerHours selectRow:0 inComponent:0 animated:YES];
    [pickerHours reloadComponent:0];
    [pickerHours selectRow:0 inComponent:1 animated:YES];
    [pickerHours reloadComponent:1];
    [pickerHours selectRow:0 inComponent:2 animated:YES];
    [pickerHours reloadComponent:2];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self resizetableview];

}

- (void)resizetableview{
    int fy = 26 * (int)[hoursArray count];
    
    if ([hoursArray count] > 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CGRect rect = viewBusinessHours.frame;
            rect.size.height += fy;
            viewBusinessHours.frame = rect;
            [viewBusinessHours setNeedsLayout];
            
            CGRect f1 = lblrating.frame;
            f1.origin.y += fy;
            lblrating.frame = f1;
            
            CGRect f2 = lblweblink.frame;
            f2.origin.y += fy;
            lblweblink.frame = f2;
            
            CGRect f3 = lblfblink.frame;
            f3.origin.y += fy;
            lblfblink.frame = f3;
            
            CGRect f4 = lbllogo.frame;
            f4.origin.y += fy;
            lbllogo.frame = f4;
            
            CGRect f5 = lbldp.frame;
            f5.origin.y += fy;
            lbldp.frame = f5;
            
            CGRect f6 = lbllogostar.frame;
            f6.origin.y += fy;
            lbllogostar.frame = f6;
            
            CGRect f7 = tfAverageRating.frame;
            f7.origin.y += fy;
            tfAverageRating.frame = f7;
            
            CGRect f8 = tfWebLink.frame;
            f8.origin.y += fy;
            tfWebLink.frame = f8;
            
            CGRect f9 = tfFBLink.frame;
            f9.origin.y += fy;
            tfFBLink.frame = f9;
            
            CGRect f10 = imgviewLogo.frame;
            f10.origin.y += fy;
            imgviewLogo.frame = f10;
            
            CGRect f11 = imgviewDP.frame;
            f11.origin.y += fy;
            imgviewDP.frame = f11;
            
            CGRect f12 = btnUpdate.frame;
            f12.origin.y += fy;
            btnUpdate.frame = f12;
            
            [self resizeScriollview];

        });
    }

}
- (void)resizeScriollview{
    scrollReg.contentSize = CGSizeMake(contentProView.frame.size.width, btnUpdate.frame.origin.y + btnUpdate.frame.size.height + 20);
    [scrollReg needsUpdateConstraints];

}
-(void)loadData
{
    [app showHUD];
    dictUserInfo = [[NSUserDefaults standardUserDefaults]valueForKey:@"userInfo"];
    tfName.text = [dictUserInfo valueForKey:@"name"];
    tfEmail.text = [dictUserInfo valueForKey:@"email"];
    tfPassword.text = [dictUserInfo valueForKey:@"password"];
    tfPhNO.text = [dictUserInfo valueForKey:@"phoneno"];
    tfAdd1.text = [dictUserInfo valueForKey:@"address1"];
    tfAdd2.text = [dictUserInfo valueForKey:@"address2"];
    tfCity.text = [dictUserInfo valueForKey:@"city"];
    tfZipcode.text = [dictUserInfo valueForKey:@"zipcode"];
//    tfPromoCode.text = [dictUserInfo valueForKey:@"promo"];
    //    tfBusinesshour.text = [dictUserInfo valueForKey:@"business_hours"];
    //    tfCreditCardNo.text = [dictUserInfo valueForKey:@"creditcardnumber"];
    //    tfCreditcardType.text = [dictUserInfo valueForKey:@"creditcardtype"];
    //    tfCVVNo.text = [dictUserInfo valueForKey:@"cvvnumber"];
    tfAverageRating.text = [dictUserInfo valueForKey:@"average_rating"];
    tfWebLink.text = [dictUserInfo valueForKey:@"website"];
    tfFBLink.text =  [dictUserInfo valueForKey:@"fb_link"];
//    lblCardExp.text =[dictUserInfo valueForKey:@"crexpdate"];
    lblExpDate.text=[dictUserInfo valueForKey:@"expdate"];
    lblLatShow.hidden=NO;
    lblLongShow.hidden=NO;
    lblLatShow.text=[dictUserInfo valueForKey:@"latitute"];
    lblLongShow.text=[dictUserInfo valueForKey:@"longitute"];
    lblLatitute.text=[dictUserInfo valueForKey:@"latitute"];
    lblLongitute.text=[dictUserInfo valueForKey:@"longitute"];
    NSString *logoUrl =[dictUserInfo valueForKey:@"logo"];
    NSString *dpUrl =[dictUserInfo valueForKey:@"image"];
    imgviewLogo.imageURL = [NSURL URLWithString:logoUrl];
    imgviewDP.imageURL = [NSURL URLWithString:dpUrl];
    
    hoursArray = [[NSMutableArray alloc] init];
    NSString *hourstring = [dictUserInfo valueForKey:@"business_hours"];
    if (![hourstring isEqualToString:@" "] &&  ![hourstring isEqualToString:@""]) {
        NSArray *harr = [hourstring componentsSeparatedByString:@","];
        for (NSString *s in harr) {
            NSArray *sarr = [s componentsSeparatedByString:@"/"];
            NSDictionary *dd = @{@"week": sarr[0], @"start": sarr[1], @"end": sarr[2]};
            [hoursArray addObject:dd];
        }
    }
}

-(void)apiLoad
{
    [self getState];
    [self getCategary];
    int state = [[dictUserInfo valueForKey:@"state"] intValue];
    int cat =[[dictUserInfo valueForKey:@"category"] intValue];
    if (cat == 10)
    {
        cat=8;
    }
    int subCat = [[dictUserInfo valueForKey:@"subcategory"]intValue];
    if (arrState.count != 0)
    {
        [btnState setTitle:[arrState objectAtIndex:state-1] forState:UIControlStateNormal];
        app.selectedStateName =btnState.titleLabel.text;
        app.selectedState =state-1;
    }
    if (arrCategary.count != 0)
    {
        [btnCat setTitle:[arrCategary objectAtIndex:cat-1] forState:UIControlStateNormal];
        app.selectedCatName=btnCat.titleLabel.text;
        //        if (cat == 8)
        //        {
        //            cat = 10;
        //        }
        app.selectedCat=cat-1;
        NSLog(@"sohan 1  -- %d ",cat-1);
        for (int i =0; i<arrSubCatId.count; i++)
        {
            int subId = [[arrSubCatId objectAtIndex:i] intValue];
            if (subId == subCat)
            {
                [btnSubcat setTitle:[arrSubCat objectAtIndex:i] forState:UIControlStateNormal];
                if (btnSubcat.titleLabel.text.length != 0)
                {
                    app.selectedSubcatName=btnSubcat.titleLabel.text;
                    app.selectedSubCat=subCat;
                }
                break;
            }
        }
    }
    [app hideHUD];
}

#pragma Gesture delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:dropDown]||[touch.view isDescendantOfView:dropDown1]||[touch.view isDescendantOfView:dropDown2]||[touch.view isDescendantOfView:dropDown3])
    {
        return NO;
    }
    [self hideKeyboard];
    
    return YES;
}

#pragma mark- Button Action

-(IBAction)btnExpdateClick:(id)sender
{
    [self hideKeyboard];
    btnTemp = (UIButton *)sender;
    viewDatePicker.frame = self.view.frame;
    viewDatePicker.alpha = 0;
    [self.view addSubview:viewDatePicker];
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseIn  animations:^
     {
         viewDatePicker.alpha = 1;
     }
                     completion:nil];
    //UIViewAnimationOptionCurveLinear
    [UIView commitAnimations];
}

-(IBAction)btnLocationClick
{
    [self hideKeyboard];
    viewLocation.frame = self.view.frame;
    [self.view addSubview:viewLocation];
}

-(IBAction)btnCancelUpdate
{
    // [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark- Update

-(IBAction)btnUpdateClick
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"" message:@"Please ceck your internet connection." cancel:@"OK" other:nil];
    }
    else
    {
        if ([self validation])
        {
            
            NSMutableArray *imageArray = [[NSMutableArray alloc ]init];
            NSMutableArray *imageNameArray = [[NSMutableArray alloc]init];
            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *imageNameLogo = [NSString stringWithFormat:@"image_%d.png",app.imageNo];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:imageNameLogo];
            NSData *imageDataLogo = UIImagePNGRepresentation(imgviewLogo.image);
            [imageDataLogo writeToFile:filePath atomically:YES];
            app.imageNo ++;
            [imageArray addObject:imageDataLogo];
            [imageNameArray addObject:@"logo"];
            NSString *filePathDP;
            if(UIImagePNGRepresentation(imgviewDP.image) !=nil)
            {
                NSString *imageNameDP = [NSString stringWithFormat:@"image_%d.png",app.imageNo];
                filePathDP = [documentsDirectory stringByAppendingPathComponent:imageNameDP];
                NSData *imageDataDP = UIImagePNGRepresentation(imgviewDP.image);
                app.imageNo ++;
                [imageDataDP writeToFile:filePathDP atomically:YES];
                [imageArray addObject:imageDataDP];
                [imageNameArray addObject:@"image"];
            }
            [self setData];
            NSString *catId =[arrCatId objectAtIndex:app.selectedCat];
//            if ([catId isEqualToString:@"8"])
//            {
//                catId = @"10";
//            }
            
            NSString *strId = [dictUserInfo valueForKey:@"id"];
            NSString *hourstring = @"";
            for (NSDictionary *d in hoursArray) {
                if (hourstring.length == 0) {
                    hourstring = [NSString stringWithFormat:@"%@/%@/%@", d[@"week"], d[@"start"], d[@"end"]];
                }else{
                    hourstring = [NSString stringWithFormat:@"%@,%@/%@/%@", hourstring, d[@"week"], d[@"start"], d[@"end"]];
                }
            }
            if (hourstring.length == 0) {
                hourstring = @" ";
            }
            NSDictionary *par =[[NSDictionary alloc] init];
            par = @{ @"email": tfEmail.text,  @"name":tfName.text, @"password" :  tfPassword.text, @"address1": tfAdd1.text, @"address2": tfAdd2.text, @"city": tfCity.text, @"state": [arrStateId objectAtIndex:app.selectedState], @"country": @"USA", @"zipcode": tfZipcode.text, @"phoneno" : tfPhNO.text, @"category": catId, @"subcategory": [NSString stringWithFormat:@"%d", app.selectedSubCat], @"latitute":lblLatitute.text ,@"longitute":lblLongitute.text, @"expdate": @"2017-12-31", @"average_rating": tfAverageRating.text, @"website": tfWebLink.text, @"fb_link": tfFBLink.text, @"promo":@"", @"id": strId, @"business_hours": hourstring};
            
            NSLog(@"%@", par);
            NSMutableDictionary *parameters =[[NSMutableDictionary alloc] initWithDictionary:par];
            [parameters setObject:@{@"data":imageArray, @"name":imageNameArray} forKey:@"images"];
            [appdelegate() showHUD];
            [[JWNetWorkManager sharedManager] POST:@"updateMerchantProfile.php" data:parameters completion:^(id data, NSError *error) {
                [appdelegate() hideHUD];
                if (error) {
                    NSLog(@"Error: %@", error);
                } else {
                    NSLog(@"%@ %@", error, data);
                    if ([[data valueForKey:@"status"] intValue] != 0)
                    {
                        NSArray *arrData = [data valueForKey:@"data"];
                        NSDictionary *dictData =[arrData objectAtIndex:0];
                        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userInfo"];
                        [[NSUserDefaults standardUserDefaults]setObject:dictData forKey:@"userInfo"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        [[NSUserDefaults standardUserDefaults] setObject:@"registered" forKey:@"loggedin"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
  
                        UIAlertController *alert = [[UIAlertController alloc] init];
                        alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:@"Update successfully." preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *btn_OK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }];
                        [alert addAction:btn_OK];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    else if ([[data valueForKey:@"status"] intValue]== 0)
                    {
                        [self showAlert:@"" message:@"Sorry, try again." cancel:@"OK" other:nil];
                    }
                }
            }];
            
            
            
        }
    }
}

-(BOOL)validation
{
    if ([tfName.text stringByTrimmingCharactersInSet:whitespace].length == 0 && [[tfName.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        [self showAlert:@"Alert" message:@"Please enter your name." cancel:@"OK" other:nil];
        return NO;
    }
    else if ([tfEmail.text stringByTrimmingCharactersInSet:whitespace].length == 0 && [[tfEmail.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        [self showAlert:@"Alert" message:@"Please enter your email adrress." cancel:@"OK" other:nil];
        return NO;
    }
    else if ([tfPassword.text stringByTrimmingCharactersInSet:whitespace].length == 0 && [[tfPassword.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        [self showAlert:@"Alert" message:@"Please enter your valid phone number." cancel:@"OK" other:nil];
        return NO;
    }
    else if ([tfPhNO.text stringByTrimmingCharactersInSet:whitespace].length == 0 || [tfPhNO.text stringByTrimmingCharactersInSet:whitespace].length < 10  || [[tfPhNO.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        [self showAlert:@"Alert" message:@"Please enter your valid phone number." cancel:@"OK" other:nil];
        return NO;
    }
    else if ([tfAdd1.text stringByTrimmingCharactersInSet:whitespace].length == 0 && [[tfAdd1.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""] )
    {
        [self showAlert:@"Alert" message:@"Please enter your first address." cancel:@"OK" other:nil];
        return NO;
    }
    else if ([app.selectedStateName stringByTrimmingCharactersInSet:whitespace].length == 0 && [[app.selectedStateName stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        [self showAlert:@"Alert" message:@"Please select state." cancel:@"OK" other:nil];
        return NO;
    }
    else if ([app.selectedCatName stringByTrimmingCharactersInSet:whitespace].length == 0 && [[app.selectedCatName stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        [self showAlert:@"Alert" message:@"Please select catagory." cancel:@"OK" other:nil];
        return NO;
    }
    else if ([app.selectedSubcatName stringByTrimmingCharactersInSet:whitespace].length == 0 && [[app.selectedSubcatName stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        [self showAlert:@"Alert" message:@"Please select sub-catagory." cancel:@"OK" other:nil];
        return NO;
    }
    else if ([lblLatitute.text stringByTrimmingCharactersInSet:whitespace].length == 0 && [[lblLatitute.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""] )
    {
        [self showAlert:@"Alert" message:@"Please select your location." cancel:@"OK" other:nil];
        return NO;
    }
    else if(UIImagePNGRepresentation(imgviewLogo.image)  == nil)
    {
        [self showAlert:@"Alert" message:@"Please select logo." cancel:@"OK" other:nil];
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)setData
{
    if ([tfAdd2.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
    {
        tfAdd2.text = @" ";
    }
    if ([tfCity.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
    {
        tfCity.text = @" ";
    }
    if ([tfZipcode.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
    {
        tfZipcode.text = @" ";
    }
//    if ([tfPromoCode.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
//    {
//        tfPromoCode.text = @" ";
//    }
//    if ([tfBusinesshour.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
//    {
//        tfBusinesshour.text = @" ";
//    }
//    if ([tfCreditCardNo.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
//    {
//        tfCreditCardNo.text = @" ";
//    }
//    if ([tfCreditcardType.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
//    {
//        tfCreditcardType.text = @" ";
//    }
//    if ([tfCVVNo.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
//    {
//        tfCVVNo.text = @" ";
//    }
    if ([tfAverageRating.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
    {
        tfAverageRating.text = @" ";
    }
    if ([tfFBLink.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
    {
        tfFBLink.text = @" ";
    }
    if ([tfWebLink.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
    {
        tfWebLink.text = @" ";
    }
    if ([lblLatitute.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
    {
        lblLatitute.text = @" ";
    }
    if ([lblLongitute.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
    {
        lblLongitute.text = @" ";
    }
}

#pragma mark- Gesture method

-(void)imageTapped:(UITapGestureRecognizer  *)gesture
{
    [self hideKeyboard];
    tempImgview =(UIImageView *) gesture.view;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [[picker navigationBar]setTintColor:[UIColor whiteColor]];
    [[picker navigationBar]setBarTintColor:[UIColor colorWithRed:(23/255.0) green:(127/255.0) blue:(101/255.0) alpha:1.0]];
    picker.allowsEditing = YES;
    UIAlertController *actionsheet = [[UIAlertController alloc] init];
    actionsheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *btn_photolibrary = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];

    }];
    [actionsheet addAction:btn_photolibrary];
    UIAlertAction *btn_camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    [actionsheet addAction:btn_camera];
    UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [actionsheet dismissViewControllerAnimated:YES completion:nil];
    }];
    [actionsheet addAction:btn_cancel];
    [self presentViewController:actionsheet animated:YES completion:nil];
}

#pragma mark- imagepicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image =info[UIImagePickerControllerOriginalImage];
    self.tempImg =[[RemoteImageView alloc]init];
    self.tempImg.image = image;
    image =[self imageWithImage:self.tempImg.image scaledToSize:CGSizeMake(90, 90)];
    [picker dismissViewControllerAnimated:YES completion:
     ^{
         tempImgview.image = image;
     }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark- Date View Methods

-(IBAction)btnPickerCancel
{
    [viewDatePicker removeFromSuperview];
}

-(IBAction)btnPickerDone
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString * strExpDateSel = [dateFormatter stringFromDate:datePicker.date];
    if (btnTemp.tag == 1)
    {
        strExpDate = strExpDateSel;
        lblExpDate.hidden = NO;
        lblExpDate.text = strExpDateSel;
    }
    else
    {
        strCardExpDate = strExpDateSel;
        lblExpDate.hidden = NO;
        lblExpDate.text = strExpDateSel;
//        lblCardExp.hidden = NO;
//        lblCardExp.text = strExpDateSel;
    }
    [viewDatePicker removeFromSuperview];
}

#pragma mark- DropDown Action

-(IBAction)btnStateClick:(id)sender
{
    [self hideKeyboard];
    if(dropDown2)
    {
        [dropDown2 hideDropDown:btnCat];
        dropDown2 = nil;
    }
    if (dropDown3)
    {
        [dropDown3 hideDropDown:btnSubcat];
        dropDown3 = nil;
    }
    UIButton *btnSt = (UIButton *)sender;
    CGFloat  f = 150;
    if(dropDown1 == nil)
    {
        dropDown1 = [[NIDropDown alloc] showDropDown:btnSt height:&f arr:arrState imgArr:nil direction:@"down"];
        dropDown1.delegate=self;
        dropDown1.tag=101;
    }
    else
    {
        [dropDown1 hideDropDown:btnSt];
        dropDown1 = nil;
    }
}

-(IBAction)btnCatClick:(id)sender
{
    [self hideKeyboard];
    if(dropDown1)
    {
        [dropDown1 hideDropDown:btnState];
        dropDown1 = nil;
    }
    if (dropDown3)
    {
        [dropDown3 hideDropDown:btnSubcat];
        dropDown3 = nil;
    }
    UIButton *btnCt = (UIButton *)sender;
    CGFloat f = 150;
    if(dropDown2 == nil)
    {
        dropDown2 =[[NIDropDown alloc]showDropDown:btnCt height:&f arr:arrCategary imgArr:nil direction:@"down"];
        dropDown2.delegate=self;
        dropDown2.tag=102;
    }
    else
    {
        [dropDown2 hideDropDown:btnCt];
        dropDown2 = nil;
    }
}

-(IBAction)btnSubcatClick:(id)sender
{
    [self hideKeyboard];
    if(dropDown2)
    {
        [dropDown2 hideDropDown:btnCat];
        dropDown2 = nil;
    }
    if (dropDown1)
    {
        [dropDown1 hideDropDown:btnState];
        dropDown1 = nil;
    }
    UIButton *btnSCat = (UIButton *)sender;
    CGFloat f = 150;
    NSMutableArray *arrTemp = [dictSubcategory valueForKey:app.selectedCatName];
    if(dropDown3 == nil)
    {
        dropDown3 = [[NIDropDown alloc] showDropDown:btnSCat height:&f arr:arrTemp imgArr:nil direction:@"down"];
        dropDown3.delegate=self;
        dropDown3.tag=103;
    }
    else
    {
        [dropDown3 hideDropDown:btnSCat];
        dropDown3 = nil;
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender
{
    if (sender.tag==101)
    {
        dropDown1=nil;
    }
    if (sender.tag ==102)
    {
        dropDown2=nil;
        [btnSubcat setTitle:@"" forState:UIControlStateNormal];
    }
    if (sender.tag ==103)
    {
//        NSDictionary *dictCat=[arrMain objectAtIndex:app.selectedCat];
//        NSArray *subCat =[dictCat valueForKey:@"subcategory_info"];
//        app.selectedSubCat=[[[subCat objectAtIndex:app.selectedSubCat] objectForKey:@"subcategoryid"] intValue];
        dropDown3=nil;
    }
}

#pragma mark- Map View methods

-(IBAction)btnSearchLocation
{
    [tfSearchMap resignFirstResponder];
    if ([tfSearchMap.text stringByTrimmingCharactersInSet:whitespace].length == 0 && [[tfSearchMap.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        [self showAlert:@"" message:@"Please enter place name to search." cancel:@"OK" other:nil];
    }
    else
    {
        NSString *address = tfSearchMap.text;
        NSString *url = [[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@",address] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSURL *jsonURl=[NSURL URLWithString:url];
        NSData *data=[NSData dataWithContentsOfURL:jsonURl];
        NSError *error=nil;
        id response=[NSJSONSerialization JSONObjectWithData:data options:
                     NSJSONReadingMutableContainers error:&error];
        dictLocation = (NSDictionary *)response;
        if ([[dictLocation valueForKey:@"status" ] isEqualToString:@"OK"])
        {
            NSArray *arrData =[dictLocation valueForKey:@"results" ];
            NSDictionary *dictInArray = [arrData objectAtIndex:0];
            NSDictionary *dictGeo = [dictInArray valueForKey:@"geometry" ];
            NSDictionary *dictLoc = [dictGeo valueForKey:@"location"];
            NSString *strLat = [[dictLoc valueForKey:@"lat"] stringValue];
            NSString *strLong =[[dictLoc valueForKey:@"lng"] stringValue];
            [lblLatitute setText:strLat];
            [lblLongitute setText:strLong];
            CLLocationCoordinate2D location;
            location.latitude = [strLat doubleValue];
            location.longitude = [strLong doubleValue];
            MKCoordinateRegion mapRegion;
            mapRegion.center = mapView.userLocation.coordinate;
            mapRegion.span.latitudeDelta = 0.05;
            mapRegion.span.longitudeDelta = 0.05;
            [mapView setCenterCoordinate:mapRegion.center animated:YES];
            MKCoordinateSpan span =
            { .longitudeDelta = mapView.region.span.longitudeDelta / 2,
                .latitudeDelta  = mapView.region.span.latitudeDelta  / 2 };
            // Create a new MKMapRegion with the new span, using the center we want.
            MKCoordinateRegion region = { .center = location, .span = span };
            [mapView setRegion:region animated:YES];
            CLLocationCoordinate2D annotationCoord;
            annotationCoord.latitude = [strLat floatValue];
            annotationCoord.longitude = [strLong floatValue];
            MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
            annotationPoint.coordinate = annotationCoord;
            annotationPoint.title = tfSearchMap.text;
            [mapView addAnnotation:annotationPoint];
        }
        else
        {
            [self showAlert:@"" message:@"Location not found." cancel:@"OK" other:nil];
        }
    }
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer
                         :(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)mapGestureHandler:(UITapGestureRecognizer *)gestureMap
{
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    CGPoint touchPoint = [gestureMap locationInView:mapView];
    CLLocationCoordinate2D touchMapCoordinate = [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
    NSString *strLat = [NSString stringWithFormat:@"%f", touchMapCoordinate.latitude ];
    NSString *strLong = [NSString stringWithFormat:@"%f",touchMapCoordinate.longitude];
    CLLocationCoordinate2D annotationCoord;
    annotationCoord.latitude = [strLat floatValue];
    annotationCoord.longitude = [strLong floatValue];
    annotationPoint.coordinate = annotationCoord;
    NSArray *existingpoints = mapView.annotations;
    if ([existingpoints count])
    {
        [mapView removeAnnotations:existingpoints];
    }
    [mapView addAnnotation:annotationPoint];
    [tfSearchMap setText:@""];
    [lblLatitute setText:strLat];
    [lblLongitute setText:strLong];
}

-(IBAction)btnAddLocation
{
    lblLongShow.text = lblLongitute.text;
    lblLongShow.hidden = NO;
    lblLatShow.text =lblLatitute.text;
    lblLatShow.hidden = NO;
    [viewLocation removeFromSuperview];
}

#pragma mark- TextFeild Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    
    scrollReg.contentInset =  UIEdgeInsetsMake(0, 0,216+50, 0);
    [scrollReg scrollRectToVisible:textField.frame animated:NO];
    
    
    if(dropDown1)
    {
        [dropDown1 hideDropDown:btnState];
        dropDown1 = nil;
    }
    if (dropDown3)
    {
        [dropDown3 hideDropDown:btnSubcat];
        dropDown3 = nil;
    }
    if(dropDown2)
    {
        [dropDown2 hideDropDown:btnCat];
        dropDown2 = nil;
    }
    if(textField.tag > 14)
    {
        //Given size may not account for screen rotation
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationBeginsFromCurrentState:YES];
        //        self.view.frame = CGRectMake(self.view.frame.origin.x,-160,self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    return YES;return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(self.view.frame.origin.x,0 ,self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [scrollReg setContentInset:  UIEdgeInsetsMake(0, 0,0, 0)];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == tfPhNO)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        if(newLength > 10)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return YES;
    }
}

#pragma mark- API Call

-(void)getState
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"" message:@"Please check your internet connection." cancel:@"OK" other:nil];
    }
    else
    {
        arrState = [[NSMutableArray alloc] init];
        arrStateId = [[NSMutableArray alloc]init];
        NSURL *jsonURl=[NSURL URLWithString:GetState];
        NSData *data=[NSData dataWithContentsOfURL:jsonURl];
        NSError *error=nil;
        id response=[NSJSONSerialization JSONObjectWithData:data options:
                     NSJSONReadingMutableContainers error:&error];
        NSArray *arrStateResponse = (NSArray *)response;
        for (int i = 0;i< arrStateResponse.count; i++)
        {
            dictResultState = [arrStateResponse objectAtIndex:i];
            NSString *strState = [dictResultState valueForKey:@"state_name"];
            NSString *strStateId = [dictResultState valueForKey:@"state_id"];
            [arrState addObject:strState ];
            [arrStateId addObject:strStateId];
        }
    }
}

-(void)getCategary
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"" message:@"Please check your internet connection." cancel:@"OK" other:nil];
    }
    else
    {
        
        NSURL *jsonURl=[NSURL URLWithString:GetCategory];
        NSData *data=[NSData dataWithContentsOfURL:jsonURl];
        NSError *error=nil;
        id response=[NSJSONSerialization JSONObjectWithData:data options:
                     NSJSONReadingMutableContainers error:&error];
        NSArray *arrCat = (NSArray *)response;
        arrMain = [arrCat mutableCopy];
        dictSubcategory = [[NSMutableDictionary alloc] init];
        arrCategary = [[NSMutableArray alloc] init];
        arrCatId = [[NSMutableArray alloc] init];
        arrSubCatId = [[NSMutableArray alloc] init];
        arrSubCat = [[NSMutableArray alloc]init];
        for (int i = 0;i< arrCat.count; i++)
        {
            dictResultCat = [arrCat objectAtIndex:i];
            NSString *strCategary = [dictResultCat valueForKey:@"category_name"];
            NSString *strCategoryId = [dictResultCat valueForKey:@"categoryid"];
            NSArray *subCat =[dictResultCat valueForKey:@"subcategory_info"];
            [arrCatId addObject:strCategoryId];
            if (![strCategary isEqualToString:@"Financial, Legal, & Devel" ] )
            {
                if (![strCategary isEqualToString:@"Home & Garden"])
                {
                    [arrCategary addObject:strCategary];
                }
            }
            NSMutableArray *subCatArr = [[NSMutableArray alloc] init];
            for (
                 
                 
                 
                 
                 
                 
                 
                 int j=0;j<subCat.count;j++)
            {
                NSDictionary *subcat = [subCat objectAtIndex:j];
                NSString *str = [subcat valueForKey:@"subcategory"];
                NSString *strId = [subcat valueForKey:@"subcategoryid"];
                [subCatArr addObject:str];
                [arrSubCatId addObject:strId];
                [arrSubCat addObject:str];
            }
            [dictSubcategory setValue:subCatArr forKey:strCategary];
        }
    }
}

#pragma mark- Touch method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView * txt in self.view.subviews)
    {
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder])
        {
            [txt resignFirstResponder];
        }
    }
    [self hideKeyboard];
}

-(void)viewTapped:(UITapGestureRecognizer  *)gesture
{
    [self hideKeyboard];
}

-(void)hideKeyboard
{
    
    [self.view endEditing:YES];
    
    [tfAdd1 resignFirstResponder];
    [tfAdd2 resignFirstResponder];
    [tfName resignFirstResponder];
    [tfEmail resignFirstResponder];
    [tfPassword resignFirstResponder];
    [tfPhNO resignFirstResponder];
//    [tfPromoCode resignFirstResponder];
    [tfSearchMap resignFirstResponder];
    [tfZipcode resignFirstResponder];
//    [tfData resignFirstResponder];
//    [tfCVVNo resignFirstResponder];
//    [tfCreditCardNo resignFirstResponder];
//    [tfCreditcardType resignFirstResponder];
//    [tfAmount resignFirstResponder];
    [tfAverageRating resignFirstResponder];
    [tfWebLink resignFirstResponder];
    [tfFBLink resignFirstResponder];
//    [tfBusinesshour resignFirstResponder];
    
    [scrollReg setContentInset:  UIEdgeInsetsMake(0, 0,0, 0)];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PrivateMethod Implimentation

-(void)setEdgesInsectForTextField:(UITextField *)txt
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    txt.leftView = paddingView;
    txt.leftViewMode = UITextFieldViewModeAlways;
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

- (IBAction)ActionAddBusinessHours:(id)sender {
    
    int fy = 26;
    CGRect f1 = lblrating.frame;
    f1.origin.y += fy;
    lblrating.frame = f1;
    
    CGRect f2 = lblweblink.frame;
    f2.origin.y += fy;
    lblweblink.frame = f2;
    
    CGRect f3 = lblfblink.frame;
    f3.origin.y += fy;
    lblfblink.frame = f3;
    
    CGRect f4 = lbllogo.frame;
    f4.origin.y += fy;
    lbllogo.frame = f4;
    
    CGRect f5 = lbldp.frame;
    f5.origin.y += fy;
    lbldp.frame = f5;
    
    CGRect f6 = lbllogostar.frame;
    f6.origin.y += fy;
    lbllogostar.frame = f6;
    
    CGRect f7 = tfAverageRating.frame;
    f7.origin.y += fy;
    tfAverageRating.frame = f7;
    
    CGRect f8 = tfWebLink.frame;
    f8.origin.y += fy;
    tfWebLink.frame = f8;
    
    CGRect f9 = tfFBLink.frame;
    f9.origin.y += fy;
    tfFBLink.frame = f9;
    
    CGRect f10 = imgviewLogo.frame;
    f10.origin.y += fy;
    imgviewLogo.frame = f10;
    
    CGRect f11 = imgviewDP.frame;
    f11.origin.y += fy;
    imgviewDP.frame = f11;
    
    CGRect f12 = btnUpdate.frame;
    f12.origin.y += fy;
    btnUpdate.frame = f12;
    
    [self resizeScriollview];
    [hoursArray addObject:@{@"week": @"Mon", @"start": @"8:00 am", @"end": @"5:00 pm"}];
    
    CGRect rect = viewBusinessHours.frame;
    rect.size.height += 26;
    viewBusinessHours.frame = rect;
    [viewBusinessHours reloadData];
    
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != [hoursArray count]) {
        selectedIndex = indexPath;
        [self dropHour:nil];
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
}

-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [hoursArray count]) {
        static NSString *CellIdentifier1 = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
        UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 15, 150, 15)];
        [addBtn.titleLabel setTextColor:UIColorFromRGB(0x28bedd)];
        [addBtn setTitle:@"+ Add another set hours" forState:UIControlStateNormal];
        [addBtn setTitleColor:UIColorFromRGB(0x28bedd) forState:UIControlStateNormal];
        [addBtn.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [addBtn addTarget:self action:@selector(ActionAddBusinessHours:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:addBtn];
        return cell;
    }else{
        static NSString *CellIdentifier = @"cell1";
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UITextField *txtWeekDay = [cell viewWithTag:301];
        UITextField *txtStart = [cell viewWithTag:302];
        UITextField *txtEnd = [cell viewWithTag:303];
        UILabel *line = [cell viewWithTag:304];
        UIButton *closeBtn = [cell viewWithTag:305];
        int w = cell.frame.size.width;
        int h = cell.frame.size.height;
        if (txtWeekDay == nil) {
            txtWeekDay = [[UITextField alloc] initWithFrame:CGRectMake(2, h * 0.2, w - h - 15 - w * 0.5, h * 0.6)];
            [txtWeekDay setTag:301];
            [txtWeekDay setBorderStyle:UITextBorderStyleLine];
            [txtWeekDay setFont:[UIFont systemFontOfSize:8.0]];
            [txtWeekDay setTextAlignment:NSTextAlignmentCenter];
            [txtWeekDay setAdjustsFontSizeToFitWidth:YES];
            [txtWeekDay setMinimumFontSize:6.0];
            [txtWeekDay setUserInteractionEnabled:NO];
            [cell addSubview:txtWeekDay];
        }
        if (txtStart == nil) {
            txtStart = [[UITextField alloc] initWithFrame:CGRectMake(w - h - 9 - w * 0.5, h * 0.2, w * 0.25, h * 0.6)];
            [txtStart setTag:302];
            [txtStart setBorderStyle:UITextBorderStyleLine];
            [txtStart setFont:[UIFont systemFontOfSize:8.0]];
            [txtStart setTextAlignment:NSTextAlignmentCenter];
            [txtStart setAdjustsFontSizeToFitWidth:YES];
            [txtStart setUserInteractionEnabled:NO];
            [txtStart setMinimumFontSize:6.0];
            [cell addSubview:txtStart];
        }
        if (txtEnd == nil) {
            txtEnd = [[UITextField alloc] initWithFrame:CGRectMake(w - h - w * 0.25, h * 0.2, w * 0.25, h * 0.6)];
            [txtEnd setTag:303];
            [txtEnd setBorderStyle:UITextBorderStyleLine];
            [txtEnd setFont:[UIFont systemFontOfSize:8.0]];
            [txtEnd setTextAlignment:NSTextAlignmentCenter];
            [txtEnd setAdjustsFontSizeToFitWidth:YES];
            [txtEnd setMinimumFontSize:6.0];
            [txtEnd setUserInteractionEnabled:NO];
            [cell addSubview:txtEnd];
        }
        if (line == nil) {
            line = [[UILabel alloc] initWithFrame:CGRectMake(w - h - 7 - w * 0.25, h * 0.25, 5, h * 0.6)];
            [line setTextColor: UIColorFromRGB(0x000000)];
            [line setFont:[UIFont systemFontOfSize:8.0]];
            [line setTag:304];
            [cell addSubview:line];
        }
        if (closeBtn == nil) {
            closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(w - h * 0.8, h * 0.2, h * 0.6, h * 0.6)];
            [closeBtn setTag:305 + indexPath.row];
//            [closeBtn setImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
            [closeBtn setTitle:@"X" forState:UIControlStateNormal];
            [closeBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
            [closeBtn setTintColor:UIColorFromRGB(0x000000)];
            [cell addSubview:closeBtn];
        }
        [txtWeekDay setText:[hoursArray objectAtIndex:indexPath.row][@"week"]];
        [txtStart setText:[hoursArray objectAtIndex:indexPath.row][@"start"]];
        [txtEnd setText:[hoursArray objectAtIndex:indexPath.row][@"end"]];
        [line setText:@"-"];
        [closeBtn addTarget:self action:@selector(deletecell:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [hoursArray count] + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [hoursArray count]) {
        return  30;
    }
    return 26;
    
}

-(void)deletecell:(id)sender{
    UIButton *button = (UIButton *)sender;
    [hoursArray removeObjectAtIndex:(button.tag - 305)];
    
    int fy = 26;
    CGRect f1 = lblrating.frame;
    f1.origin.y -= fy;
    lblrating.frame = f1;
    
    CGRect f2 = lblweblink.frame;
    f2.origin.y -= fy;
    lblweblink.frame = f2;
    
    CGRect f3 = lblfblink.frame;
    f3.origin.y -= fy;
    lblfblink.frame = f3;
    
    CGRect f4 = lbllogo.frame;
    f4.origin.y -= fy;
    lbllogo.frame = f4;
    
    CGRect f5 = lbldp.frame;
    f5.origin.y -= fy;
    lbldp.frame = f5;
    
    CGRect f6 = lbllogostar.frame;
    f6.origin.y -= fy;
    lbllogostar.frame = f6;
    
    CGRect f7 = tfAverageRating.frame;
    f7.origin.y -= fy;
    tfAverageRating.frame = f7;
    
    CGRect f8 = tfWebLink.frame;
    f8.origin.y -= fy;
    tfWebLink.frame = f8;
    
    CGRect f9 = tfFBLink.frame;
    f9.origin.y -= fy;
    tfFBLink.frame = f9;
    
    CGRect f10 = imgviewLogo.frame;
    f10.origin.y -= fy;
    imgviewLogo.frame = f10;
    
    CGRect f11 = imgviewDP.frame;
    f11.origin.y -= fy;
    imgviewDP.frame = f11;
    
    CGRect f12 = btnUpdate.frame;
    f12.origin.y -= fy;
    btnUpdate.frame = f12;
    
    [self resizeScriollview];
    
    CGRect rect = viewBusinessHours.frame;
    rect.size.height -= 26;
    viewBusinessHours.frame = rect;
    [viewBusinessHours reloadData];

    
}
- (void)dropHour:(id)sender{
    [self hideKeyboard];
    [self PickerClicked:nil];

}
- (IBAction)ActionHourCancelBtn:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        viewHoursPicker.frame = CGRectMake(self.view.frame.origin.x, 580, self.view.frame.size.width, self.view.frame.size.height+15);

    } completion:^(BOOL finished) {
        [viewHoursPicker removeFromSuperview];
    }];
    
}

- (IBAction)ActionHourDoneBtn:(id)sender {
    NSDictionary *dict = @{@"week":[arr1 objectAtIndex:[pickerHours selectedRowInComponent:0]] , @"start":[arr2 objectAtIndex:[pickerHours selectedRowInComponent:1]], @"end":[arr3 objectAtIndex:[pickerHours selectedRowInComponent:2]]};
    [hoursArray replaceObjectAtIndex:selectedIndex.row withObject:dict];
    [viewBusinessHours reloadData];
    [UIView animateWithDuration:0.5 animations:^{
        viewHoursPicker.frame = CGRectMake(self.view.frame.origin.x, 580, self.view.frame.size.width, self.view.frame.size.height+15);
    } completion:^(BOOL finished) {
        [viewHoursPicker removeFromSuperview];
    }];
}

#pragma mark - picker view delegates- Select the subcategories

-(IBAction)PickerClicked:(id)sender
{
    if ([UIScreen mainScreen].bounds.size.height > 500)
    {
        viewHoursPicker.frame = CGRectMake(self.view.frame.origin.x, 580, self.view.frame.size.width, self.view.frame.size.height+15);
        [self.view addSubview:viewHoursPicker];
        
        [UIView animateWithDuration:0.5 animations:^{
            viewHoursPicker.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height+15);
        }];
        
    }
    else
    {
        viewHoursPicker.frame = CGRectMake(self.view.frame.origin.x, 580, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:viewHoursPicker];
        
        [UIView animateWithDuration:0.5 animations:^{
            viewHoursPicker.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    
    [pickerHours reloadAllComponents];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 3;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if (component == 0) {
        return [arr1 count];
    }else if (component == 1){
        return [arr2 count];
    }
    return [arr3 count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    if (component == 0) {
        return [arr1 objectAtIndex:row];
    }else if (component == 1){
        return [arr2 objectAtIndex:row];
    }
    return [arr3 objectAtIndex:row];
}
-(UIView* )pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = (UILabel*) view;
    if (!label) {
        label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setTextAlignment:NSTextAlignmentCenter];
    }
    if (component == 0) {
        [label setText:[arr1 objectAtIndex:row]];
        return label;
    }else if (component == 1){
        [label setText:[arr2 objectAtIndex:row]];
        return label;
    }
    [label setText:[arr3 objectAtIndex:row]];
    return label;
}

@end
