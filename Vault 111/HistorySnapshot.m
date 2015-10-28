//
//  HistorySnapshot.m
//  Vault Tools
//
//  Created by Alexander Heemann on 22/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "HistorySnapshot.h"

@implementation HistorySnapshot

- (void)setChanges:(NSDictionary *)changes
{
    _changes = changes;
    self.keys = [[changes allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *key1 = obj1;
        NSString *key2 = obj2;
        if ([self orderForKey:key1] > [self orderForKey:key2])
        {
            return NSOrderedDescending;
        }
        else if ([self orderForKey:key1] < [self orderForKey:key2])
        {
            return NSOrderedAscending;
        }
        else
        {
            return NSOrderedSame;
        }
    }];
}

- (NSInteger)orderForKey:(NSString *)key
{
    NSDictionary *order = @{kSnapshotStrength: @(0),
                            kSnapshotPerception: @(1),
                            kSnapshotEndurance: @(2),
                            kSnapshotCharisma: @(3),
                            kSnapshotIntelligence: @(4),
                            kSnapshotAgility: @(5),
                            kSnapshotLuck: @(6),
                            kPerkChanges: @(7),
                            };
    return [order[key] integerValue];
}

- (BOOL)hasSPECIALChanges
{
    return (self.changes[kSnapshotStrength] || self.changes[kSnapshotPerception] || self.changes[kSnapshotEndurance] || self.changes[kSnapshotCharisma] ||
            self.changes[kSnapshotIntelligence] || self.changes[kSnapshotAgility] || self.changes[kSnapshotLuck]);
}

@end
