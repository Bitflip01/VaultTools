//
//  PerkCollectionViewCell.h
//  Vault 111
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

@end
