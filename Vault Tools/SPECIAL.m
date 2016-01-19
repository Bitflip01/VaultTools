//
//  SPECIAL.m
//  Vault Tools
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

+ (SPECIALType)specialTypeForName:(NSString *)name
{
    NSString *lcName = [name lowercaseString];
    if ([lcName isEqualToString:@"strength"])
    {
        return SPECIALTypeStrength;
    }
    else if ([lcName isEqualToString:@"perception"])
    {
        return SPECIALTypePerception;
    }
    else if ([lcName isEqualToString:@"endurance"])
    {
        return SPECIALTypeEndurance;
    }
    else if ([lcName isEqualToString:@"charisma"])
    {
        return SPECIALTypeCharisma;
    }
    else if ([lcName isEqualToString:@"intelligence"])
    {
        return SPECIALTypeIntelligence;
    }
    else if ([lcName isEqualToString:@"agility"])
    {
        return SPECIALTypeAgility;
    }
    else
    {
        return SPECIALTypeLuck;
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
