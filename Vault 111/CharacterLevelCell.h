//
//  CharacterLevelCell.h
//  Vault 111
//
//  Created by Alexander Heemann on 10/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CharacterLevelCell;
@protocol CharacterLevelCellDelegate <NSObject>

- (void)characterLevelCellDidTapLevelUp:(CharacterLevelCell *)cell;

@end

@interface CharacterLevelCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (nonatomic, assign, readwrite) id<CharacterLevelCellDelegate> delegate;

@end
