//
//  SwitchViewController.m
//  Jwalkin
//
//  Created by Asai on 4/12/17.
//  Copyright © 2017 fox. All rights reserved.
//

#import "SwitchViewController.h"
#import "AccountCardCell.h"
#import "AccountCardViewCell.h"
#import "SubCatCell.h"
#import "SignupVC.h"
@interface SwitchViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *arrayAccounts;
}
@end

@implementation SwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    arrayAccounts = [[NSMutableArray alloc] initWithArray:[de objectForKey:@"accounts"]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [appdelegate() hideHUD];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayAccounts count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AccountCardViewCell *cell = (AccountCardViewCell *)[tableView dequeueReusableCellWithIdentifier:@"accountCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = (AccountCardViewCell*)[self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"accountCell"];
    }
    NSDictionary *dict = [arrayAccounts objectAtIndex:indexPath.row];
    [cell setBackgroundColor:[UIColor blueColor]];
    [cell.nameLabel setText:dict[@"name"]];
    [cell.emailLabel setText:dict[@"email"]];
    cell.logoImageView.imageURL = [NSURL URLWithString:dict[@"logo"]];
    NSString *loggeduserId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user-Id"];
    if ([dict[@"id"] isEqualToString:loggeduserId]) {
        [cell.switchButton setHidden:YES];
    }
    [cell.switchButton setTag:indexPath.row];
    [cell.switchButton addTarget:self action:@selector(okayNotification:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}
- (IBAction)signinWithAnother:(id)sender {
    SignupVC *signup = [self.storyboard instantiateViewControllerWithIdentifier:@"SignupVC"];//[[SignupVC alloc] initWithNibName:@"SignupVC" bundle:nil];
    [self.navigationController pushViewController:signup animated:YES];
}
- (IBAction)ActionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)okayNotification:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSInteger index = button.tag;
    [self signinWithAnotherAccount:index];
}

- (void)signinWithAnotherAccount: (NSInteger)index{
    
    NSDictionary *parameters = @{@"email_id": [arrayAccounts objectAtIndex:index][@"email"],
                                 @"password": [arrayAccounts objectAtIndex:index][@"password"]
                                 };
    
    [appdelegate() showHUD];
    [[JWNetWorkManager sharedManager] POST:@"login.php" data:parameters completion:^(id data, NSError *error) {
        if (error) {
            [appdelegate() hideHUD];
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", error, data);
            if ([[data valueForKey:@"status"] intValue]== 1)
            {
                NSArray *arrData = [data valueForKey:@"data"];
                NSMutableDictionary *dictData= [[NSMutableDictionary alloc]init];
                dictData = [[arrData objectAtIndex:0] mutableCopy];
                NSMutableDictionary *newinfo = [[NSMutableDictionary alloc]init];
                for(id ss in dictData)
                {
                    NSString *str  =[dictData objectForKey:ss];
                    if (![str isKindOfClass:[NSNull class]])
                    {
                        [newinfo setObject:str forKey:ss];
                    }
                }
                NSLog(@"dictdata %@",newinfo);
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                if ([defaults objectForKey:@"loggedin"]) {
                    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"accounts"]];
                    NSMutableDictionary *account = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"userInfo"]];
                    if (![array containsObject:account]) {
                        [array addObject:account];
                    }
                    [defaults setObject:array forKey:@"accounts"];
                }else{
                    [defaults setObject:@[newinfo] forKey:@"accounts"];
                }
                [defaults setObject:newinfo forKey:@"userInfo"];
                NSString *merchantid = [dictData valueForKey:@"id"];
                NSString *merchantName = [dictData valueForKey:@"name"];
                NSString *FbLink = [dictData valueForKey:@"fb_link"];
                NSString *WebLink = [dictData valueForKey:@"website"];
                [defaults setObject:merchantName forKey:@"merchantName"];
                [defaults synchronize];
                [defaults setObject:merchantid forKey:@"merchantid"];
                [defaults synchronize];
                [defaults setObject:merchantid forKey:@"user-Id"];
                [defaults synchronize];
                [defaults setObject:@"registered" forKey:@"loggedin"];
                [defaults synchronize];
                [defaults setObject:FbLink forKey:@"fb_link"];
                [defaults synchronize];
                [defaults setObject:WebLink forKey:@"Website"];
                [defaults synchronize];
//                [appdelegate() hideHUD];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            else if([[data valueForKey:@"status"] intValue]== 0)
            {
                [self showAlert:@"Message" message:[NSString stringWithFormat:@"%@",[data objectForKey:@"data"]] cancel:@"Ok" other:nil];
                [appdelegate() hideHUD];
            }
            else if([[data valueForKey:@"status"] intValue] == 2)
            {
                UIAlertController *alert = [[UIAlertController alloc] init];
                alert = [UIAlertController alertControllerWithTitle:@"Message" message:[NSString stringWithFormat:@"%@",[data objectForKey:@"data"]] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:@"Subscribe" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSURL *url = [NSURL URLWithString:@"http://emsbapp.com/jwalkin_new_work/signup.php"];
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }];
                [alert addAction:btn_ok];
                UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alert dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                    
                }];
                [alert addAction:btn_cancel];
                [self presentViewController:alert animated:YES completion:nil];
                [appdelegate() hideHUD];
            }
            
            else
            {
                [self showAlert:@"" message:@"Incorrect email id or password." cancel:@"Ok" other:nil];
                [appdelegate() hideHUD];
            }
        }
    }];
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
