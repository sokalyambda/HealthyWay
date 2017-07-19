//
//  HWAddToFriendTask.m
//  HealthyWay
//
//  Created by Eugenity on 31.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAddToFriendTask.h"

#import "HWUserProfileService.h"

@interface HWAddToFriendTask ()

@property (strong, nonatomic) NSString *userId;

@end

@implementation HWAddToFriendTask

#pragma mark - Lifecycle

- (instancetype)initWithUserId:(NSString *)userId
{
    self = [super init];
    if (self) {
        _userId = userId;
    }
    return self;
}

#pragma mark - Actions

- (void)performCurrentTaskOnSuccess:(TaskSuccess)success
                          onFailure:(TaskFailure)failure
{
    [HWUserProfileService addUserToFriendsWithId:self.userId onCompletion:^(NSError *error) {
        if (!error && success) {
            success();
        } else if (error && failure) {
            failure(error);
        }
    }];
}

@end
