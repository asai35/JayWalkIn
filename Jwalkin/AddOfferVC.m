//
//  AddOfferVC.m
//  Jwalkin
//
//  Created by Asai on 22/07/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import "AddOfferVC.h"
#import "Reachability.h"
#import "UrlFile.h"
#import "AFNetworking.h"

@interface AddOfferVC ()
{
    int preOffset;
}
@end

@implementation AddOfferVC
@synthesize isUpdate,dictOffer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CGRect rect = contentView.frame;
    rect.size.width = self.view.frame.size.width -1;
    contentView.frame = rect;
    [contentView sizeToFit];
    [scrollOffer addSubview:contentView];
    [self setEdgesInsectForTextField:txtMaxCount];
    preOffset = 0;
    txtVDescription.delegate = (id)self;
    [self setEdgesInsectForTextField:txtTitle];
    whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    imgView.layer.borderColor =[[UIColor blackColor] CGColor];
    imgView.layer.borderWidth = 1.0;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [scrollOffer addGestureRecognizer:singleTap];
    if (isUpdate)
    {
        [btnAdd setImage:[UIImage imageNamed:@"btn_submit"] forState:UIControlStateNormal];
        _navTitle.title = @"Update Offer";
        [self setData];
    }

}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    scrollOffer.contentSize =CGSizeMake(self.view.frame.size.width, btnAdd.frame.origin.y +50);

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Button Action

-(IBAction)btnAddClicked:(id)sender
{
    //http://198.57.247.185/~jwalkin/admin/api/add_offer.php
    // parameter: title, description, image, is_active, start_on (eg. 2015-07-09),expire_on(eg. 2015-07-09), maxcount, merchant_id
    //Update offer
    // http://198.57.247.185/~jwalkin/admin/api/update_offer.php
    //parameter: require: offer_id optional: title, description, image, is_active, start_on (eg. 2015-07-09),expire_on(eg. 2015-07-09), maxcount

    [txtMaxCount resignFirstResponder];
    [txtTitle resignFirstResponder];
    [txtVDescription resignFirstResponder];
    scrollOffer.contentSize = CGSizeMake(self.view.frame.size.width,btnAdd.frame.origin.y +50);

    if ([self validation])
    {
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        NSString *mId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"merchantid"]];
        if (networkStatus == NotReachable)
        {
            [self showAlert:@"" message:@"Please check your internet connection." cancel:@"OK" other:nil];
        }
        else
        {
            if (isUpdate)
            {
                NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                NSString *imageName = [NSString stringWithFormat:@"image_%dOffer",app.imageNo];
                NSString *filePath = [documentsDirectory stringByAppendingPathComponent:imageName];
                NSData *imageData = UIImagePNGRepresentation(imgView.image);
                [imageData writeToFile:filePath atomically:YES];
                app.imageNo ++;
                NSString *offerId = [dictOffer valueForKey:@"id"];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:offerId forKey:@"offer_id"];
                [dict setObject:txtTitle.text forKey:@"title"];
                [dict setObject:txtVDescription.text forKey:@"description"];
                [dict setObject:@"1" forKey:@"is_active"];
                [dict setObject:lblStartOn.text forKey:@"start_on"];
                [dict setObject:lblExpireOn.text forKey:@"expire_on"];
                [dict setObject:txtMaxCount.text forKey:@"maxcount"];
                [dict setObject:mId forKey:@"merchant_id"];
                [dict setObject:@{@"data": imageData, @"name" :@"Photo.png"} forKey:@"image"];
//                NSURL *codeURL = [NSURL URLWithString:mainUrl];
                [app showHUD];
                [[JWNetWorkManager sharedManager] POST:update_offer data:dict completion:^(id data, NSError *error) {
                    [app hideHUD];
                    if (error) {
                        NSLog(@"Error: %@", error);
                    } else {
                        NSLog(@"%@ %@", error, data);
                        NSString *msg = [NSString stringWithFormat:@"%@",[data valueForKey:@"message"]];
                        if ([[data valueForKey:@"status"] intValue]== 1)
                        {
                            UIAlertController *alert = [[UIAlertController alloc] init];
                            alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:msg preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    [self.navigationController popViewControllerAnimated:YES];
                            }];
                            [alert addAction:btn_ok];
                            [self presentViewController:alert animated:YES completion:nil];
                            
                        }
                        else
                        {
                            
                        }
                    }
                }];

