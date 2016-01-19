//
//  PerksLoader.m
//  Vault Tools
//
//  Created by Alexander Heemann on 06/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "PerksLoader.h"
#import "PerkDescription.h"

@implementation PerksLoader

+ (NSArray *)loadPerksFromJSON
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Perks" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    return json;
}

+ (NSArray *)loadPerkDescriptionsFromJSON
{
    NSArray *rawPerksArray = [PerksLoader loadPerksFromJSON];
    
    NSMutableArray *mutablePerks = [NSMutableArray array];
    for (int specialType = 0; specialType < rawPerksArray.count; specialType++)
    {
        NSMutableArray *perkSection = [NSMutableArray array];
        for (int perkId = 0; perkId < [rawPerksArray[specialType] count]; perkId++)
        {
            NSDictionary *perkDict = rawPerksArray[specialType][perkId];
            NSString *perkName = perkDict[@"name"];
            
            PerkDescription *perkDescription = [PerksLoader perkDescriptionForName:perkName];
            [perkSection addObject:perkDescription];
        }
        [mutablePerks addObject:perkSection];
    }
    return [mutablePerks copy];
}

+ (NSDictionary *)loadPerksDictionaryFromJSON
{
    NSArray *rawPerksArray = [PerksLoader loadPerksFromJSON];
    
    NSMutableDictionary *mutablePerks = [NSMutableDictionary dictionary];
    for (int specialType = 0; specialType < rawPerksArray.count; specialType++)
    {
        for (int perkId = 0; perkId < [rawPerksArray[specialType] count]; perkId++)
        {
            NSDictionary *perkDict = rawPerksArray[specialType][perkId];
            NSString *perkName = perkDict[@"name"];
            
            PerkDescription *perkDescription = [PerksLoader perkDescriptionForName:perkName];
            mutablePerks[perkName] = perkDescription;
        }
    }
    return [mutablePerks copy];
}

+ (PerkDescription *)perkDescriptionForName:(NSString *)name
{
    NSString *strippedName = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    strippedName = [strippedName stringByReplacingOccurrencesOfString:@"." withString:@""];
    if ([strippedName isEqualToString:@"ActionBoy/ActionGirl"])
    {
        strippedName = @"ActionBoy";
    }
    NSString *filePath = [[NSBundle mainBundle] pathForResource:strippedName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    PerkDescription *perkDescription = [[PerkDescription alloc] initWithDictionary:json];
    return perkDescription;
}

@end
