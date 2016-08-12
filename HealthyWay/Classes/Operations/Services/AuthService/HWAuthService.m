//
//  HWAuthService.m
//  HealthyWay
//
//  Created by Eugenity on 29.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAuthService.h"

#import "HWAuthorizationOperation.h"

#import "HWCredentials.h"

@interface HWAuthService ()

@property (strong, nonatomic) NSOperationQueue *authOperations;

@property (strong, nonatomic) HWCredentials *credentials;

@end

@implementation HWAuthService

#pragma mark - Accessors

- (NSOperationQueue *)authOperations
{
    if (!_authOperations) {
        _authOperations = [[NSOperationQueue alloc] init];
        _authOperations.name = @"com_auth_operations_queue";
        _authOperations.maxConcurrentOperationCount = 1;
    }
    return _authOperations;
}

#pragma mark - Lifecycle

- (instancetype)initWithEmail:(NSString *)email
                     password:(NSString *)password
            confirmedPassword:(NSString *)confirmedPassword
                     authType:(HWAuthType)authType
{
    self = [super init];
    if (self) {
        _credentials = [HWCredentials credentialsWithEmail:email
                                                  password:password
                                         confirmedPassword:confirmedPassword
                                                  authType:authType];
    }
    return self;
}

- (HWAuthorizationOperation *)authorizationOperationWithCompletion:(HWAuthorizationCompletion)completion
{
    /**
     Create the auth operation
     
     - returns: Current authorization operation
     */
    HWAuthorizationOperation *operation = [[HWAuthorizationOperation alloc] initWithCredentials:self.credentials];
    [self.authOperations addOperation:operation];
    
    __block HWAuthorizationOperation *weakOperation = operation;
    
    [operation setCompletionBlock:^{
        
        NSError *error = weakOperation.error;
        /**
         *  We have to guarantee that UI things will be performed on the main thread;
         */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (completion) {
                completion(error);
            }
        });
    }];
    return operation;
}

@end