//                AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:codeURL];
//                NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:update_offer parameters:dict constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)
//                                                {
//                                                    [formData appendPartWithFileData:imageData name:@"image" fileName:@"Photo.png" mimeType:@"image/png"];
//                                                }];
//                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
//                 {
//                     NSString *response = [operation responseString];
//                     [app hideHUD];
//                     NSError *error;
//                     if (response!=nil)
//                     {
//                         NSDictionary *responseDict = [NSJSONSerialization
//                                                       JSONObjectWithData:[operation responseData] options:kNilOptions error:&error];
//                         NSString *msg = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"message"]];
//                         if ([[responseDict valueForKey:@"status"] intValue]== 1)
//                         {
//                             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Jaywalk.In" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                             alert.tag = 5001;
//                             [alert show];
//                         }
//                         else
//                         {
//                             
//                         }
//                     }
//                 }
//                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
//                 {
//                 }];
//                [operation start];

            }
            else
            {
                NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                NSString *imageName = [NSString stringWithFormat:@"image_%dOffer",app.imageNo];
                NSString *filePath = [documentsDirectory stringByAppendingPathComponent:imageName];
                NSData *imageData = UIImagePNGRepresentation(imgView.image);
                [imageData writeToFile:filePath atomically:YES];
                app.imageNo ++;
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:txtTitle.text forKey:@"title"];
                [dict setObject:txtVDescription.text forKey:@"description"];
                [dict setObject:@"1" forKey:@"is_active"];
                [dict setObject:lblStartOn.text forKey:@"start_on"];
                [dict setObject:lblExpireOn.text forKey:@"expire_on"];
                [dict setObject:txtMaxCount.text forKey:@"maxcount"];
                [dict setObject:mId forKey:@"merchant_id"];
                [dict setObject:@{@"data":imageData, @"name":@"Photo.png"} forKey:@"image"];
                [app showHUD];
                [[JWNetWorkManager sharedManager] POST:add_Offer data:dict completion:^(id data, NSError *error) {
                    [app hideHUD];
                    if (error) {
                        NSLog(@"Error: %@", error);
                    } else {
                        NSLog(@"%@ %@", error, data);
                        NSString *msg = [NSString stringWithFormat:@"%@",[data valueForKey:@"message"]];
                        if ([[data valueForKey:@"status"] intValue]== 1)
                        {
                            UIAlertController *alert = [[UIAlertController alloc] init];
                            alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:msg preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    [self.navigationController popViewControllerAnimated:YES];
                            }];
                            [alert addAction:btn_ok];
                            [self presentViewController:alert animated:YES completion:nil];
                        }
                        else
                        {
                            
                        }
                    }
                }];
