//
//  HWUpdateEmailTask.m
//  HealthyWay
//
//  Created by Anastasia Mark on 07.09.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWUpdateEmailTask.h"

#import "HWAuthorizationService.h"

@interface HWUpdateEmailTask ()

@property (strong, nonatomic) NSString *email;

@property (nonatomic) NSError *error;

@end

@implementation HWUpdateEmailTask

@synthesize error = _error;

#pragma mark - Lifecycle

- (instancetype)initWithEmail:(NSString *)email
{
    self = [super init];
    if (self) {
        _email = email;
    }
    return self;
}

#pragma mark - Actions

- (void)performCurrentTaskOnSuccess:(TaskSuccess)success
                          onFailure:(TaskFailure)failure
{
    [super performCurrentTaskOnSuccess:success onFailure:failure];
    WEAK_SELF;
    [HWValidator validateEmail:self.email onSuccess:^{
        [HWAuthorizationService updateEmail:weakSelf.email completion:^(NSError *error) {
            weakSelf.error = error;
            if (error && weakSelf.failureBlock) {
                return weakSelf.failureBlock(error);
            }
            if (!error && weakSelf.successBlock) {
                weakSelf.successBlock();
            }
            if (error && weakSelf.successBlock) {
                return weakSelf.failureBlock(error);
            }
        }];
    } onFailure:^(NSMutableArray *errorArray) {
        NSError *validationError = [NSError errorWithDomain:@"com.validation.error" code:HWErrorCodeValidation userInfo:@{ErrorsArrayKey: errorArray}];
        weakSelf.error = validationError;
        [HWValidator cleanValidationErrorArray];
        if (weakSelf.failureBlock) {
            weakSelf.failureBlock(validationError);
        }
    }];
    
     
}

@end
