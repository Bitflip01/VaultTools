//
//  PerksLoader.h
//  Vault 111
//
//  Created by Alexander Heemann on 06/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PerkDescription;
@interface PerksLoader : NSObject

+ (NSArray *)loadPerksFromJSON;
+ (NSArray *)loadPerkDescriptionsFromJSON;
+ (PerkDescription *)perkDescriptionForName:(NSString *)name;

@end
