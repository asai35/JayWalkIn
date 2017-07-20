//
//  calloutView.h
//  HuntersRoom
//
//  Created by Asai on 14/08/14.
//  Copyright (c) 2014 Ramprakash. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface calloutView : UIView


@property (nonatomic,strong)IBOutlet UILabel *lblHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblAdd;
@property (strong, nonatomic) IBOutlet UIButton *btnA;
@property (strong, nonatomic) IBOutlet UIButton *btnB;
@property (strong, nonatomic) IBOutlet UIButton *btnD;
@property (strong, nonatomic) IBOutlet UIButton *btnC;


@property (strong, nonatomic) IBOutlet UIButton *btnBackClicked;



+ (calloutView*)ViewWithFrame:(CGRect)frame;
@end
