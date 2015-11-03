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
@class Character;

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kSnapshotSpecialPoints;
extern NSString *const kSnapshotPerkPoints;
extern NSString *const kSnapshotStrength;
extern NSString *const kSnapshotPerception;
extern NSString *const kSnapshotEndurance;
extern NSString *const kSnapshotCharisma;
extern NSString *const kSnapshotIntelligence;
extern NSString *const kSnapshotAgility;
extern NSString *const kSnapshotLuck;

extern NSString *const kSpecialChangeRelative;
extern NSString *const kSpecialChangeAbsolute;

extern NSString *const kPerk;
extern NSString *const kPerkChanges;
extern NSString *const kPerkChange;
extern NSString *const kPerkRankChangeRelative;
extern NSString *const kPerkRankChangeAbsolute;

typedef NS_ENUM(NSUInteger, PerkChange)
{
    PerkChangeAdded,
    PerkChangeRemoved,
    PerkChangeRankChanged,
};


@interface StatsSnapshot : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (NSDictionary *)changesSinceSnapshot:(StatsSnapshot *)snapshot;
- (NSDictionary *)dictionaryRepresentation;

@end

NS_ASSUME_NONNULL_END

#import "StatsSnapshot+CoreDataProperties.h"
