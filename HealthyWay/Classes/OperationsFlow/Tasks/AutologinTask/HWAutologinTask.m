//
//  HWAutologinTask.m
//  HealthyWay
//
//  Created by Eugenity on 15.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAutologinTask.h"

#import "HWAuthorizationService.h"

@interface HWAutologinTask ()

@property (nonatomic) NSError *error;
@property (nonatomic) NSString *token;

@end

@implementation HWAutologinTask

@synthesize error = _error;

#pragma mark - HWTask

- (void)performCurrentTaskOnSuccess:(TaskSuccess)success
                          onFailure:(TaskFailure)failure
{
    [super performCurrentTaskOnSuccess:success onFailure:failure];
    WEAK_SELF;
    [HWAuthorizationService getTokenWithCompletion:^(NSString *token, NSError *error) {
        weakSelf.token = token;
        weakSelf.error = error;
        
        if (error && failure) {
            return failure(error);
        }
        if (!error && success) {
            return success();
        }
        
    }];
}

@end
