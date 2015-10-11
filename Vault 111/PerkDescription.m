//
//  PerkDescription.m
//  Vault 111
//
//  Created by Alexander Heemann on 04/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "PerkDescription.h"
#import "Perk.h"

@implementation PerkDescription

- (instancetype)initWithPerk:(Perk *)perk
{
    if (self = [super init])
    {
        self.name = perk.name;
        self.rank = [perk.rank integerValue];
        self.specialType = [perk.specialType integerValue];
        self.minSpecial = [perk.minLevel integerValue];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.name = dict[@"name"];
        
        // Ranks
        NSArray *ranks = dict[@"ranks"];
        NSMutableArray *mutableRanks = [NSMutableArray array];
        for (NSDictionary *rankDict in ranks)
        {
            PerkRank *perkRank = [PerkRank new];
            perkRank.rankDescription = rankDict[@"rankDescription"];
            perkRank.minLevel = [rankDict[@"minLevel"] integerValue];
            [mutableRanks addObject:perkRank];
        }
        
        self.ranks = [mutableRanks copy];
        self.minSpecial = [dict[@"minSpecial"] integerValue];
        self.specialType = [SPECIAL specialTypeForName:dict[@"specialType"]];
        self.maxRank = [dict[@"maxRank"] integerValue];

    }
    return self;
}

@end
