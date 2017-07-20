//
//  ViewController.h
//  Jwalkin
//
//  Created by Asai on 06/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate>
{
}
@property (nonatomic,strong)CLLocationManager *locationManager;
-(void)startUpdate;
-(void)stopUpdate;

@end
