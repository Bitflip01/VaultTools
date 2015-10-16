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
+ (void)save;
- (void)loadLastCharacter;
- (void)loadLastCharacterOrCreateNew;
- (void)createNewCharacter;
- (NSArray *)allCharacters;

@property (nonatomic, strong, readwrite) Character *currentCharacter;

@end
