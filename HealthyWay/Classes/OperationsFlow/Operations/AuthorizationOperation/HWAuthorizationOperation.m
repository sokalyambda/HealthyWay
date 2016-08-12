//
//  HWSignInOperation.m
//  HealthyWay
//
//  Created by Eugene Sokolenko on 08.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAuthorizationOperation.h"

#import "HWCredentials.h"

#import "HWAuthorizationService.h"

@interface HWAuthorizationOperation () 

@property (strong, nonatomic, readwrite) NSError *error;

@property (strong, nonatomic) HWCredentials *credentials;
@property (assign, nonatomic) HWAuthType authType;

@end

@implementation HWAuthorizationOperation

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
                                                  authType:authType];;
        
        /**
         *  The operation is ready when all parameters have been set
         */
        [self makeReady];
    }
    return self;
}

- (void)start
{
    if (![NSThread isMainThread]) {
        return [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
    }
    
    if (self.isCancelled) {
        return [self finish:YES];
    }
    
    /**
     *  The operation begins executing now
     */
    [self execute];
    
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
        return [self finish:YES];
    }
    
    WEAK_SELF;
    [HWValidator validateEmail:self.email onSuccess:^{
        
        if (weakSelf.isCancelled) {
            return [weakSelf finish:YES];
        }
        
        [HWAuthorizationService sendPasswordResetWithEmail:weakSelf.email completion:^(NSError * _Nullable error) {
            weakSelf.error = error;
            [weakSelf completeTheExecution];
        }];
    } onFailure:^(NSMutableArray *errorArray) {
        
        if (weakSelf.isCancelled) {
            return [weakSelf finish:YES];
        }
        
        NSError *validationError = [NSError errorWithDomain:@"com.validation.error" code:HWErrorCodeValidation userInfo:@{ErrorsArrayKey: errorArray}];
        weakSelf.error = validationError;
        [HWValidator cleanValidationErrorArray];
        [weakSelf completeTheExecution];
    }];
}

/**
 *  Sign in user
 */
- (void)performSignIn
{
    if (self.isCancelled) {
        return [self finish:YES];
    }
    
    WEAK_SELF;
    [HWValidator validateEmail:self.email andPassword:self.password onSuccess:^{
        
        if (weakSelf.isCancelled) {
            return [weakSelf finish:YES];
        }
        
        [HWAuthorizationService signInWithEmail:weakSelf.email password:weakSelf.password completion:^(NSError *error) {
            weakSelf.error = error;
            [weakSelf completeTheExecution];
        }];
    } onFailure:^(NSMutableArray *errorArray) {
        if (weakSelf.isCancelled) {
            return [weakSelf finish:YES];
        }
        
        NSError *validationError = [NSError errorWithDomain:@"com.validation.error" code:HWErrorCodeValidation userInfo:@{ErrorsArrayKey: errorArray}];
        weakSelf.error = validationError;
        [HWValidator cleanValidationErrorArray];
        
        [weakSelf completeTheExecution];
    }];
}

/**
 *  Sign up user
 */
- (void)performSignUp
{
    if (self.isCancelled) {
        return [self finish:YES];
    }
    
    WEAK_SELF;
    [HWValidator validateEmail:self.email andPassword:self.password andConfirmPassword:self.confirmedPassword onSuccess:^{
        
        if (weakSelf.isCancelled) {
            return [weakSelf finish:YES];
        }
        
        [HWAuthorizationService signUpWithEmail:weakSelf.email password:weakSelf.password completion:^(NSError * _Nullable error) {
            weakSelf.error = error;
            [weakSelf completeTheExecution];
        }];
        
    } onFailure:^(NSMutableArray *errorArray) {
        
        if (weakSelf.isCancelled) {
            return [weakSelf finish:YES];
        }
        
        NSError *validationError = [NSError errorWithDomain:@"com.validation.error" code:HWErrorCodeValidation userInfo:@{ErrorsArrayKey: errorArray}];
        weakSelf.error = validationError;
        [HWValidator cleanValidationErrorArray];
        
        [weakSelf completeTheExecution];
    }];
}

@end
