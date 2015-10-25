//
//  StatsSnapshot.m
//  
//
//  Created by Alexander Heemann on 16/10/15.
//
//

#import "StatsSnapshot.h"
#import "Perk.h"

NSString *const kSnapshotSpecialPoints = @"kSnapshotSpecialPoints";
NSString *const kSnapshotPerkPoints = @"kSnapshotPerkPoints";
NSString *const kSnapshotStrength = @"kSnapshotStrength";
NSString *const kSnapshotPerception = @"kSnapshotPerception";
NSString *const kSnapshotEndurance = @"kSnapshotEndurance";
NSString *const kSnapshotCharisma = @"kSnapshotCharisma";
NSString *const kSnapshotIntelligence = @"kSnapshotIntelligence";
NSString *const kSnapshotAgility = @"kSnapshotAgility";
NSString *const kSnapshotLuck = @"kSnapshotLuck";

NSString *const kSpecialChangeRelative = @"kSpecialChangeRelative";
NSString *const kSpecialChangeAbsolute = @"kSpecialChangeAbsolute";

NSString *const kPerk = @"kPerk";
NSString *const kPerkChange = @"kPerkChange";
NSString *const kPerkChanges = @"kPerkChanges";
NSString *const kPerkRemoved = @"kPerkRemoved";
NSString *const kPerkAdded = @"kPerkAdded";
NSString *const kPerkRankChangeRelative = @"kPerkRankChangeRelative";
NSString *const kPerkRankChangeAbsolute = @"kPerkRankChangeAbsolute";

@implementation StatsSnapshot

// Insert code here to add functionality to your managed object subclass

