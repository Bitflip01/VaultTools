//
//  Character+CoreDataProperties.h
//  Vault 111
//
//  Created by Alexander Heemann on 02/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Character.h"

NS_ASSUME_NONNULL_BEGIN

@interface Character (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *agility;
@property (nullable, nonatomic, retain) NSNumber *charisma;
@property (nullable, nonatomic, retain) NSNumber *endurance;
@property (nullable, nonatomic, retain) NSNumber *intelligence;
@property (nullable, nonatomic, retain) NSNumber *level;
@property (nullable, nonatomic, retain) NSNumber *luck;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *perception;
@property (nullable, nonatomic, retain) NSNumber *strength;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *perks;

@end

@interface Character (CoreDataGeneratedAccessors)

- (void)addPerksObject:(NSManagedObject *)value;
- (void)removePerksObject:(NSManagedObject *)value;
- (void)addPerks:(NSSet<NSManagedObject *> *)values;
- (void)removePerks:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
