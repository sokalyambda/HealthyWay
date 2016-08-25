//
//  HWTasksParametersKeys.h
//  HealthyWay
//
//  Created by Eugenity on 25.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#ifndef HWTasksParametersKeys_h
#define HWTasksParametersKeys_h

typedef NS_ENUM(NSUInteger, HWFetchUsersTaskType) {
    HWFetchUsersTaskTypeCurrent,
    HWFetchUsersTaskTypeTypeAll
};

typedef NS_ENUM(NSUInteger, HWSendOrDenyFriendsRequestTaskType) {
    HWSendOrDenyFriendsRequestTaskTypeSend,
    HWSendOrDenyFriendsRequestTaskTypeDeny
};

typedef NS_ENUM(NSUInteger, HWFetchRequestedFriendsTaskType) {
    HWFetchRequestedFriendsTaskTypeIds,
    HWFetchRequestedFriendsTaskTypeEntities
};

// Authorization parameters keys
//input:
static NSString *const TaskKeyEmail = @"email";
static NSString *const TaskKeyPassword = @"password";
static NSString *const TaskKeyConfirmedPassword = @"confirmedPassword";
static NSString *const TaskKeyAuthType = @"authType";
//output:
static NSString *const TaskKeyToken = @"token";

// User Profiles parameters keys
static NSString *const TaskKeyUsersFetchingType = @"fetchType";
static NSString *const TaskKeyUsersSearchString = @"searchText";

static NSString *const TaskKeyFirstName = @"firstName";
static NSString *const TaskKeyLastName = @"lastName";
static NSString *const TaskKeyNickName = @"nickName";
static NSString *const TaskKeyDateOfBirthName = @"dateOfBirth";
static NSString *const TaskKeyAvatarData = @"avatarData";
static NSString *const TaskKeyIsMale = @"isMale";

// Friends Tasks parameters keys

//input:
static NSString *const TaskKeyRemoteUserId = @"remoteUserId";
static NSString *const TaskKeyFriendRequestType = @"friendRequestType";

static NSString *const TaskKeyFetchRequestedFriendsType = @"fetchType";

//output:
static NSString *const TaskKeyRequestedFriendsIds = @"requestedFriendsIds";
static NSString *const TaskKeyRequestedFriends = @"requestedFriends";

static NSString *const TaskKeyRequestingFriends = @"requestingFriends";

#endif /* HWTasksParametersKeys_h */
