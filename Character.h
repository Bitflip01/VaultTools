//
//  Character.h
//  Vault 111
//
//  Created by Alexander Heemann on 02/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SPECIAL.h"
#import "PerkDescription.h"

NS_ASSUME_NONNULL_BEGIN

@interface Character : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (void)setupDefault;
- (void)setSpecial:(SPECIAL *)special;
- (void)save;
- (void)incrementSPECIALPoints;
- (void)decrementSPECIALPoints;
- (BOOL)canCharacterTakePerk:(PerkDescription *)perk;
- (NSInteger)specialValueForType:(SPECIALType)type;

@end

NS_ASSUME_NONNULL_END

#import "Character+CoreDataProperties.h"
