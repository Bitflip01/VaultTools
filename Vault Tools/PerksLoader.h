//
//  PerksLoader.h
//  Vault Tools
//
//  Created by Alexander Heemann on 06/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PerkDescription;
@interface PerksLoader : NSObject

+ (NSArray *)loadPerksFromJSON;
+ (NSArray *)loadPerkDescriptionsFromJSON;
+ (NSDictionary *)loadPerksDictionaryFromJSON;
+ (PerkDescription *)perkDescriptionForName:(NSString *)name;

@end
