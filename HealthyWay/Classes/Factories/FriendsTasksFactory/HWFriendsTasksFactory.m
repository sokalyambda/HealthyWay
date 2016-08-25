//
//  HWFriendsTasksFactory.m
//  HealthyWay
//
//  Created by Eugenity on 25.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWFriendsTasksFactory.h"

#import "HWSendOrDenyFriendsRequestTask.h"
#import "HWFetchRequestedFriendsTask.h"
#import "HWFetchRequestingFriendsTask.h"

@implementation HWFriendsTasksFactory

#pragma mark - HWTasksAbstractFactory

- (id<HWTask>)taskWithType:(HWTaskType)taskType
             andParameters:(NSDictionary *)parameters
{
    switch (taskType) {
        case HWTaskTypeSendOrDenyFriendsRequest:
            
            return [[HWSendOrDenyFriendsRequestTask alloc] initWithRemoteUserId:parameters[TaskKeyRemoteUserId]
                                                                        andType:[parameters[TaskKeyFriendRequestType] integerValue]];
            case HWTaskTypeFetchRequestedFriends:
            return [[HWFetchRequestedFriendsTask alloc] initWithFetchType:[parameters[TaskKeyFetchRequestedFriendsType] integerValue]];
        case HWTaskTypeFetchRequestingFriends:
            return [[HWFetchRequestingFriendsTask alloc] init];
        default:
            return nil;
    }
}

@end
