//
//  Perk.h
//  Vault Tools
//
//  Created by Alexander Heemann on 02/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PerkDescription.h"

@class StatsSnapshot;
@class Character;
NS_ASSUME_NONNULL_BEGIN

@interface Perk : NSManagedObject

- (void)setupWithPerkDescription:(PerkDescription *)perkDescription;
- (BOOL)isEqualToPerk:(Perk *)perk;

@end

NS_ASSUME_NONNULL_END

#import "Perk+CoreDataProperties.h"
