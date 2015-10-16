//
//  CharacterManager.m
//  Vault 111
//
//  Created by Alexander Heemann on 02/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "CharacterManager.h"

@interface CharacterManager ()

@end

@implementation CharacterManager

+ (CharacterManager *)sharedCharacterManager
{
    static CharacterManager *sharedCharacterManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
                  ^{
                      sharedCharacterManager = [[CharacterManager alloc] init];
                  });
    
    return sharedCharacterManager;
}

- (void)createNewCharacter
{
    self.currentCharacter = [Character MR_createEntity];
    [self.currentCharacter setupDefault];
    [self.currentCharacter save];
}

- (void)loadLastCharacter
{
    self.currentCharacter = [[Character MR_findAllSortedBy:@"lastUsed" ascending:NO] firstObject];
}

- (void)loadLastCharacterOrCreateNew
{
    [self loadLastCharacter];
    if (!self.currentCharacter)
    {
        [self createNewCharacter];
    }
}

- (NSArray *)allCharacters
{
    return [Character MR_findAllSortedBy:@"lastUsed" ascending:NO];
}


@end
