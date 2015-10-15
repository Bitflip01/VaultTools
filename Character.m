//
//  Character.m
//  Vault 111
//
//  Created by Alexander Heemann on 02/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "Character.h"

#define START_SPECIAL_POINTS 21

@implementation Character
// Insert code here to add functionality to your managed object subclass

- (void)setupDefault
{
    [self setupDefaultWithName:@"New Character"];
}

- (void)setupDefaultWithName:(NSString *)name
{
    self.specialPoints = @(START_SPECIAL_POINTS);
    self.dateCreated = [NSDate date];
    self.name = name;
    self.lastUsed = [NSDate date];
    self.strength = @(1);
    self.perception = @(1);
    self.endurance = @(1);
    self.charisma = @(1);
    self.intelligence = @(1);
    self.agility = @(1);
    self.luck = @(1);
    self.perkPoints = @(0);
    self.level = @(0);
}

- (void)setSpecial:(SPECIAL *)special
{
    NSInteger diff = 0;
    NSInteger old = 0;
    
    switch (special.type)
    {
        case SPECIALTypeStrength:
            old = [self.strength integerValue];
            self.strength = @(special.value);
            break;
        case SPECIALTypePerception:
            old = [self.perception integerValue];
            self.perception = @(special.value);
            break;
        case SPECIALTypeEndurance:
            old = [self.endurance integerValue];
            self.endurance = @(special.value);
            break;
        case SPECIALTypeCharisma:
            old = [self.charisma integerValue];
            self.charisma = @(special.value);
            break;
        case SPECIALTypeIntelligence:
            old = [self.intelligence integerValue];
            self.intelligence = @(special.value);
            break;
        case SPECIALTypeAgility:
            old = [self.agility integerValue];
            self.agility = @(special.value);
            break;
        case SPECIALTypeLuck:
            old = [self.luck integerValue];
            self.luck = @(special.value);
            break;
    }
    diff = special.value - old;

    if (([self specialSum] > START_SPECIAL_POINTS + 7 && diff > 0) ||
        ([self specialSum] >= START_SPECIAL_POINTS + 7 && diff < 0))
    {
        self.perkPoints = @([self.perkPoints integerValue] - diff);
    }
    else
    {
        self.specialPoints = @([self.specialPoints integerValue] - diff);
    }
    
    [self save];
}

- (NSInteger)specialSum
{
    return [self.strength integerValue] +
    [self.perception integerValue] +
    [self.endurance integerValue] +
    [self.charisma integerValue] +
    [self.intelligence integerValue] +
    [self.agility integerValue] +
    [self.luck integerValue];
}

- (void)updateSpecialPoints
{
    NSInteger sum = [self specialSum];
    
    self.specialPoints = @(MAX(0, (START_SPECIAL_POINTS + 7) - sum));
}

- (void)incrementSPECIALPoints
{
    self.specialPoints = @([self.specialPoints integerValue] + 1);
}

- (void)decrementSPECIALPoints
{
    self.specialPoints = @([self.specialPoints integerValue] - 1);
}

- (void)save
{
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)reset
{
    for (Perk *perk in self.perks)
    {
        [perk MR_deleteEntity];
    }
    [self removePerks:self.perks];
    
    [self setupDefaultWithName:self.name];
}

- (NSInteger)specialValueForType:(SPECIALType)type
{
    switch (type)
    {
        case SPECIALTypeStrength:
            return [self.strength integerValue];
            
        case SPECIALTypePerception:
            return [self.perception integerValue];
            
        case SPECIALTypeEndurance:
            return [self.endurance integerValue];
            
        case SPECIALTypeCharisma:
            return [self.charisma integerValue];
            
        case SPECIALTypeIntelligence:
            return [self.intelligence integerValue];
            
        case SPECIALTypeAgility:
            return [self.agility integerValue];
            
        case SPECIALTypeLuck:
            return [self.luck integerValue];
    }
}

- (Perk *)perkForPerkDescription:(PerkDescription *)perkDescription
{
    NSSet<Perk *>* passingPerks = [self.perks objectsPassingTest:^BOOL(Perk * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:perkDescription.name])
        {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    
    return [passingPerks anyObject];
}

- (BOOL)canCharacterTakePerk:(PerkDescription *)perk atRank:(NSInteger)rank
{
    NSInteger specialValue = [self specialValueForType:perk.specialType];
    if (specialValue < perk.minSpecial)
    {
        return NO;
    }
    if ([self.perkPoints integerValue] == 0)
    {
        return NO;
    }
    
    if (rank <= perk.maxRank)
    {
        PerkRank *perkRank = perk.ranks[rank - 1];
        if ([self.level integerValue] < perkRank.minLevel)
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)hasEnoughSpecialPointsForPerk:(PerkDescription *)perk
{
    NSInteger specialValue = [self specialValueForType:perk.specialType];
    if (specialValue < perk.minSpecial)
    {
        return NO;
    }
    return YES;
}

- (NSInteger)health
{
    return 80 + [self.endurance integerValue] * 5;
}

- (NSInteger)carryWeight
{
    return 180 + [self.strength integerValue] * 20;
}

- (NSInteger)actionPoints
{
    return 60 + [self.agility integerValue] * 10;
}

@end
