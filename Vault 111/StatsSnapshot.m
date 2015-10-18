//
//  StatsSnapshot.m
//  
//
//  Created by Alexander Heemann on 16/10/15.
//
//

#import "StatsSnapshot.h"
#import "Perk.h"

@implementation StatsSnapshot

// Insert code here to add functionality to your managed object subclass

- (BOOL)hasChangesFromSnapshot:(StatsSnapshot *)snapshot
{
    if ([self.specialPoints integerValue] != [snapshot.specialPoints integerValue] ||
        [self.perkPoints integerValue] != [snapshot.perkPoints integerValue] ||
        [self.strength integerValue] != [snapshot.strength integerValue] ||
        [self.perception integerValue] != [snapshot.perception integerValue] ||
        [self.endurance integerValue] != [snapshot.endurance integerValue] ||
        [self.charisma integerValue] != [snapshot.charisma integerValue] ||
        [self.intelligence integerValue] != [snapshot.intelligence integerValue] ||
        [self.agility integerValue] != [snapshot.agility integerValue] ||
        [self.luck integerValue] != [snapshot.luck integerValue]
        )
    {
        
    }
    return NO;
}

@end
