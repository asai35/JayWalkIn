//
//  InfoVC.m
//  Jwalkin
//
//  Created by Kanika on 11/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//

#import "InfoVC.h"
#import <MessageUI/MessageUI.h>
#import "UrlFile.h"
#import "SBJson5.h"
#import "MBProgressHUD.h"

@interface InfoVC ()

@end

@implementation InfoVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"status_bar"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    [btnFacebook setFrame:CGRectMake(btnFacebook.frame.origin.x, self.view.frame.size.height-65, btnFacebook.frame.size.width, btnFacebook.frame.size.height)];
//    [btnMail setFrame:CGRectMake(btnMail.frame.origin.x, self.view.frame.size.height-65, btnMail.frame.size.width, btnMail.frame.size.height)];
//    [btnTwitter setFrame:CGRectMake(btnTwitter.frame.origin.x, self.view.frame.size.height-65, btnTwitter.frame.size.width, btnTwitter.frame.size.height)];
    wbView.delegate = self;
    //dp
    wbView.scrollView.scrollEnabled=NO;
    netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponse:) WithCallBackObject:self];
    [netUtills GetResponseByASIHttpRequest:[NSString stringWithFormat:@"%@%@",mainUrl,getInfoDetail]];
    webViewFBTwitter.hidden=YES;
    btnCloseWebView.hidden = YES;
    btnCloseWebView.layer.borderColor = [[UIColor whiteColor] CGColor];
    btnCloseWebView.layer.borderWidth = 1.5;
    btnCloseWebView.layer.cornerRadius = 10;
    [self.ShareView setHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API Response

-(void)ParseResponse:(id)sender
{
    NetworkUtills *utills=(NetworkUtills *)sender;
    [self ParseResult:utills.strResponse];
}
-(void)ParseResult:(NSString *)strResponse
{
    NSError *error = nil;
    NSData *data = [strResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSString *html =[NSString stringWithFormat:@"<html><body><div style=\"font-family: cursive; font-size: 14px;\">%@</div></body></html>",[dict objectForKey:@"info"]];
  //  [wbView loadHTMLString:[NSString stringWithFormat:@"<html><body>%@</body></html>",[dict objectForKey:@"info"]] baseURL:nil];
     [wbView loadHTMLString:html baseURL:nil];
}

#pragma mark- Button Action

-(IBAction)BackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)FBClicked:(id)sender

{
     [self.ShareView setHidden:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    btnCloseWebView.hidden=NO;
    webViewFBTwitter.hidden=NO;
    NSURL *url = [NSURL URLWithString:@"http://www.facebook.com/pages/Jwalkin/225551014301348"];
    [webViewFBTwitter loadRequest:[NSURLRequest requestWithURL:url]];
    //if (![[UIApplication sharedApplication] openURL:url])
       //NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

-(IBAction)TweetClicked:(id)sender
{
     [self.ShareView setHidden:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    btnCloseWebView.hidden=NO;
    webViewFBTwitter.hidden=NO;
    NSURL *url = [NSURL URLWithString:@"http://twitter.com/jwalkinsmallbiz"];
    [webViewFBTwitter loadRequest:[NSURLRequest requestWithURL:url]];

//    if (![[UIApplication sharedApplication] openURL:url])
//        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

-(IBAction)SendMailClicled:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        [self.ShareView setHidden:YES];
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [[picker navigationBar]setTintColor:[UIColor whiteColor]];
        NSArray * arr=[NSArray arrayWithObjects:@"support@jwalkin.com", nil];
        [picker setToRecipients:arr];
        if([MFMailComposeViewController canSendMail])
        {
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
    else
    {
        [self showAlert:@"Failure" message:@"Your email service is off, please enable email service in your device" cancel:@"OK" other:nil];
    }
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
-(IBAction)btnCloseWebViewClicked:(id)sender
{
    webViewFBTwitter.hidden=YES;
    btnCloseWebView.hidden = YES;
    [webViewFBTwitter loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
     [self.ShareView setHidden:NO];

}
#pragma mark- MFMail Delegates

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
        {
             [self.ShareView setHidden:NO];
            break;
            
        }
        case MFMailComposeResultSaved:
        {
             [self.ShareView setHidden:NO];
            [self showAlert:@"Alert" message:@"Mail saved!" cancel:@"OK" other:nil];
            break;
        }
        case MFMailComposeResultSent:
        {
             [self.ShareView setHidden:NO];
            [self showAlert:@"Alert" message:@"Mail sent!" cancel:@"OK" other:nil];
            break;
        }
        case MFMailComposeResultFailed:
        {
             [self.ShareView setHidden:NO];
            [self showAlert:@"Alert" message:@"Mail Sending Failed!" cancel:@"OK" other:nil];
            break;
        }
        default:
        {
             [self.ShareView setHidden:NO];
            [self showAlert:@"Alert" message:@"Mail Not Sent!" cancel:@"OK" other:nil];
            break;
        }
    }
     [self.ShareView setHidden:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- WebView Delegates

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
@end
