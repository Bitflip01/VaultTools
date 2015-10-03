//
//  Character+CoreDataProperties.h
//  
//
//  Created by Alexander Heemann on 03/10/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Character.h"
#import "Perk.h"

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
@property (nullable, nonatomic, retain) NSDate *dateCreated;
@property (nullable, nonatomic, retain) NSDate *lastUsed;
@property (nullable, nonatomic, retain) NSNumber *specialPoints;
@property (nullable, nonatomic, retain) NSNumber *perkPoints;
@property (nullable, nonatomic, retain) NSSet<Perk *> *perks;

@end

@interface Character (CoreDataGeneratedAccessors)

- (void)addPerksObject:(Perk *)value;
- (void)removePerksObject:(Perk *)value;
- (void)addPerks:(NSSet<Perk *> *)values;
- (void)removePerks:(NSSet<Perk *> *)values;

@end

NS_ASSUME_NONNULL_END
