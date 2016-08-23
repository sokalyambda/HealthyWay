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
                                andAvatarData:(NSData *)data
                                 onCompletion:(void(^)(NSError *error))completion;

/**
 *  Send friends request to specific user
 *
 *  @param userId     User to be friends with
 *  @param completion Completion block
 */
+ (void)sendFriendsRequestForUserWithId:(NSString *)userId
                           onCompletion:(void(^)(NSError *error))completion;

/**
 *  Deny friends request to specific user
 */
+ (void)denyFriendsRequestForUserWithId:(NSString *)userId
                           onCompletion:(void(^)(NSError *error))completion;

/**
 *  Fetch current user's requested friends ids
 *
 *  @param completion Completion Block
 */
+ (void)fetchRequestedFriendsIdsOnCompletion:(void(^)(NSArray *requestedFriendsIds))completion;

/**
 *  Get array of requested friends
 *
 *  @param completion Completion Block
 */
+ (void)fetchRequestedFriendsOnCompletion:(void(^)(NSArray *requestedFriends))completion;

/**
 *  Get arrat of requesting friends
 *
 *  @param completion Completion Block
 */
+ (void)fetchRequestingFriendsOnCompletion:(void(^)(NSArray *requestingFriends))completion;

@end
