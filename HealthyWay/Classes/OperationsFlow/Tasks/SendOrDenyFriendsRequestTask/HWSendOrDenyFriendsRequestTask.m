//
//  HWSendOrDenyFriendsRequestTask.m
//  HealthyWay
//
//  Created by Eugenity on 22.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWSendOrDenyFriendsRequestTask.h"

#import "HWUserProfileService.h"

@interface HWSendOrDenyFriendsRequestTask ()

@property (strong, nonatomic) NSString *remoteUserId;
@property (assign, nonatomic) HWSendOrDenyFriendsRequestTaskType type;

@end

@implementation HWSendOrDenyFriendsRequestTask

#pragma mark - Lifecycle

- (instancetype)initWithRemoteUserId:(NSString *)remoteUserId
                             andType:(HWSendOrDenyFriendsRequestTaskType)type
{
    self = [super init];
    
    if (self) {
        _remoteUserId = remoteUserId;
        _type = type;
    }
    
    return self;
}

#pragma mark - Actions

- (void)performCurrentTaskOnSuccess:(TaskSuccess)success
                          onFailure:(TaskFailure)failure
{
    switch (self.type) {
        case HWSendOrDenyFriendsRequestTaskTypeDeny: {
            [HWUserProfileService denyFriendsRequestForUserWithId:self.remoteUserId onCompletion:^(NSError *error) {
                if (!error && success) {
                    success();
                } else if (error && failure) {
                    failure(error);
                }
            }];
            break;
        }
        case HWSendOrDenyFriendsRequestTaskTypeSend: {
            [HWUserProfileService sendFriendsRequestForUserWithId:self.remoteUserId onCompletion:^(NSError *error) {
                if (!error && success) {
                    success();
                } else if (error && failure) {
                    failure(error);
                }
            }];
            break;
        }
        default:
            break;
    }
}

@end
