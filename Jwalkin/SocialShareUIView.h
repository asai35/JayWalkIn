//
//  SocialShareUIView.h
//  Jwalkin
//
//  Created by Asai on 4/6/17.
//  Copyright © 2017 fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialShareUIView : UIView
@property (strong, nonatomic) IBOutlet UISwitch *switchFB;
@property (strong, nonatomic) IBOutlet UISwitch *switchTW;
@property (strong, nonatomic) IBOutlet UISwitch *switchPT;
@property (strong, nonatomic) IBOutlet UISwitch *switchIST;
@property (strong, nonatomic) IBOutlet UISwitch *switchGG;
@property (strong, nonatomic) IBOutlet UISwitch *switchIN;
+(id)customView;
@end
