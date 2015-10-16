//
//  Perk.m
//  Vault 111
//
//  Created by Alexander Heemann on 02/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "Perk.h"

@implementation Perk

- (void)setupWithPerkDescription:(PerkDescription *)perkDescription
{
    self.name = perkDescription.name;
    self.rank = @(perkDescription.rank);
    self.specialType = @(perkDescription.specialType);
    self.minSpecial = @(perkDescription.minSpecial);
}

@end
