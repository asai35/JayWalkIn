//
//  ManageOffersViewController.m
//  Jwalkin
//
//  Created by Asai on 4/16/17.
//  Copyright © 2017 fox. All rights reserved.
//

#import "CreatePunchCardViewController.h"

@interface CreatePunchCardViewController ()<UITextFieldDelegate>{
    int selectedPunches;
}

@end

@implementation CreatePunchCardViewController
@synthesize user_id, user_type;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [tap setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapView:(UITapGestureRecognizer*)re{
    [self.view endEditing:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)radioClicked:(id)sender {
    UIButton *button = (UIButton*)sender;
    NSInteger index = button.tag;
    selectedPunches = (int)index * 5;
    _lblcomplete.text = [NSString stringWithFormat:@"Complete %ld punches and get:", (long)index];
    switch (index) {
        case 1:
            [_radio5punches setImage:[UIImage imageNamed:@"radio-button_touch"] forState:UIControlStateNormal];
            [_radio10punches setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
            [_radio15punches setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
            break;
            
        case 2:
            [_radio5punches setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
            [_radio10punches setImage:[UIImage imageNamed:@"radio-button_touch"] forState:UIControlStateNormal];
            [_radio15punches setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
            break;
            
        case 3:
            [_radio5punches setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
            [_radio10punches setImage:[UIImage imageNamed:@"radio_button_normal"] forState:UIControlStateNormal];
            [_radio15punches setImage:[UIImage imageNamed:@"radio-button_touch"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (IBAction)saveButtonClicked:(id)sender {
    if (_txtTitle.text.length == 0) {
        [self showAlert:@"Warning" message:@"Please type punch card title." cancel:@"Ok" other:nil];
        return;
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"loggedin"])
    {
        user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"user-Id"];
        user_type = @"merchant";
    }
    else
    {
        user_id =@"0";
    }
    if ([user_id isEqualToString:@"0"]) {
        [self showAlert:@"Warning" message:@"Please login with merchant" cancel:@"Ok" other:nil];
        return;
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"punch_type"] = [NSString stringWithFormat:@"%d_punch", selectedPunches];
    parameters[@"user_id"] = user_id;
    parameters[@"user_type"] = user_type;
    parameters[@"punch_title"] = _txtTitle.text;
    parameters[@"isactive"] = @1;
    [appdelegate() showHUD];
    [[JWNetWorkManager sharedManager] POST:@"create_punch_card.php" data:parameters completion:^(id data, NSError *error) {
        [appdelegate() hideHUD];
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", error, data);
            if ([[data valueForKey:@"status"] intValue] == 1)
            {
                NSArray *arrData = [data valueForKey:@"data"];
                NSDictionary *dictData =[arrData objectAtIndex:0];
                NSString *msg = [data valueForKey:@"message"];
                NSString *qr_image = [dictData valueForKey:@"qr_image"];
                UIAlertController *alert = [[UIAlertController alloc] init];
                alert = [UIAlertController alertControllerWithTitle:@"Empower Main Street" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *btn_OK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
