//
//  RankTableViewCell.h
//  Vault Tools
//
//  Created by Alexander Heemann on 09/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rankDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (nonatomic, assign, readwrite) BOOL rankTaken;

@end
