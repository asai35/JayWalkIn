//
//  TownInfoCenterVC.m
//  Jwalkin
//
//  Created by Asai on 11/06/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import "TownInfoCenterVC.h"
#import "SubCatCell.h"
#import "SubCatNameCell.h"
#import "SBJson5.h"
#import "UrlFile.h"
#import "UIImageView+WebCache.h"
#import "TownInfoCoupanVC.h"
#import "Reachability.h"


@interface TownInfoCenterVC ()
{
    NSArray *arrTownCat;
}
@end

@implementation TownInfoCenterVC
@synthesize lblDListSubCatName,lblCouponMName,lblCouponMAddress,mainDict,catId,lblPercentage;
@synthesize lblTotalWalkin;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrMerchantDetail = [[NSMutableArray alloc] init];
    lblDListSubCatName.text=@"Town Info Center";
     app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    arrTownCat =[[NSArray alloc]initWithObjects:@"Contest",@"Happy Hour",@"Breakfast Specials",@"Lunch Specials",@"Dinner Specials",@"Kids Activites",@"Events",@"Local Sales",@"School News",@"Town News",@"Holiday",@"Town Info Center", nil];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- other method

-(void)loadData
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showAlert:@"" message:@"Please check your internet connection." cancel:@"OK" other:nil];
    }
    else
    {
        //http://198.57.247.185/~jwalkin/admin/api/getTownInfoCenterbillboards.php?lat=26&lng=73&radius=50
        netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponse:) WithCallBackObject:self];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[NSString stringWithFormat:@"%f",app.clLocation.coordinate.latitude] forKey:@"lat"];
        [dict setValue:[NSString stringWithFormat:@"%f",app.clLocation.coordinate.longitude] forKey:@"lng"];

        [dict setValue:@"50" forKey:@"radius"];
        netUtills.tag = 1;
        [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl, getbiillboardntowncat] WithDictionary:dict];
    }

}

-(void)ParseResponse:(id)sender
{
    NetworkUtills *utills=(NetworkUtills *)sender;
    [self ParseResult:utills.strResponse];
}

-(void)ParseResult:(NSString *)strResponse
{
    if (netUtills.tag == 1)
    {
        NSError *error = nil;
        NSData *data = [strResponse dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

//        NSDictionary *dict =[strResponse JSONValue];
        if ([[dict valueForKey:@"Status"] integerValue] == 1)
        {
            arrMerchantDetail = [dict valueForKey:@"data"];
            if (![arrMerchantDetail isKindOfClass:[NSString class]])
            {
                arrAllMerchantCopy =[[NSMutableArray alloc]initWithArray:arrMerchantDetail];
                [tblMerchant reloadData];
            }
            else
            {
                NSString *str = [dict valueForKey:@"data"];
                [self showAlert:@"Empower Main Street" message:str cancel:@"OK" other:nil];
                return;
            }
        }
    }
}

#pragma mark- PickerView Delegates

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [arrTownCat count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [arrTownCat objectAtIndex:row];
}

#pragma mark- Button Action

-(IBAction)btnHomeClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)pickerClicked:(id)sender
{
    //Dp 30Dec
    
    if ([UIScreen mainScreen].bounds.size.height > 500)
    {
        
        
        //        picView.frame  = CGRectMake(0, 568, 320, 568);
        //        [UIView beginAnimations:nil context:NULL];
        //        [UIView setAnimationDuration:0.5];
        //        picView.frame  = CGRectMake(0, 0, 320, 568);
        //        picView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        
        // [UIView commitAnimations];
        picView.frame = CGRectMake(self.view.frame.origin.x, 580, self.view.frame.size.width, self.view.frame.size.height+15);
        [self.view addSubview:picView];
        
        [UIView animateWithDuration:0.5 animations:^{
            picView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height+15);
        }];
        
    }
    else
    {
        //        picView.frame  = CGRectMake(0, 460, 320, 460);
        //        [UIView beginAnimations:nil context:NULL];
        //        [UIView setAnimationDuration:0.5];
        //        picView.frame  = CGRectMake(0, 0, 320, 480);
        //        [UIView commitAnimations];
        
        picView.frame = CGRectMake(self.view.frame.origin.x, 580, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:picView];
        
        [UIView animateWithDuration:0.5 animations:^{
            picView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    
    [picker reloadAllComponents];

//    if ([UIScreen mainScreen].bounds.size.height > 500)
//    {
//        picView.frame  = CGRectMake(0, 568, 320, 568);
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.5];
//        picView.frame  = CGRectMake(0, 0, 320, 568);
//        [UIView commitAnimations];
//        [self.view addSubview:picView];
//    }
//    else
//    {
//        picView.frame  = CGRectMake(0, 460, 320, 460);
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.5];
//        picView.frame  = CGRectMake(0, 0, 320, 480);
//        [UIView commitAnimations];
//        [self.view addSubview:picView];
//    }
//    [picker reloadAllComponents];
}

