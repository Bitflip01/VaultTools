//
//  CharacterLevelCell.m
//  Vault 111
//
//  Created by Alexander Heemann on 10/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "CharacterLevelCell.h"

@interface CharacterLevelCell ()

@property (weak, nonatomic) IBOutlet UIButton *levelUpButton;


@end

@implementation CharacterLevelCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)levelUpButtonTapped:(id)sender
{
    [self.delegate characterLevelCellDidTapLevelUp:self];
}

@end
