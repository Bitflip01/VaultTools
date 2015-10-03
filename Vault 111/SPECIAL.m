//
//  SPECIAL.m
//  Vault 111
//
//  Created by Alexander Heemann on 01/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "SPECIAL.h"

@implementation SPECIAL

+ (NSString *)nameForType:(SPECIALType)type
{
    switch (type)
    {
        case SPECIALTypeStrength:
            return @"Strength";
            break;
        case SPECIALTypePerception:
            return @"Perception";
            break;
        case SPECIALTypeEndurance:
            return @"Endurance";
            break;
        case SPECIALTypeCharisma:
            return @"Charisma";
            break;
        case SPECIALTypeIntelligence:
            return @"Intelligence";
            break;
        case SPECIALTypeAgility:
            return @"Agility";
            break;
        case SPECIALTypeLuck:
            return @"Luck";
            break;
    }
}

- (NSString *)name
{
    return [SPECIAL nameForType:self.type];
}

- (instancetype)initWithType:(SPECIALType)type
{
    if (self = [super init])
    {
        self.type = type;
    }
    
    return self;
}

@end