//                NSURL *codeURL = [NSURL URLWithString:mainUrl];
//                AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:codeURL];
//                [app showHUD];
//                NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:add_Offer parameters:dict constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)
//                                                {
//                                                    [formData appendPartWithFileData:imageData name:@"image" fileName:@"Photo.png" mimeType:@"image/png"];
//                                                }];
//                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
//                 {
//                     NSString *response = [operation responseString];
//                     [app hideHUD];
//                     NSError *error;
//                     if (response!=nil)
//                     {
//                         NSDictionary *responseDict = [NSJSONSerialization
//                                                       JSONObjectWithData:[operation responseData] options:kNilOptions error:&error];
//                         NSString *msg = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"message"]];
//                         if ([[responseDict valueForKey:@"status"] intValue]== 1)
//                         {
//                             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Jaywalk.In" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                             alert.tag = 5001;
//                             [alert show];
//                         }
//                         else
//                         {
//                             
//                         }
//                     }
//                 }
//                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
//                 {
//                 }];
//                [operation start];
            }
        }
    }
}

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnDateClicked:(id)sender
{
    [txtMaxCount resignFirstResponder];
    [txtTitle resignFirstResponder];
    [txtVDescription resignFirstResponder];
    [self.view endEditing:YES];
    scrollOffer.contentSize = CGSizeMake(self.view.frame.size.width, btnAdd.frame.origin.y +50);
    viewPicker.frame =self.view.frame;
    viewPicker.alpha = 0;
    btnTemp = (UIButton *)sender;
    [self.view addSubview:viewPicker];
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseIn  animations:^
     {
         viewPicker.alpha = 1;
     }
                     completion:nil];
    [UIView commitAnimations];
}

-(IBAction)btnPickerDone:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString * strExpDateSel = [dateFormatter stringFromDate:pickerDate.date];
    if (btnTemp.tag == 1)
    {
        lblStartOn.hidden = NO;
        lblStartOn.text = strExpDateSel;
    }
    else if(btnTemp.tag == 2)
    {
        lblExpireOn.hidden = NO;
        lblExpireOn.text = strExpDateSel;
    }
    [viewPicker removeFromSuperview];
}

-(IBAction)btnCancel:(id)sender
{
    [viewPicker removeFromSuperview];
}

-(IBAction)btnSelectImageClicked:(id)sender
{
    [txtVDescription resignFirstResponder];
    [txtTitle resignFirstResponder];
    [txtMaxCount resignFirstResponder];

    
        scrollOffer.contentSize =CGSizeMake(self.view.frame.size.width, btnAdd.frame.origin.y +50);

    
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photolibrary = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.delegate = self;
            picker.allowsEditing = NO;
            [[picker navigationBar]setBackgroundImage:[UIImage imageNamed:@"status_bar"] forBarMetrics:UIBarMetricsDefault];
            [[picker navigationBar]setTintColor:[UIColor clearColor]];
            [[picker navigationBar]setTintColor:[UIColor whiteColor]];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:NULL];
    }];
    [alert addAction:photolibrary];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.delegate = self;
            picker.allowsEditing = NO;
            [[picker navigationBar]setBackgroundImage:[UIImage imageNamed:@"status_bar"] forBarMetrics:UIBarMetricsDefault];
            [[picker navigationBar]setTintColor:[UIColor clearColor]];
            [[picker navigationBar]setTintColor:[UIColor whiteColor]];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
        
    }];
    [alert addAction:camera];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];

//        UIActionSheet *actionSheet = [[UIActionSheet alloc]
//                                  initWithTitle:nil
//                                  delegate:self
//                                  cancelButtonTitle:@"Cancel"
//                                  destructiveButtonTitle:@"Photo Library"
//                                  otherButtonTitles:@"Camera", nil];
//    actionSheet.tag = 1;
//    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
//    [actionSheet showInView:self.view];

}

#pragma mark- ImagePiker Delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker.allowsEditing)
    {
        imageSelected =info[UIImagePickerControllerOriginalImage];
        NSData *imageData = UIImageJPEGRepresentation([self fixOrientation:imageSelected], 0.3);
        //    [imageData writeToFile:filePath atomically:YES];
        imageSelected = [UIImage imageWithData:imageData];

    }
    else
    {
        imageSelected =info[UIImagePickerControllerOriginalImage];
        NSData *imageData = UIImageJPEGRepresentation([self fixOrientation:imageSelected], 0.3);
        //    [imageData writeToFile:filePath atomically:YES];
        imageSelected = [UIImage imageWithData:imageData];

    }
    //imageSelected = [self fixOrientation:imageSelected];

        imgView.image =imageSelected;
                [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - TextField Delegates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 11)
    {
//        [scrollOffer setContentOffset:CGPointMake(0, 400) animated:YES];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == 11){
        [scrollOffer setContentOffset:CGPointMake(0, -400) animated:YES];
    }
    scrollOffer.contentSize = CGSizeMake(self.view.frame.size.width, btnAdd.frame.origin.y +50);
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    return YES;
}



