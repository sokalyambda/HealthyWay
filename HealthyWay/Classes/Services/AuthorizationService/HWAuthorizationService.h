//
//  HWAuthorizationService.h
//  HealthyWay
//
//  Created by Eugenity on 12.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

@interface HWAuthorizationService : NSObject

/**
 *  Call as soon as possible for app initialization
 */
+ (void)authorizeFirebaseApp;

/**
 *  Perform sign out if an app launches first time
 */
+ (void)signOutIfFirstLaunch;

/**
 *  Get Authorization Token
 *
 *  @param completion Completion Block
 */
+ (void)getTokenWithCompletion:(void(^)(NSString *token, NSError *error))completion;

/**
 *  Send reset password request
 *
 *  @param email Email to send the reset password letter
 *  @param completion Completion Block
 */
+ (void)sendPasswordResetWithEmail:(NSString *)email
                        completion:(void(^)(NSError *error))completion;

/**
 *  Perform sign in with email
 *
 *  @param email      Email
 *  @param password   Password
 *  @param completion Completion Block
 */
+ (void)signInWithEmail:(NSString *)email
               password:(NSString *)password
             completion:(void(^)())completion;

/**
 *  Create user with email
 *
 *  @param email      Email
 *  @param password   Password
 *  @param completion Completion Block
 */
+ (void)signUpWithEmail:(NSString *)email
               password:(NSString *)password
             completion:(void(^)(NSError *error))completion;


@end
