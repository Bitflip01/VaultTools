//
//  Perk+CoreDataProperties.h
//  Vault 111
//
//  Created by Alexander Heemann on 02/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
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

@end

NS_ASSUME_NONNULL_END
