//
//  HWSendOrDenyFriendsRequestTask.h
//  HealthyWay
//
//  Created by Eugenity on 22.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

typedef NS_ENUM(NSUInteger, HWSendOrDenyFriendsRequestTaskType) {
    HWSendOrDenyFriendsRequestTaskTypeSend,
    HWSendOrDenyFriendsRequestTaskTypeDeny
};

#import "HWBaseTask.h"

@interface HWSendOrDenyFriendsRequestTask : HWBaseTask

- (instancetype)initWithRemoteUserId:(NSString *)remoteUserId
                             andType:(HWSendOrDenyFriendsRequestTaskType)type;

@end
