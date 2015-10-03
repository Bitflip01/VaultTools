//
//  SPECIALTableViewCell.m
//  Vault 111
//
//  Created by Alexander Heemann on 01/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "SPECIALTableViewCell.h"

@interface SPECIALTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barViewConstraint;
@property (weak, nonatomic) IBOutlet UIView *barContainerView;
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (nonatomic, strong, readwrite) UIColor *barColor;

@end

@implementation SPECIALTableViewCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        // Recover backgroundColor of subviews.
//        self.barView.backgroundColor = self.barColor;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected)
    {
        // Recover backgroundColor of subviews.
//        self.barView.backgroundColor = self.barColor;
    }
}

- (void)setSpecial:(SPECIAL *)special
{
    _special = special;
    self.specialNameLabel.text = special.name;
}

- (void)awakeFromNib
{
    // Initialization code
    self.barColor = self.barView.backgroundColor;
}

- (void)setSpecialValue:(NSInteger)specialValue
{
    _specialValue = specialValue;
    [self updateBar];
}

- (void)updateBar
{
    double multiplier = self.specialValue / 10.0;
    NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:self.barViewConstraint.firstItem
                                 attribute:self.barViewConstraint.firstAttribute
                                 relatedBy:self.barViewConstraint.relation
                                    toItem:self.barViewConstraint.secondItem
                                 attribute:self.barViewConstraint.secondAttribute
                                multiplier:multiplier
                                  constant:self.barViewConstraint.constant];
    [self layoutIfNeeded];
    double oldMultiplier = self.barViewConstraint.multiplier;
    [self.barContainerView removeConstraint:self.barViewConstraint];
    [self.barContainerView addConstraint:newConstraint];
    self.barViewConstraint = newConstraint;
    NSTimeInterval duration = 1 * fabs(multiplier - oldMultiplier);
    
    [UIView animateWithDuration:duration
                     animations:^{
                         [self layoutIfNeeded]; // Called on parent view
                     }];
    
//    [self setNeedsLayout];
}

- (IBAction)specialValueStepperChangedValue:(id)sender
{
    UIStepper *stepper = sender;
    self.specialValueLabel.text = [NSString stringWithFormat:@"%ld", (long)stepper.value];
    self.special.value = stepper.value;
    [self.delegate cell:self changedSpecial:self.special];
}

@end
