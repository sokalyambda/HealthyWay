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
@property (nonatomic, readwrite) NSDictionary *outputFields;

@end

@implementation HWAutologinTask

@synthesize error = _error;
@synthesize outputFields = _outputFields;

#pragma mark - HWTask

- (void)performCurrentTaskOnSuccess:(TaskSuccess)success
                          onFailure:(TaskFailure)failure
{
    [super performCurrentTaskOnSuccess:success onFailure:failure];
    WEAK_SELF;
    [HWAuthorizationService getTokenWithCompletion:^(NSString *token, NSError *error) {
        
        weakSelf.error = error;
        
        if (token) {
            weakSelf.outputFields = @{TaskKeyToken: token};
        }
        
        if (error && failure) {
            return failure(error);
        }
        if (!error && success) {
            return success();
        }
        
    }];
}

@end
