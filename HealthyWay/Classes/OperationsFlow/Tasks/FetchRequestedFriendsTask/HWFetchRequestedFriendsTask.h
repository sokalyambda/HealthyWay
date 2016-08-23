//
//  HWFetchRequestedFriendsTask.h
//  HealthyWay
//
//  Created by Eugenity on 22.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

typedef NS_ENUM(NSUInteger, HWFetchRequestedFriendsTaskType) {
    HWFetchRequestedFriendsTaskTypeIds,
    HWFetchRequestedFriendsTaskTypeEntities
};

#import "HWBaseTask.h"

/**
 *  This task is needed for fetching the users I want to be a friend with;
 */
@interface HWFetchRequestedFriendsTask : HWBaseTask

@property (strong, nonatomic, readonly) NSArray *requestedFriendsIds;
@property (strong, nonatomic, readonly) NSArray *requestedFriends;

- (instancetype)initWithFetchType:(HWFetchRequestedFriendsTaskType)type;

@end
