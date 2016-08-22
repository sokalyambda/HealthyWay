//
//  Constants.h
//  HealthyWay
//
//  Created by Eugenity on 01.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

// Keychain service keys
static NSString *const UserNameKey          = @"UsernameKey";
static NSString *const PasswordKey          = @"PasswordKey";
static NSString *const UserCredentialsKey   = @"UserCredentialsKey";
static NSString *const IsFirstLaunch        = @"IsFirstLaunch";

// Firebase Database Keys

static NSString *const UsersKey = @"users";
static NSString *const RequestedFriendsKey = @"requestedFriends";
static NSString *const RequestingFriendsKey = @"requestingFriends";

// Validation

static NSString *const ErrorsArrayKey = @"ErrorsArray";

static NSString *const ErrorMessage = @"Error";
static NSString *const ErrorCode = @"ErrorCode";

#endif /* Constants_h */
