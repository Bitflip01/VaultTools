//
//  SnapshotHistoryHelper.m
//  VaultApp
//
//  Created by Alexander Heemann on 18/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "SnapshotHistoryHelper.h"
#import "StatsSnapshot.h"

@implementation SnapshotHistoryHelper

+ (NSArray *)snapshotsForHistoryFromSnapshots:(NSArray *)snapshots
{
    NSMutableArray *mutableSnapshots = [NSMutableArray array];
    
    for (StatsSnapshot *snapshot in snapshots)
    {
        
    }
    return [mutableSnapshots copy];
}

@end