- (NSDictionary *)changesSinceSnapshot:(StatsSnapshot *)snapshot
{
    NSMutableDictionary *changes = [NSMutableDictionary dictionary];
    if (!snapshot)
    {
        return [self dictionaryRepresentation];
    }
    
    if ([self.strength integerValue] != [snapshot.strength integerValue])
    {
        NSNumber *changeValue = @([self.strength integerValue] - [snapshot.strength integerValue]);
        changes[kSnapshotStrength] = @{kSpecialChangeRelative: changeValue,
                                       kSpecialChangeAbsolute: self.strength};
    }
    if ([self.perception integerValue] != [snapshot.perception integerValue])
    {
        NSNumber *changeValue = @([self.perception integerValue] - [snapshot.perception integerValue]);
        changes[kSnapshotPerception] = @{kSpecialChangeRelative: changeValue,
                                       kSpecialChangeAbsolute: self.perception};
    }
    if ([self.endurance integerValue] != [snapshot.endurance integerValue])
    {
        NSNumber *changeValue = @([self.endurance integerValue] - [snapshot.endurance integerValue]);
        changes[kSnapshotEndurance] = @{kSpecialChangeRelative: changeValue,
                                       kSpecialChangeAbsolute: self.endurance};
    }
    if ([self.charisma integerValue] != [snapshot.charisma integerValue])
    {
        NSNumber *changeValue = @([self.charisma integerValue] - [snapshot.charisma integerValue]);
        changes[kSnapshotCharisma] = @{kSpecialChangeRelative: changeValue,
                                       kSpecialChangeAbsolute: self.charisma};
    }
    if ([self.intelligence integerValue] != [snapshot.intelligence integerValue])
    {
        NSNumber *changeValue = @([self.intelligence integerValue] - [snapshot.intelligence integerValue]);
        changes[kSnapshotIntelligence] = @{kSpecialChangeRelative: changeValue,
                                       kSpecialChangeAbsolute: self.intelligence};
    }
    if ([self.agility integerValue] != [snapshot.agility integerValue])
    {
        NSNumber *changeValue = @([self.agility integerValue] - [snapshot.agility integerValue]);
        changes[kSnapshotAgility] = @{kSpecialChangeRelative: changeValue,
                                       kSpecialChangeAbsolute: self.agility};
    }
    if ([self.luck integerValue] != [snapshot.luck integerValue])
    {
        NSNumber *changeValue = @([self.luck integerValue] - [snapshot.luck integerValue]);
        changes[kSnapshotLuck] = @{kSpecialChangeRelative: changeValue,
                                       kSpecialChangeAbsolute: self.luck};
    }
    
    // Contains dictionaries with perks and their change (added, removed, changed rank)
    NSMutableArray *perkChanges = [NSMutableArray array];
    
    // Check if perks have been added
    for (Perk *perk in self.perks)
    {
        NSMutableDictionary *perkChangeDict = [NSMutableDictionary dictionary];
        perkChangeDict[kPerk] = perk.name;
        
        Perk *otherPerk = [[snapshot.perks objectsPassingTest:^BOOL(Perk * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj.name isEqualToString:perk.name])
            {
                *stop = YES;
                return YES;
            }
            return NO;
        }] anyObject];
        
        if (!otherPerk)
        {
            perkChangeDict[kPerkChange] = @(PerkChangeAdded);
            [perkChanges addObject:perkChangeDict];
        }
        else if (otherPerk.rank != perk.rank)
        {
            perkChangeDict[kPerkChange] = @(PerkChangeRankChanged);
            perkChangeDict[kPerkRankChangeRelative] = @([perk.rank integerValue] - [otherPerk.rank integerValue]);
            perkChangeDict[kPerkRankChangeAbsolute] = perk.rank;
            [perkChanges addObject:perkChangeDict];
        }
    }
    // Check if perks have been removed
    for (Perk *perk in snapshot.perks)
    {
        NSMutableDictionary *perkChangeDict = [NSMutableDictionary dictionary];
        perkChangeDict[kPerk] = perk.name;
        
        Perk *otherPerk = [[self.perks objectsPassingTest:^BOOL(Perk * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj.name isEqualToString:perk.name])
            {
                *stop = YES;
                return YES;
            }
            return NO;
        }] anyObject];
        
        if (!otherPerk)
        {
            perkChangeDict[kPerkChange] = @(PerkChangeRemoved);
            [perkChanges addObject:perkChangeDict];
        }
    }
    if (perkChanges.count > 0)
    {
        changes[kPerkChanges] = perkChanges;
    }
    
    return [changes copy];
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    if ([self.strength integerValue] > 1)
    {
        dictionary[kSnapshotStrength] = @{kSpecialChangeRelative: @([self.strength integerValue] - 1),
                                          kSpecialChangeAbsolute: self.strength};
    }
    if ([self.perception integerValue] > 1)
    {
        dictionary[kSnapshotPerception] = @{kSpecialChangeRelative: @([self.perception integerValue] - 1),
                                          kSpecialChangeAbsolute: self.perception};
    }
    if ([self.endurance integerValue] > 1)
    {
        dictionary[kSnapshotEndurance] = @{kSpecialChangeRelative: @([self.endurance integerValue] - 1),
                                          kSpecialChangeAbsolute: self.endurance};
    }
    if ([self.charisma integerValue] > 1)
    {
        dictionary[kSnapshotCharisma] = @{kSpecialChangeRelative: @([self.charisma integerValue] - 1),
                                          kSpecialChangeAbsolute: self.charisma};
    }
    if ([self.intelligence integerValue] > 1)
    {
        dictionary[kSnapshotIntelligence] = @{kSpecialChangeRelative: @([self.intelligence integerValue] - 1),
                                          kSpecialChangeAbsolute: self.intelligence};
    }
    if ([self.agility integerValue] > 1)
    {
        dictionary[kSnapshotAgility] = @{kSpecialChangeRelative: @([self.agility integerValue] - 1),
                                          kSpecialChangeAbsolute: self.agility};
    }
    if ([self.luck integerValue] > 1)
    {
        dictionary[kSnapshotLuck] = @{kSpecialChangeRelative: @([self.luck integerValue] - 1),
                                          kSpecialChangeAbsolute: self.luck};
    }
    
    NSMutableArray *perkChanges = [NSMutableArray array];
    
    for (Perk *perk in self.perks)
    {
        NSDictionary *perkDict = @{kPerk: perk.name, kPerkChange: @(PerkChangeAdded)};
        [perkChanges addObject:perkDict];
    }
    
    if (perkChanges.count > 0)
    {
        dictionary[kPerkChanges] = perkChanges;
    }
    
    return [dictionary copy];
}

@end
