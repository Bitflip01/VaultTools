//
//  PerkCollectionViewCell.m
//  Vault 111
//
//  Created by Alexander Heemann on 03/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "PerkCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PerkCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)setPerk:(Perk *)perk
{
    self.perkTitleLabel.text = perk.name;
}

@end
