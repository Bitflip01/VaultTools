//
//  Character.h
//  Vault Tools
//
//  Created by Alexander Heemann on 02/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SPECIAL.h"
#import "Perk.h"
#import "PerkDescription.h"

@class StatsSnapshot;
@class HistorySnapshot;

NS_ASSUME_NONNULL_BEGIN

@interface Character : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (void)setupDefault;
- (void)setSpecial:(SPECIAL *)special;
- (void)save;
- (void)incrementSPECIALPoints;
- (void)decrementSPECIALPoints;
- (BOOL)canCharacterTakePerk:(PerkDescription *)perk atRank:(NSInteger)rank;
- (BOOL)hasEnoughSpecialPointsForPerk:(PerkDescription *)perk;
- (Perk *)perkForPerkDescription:(PerkDescription *)perkDescription;
- (NSInteger)specialValueForType:(SPECIALType)type;
- (BOOL)hasTakenPerkWithName:(NSString *)name;
- (void)reset;
- (void)levelUp;
- (void)levelDown;
- (StatsSnapshot *)snapshotForCurrentLevel;
- (void)deleteSnapshotsAndPerks;

/**
 * Validates perks to remove invalid ones and return the corresponding perk points.
 */
- (void)validatePerks;

- (NSInteger)health;
- (NSInteger)carryWeight;
- (NSInteger)actionPoints;

@end

NS_ASSUME_NONNULL_END

#import "Character+CoreDataProperties.h"
