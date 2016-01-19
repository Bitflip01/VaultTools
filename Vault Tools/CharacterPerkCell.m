//
//  CharacterPerkCell.m
//  Vault Tools
//
//  Created by Alexander Heemann on 11/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "CharacterPerkCell.h"

@interface CharacterPerkCell ()

@property (nonatomic, strong, readwrite) NSMutableArray *stars;

@end

@implementation CharacterPerkCell

- (void)awakeFromNib
{
    
}

- (void)setRank:(NSInteger)rank
{
    _rank = rank;
    for (NSInteger starIndex = 0; starIndex < self.stars.count; starIndex++)
    {
        UIImageView *star = self.stars[starIndex];
        star.image = starIndex < rank ? [UIImage imageNamed:@"star_selected"] : [UIImage imageNamed:@"star_deselected"];
    }
}

- (void)setMaxRank:(NSInteger)maxRank
{
    _maxRank = maxRank;
    
    if (!self.stars)
    {
        self.stars = [NSMutableArray array];
    }
    
    for (UIImageView *star in self.stars)
    {
        [star removeFromSuperview];
    }
    [self.stars removeAllObjects];
    
    UIImageView *previousStar = nil;
    for (NSInteger starIndex = 0; starIndex < maxRank; starIndex++)
    {
        UIImageView *star = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_deselected"]];
        star.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:star];
        
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:star
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                            toItem:self.perkNameLabel
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0
                                                                          constant:0.0];
        NSLayoutConstraint *leftConstraint;
        if (!previousStar)
        {
            leftConstraint = [NSLayoutConstraint constraintWithItem:star
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.perkNameLabel
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0];
        }
        else
        {
            leftConstraint = [NSLayoutConstraint constraintWithItem:star
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:previousStar
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:4.0];
        }
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:star attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:star attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
        
        NSLayoutConstraint *aspectRatioConstraint = [NSLayoutConstraint constraintWithItem:star attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:star attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
        
        [star setContentCompressionResistancePriority:1 forAxis:UILayoutConstraintAxisHorizontal];
        [star setContentCompressionResistancePriority:1 forAxis:UILayoutConstraintAxisVertical];
        
        [self.contentView addConstraints:@[topConstraint, leftConstraint, bottomConstraint, rightConstraint]];
        [star addConstraint:aspectRatioConstraint];
        
        previousStar = star;
        [self.stars addObject:star];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
