//
//  CharacterSpecialCell.h
//  Vault 111
//
//  Created by Alexander Heemann on 11/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharacterSpecialCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *strengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *perceptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *enduranceLabel;
@property (weak, nonatomic) IBOutlet UILabel *charismaLabel;
@property (weak, nonatomic) IBOutlet UILabel *intelligenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *agilityLabel;
@property (weak, nonatomic) IBOutlet UILabel *luckLabel;

@end
