//
//  HWBaseTask.m
//  HealthyWay
//
//  Created by Eugenity on 15.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWBaseTask.h"

@interface HWBaseTask ()

@end

@implementation HWBaseTask

@synthesize error = _error;

#pragma mark - Actions

/**
 *  Abstrace method, shuld be performed in any subclass
 *
 *  @param success Success Completion Block
 *  @param failure Failure Completion Block
 */
- (void)performCurrentTaskOnSuccess:(TaskSuccess)success
                          onFailure:(TaskFailure)failure
{
    return;
}

@end
