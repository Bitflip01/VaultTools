//
//  SnapshotHistoryHelper.m
//  Vault Tools
//
//  Created by Alexander Heemann on 18/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "SnapshotHistoryHelper.h"
#import "StatsSnapshot.h"
#import "HistorySnapshot.h"

@implementation SnapshotHistoryHelper

+ (NSArray *)snapshotsForHistoryFromSnapshots:(NSArray *)snapshots
{
    NSArray *sortedSnapshots = [snapshots sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        StatsSnapshot *snapshot1 = (StatsSnapshot *)obj1;
        StatsSnapshot *snapshot2 = (StatsSnapshot *)obj2;
        return [snapshot1.level compare:snapshot2.level];
    }];
    
    NSMutableArray *mutableSnapshots = [NSMutableArray array];
    
    StatsSnapshot *previousSnapshot;
    for (StatsSnapshot *snapshot in sortedSnapshots)
    {
        NSDictionary *changes = [snapshot changesSinceSnapshot:previousSnapshot];
        if (!previousSnapshot || changes.count > 0)
        {
            HistorySnapshot *historySnapshot = [HistorySnapshot new];
            historySnapshot.snapshot = snapshot;
            historySnapshot.changes = changes;
            [mutableSnapshots addObject:historySnapshot];
        }
        
        previousSnapshot = snapshot;
    }
    return [mutableSnapshots copy];
}

@end
