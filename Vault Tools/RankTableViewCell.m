//
//  RankTableViewCell.m
//  Vault Tools
//
//  Created by Alexander Heemann on 09/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "RankTableViewCell.h"

@implementation RankTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRankTaken:(BOOL)rankTaken
{
    _rankTaken = rankTaken;
    if (rankTaken)
    {
        self.starImageView.image = [UIImage imageNamed:@"star_selected"];
    }
    else
    {
        self.starImageView.image = [UIImage imageNamed:@"star_deselected"];
    }
}

@end
