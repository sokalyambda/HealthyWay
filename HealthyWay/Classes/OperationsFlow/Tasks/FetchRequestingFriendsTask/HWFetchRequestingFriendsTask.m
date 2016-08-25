//
//  HWFetchRequestingFriendsTask.m
//  HealthyWay
//
//  Created by Eugenity on 22.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWFetchRequestingFriendsTask.h"

#import "HWUserProfileService.h"

@interface HWFetchRequestingFriendsTask ()

@property (nonatomic, readwrite) NSDictionary *outputFields;

@end

@implementation HWFetchRequestingFriendsTask

@synthesize outputFields = _outputFields;

#pragma mark - Actions

- (void)performCurrentTaskOnSuccess:(TaskSuccess)success
                          onFailure:(TaskFailure)failure
{
    WEAK_SELF;
    [HWUserProfileService fetchRequestingFriendsOnCompletion:^(NSArray *requestingFriends) {

        weakSelf.outputFields = @{TaskKeyRequestingFriends: requestingFriends};
        
        if (success) {
            success();
        }
    }];
}

@end
