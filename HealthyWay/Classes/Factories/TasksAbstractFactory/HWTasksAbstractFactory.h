//
//  HWTasksAbstractFactory.h
//  HealthyWay
//
//  Created by Eugenity on 25.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

typedef NS_ENUM(NSUInteger, HWTaskType) {
    HWTaskTypeAutologin,
    HWTaskTypeFetchUsers,
    HWTaskTypeCreateUpdateUserProfile,
    HWTaskTypeAuthorization,
    HWTaskTypeSendOrDenyFriendsRequest,
    HWTaskTypeFetchRequestedFriends,
    HWTaskTypeFetchRequestingFriends
};

#import "HWTask.h"

@protocol HWTasksAbstractFactory <NSObject>

- (id<HWTask>)taskWithType:(HWTaskType)taskType
             andParameters:(NSDictionary *)parameters;

@end
