//
//  HWBaseAppManager.m
//  HealthyWay
//
//  Created by Eugenity on 28.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWBaseAppManager.h"

@implementation HWBaseAppManager

#pragma mark - Accessors

- (FIRUser *)currentUser
{
    return self.currentAuth.currentUser;
}

- (FIRAuth *)currentAuth
{
    return [FIRAuth authWithApp:[FIRApp defaultApp]];
}

#pragma mark - Lifecycle

+ (instancetype)sharedManager
{
    static HWBaseAppManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

@end
