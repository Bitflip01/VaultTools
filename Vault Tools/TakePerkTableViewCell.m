//
//  TakePerkTableViewCell.m
//  Vault Tools
//
//  Created by Alexander Heemann on 09/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "TakePerkTableViewCell.h"

@implementation TakePerkTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)takePerkButtonTapped:(id)sender
{
    [self.delegate takePerkTableViewCellDidTakePerk:self];
}

- (IBAction)removePerkButtonTapped:(id)sender
{
    [self.delegate takePerkTableViewCellDidRemovePerk:self];
}

@end
