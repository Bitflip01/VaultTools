//
//  CharacterStatsCell.m
//  Vault 111
//
//  Created by Alexander Heemann on 16/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "CharacterStatsCell.h"

@implementation CharacterStatsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHp:(NSInteger)hp
{
    _hp = hp;
    
    NSMutableAttributedString *hpStringNormal = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"HP: %ld", hp]];
    NSMutableAttributedString *hpString =
    [[NSMutableAttributedString alloc]
     initWithAttributedString: hpStringNormal];
    
    [hpString addAttribute:NSForegroundColorAttributeName
                     value:[UIColor flatRedColor]
                     range:NSMakeRange(4, hpString.length - 4)];
    self.hpLabel.attributedText = hpString;
}

- (void)setAp:(NSInteger)ap
{
    _ap = ap;
    
    NSMutableAttributedString *apStringNormal = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"AP: %ld", ap]];
    NSMutableAttributedString *apString =
    [[NSMutableAttributedString alloc]
     initWithAttributedString: apStringNormal];
    
    [apString addAttribute:NSForegroundColorAttributeName
                     value:[UIColor flatSkyBlueColor]
                     range:NSMakeRange(4, apString.length - 4)];
    self.apLabel.attributedText = apString;
}

- (void)setCarryWeight:(NSInteger)carryWeight
{
    _carryWeight = carryWeight;
    
    NSMutableAttributedString *cwStringNormal = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Carry Weight: %ld", carryWeight]];
    NSMutableAttributedString *cwString =
    [[NSMutableAttributedString alloc]
     initWithAttributedString: cwStringNormal];
    
    [cwString addAttribute:NSForegroundColorAttributeName
                     value:[UIColor flatOrangeColor]
                     range:NSMakeRange(14, cwString.length - 14)];
    self.carryWeightLabel.attributedText = cwString;
}

@end
