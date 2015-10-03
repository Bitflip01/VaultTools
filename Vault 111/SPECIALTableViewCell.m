//
//  SPECIALTableViewCell.m
//  Vault 111
//
//  Created by Alexander Heemann on 01/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "SPECIALTableViewCell.h"

@interface SPECIALTableViewCell ()

@end

@implementation SPECIALTableViewCell

- (void)setSpecial:(SPECIAL *)special
{
    _special = special;
    self.specialNameLabel.text = special.name;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)specialValueStepperChangedValue:(id)sender
{
    UIStepper *stepper = sender;
    self.specialValueLabel.text = [NSString stringWithFormat:@"%ld", (long)stepper.value];
    self.special.value = stepper.value;
    [self.delegate cell:self changedSpecial:self.special];
}

@end
