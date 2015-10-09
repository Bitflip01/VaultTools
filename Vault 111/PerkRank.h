//
//  PerkRank.h
//  Vault 111
//
//  Created by Alexander Heemann on 07/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PerkRank : NSObject

@property (nullable, nonatomic, copy, readwrite) NSString *rankDescription;
@property (nonatomic, assign, readwrite) NSInteger minLevel;


@end
