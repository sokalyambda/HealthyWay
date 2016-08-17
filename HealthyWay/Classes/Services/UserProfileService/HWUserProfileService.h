//
//  HWUserProfileService.h
//  HealthyWay
//
//  Created by Eugenity on 12.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

@interface HWUserProfileService : NSObject

/**
 *  Profile changes
 *
 *  @param displayName Display name to be set
 *  @param photoURL    New Photo URL
 *  @param completion  Completion Block
 */
+ (void)performProfileChangesRequestWithDisplayName:(NSString *)displayName
                                           photoURL:(NSURL *)photoURL
                                     withCompletion:(void(^)(NSError *error))completion;

/**
 *  Fetch Current User Data
 *
 *  @param completion Completion Block
 */
+ (void)fetchCurrentUserDataWithCompletion:(void(^)(NSArray *users, NSError *error))completion;

/**
 *  Fetch all users
 *
 *  @param completion CompletionBlock
 */
+ (void)fetchUsersDataWithSearchString:(NSString *)searchString
                          onCompletion:(void(^)(NSArray *users, NSError *error))completion;

/**
 *  Create or update current user profile
 *
 *  @param userProfileParameters Parameters for updation
 *  @param completion            CompletionBlock
 */
+ (void)createUpdateUserProfileWithParameters:(NSDictionary *)userProfileParameters
                                 onCompletion:(void(^)(NSError *error))completion;

@end
