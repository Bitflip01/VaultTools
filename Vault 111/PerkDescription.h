//
//  PerkDescription.h
//  Vault 111
//
//  Created by Alexander Heemann on 04/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPECIAL.h"

@interface PerkDescription : NSObject

@property (nullable, nonatomic, assign, readwrite) NSInteger *minLevel;
@property (nullable, nonatomic, assign, readwrite) NSInteger *minSpecial;
@property (nullable, nonatomic, copy, readwrite) NSString *name;
@property (nullable, nonatomic, assign, readwrite) NSInteger *rank;
@property (nullable, nonatomic, assign, readwrite) SPECIALType *specialType;
@property (nullable, nonatomic, strong, readwrite) PerkDescription * nextRank;
@property (nullable, nonatomic, strong, readwrite) PerkDescription * previousRank;

@end