-(IBAction)pickerDoneClicked:(id)sender
{
    lblDListSubCatName.text = [arrTownCat objectAtIndex:[picker selectedRowInComponent:0]];
    NSString *str =[NSString stringWithFormat:@" %@",lblDListSubCatName.text];
    if (arrMerchantDetail.count > 0) {
        arrMerchantDetail = [NSMutableArray new];
    }
    for (int i =0; i<arrAllMerchantCopy.count; i++)
    {
        NSDictionary *dict = [arrAllMerchantCopy objectAtIndex:i];
        NSArray *arrBill = [dict valueForKey:@"billboards"];
        for (int j=0; j<arrBill.count; j++)
        {
            NSDictionary *dictBill = [arrBill objectAtIndex:j];
            NSString *strTown = [dictBill valueForKey:@"towncategory_name"];
            if ([str isEqualToString:strTown])
            {
                [arrMerchantDetail addObject:dict];
                [tblMerchant reloadData];
            }
        }
    }
    if ([str isEqualToString:@" Town Info Center"])
    {
        [arrMerchantDetail addObjectsFromArray:arrAllMerchantCopy];
        [tblMerchant reloadData];
    }
    if (arrMerchantDetail.count == 0)
    {
        [tblMerchant reloadData];
        [self showAlert:@"Empower Main Street" message:@"No Data Found" cancel:@"OK" other:nil];
    }
//    picView.frame  = CGRectMake(0, 0, 320, 568);
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.5];
//    picView.frame  = CGRectMake(0, 568, 320, 568);
    
//    [UIView commitAnimations];
    
    
    //Dp 30Dec
    [UIView animateWithDuration:0.5 animations:^{
        picView.frame = CGRectMake(self.view.frame.origin.x, 580, self.view.frame.size.width, self.view.frame.size.height+15);
    }];

}

-(IBAction)pickerCancelClicked:(id)sender
{
//    picView.frame  = CGRectMake(0, 0, 320, 568);
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.5];
//    picView.frame  = CGRectMake(0, 568, 320, 568);
//    [UIView commitAnimations];
    
    
    //Dp 30Dec
    [UIView animateWithDuration:0.5 animations:^{
        picView.frame = CGRectMake(self.view.frame.origin.x, 580, self.view.frame.size.width, self.view.frame.size.height+15);
    }];

}

