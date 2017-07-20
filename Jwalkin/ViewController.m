
//  ViewController.m
//  Jwalkin
//
//  Created by Asai on 06/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//

#import "ViewController.h"
#import "HomeVC.h"
#import "MainScreenViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "TutorialVC.h"

@interface ViewController ()
{
    int count;
}
@end

@implementation ViewController
@synthesize locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    count = 0;
    [[UINavigationBar appearance]setFrame:CGRectMake(0, 0, 320, 64)];

   // [self startUpdate];
 //   [self GoToNxt];
    
	// Do any additional setup after loading the view, typically from a nib.
}


-(void)viewWillAppear:(BOOL)animated
{
    count = 0;
    [self startUpdate];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
   NSLog(@"Error: %@", [error description]);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation * currentlocation=[locations lastObject];
    appdelegate().clLocation = currentlocation;
    appdelegate().userNewLocatiion=currentlocation;
    [self stopUpdate];

    //NSLog(@"%f  %f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    //NSLog(@"1:-  %f  %f",app.clLocation.coordinate.latitude,app.clLocation.coordinate.longitude);
    if (appdelegate().clLocation.coordinate.latitude == 0.00000 && appdelegate().clLocation.coordinate.longitude == 0.00000)
    {
        [self showAlert:@"EmpowerMainStreet" message:@"You have not allow to use your current location, you couldn't preoceed further" cancel:@"OK" other:nil];
    }
    else
    {
        if (count == 0)
        {
            [self performSelector:@selector(GoToNxt) withObject:nil afterDelay:2.0];
            count++;
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    appdelegate().clLocation = newLocation;
    appdelegate().userNewLocatiion=newLocation;

    [self stopUpdate];
    
    //NSLog(@"%f  %f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    //NSLog(@"2:  %f  %f",app.clLocation.coordinate.latitude,app.clLocation.coordinate.longitude);
    
    if (appdelegate().clLocation.coordinate.latitude == 0.00000 && appdelegate().clLocation.coordinate.longitude == 0.00000)
    {
        [self showAlert:@"EmpowerMainStreet" message:@"You have not allow to use your current location, you couldn't preoceed further." cancel:@"OK" other:nil];
    }
    else
    {
        if (count == 0)
        {
            [self performSelector:@selector(GoToNxt) withObject:nil afterDelay:2.0];
            count++;
        }
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

-(void)startUpdate
{
    locationManager=[[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self.locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];

}

-(void)stopUpdate
{
    [locationManager stopUpdatingLocation];
    locationManager=nil;
}



-(void)GoToNxt
{
    //Dp (23Dec)
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"hasIntroShown"])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            TutorialVC *introVC = [[TutorialVC alloc] initWithNibName:@"TutorialVC" bundle:nil];
//            [self.navigationController presentViewController:introVC animated:YES completion:nil];
            [self.navigationController presentViewController:introVC animated:YES completion:nil];

           [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasIntroShown"];
          [[NSUserDefaults standardUserDefaults] synchronize];
        });
    }//Dp (23Dec)
//    UINavigationController *home = [self.storyboard instantiateViewControllerWithIdentifier:@"MainScreenNav"];//[[HomeVC alloc] initWithNibName:@"HomeVC" bundle:nil];
//    [self presentViewController:home animated:YES completion:nil];
    UIViewController *home = [self.storyboard instantiateViewControllerWithIdentifier:@"mainVC"];
    [self.navigationController pushViewController:home animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
