//
//  Character.m
//  Vault 111
//
//  Created by Alexander Heemann on 02/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "Character.h"
#import "PerksLoader.h"
#import "PerkDescription.h"
#import "PerkRank.h"
#import "StatsSnapshot.h"
#import "HistorySnapshot.h"

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

- (void)validatePerks
{
    NSDictionary *perkDict = [PerksLoader loadPerksDictionaryFromJSON];
    
    for (Perk *perk in [self.perks copy])
    {
        if (!perkDict[perk.name])
        {
            [self removePerksObject:perk];
            [perk MR_deleteEntity];
            self.perkPoints = @([self.perkPoints integerValue] + [perk.rank integerValue]);
        }
        else
        {
            PerkDescription *perkDescription = perkDict[perk.name];
            NSInteger rank = [perk.rank integerValue];
            if (rank > perkDescription.maxRank)
            {
                NSInteger diff = rank - perkDescription.maxRank;
                perk.rank = @(perkDescription.maxRank);
                self.perkPoints = @([self.perkPoints integerValue] + diff);
            }
            for (int rankIndex = 0; rankIndex < [perk.rank integerValue] && rankIndex < perkDescription.ranks.count; rankIndex++)
            {
                PerkRank *perkRank = perkDescription.ranks[rankIndex];
                if ([self.level integerValue] < perkRank.minLevel)
                {
                    NSInteger diff = rank - rankIndex;
                    perk.rank = @(rankIndex);
                    self.perkPoints = @([self.perkPoints integerValue] + diff);
                }
            }
            // Remove perk if rank is 0
            if (perk.rank == 0)
            {
                [self removePerksObject:perk];
                [perk MR_deleteEntity];
            }
        }
    }
}

- (StatsSnapshot *)snapshotForCurrentLevel
{
    StatsSnapshot *snapshot = [StatsSnapshot MR_createEntity];
    
    [self fillSnapshotWithCurrentStats:snapshot];
    return snapshot;
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

- (void)fillSnapshotWithCurrentStats:(StatsSnapshot *)snapshot
{
    snapshot.level = @([self.level integerValue]);
    snapshot.strength = @([self.strength integerValue]);
    snapshot.perception = @([self.perception integerValue]);
    snapshot.endurance = @([self.endurance integerValue]);
    snapshot.charisma = @([self.charisma integerValue]);
    snapshot.intelligence = @([self.intelligence integerValue]);
    snapshot.agility = @([self.agility integerValue]);
    snapshot.luck = @([self.luck integerValue]);
    snapshot.specialPoints = @([self.specialPoints integerValue]);
    snapshot.perkPoints = @([self.perkPoints integerValue]);
    
    for (Perk *perk in self.perks)
    {
        Perk *newPerk = [Perk MR_createEntity];
        newPerk.name = [perk.name copy];
        newPerk.rank = @([perk.rank integerValue]);
        [snapshot addPerksObject:newPerk];
    }
}

- (void)createSnapshot
{
    StatsSnapshot *snapshot = [StatsSnapshot MR_createEntity];
    [self fillSnapshotWithCurrentStats:snapshot];
    
    [self addSnapshotsObject:snapshot];
}

- (void)levelUp
{
    [self createSnapshot];
    
    NSInteger oldLevel = [self.level integerValue];
    self.level = @(oldLevel + 1);
    NSInteger oldPerkPoints = [self.perkPoints integerValue];
    self.perkPoints = @(oldPerkPoints + 1);
}

- (void)levelDown
{
    if ([self.level integerValue] > 0)
    {
        self.level = @([self.level integerValue] - 1);
        StatsSnapshot *snapshot = [self findSnapshotForLevel:[self.level integerValue]];
        if (snapshot)
        {
            self.strength = @([snapshot.strength integerValue]);
            self.perception = @([snapshot.perception integerValue]);
            self.endurance = @([snapshot.endurance integerValue]);
            self.charisma = @([snapshot.charisma integerValue]);
            self.intelligence = @([snapshot.intelligence integerValue]);
            self.agility = @([snapshot.agility integerValue]);
            self.luck = @([snapshot.luck integerValue]);
            self.perkPoints = @([snapshot.perkPoints integerValue]);
            self.specialPoints = @([snapshot.specialPoints integerValue]);
            
            [self removeAllPerks];
            for (Perk *perk in [snapshot.perks copy])
            {
                Perk *newPerk = [Perk MR_createEntity];
                newPerk.name = [perk.name copy];
                newPerk.rank = @([perk.rank integerValue]);
                [self addPerksObject:newPerk];
                
                [perk MR_deleteEntity];
            }
            
            [self removeSnapshotsObject:snapshot];
            [snapshot MR_deleteEntity];
        }
    }
}

- (void)removeAllPerks
{
    for (Perk *perk in [self.perks copy])
    {
        [self removePerksObject:perk];
        [perk MR_deleteEntity];
    }
}

- (StatsSnapshot *)findSnapshotForLevel:(NSInteger)level
{
    return [[self.snapshots objectsPassingTest:^BOOL(StatsSnapshot * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.level integerValue] == level)
        {
            *stop = YES;
            return YES;
        }
        return NO;
    }] anyObject];
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

- (BOOL)hasTakenPerkWithName:(NSString *)name
{
    return [self perkForName:name] != nil;
}

- (Perk *)perkForName:(NSString *)name
{
    NSSet<Perk *>* passingPerks = [self.perks objectsPassingTest:^BOOL(Perk * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:name])
        {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    
    return [passingPerks anyObject];
}

- (NSInteger)health
{
    Perk *lifegiver = [self perkForName:@"Lifegiver"];
    
    return 80 + [self.endurance integerValue] * 5 + ([lifegiver.rank integerValue] * 20);
}

- (NSInteger)carryWeight
{
    return 200 + [self.strength integerValue] * 10;
}

- (NSInteger)actionPoints
{
    return 60 + [self.agility integerValue] * 10;
}

@end