#pragma mark- Tap Gesture

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [txtMaxCount resignFirstResponder];
    [txtTitle resignFirstResponder];
    [txtVDescription resignFirstResponder];
    [self.view endEditing:YES];
    scrollOffer.contentSize = CGSizeMake(self.view.frame.size.width, btnAdd.frame.origin.y +50);
}

#pragma mark- Other Method

-(void)setEdgesInsectForTextField:(UITextField *)txt
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    txt.leftView = paddingView;
    txt.leftViewMode = UITextFieldViewModeAlways;
}

-(BOOL)validation
{
    if ([txtTitle.text stringByTrimmingCharactersInSet:whitespace].length == 0 && [[txtTitle.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        [self showAlert:@"Empower Main Street" message:@"Please enter title." cancel:@"OK" other:nil];
        return NO;
    }
    else if ([txtVDescription.text stringByTrimmingCharactersInSet:whitespace].length == 0 && [[txtVDescription.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        [self showAlert:@"Empower Main Street" message:@"Please writes some description about offer." cancel:@"OK" other:nil];
        return NO;
    }
    else if(UIImagePNGRepresentation(imgView.image) == nil)
    {
        
        [self showAlert:@"Empower Main Street" message:@"Please select offer image." cancel:@"OK" other:nil];
        return NO;
    }
    else if ([lblStartOn.text stringByTrimmingCharactersInSet:whitespace].length == 0 && [[lblStartOn.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""] )
    {
        [self showAlert:@"Empower Main Street" message:@"Please select start date of the offer." cancel:@"OK" other:nil];
        return NO;
    }
    else if ([lblExpireOn.text stringByTrimmingCharactersInSet:whitespace].length == 0 && [[lblExpireOn.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""] )
    {
        [self showAlert:@"Empower Main Street" message:@"Please select expiry date of the offer." cancel:@"OK" other:nil];
       return NO;
    }
    else if ([txtMaxCount.text stringByTrimmingCharactersInSet:whitespace].length == 0 && [[txtMaxCount.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        [self showAlert:@"Empower Main Street" message:@"Please enter the max count" cancel:@"OK" other:nil];
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)setData
{
    lblStartOn.hidden = NO;
    lblExpireOn.hidden = NO;
    
    txtTitle.text = [dictOffer valueForKey:@"title"];
    txtVDescription.text = [dictOffer valueForKey:@"description"];
    txtMaxCount.text = [dictOffer valueForKey:@"maxcount"];
    lblStartOn.text =[dictOffer valueForKey:@"start_on"];
    lblExpireOn.text = [dictOffer valueForKey:@"expire_on"];
    NSString *imgUrl = [dictOffer valueForKey:@"image"];
    imgView.imageURL = [NSURL URLWithString:imgUrl];
}

- (UIImage *)fixOrientation:(UIImage *)imgLocal
{
    
    // No-op if the orientation is already correct
    if (imgLocal.imageOrientation == UIImageOrientationUp) return imgLocal;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (imgLocal.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imgLocal.size.width, imgLocal.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, imgLocal.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, imgLocal.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (imgLocal.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imgLocal.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, imgLocal.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, imgLocal.size.width, imgLocal.size.height,
                                             CGImageGetBitsPerComponent(imgLocal.CGImage), 0,
                                             CGImageGetColorSpace(imgLocal.CGImage),
                                             CGImageGetBitmapInfo(imgLocal.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (imgLocal.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,imgLocal.size.height,imgLocal.size.width), imgLocal.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,imgLocal.size.width,imgLocal.size.height), imgLocal.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
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
