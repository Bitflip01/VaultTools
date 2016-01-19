//
//  PerksDetailViewController.h
//  Vault Tools
//
//  Created by Alexander Heemann on 08/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PerkDescription.h"

@interface PerksDetailViewController : UITableViewController

@property (nonatomic, strong, readwrite) PerkDescription *perkDescription;

@end
