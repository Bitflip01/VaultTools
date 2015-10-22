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

NSString *const kPerk = @"kPerk";
NSString *const kPerkRemoved = @"kPerkRemoved";
NSString *const kPerkAdded = @"kPerkAdded";
NSString *const kPerkRankChanged = @"kPerkRankChanged";

@implementation StatsSnapshot

// Insert code here to add functionality to your managed object subclass

- (NSDictionary *)changesSinceSnapshot:(StatsSnapshot *)snapshot
{
    NSMutableDictionary *changes = [NSMutableDictionary dictionary];
    if (!snapshot) return changes;
    
    if ([self.specialPoints integerValue] != [snapshot.specialPoints integerValue])
    {
        changes[kSnapshotSpecialPoints] = @([self.specialPoints integerValue] - [snapshot.specialPoints integerValue]);
    }
    if ([self.perkPoints integerValue] != [snapshot.perkPoints integerValue])
    {
        changes[kSnapshotPerkPoints] = @([self.perkPoints integerValue] - [snapshot.perkPoints integerValue]);
    }
    if ([self.strength integerValue] != [snapshot.strength integerValue])
    {
        changes[kSnapshotStrength] = @([self.strength integerValue] - [snapshot.strength integerValue]);
    }
    if ([self.perception integerValue] != [snapshot.perception integerValue])
    {
        changes[kSnapshotPerception] = @([self.perception integerValue] - [snapshot.perception integerValue]);
    }
    if ([self.endurance integerValue] != [snapshot.endurance integerValue])
    {
        changes[kSnapshotEndurance] = @([self.endurance integerValue] - [snapshot.endurance integerValue]);
    }
    if ([self.charisma integerValue] != [snapshot.charisma integerValue])
    {
        changes[kSnapshotCharisma] = @([self.charisma integerValue] - [snapshot.charisma integerValue]);
    }
    if ([self.intelligence integerValue] != [snapshot.intelligence integerValue])
    {
        changes[kSnapshotIntelligence] = @([self.intelligence integerValue] - [snapshot.intelligence integerValue]);
    }
    if ([self.agility integerValue] != [snapshot.agility integerValue])
    {
        changes[kSnapshotAgility] = @([self.agility integerValue] - [snapshot.agility integerValue]);
    }
    if  ([self.luck integerValue] != [snapshot.luck integerValue])
    {
        changes[kSnapshotLuck] = @([self.luck integerValue] - [snapshot.luck integerValue]);
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
            perkChangeDict[kPerkRankChange] = @([perk.rank integerValue] - [otherPerk.rank integerValue]);
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
            perkChangeDict[kPerkChange] = @(PerkChangeAdded);
            [perkChanges addObject:perkChangeDict];
        }
    }
    
    return [changes copy];
}

@end
