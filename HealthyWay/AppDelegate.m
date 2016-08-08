//
//  AppDelegate.m
//  HealthyWay
//
//  Created by Eugenity on 24.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - Application Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FIRApp configure];

    // If it is the first launch - check whether the user exists and if so - sign out it;
    [[HWBaseAppManager sharedManager] signOutIfFirstLaunch];
    
    return YES;
}

@end
