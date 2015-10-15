//
//  CharacterPerkCell.h
//  Vault 111
//
//  Created by Alexander Heemann on 11/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharacterPerkCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *perkNameLabel;
@property (nonatomic, assign, readwrite) NSInteger maxRank;
@property (nonatomic, assign, readwrite) NSInteger rank;

@end
