//
//  HWBaseAppManager.h
//  HealthyWay
//
//  Created by Eugenity on 28.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

@class HWUserProfileData;

@interface HWBaseAppManager : NSObject

@property (strong, nonatomic, readonly) FIRUser *currentUser;
@property (strong, nonatomic, readonly) FIRAuth *currentAuth;
@property (strong, nonatomic, readonly) FIRDatabaseReference *dataBaseReference;

@property (assign, nonatomic, readonly) BOOL userExists;
@property (strong, nonatomic, readonly) NSString *currentUserId;

@property (strong, nonatomic, readonly) HWUserProfileData *userProfileData;

+ (instancetype)sharedManager;

/**
 *  Perform sign out if an app launches first time
 */
- (void)signOutIfFirstLaunch;

/**
 *  Profile changes
 *
 *  @param displayName Display name to be set
 *  @param photoURL    New Photo URL
 *  @param completion  Completion Block
 */
- (void)performProfileChangesRequestWithDisplayName:(NSString *)displayName
                                           photoURL:(NSURL *)photoURL
                                     withCompletion:(void(^)(NSError *error))completion;

/**
 *  Get Authorization Token
 *
 *  @param completion Completion Block
 */
- (void)getTokenWithCompletion:(void(^)(NSString *token, NSError *error))completion;

/**
 *  Send reset password request
 *
 *  @param email Email to send the reset password letter
 *  @param completion Completion Block
 */
- (void)sendPasswordResetWithEmail:(NSString *)email
                        completion:(void(^)(NSError *error))completion;

/**
 *  Perform sign in with email
 *
 *  @param email      Email
 *  @param password   Password
 *  @param completion Completion Block
 */
- (void)signInWithEmail:(NSString *)email
               password:(NSString *)password
             completion:(void(^)())completion;

/**
 *  Create user with email
 *
 *  @param email      Email
 *  @param password   Password
 *  @param completion Completion Block
 */
- (void)signUpWithEmail:(NSString *)email
               password:(NSString *)password
             completion:(void(^)(NSError *error))completion;

/**
 *  Fetch Current User Data
 *
 *  @param completion Completion Block
 */
- (void)fetchCurrentUserDataWithCompletion:(void(^)(NSArray *users, NSError *error))completion;

/**
 *  Create or update current user profile
 *
 *  @param userProfileParameters Parameters for updation
 *  @param completion            CompletionBlock
 */
- (void)createUpdateUserProfileWithParameters:(NSDictionary *)userProfileParameters onCompletion:(void(^)(NSError *error))completion;

@end
