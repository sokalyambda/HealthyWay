//
//  HWAuthorizationService.m
//  HealthyWay
//
//  Created by Eugenity on 12.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAuthorizationService.h"

@implementation HWAuthorizationService

#pragma mark - Accessors

+ (FIRUser *)currentUser
{
    return self.currentAuth.currentUser;
}

+ (FIRAuth *)currentAuth
{
    return [FIRAuth authWithApp:[FIRApp defaultApp]];
}

#pragma mark - Actions

+ (void)authorizeFirebaseApp
{
    [FIRApp configure];
}

+ (void)signOutIfFirstLaunch
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults.dictionaryRepresentation.allKeys containsObject:IsFirstLaunch]) {
        if (self.currentUser) {
            NSError *error;
            [self.currentAuth signOut:&error];
            if (error) {
                DLog(@"Error: %@", error.localizedDescription);
            }
        }
        [defaults setBool:NO forKey:IsFirstLaunch];
    }
}

+ (void)getTokenWithCompletion:(void(^)(NSString *token, NSError *error))completion
{
    if (self.currentUser) {
        [self.currentUser getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
            if (completion) {
                completion(token, error);
            }
        }];
    } else {
        NSError *error = [NSError errorWithDomain:@"com.authorization.error" code:HWErrorCodeUserDoesntExist userInfo:@{
                                                                                                                        ErrorMessage: LOCALIZED(@"User doesn't exist.")
                                                                                                                        }];
        if (completion) {
            completion(nil, error);
        }
    }
}

+ (void)sendPasswordResetWithEmail:(NSString *)email
                        completion:(void(^)(NSError *error))completion
{
    [self.currentAuth sendPasswordResetWithEmail:email completion:completion];
}

+ (void)signInWithEmail:(NSString *)email
               password:(NSString *)password
             completion:(void(^)())completion
{
    [self.currentAuth signInWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (completion) {
            completion(error);
        }
    }];
}

+ (void)signUpWithEmail:(NSString *)email
               password:(NSString *)password
             completion:(void(^)(NSError *error))completion
{
    [self.currentAuth createUserWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (completion) {
            completion(error);
        }
    }];
}

+ (void)updateEmail:(NSString *)email
         completion:(void(^)(NSError *error))completion
{
    [self.currentUser updateEmail:email completion:^(NSError * _Nullable error) {
        if (completion) {
            DLog(@"%@", error);
            completion(error);
        }
    }];
}

+ (void)updatePassword:(NSString *)password
            completion:(void(^)(NSError *error))completion
{
    [self.currentUser updatePassword:password completion:^(NSError * _Nullable error) {
        if (completion) {
            completion(error);
        }
    }];
}

@end
