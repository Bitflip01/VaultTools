//
//  PerkDescription.h
//  Vault 111
//
//  Created by Alexander Heemann on 04/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPECIAL.h"
#import "PerkRank.h"

@class Perk;
@interface PerkDescription : NSObject

@property (nonatomic, assign, readwrite) NSInteger minLevel;
@property (nonatomic, assign, readwrite) NSInteger minSpecial;
@property (nullable, nonatomic, copy, readwrite) NSString *name;
@property (nullable, nonatomic, copy, readwrite) NSString *notes;
@property (nonatomic, assign, readwrite) NSInteger rank;
@property (nonatomic, assign, readwrite) NSInteger maxRank;
@property (nonatomic, assign, readwrite) SPECIALType specialType;
@property (nullable, nonatomic, strong, readwrite) NSArray *ranks;

- (instancetype)initWithPerk:(Perk *)perk;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
