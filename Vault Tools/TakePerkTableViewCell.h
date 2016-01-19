//
//  TakePerkTableViewCell.h
//  Vault Tools
//
//  Created by Alexander Heemann on 09/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TakePerkTableViewCell;
@protocol TakePerkTableViewCellDelegate <NSObject>

- (void)takePerkTableViewCellDidTakePerk:(TakePerkTableViewCell *)cell;
- (void)takePerkTableViewCellDidRemovePerk:(TakePerkTableViewCell *)cell;

@end

@interface TakePerkTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *perkPointsLabel;
@property (weak, nonatomic) IBOutlet UIButton *takePerkButton;
@property (weak, nonatomic) IBOutlet UIButton *removePerkButton;

@property (nonatomic, assign, readwrite) id<TakePerkTableViewCellDelegate> delegate;

@end
