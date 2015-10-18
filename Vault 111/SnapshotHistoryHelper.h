//
//  SnapshotHistoryHelper.h
//  VaultApp
//
//  Created by Alexander Heemann on 18/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StatsSnapshot;
@interface SnapshotHistoryHelper : NSObject

+ (NSArray *)snapshotsForHistoryFromSnapshots:(NSArray *)snapshots;

@end
