//
//  AccountCardCell.h
//  Jwalkin
//
//  Created by Asai on 4/12/17.
//  Copyright © 2017 fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDCCardTableViewCell.h"

@interface AccountCardCell : MDCCardTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end
