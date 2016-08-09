//
//  HWSignInOperation.m
//  HealthyWay
//
//  Created by Eugene Sokolenko on 08.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

typedef NS_ENUM(NSUInteger, HWAuthorizationOperationErrorType) {
    HWAuthorizationOperationErrorTypeValidation = -999
};

#import "HWAuthorizationOperation.h"

#import "HWCredentials.h"

NSString *const ErrorsArrayKey = @"ErrorsArray";

@interface HWAuthorizationOperation () {
    BOOL _isFinished;
    BOOL _isExecuting;
    BOOL _isReady;
}

@property (strong, nonatomic, readwrite) NSError *error;

@property (strong, nonatomic) FIRAuth *currentAuth;

@property (strong, nonatomic) HWCredentials *credentials;
@property (assign, nonatomic) HWAuthType authType;

@end

@implementation HWAuthorizationOperation

#pragma mark - Accessors

- (BOOL)isExecuting
{
    return _isExecuting;
}

- (BOOL)isFinished
{
    return _isFinished;
}

- (BOOL)isReady
{
    return _isReady;
}

- (BOOL)isAsynchronous
{
    return YES;
}

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

- (FIRAuth *)currentAuth
{
    return [HWBaseAppManager sharedManager].currentAuth;
}

- (void)setCredentials:(HWCredentials *)credentials
{
    _credentials = credentials;
    _authType = _credentials.authType;
}

#pragma mark - Lifecycle

- (instancetype)initWithCredentials:(HWCredentials *)credentials
{
    self = [super init];
    if (self) {
        _isExecuting = NO;
        _isFinished = NO;
        _isReady = NO;
        
        /**
         *  Call the mutator
         */
        self.credentials = credentials;
        
        /**
         *  The operation is ready when all parameters have been set
         */
        [self willChangeValueForKey:@"isReady"];
        _isReady = YES;
        [self didChangeValueForKey:@"isReady"];
    }
    return self;
}

- (void)start
{
    if (![NSThread isMainThread]) {
        return [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
    }
    
    if (self.isCancelled) {
        [self willChangeValueForKey:@"isFinished"];
        _isFinished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    /**
     *  The operation begins executing now
     */
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
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
    if (self.isCancelled) {
        return;
    }
    
    WEAK_SELF;
    [HWValidator validateEmail:self.email onSuccess:^{
        
        if (weakSelf.isCancelled) {
            return;
        }
        
        [weakSelf.currentAuth sendPasswordResetWithEmail:weakSelf.email completion:^(NSError * _Nullable error) {
            weakSelf.error = error;
            [weakSelf completeTheExecution];
        }];
    } onFailure:^(NSMutableArray *errorArray) {
        
        if (weakSelf.isCancelled) {
            return;
        }
        
        NSError *validationError = [NSError errorWithDomain:@"com.eugenity" code:HWAuthorizationOperationErrorTypeValidation userInfo:@{ErrorsArrayKey: errorArray}];
        weakSelf.error = validationError;
        [weakSelf completeTheExecution];
    }];
}

/**
 *  Sign in user
 */
- (void)performSignIn
{
    if (self.isCancelled) {
        return;
    }
    
    WEAK_SELF;
    [HWValidator validateEmail:self.email andPassword:self.password onSuccess:^{
        
        if (weakSelf.isCancelled) {
            return;
        }
        
        [weakSelf.currentAuth signInWithEmail:weakSelf.email password:weakSelf.password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            weakSelf.error = error;
            [weakSelf completeTheExecution];
        }];
    } onFailure:^(NSMutableArray *errorArray) {
        if (weakSelf.isCancelled) {
            return;
        }
        
        NSError *validationError = [NSError errorWithDomain:@"com.eugenity" code:HWAuthorizationOperationErrorTypeValidation userInfo:@{ErrorsArrayKey: errorArray}];
        weakSelf.error = validationError;
        
        [weakSelf completeTheExecution];
    }];
}

/**
 *  Sign up user
 */
- (void)performSignUp
{
    if (self.isCancelled) {
        return;
    }
    
    WEAK_SELF;
    [HWValidator validateEmail:self.email andPassword:self.password andConfirmPassword:self.confirmedPassword onSuccess:^{
        
        if (weakSelf.isCancelled) {
            return;
        }
        
        [weakSelf.currentAuth createUserWithEmail:weakSelf.email password:weakSelf.password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            weakSelf.error = error;
            [weakSelf completeTheExecution];
        }];
        
    } onFailure:^(NSMutableArray *errorArray) {
        
        if (weakSelf.isCancelled) {
            return;
        }
        
        NSError *validationError = [NSError errorWithDomain:@"com.eugenity" code:HWAuthorizationOperationErrorTypeValidation userInfo:@{ErrorsArrayKey: errorArray}];
        weakSelf.error = validationError;
        
        [weakSelf completeTheExecution];
    }];
}

/**
 *  Finish the current operation
 */
- (void)completeTheExecution
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _isExecuting = NO;
    _isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end
