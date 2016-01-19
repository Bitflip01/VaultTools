//
//  SPECIAL.h
//  Vault Tools
//
//  Created by Alexander Heemann on 01/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SPECIALType)
{
    SPECIALTypeStrength,
    SPECIALTypePerception,
    SPECIALTypeEndurance,
    SPECIALTypeCharisma,
    SPECIALTypeIntelligence,
    SPECIALTypeAgility,
    SPECIALTypeLuck,
};

@interface SPECIAL : NSObject

+ (NSString *)nameForType:(SPECIALType)type;
+ (SPECIALType)specialTypeForName:(NSString *)name;

- (instancetype)initWithType:(SPECIALType)type;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readwrite) NSUInteger value;
@property (nonatomic, assign, readwrite) SPECIALType type;

@end
