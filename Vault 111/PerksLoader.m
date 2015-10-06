//
//  PerksLoader.m
//  Vault 111
//
//  Created by Alexander Heemann on 06/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "PerksLoader.h"

@implementation PerksLoader

+ (NSArray *)loadPerksFromJSON
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Perks" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    return json;
}

@end
