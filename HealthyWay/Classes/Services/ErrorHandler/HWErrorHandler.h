//
//  ALLOErrorHandler.h
//  Allo
//
//  Created by Eugenity on 23.07.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

typedef NS_ENUM(NSInteger, HWErrorCode) {
    HWErrorCodeNotRegistered = -999,
    HWErrorCodeUserDoesntExist,
    HWErrorCodeNeedPasswordForAssignToExistedAccount,
    HWErrorCodeCustomerAlreadyExists,
    HWErrorCodeValidation,
    HWErrorCodeMapping
};

typedef void(^ErrorParsingCompletion)(NSString *alertTitle, NSString *alertMessage);
typedef void(^SocialErrorParsingCompletion)(BOOL isRegistered);

@interface HWErrorHandler : NSObject

+ (BOOL)errorIsNetworkError:(NSError *)error;

+ (void)parseError:(NSError *)error withCompletion:(ErrorParsingCompletion)completion;
+ (void)parseSocialError:(NSError *)error withCompletion:(SocialErrorParsingCompletion)completion;

@end
