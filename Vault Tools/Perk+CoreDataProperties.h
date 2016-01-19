//
//  Perk+CoreDataProperties.h
//  
//
//  Created by Alexander Heemann on 03/11/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Perk.h"

NS_ASSUME_NONNULL_BEGIN

@interface Perk (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *minLevel;
@property (nullable, nonatomic, retain) NSNumber *minSpecial;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *rank;
@property (nullable, nonatomic, retain) NSNumber *specialType;
@property (nullable, nonatomic, retain) Character *character;
@property (nullable, nonatomic, retain) StatsSnapshot *snapshot;

@end

NS_ASSUME_NONNULL_END
