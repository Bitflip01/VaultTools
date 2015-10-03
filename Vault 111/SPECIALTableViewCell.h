//
//  SPECIALTableViewCell.h
//  Vault 111
//
//  Created by Alexander Heemann on 01/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPECIAL.h"

@class SPECIALTableViewCell;
@protocol SPECIALTableViewCellDataSource <NSObject>

- (BOOL)canIncreaseSpecial;

@end

@protocol SPECIALTableViewCellDelegate <NSObject>

- (void)cell:(SPECIALTableViewCell *)cell changedSpecial:(SPECIAL *)special;

@end

@interface SPECIALTableViewCell : UITableViewCell

@property (nonatomic, strong, readwrite) SPECIAL *special;
@property (weak, nonatomic) IBOutlet UILabel *specialNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialValueLabel;
@property (weak, nonatomic) IBOutlet UIStepper *specialValueStepper;
@property (nonatomic, assign, readwrite) id<SPECIALTableViewCellDataSource> dataSource;
@property (nonatomic, assign, readwrite) id<SPECIALTableViewCellDelegate> delegate;

@end
