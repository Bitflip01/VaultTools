//
//  AppDelegate.m
//  Vault Tools
//
//  Created by Alexander Heemann on 01/10/15.
//  Copyright © 2015 Alexander Heemann. All rights reserved.
//

#import "AppDelegate.h"
#import "CharacterManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupAutoMigratingCoreDataStack];
    [[CharacterManager sharedCharacterManager] loadLastCharacterOrCreateNew];
    
    [[CharacterManager sharedCharacterManager].currentCharacter validatePerks];
    [CharacterManager save];
    [self setupAppearance];
    
    return YES;
}

- (void)setupAppearance
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor flatWhiteColor],
                                                         NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:10.0f]}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor flatGreenColor],
                                                         NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:10.0f]}
                                             forState:UIControlStateSelected];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor flatWhiteColor],
                                                           NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:18.0f]
                                                           }];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{
       NSForegroundColorAttributeName: [UIColor flatWhiteColor],
       NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:15.0f]
       }
     forState:UIControlStateNormal];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MagicalRecord cleanUp];
}

@end
