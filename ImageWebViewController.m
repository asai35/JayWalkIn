//
//  ImageWebViewController.m
//  Jwalkin
//
//  Created by Manish Sawlot on 19/05/16.
//  Copyright (c) 2016 fox. All rights reserved.
//

#import "ImageWebViewController.h"
#import "MBProgressHUD.h"
@interface ImageWebViewController ()<UIWebViewDelegate>

@end

@implementation ImageWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *fullURL = self.Strlink;
    if ([fullURL isEqualToString:@"null"])
    {
        return;
    }
    NSURL *url;

    if ([fullURL hasPrefix:@"http://"] || [fullURL hasPrefix:@"https://"]) {
        url = [NSURL URLWithString:fullURL];
    }else{
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", fullURL]];
    }
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.wbImgLinkopen loadRequest:requestObj];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)BtnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self showHUD];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideHUD];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self hideHUD];
    [self showAlert:@"Error" message:[NSString stringWithFormat:@"%@", error] cancel:@"Cancel" other:nil];
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
-(void)showHUD
{
    [MBProgressHUD showHUDAddedTo:self.wbImgLinkopen animated:YES];
}

-(void)hideHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.wbImgLinkopen animated:YES];
    });
}

@end