-(IBAction)SlectedMerchentDetail:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    merchantTag = btn.tag;
    [self ShowCoupons];
}
-(IBAction)ShowCoupons
{
    NSString *str1 =[NSString stringWithFormat:@" %@",lblDListSubCatName.text];
    NSMutableDictionary *dic_K = [arrMerchantDetail objectAtIndex:merchantTag];
    NSMutableDictionary *dic_KBIll = [[NSMutableDictionary alloc]init];
    
    if ([str1 isEqualToString:@" Town Info Center"])
    {
        dic_KBIll = dic_K;
    }
    else
    {
        [dic_KBIll setValue:[dic_K valueForKey:@"merchantid"] forKey:@"merchantid"];
        [dic_KBIll setValue:[dic_K valueForKey:@"merchant_name"] forKey:@"merchant_name"];
        NSArray *arrDictBill = [dic_K valueForKey:@"billboards"];
        NSMutableArray *billboards =[[NSMutableArray alloc]init];
        for (int i =0; i<arrDictBill.count; i++)
        {
            NSDictionary *dict = [arrDictBill objectAtIndex:i];
            NSString *str = [dict valueForKey:@"towncategory_name"];
            if ([str isEqualToString:str1])
            {
                [billboards addObject:dict];
            }
        }
        [dic_KBIll setValue:billboards forKey:@"billboards"];
    }
    TownInfoCoupanVC *townCoupan = [[TownInfoCoupanVC alloc] initWithNibName:@"TownInfoCoupanVC" bundle:nil];
    townCoupan.strMNameTown = [dic_K valueForKey:@"merchant_name"];
    townCoupan.strMIdTown = [dic_K valueForKey:@"merchantid"];
    townCoupan.dictMerchantInfo = dic_KBIll;
    [self.navigationController pushViewController:townCoupan animated:YES];
}

#pragma mark- TableView Delegates

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = @"SubCatCell";
    SubCatCell *cell = (SubCatCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            NSArray *toplevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SubCatCell" owner:nil options:nil];
            for(id currentObject in toplevelObjects)
            {
                if([currentObject isKindOfClass:[UITableViewCell class]])
                {
                    cell = (SubCatCell *)currentObject;
                    break;
                }
            }
        }
    }
    NSInteger IndexRow = indexPath.row+1;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    endindex = IndexRow *2;
    startindex = endindex-2;
    currentCounter=0;
    if(endindex > [arrMerchantDetail count])
    {
        endindex=[arrMerchantDetail count];
    }
    for(NSInteger Counter=startindex;Counter<endindex;Counter++)
    {
        NSMutableDictionary *dic_K = [arrMerchantDetail objectAtIndex:Counter];
        currentCounter++;
        if (currentCounter < 2 )
        {
            cell.lblMerchant2.hidden = YES;
            cell.imgMerchant2.hidden = YES;
            cell.imgBorder2.hidden = YES;
        }
        else
        {
            cell.lblMerchant1.hidden = NO;
            cell.imgMerchant1.hidden = NO;
            cell.lblMerchant2.hidden = NO;
            cell.imgMerchant2.hidden = NO;
            cell.imgBorder1.hidden = NO;
            cell.imgBorder2.hidden = NO;
        }
        if(currentCounter == 1)
        {
            cell.btnM1.tag = Counter;
            NSString *thumbURL = [[dic_K valueForKey:@"merchant_logo"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            cell.lblMerchant1.text = [dic_K valueForKey:@"merchant_name"];
            NSURL *url = [NSURL URLWithString:thumbURL];
            [cell.imgMerchant1 sd_setImageWithURL:url];
            cell.imgBorder1.hidden = NO;
            [cell.btnM1 addTarget:self action:@selector(SlectedMerchentDetail:) forControlEvents:UIControlEventTouchUpInside];
            NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
            [de setObject:[NSString stringWithFormat:@"%@",[dic_K valueForKey:@"merchant_id"]] forKey:@"MerchentId"];
            [de synchronize];
        }
        if(currentCounter == 2)
        {
            cell.btnM2.tag = Counter;
            NSString *thumbURL=[[dic_K valueForKey:@"merchant_logo"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            cell.imgBorder1.hidden = NO;
            cell.imgBorder2.hidden = NO;
            cell.lblMerchant2.text = [dic_K valueForKey:@"merchant_name"];
            NSURL *url = [NSURL URLWithString:thumbURL];
            [cell.imgMerchant2 sd_setImageWithURL:url];
            [cell.btnM2 addTarget:self action:@selector(SlectedMerchentDetail:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([arrMerchantDetail count]+1)/2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}
- (void)showAlert:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel other:(NSString *)other{
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (other) {
        UIAlertAction *btn_ok = [UIAlertAction actionWithTitle:other style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
        [alert addAction:btn_ok];
    }
    if (cancel) {
        UIAlertAction *btn_cancel = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:^{
                
            }];
            
        }];
        [alert addAction:btn_cancel];
    }
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
