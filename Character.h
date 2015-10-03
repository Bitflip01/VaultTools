//
//  Character.h
//  Vault 111
//
//  Created by Alexander Heemann on 02/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Character : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (void)setupDefault;

@end

NS_ASSUME_NONNULL_END

#import "Character+CoreDataProperties.h"
