//
//  SPECIALTableViewCell.h
//  Vault 111
//
//  Created by Alexander Heemann on 01/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPECIAL.h"

@interface SPECIALTableViewCell : UITableViewCell

@property (nonatomic, strong, readwrite) SPECIAL *special;
@property (weak, nonatomic) IBOutlet UILabel *specialNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialValueLabel;
@property (weak, nonatomic) IBOutlet UIStepper *specialValueStepper;

@end
