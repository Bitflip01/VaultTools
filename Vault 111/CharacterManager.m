//
//  CharacterManager.m
//  Vault 111
//
//  Created by Alexander Heemann on 02/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "CharacterManager.h"

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


@end
