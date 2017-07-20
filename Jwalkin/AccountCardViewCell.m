//
//  AccountCardViewCell.m
//  Jwalkin
//
//  Created by Asai on 4/12/17.
//  Copyright © 2017 fox. All rights reserved.
//

#import "AccountCardViewCell.h"

@implementation AccountCardViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _nameLabel.font = [UIFont mdcTitleFont];
    _nameLabel.textColor = [UIColor mdcTextColor];
    
    _emailLabel.font = [UIFont mdcBody1Font];
    _emailLabel.textColor = [UIColor mdcSecondaryTextColor];
    
    _switchButton.titleLabel.font = [UIFont mdcButtonFont];
    [_switchButton setTitleColor:[UIColor mdcRedColorWithPaletteId:kUIColorMDCPaletteIdPrimary]
                        forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
