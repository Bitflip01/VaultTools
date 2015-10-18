//
//  StatsSnapshot.h
//  
//
//  Created by Alexander Heemann on 16/10/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Perk;

NS_ASSUME_NONNULL_BEGIN

@interface StatsSnapshot : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (BOOL)hasChangesFromSnapshot:(StatsSnapshot *)snapshot;

@end

NS_ASSUME_NONNULL_END

#import "StatsSnapshot+CoreDataProperties.h"
