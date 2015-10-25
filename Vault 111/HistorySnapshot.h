//
//  HistorySnapshot.h
//  Vault Tools
//
//  Created by Alexander Heemann on 22/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatsSnapshot.h"

@interface HistorySnapshot : NSObject

@property (nonatomic, strong, readwrite) StatsSnapshot *snapshot;
@property (nonatomic, strong, readwrite) NSDictionary *changes;
@property (nonatomic, strong, readwrite) NSArray *keys;

@end
