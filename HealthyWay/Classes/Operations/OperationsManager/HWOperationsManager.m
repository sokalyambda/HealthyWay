//
//  HWOperationsManager.m
//  HealthyWay
//
//  Created by Eugenity on 12.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWOperationsManager.h"

@implementation HWOperationsManager

#pragma mark - Lifecycle

+ (instancetype)sharedManager
{
    static HWOperationsManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

@end
