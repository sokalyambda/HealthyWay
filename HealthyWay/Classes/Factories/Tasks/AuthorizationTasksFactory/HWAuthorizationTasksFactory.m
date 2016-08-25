//
//  HWAuthorizationTasksFactory.m
//  HealthyWay
//
//  Created by Eugenity on 25.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAuthorizationTasksFactory.h"

#import "HWAuthorizationTask.h"
#import "HWAutologinTask.h"

@implementation HWAuthorizationTasksFactory

#pragma mark - HWTasksAbstractFactory

- (id<HWTask>)taskWithType:(HWTaskType)taskType
             andParameters:(NSDictionary *)parameters
{
    switch (taskType) {
        case HWTaskTypeAutologin:
            return [[HWAutologinTask alloc] init];
        case HWTaskTypeAuthorization:
            return [[HWAuthorizationTask alloc] initWithEmail:parameters[TaskKeyEmail]
                                                     password:parameters[TaskKeyPassword]
                                            confirmedPassword:parameters[TaskKeyConfirmedPassword]
                                                     authType:[parameters[TaskKeyAuthType] integerValue]];
        default:
            return nil;
    }
}

@end
