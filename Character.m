//
//  Character.m
//  Vault 111
//
//  Created by Alexander Heemann on 02/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "Character.h"

#define START_SPECIAL_POINTS 21

@implementation Character

// Insert code here to add functionality to your managed object subclass

- (void)setupDefault
{
    self.specialPoints = @(START_SPECIAL_POINTS);
    self.dateCreated = [NSDate date];
    self.lastUsed = [NSDate date];
    self.strength = @(0);
    self.perception = @(0);
    self.endurance = @(0);
    self.charisma = @(0);
    self.intelligence = @(0);
    self.agility = @(0);
    self.luck = @(0);
    self.perkPoints = @(0);
    self.level = @(1);
}

@end
