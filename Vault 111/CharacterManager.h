//
//  CharacterManager.h
//  Vault 111
//
//  Created by Alexander Heemann on 02/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Character.h"

@interface CharacterManager : NSObject

+ (CharacterManager *)sharedCharacterManager;
- (void)loadLastCharacter;
- (void)loadLastCharacterOrCreateNew;

@property (nonatomic, strong, readonly) Character *currentCharacter;

@end
