//
//  PerkCollectionViewCell.h
//  Vault Tools
//
//  Created by Alexander Heemann on 03/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PerkDescription.h"

@interface PerkCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *perkTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *perkImageView;
@property (nonatomic, strong, readwrite) PerkDescription *perk;
@property (nonatomic, assign, readwrite) NSInteger maxRank;
@property (nonatomic, assign, readwrite) NSInteger rank;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *minWidthConstraint;

@end
