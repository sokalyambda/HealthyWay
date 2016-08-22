//
//  HWAuthorizationTask.m
//  HealthyWay
//
//  Created by Eugenity on 15.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAuthorizationTask.h"

#import "HWCredentials.h"

#import "HWAuthorizationService.h"

@interface HWAuthorizationTask ()

@property (assign, nonatomic) HWAuthType authType;

@property (nonatomic) NSError *error;

@end

@implementation HWAuthorizationTask

@synthesize error = _error;

#pragma mark - Accessors

- (NSString *)email
{
    return self.credentials.email;
}

- (NSString *)password
{
    return self.credentials.password;
}

- (NSString *)confirmedPassword
{
    return self.credentials.confirmedPassword;
}

- (void)setCredentials:(HWCredentials *)credentials
{
    _credentials = credentials;
    _authType = _credentials.authType;
}

#pragma mark - Lifecycle

- (instancetype)initWithEmail:(NSString *)email
                     password:(NSString *)password
            confirmedPassword:(NSString *)confirmedPassword
                     authType:(HWAuthType)authType
{
    self = [super init];
    if (self) {
        /**
         *  Call the mutator
         */
        self.credentials = [HWCredentials credentialsWithEmail:email
                                                      password:password
                                             confirmedPassword:confirmedPassword
                                                      authType:authType];
    }
    return self;
}

#pragma mark - Actions

- (void)performCurrentTaskOnSuccess:(TaskSuccess)success
                          onFailure:(TaskFailure)failure
{
    [super performCurrentTaskOnSuccess:success onFailure:failure];
    switch (self.authType) {
        case HWAuthTypeSignIn: {
            [self performSignIn];
            break;
        }
        case HWAuthTypeSignUp: {
            [self performSignUp];
            break;
        }
        case HWAuthTypeForgotPassword: {
            [self performResetPassword];
            break;
        }
    }
}

#pragma mark - Private

/**
 *  Reset password
 */
- (void)performResetPassword
{
    WEAK_SELF;
    [HWValidator validateEmail:self.email onSuccess:^{
        
        [HWAuthorizationService sendPasswordResetWithEmail:weakSelf.email completion:^(NSError * _Nullable error) {
            weakSelf.error = error;
            if (error && weakSelf.failureBlock) {
                return weakSelf.failureBlock(error);
            }
            if (!error && weakSelf.successBlock) {
                weakSelf.successBlock();
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

/**
 *  Sign in user
 */
- (void)performSignIn
{
    WEAK_SELF;
    [HWValidator validateEmail:self.email andPassword:self.password onSuccess:^{
        [HWAuthorizationService signInWithEmail:weakSelf.email password:weakSelf.password completion:^(NSError *error) {
            weakSelf.error = error;
            if (error && weakSelf.failureBlock) {
                return weakSelf.failureBlock(error);
            }
            if (!error && weakSelf.successBlock) {
                weakSelf.successBlock();
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

/**
 *  Sign up user
 */
- (void)performSignUp
{
    WEAK_SELF;
    [HWValidator validateEmail:self.email andPassword:self.password andConfirmPassword:self.confirmedPassword onSuccess:^{
        [HWAuthorizationService signUpWithEmail:weakSelf.email password:weakSelf.password completion:^(NSError * _Nullable error) {
            weakSelf.error = error;
            if (error && weakSelf.failureBlock) {
                return weakSelf.failureBlock(error);
            }
            if (!error && weakSelf.successBlock) {
                weakSelf.successBlock();
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
