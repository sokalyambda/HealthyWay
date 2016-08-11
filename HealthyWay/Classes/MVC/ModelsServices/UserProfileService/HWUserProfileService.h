//
//  HWUserProfileService.h
//  HealthyWay
//
//  Created by Eugenity on 10.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

typedef void(^HWUserCreateUpdateCompletion)(NSError *error);

@class HWCreateUpdateUserProfileOperation;

@interface HWUserProfileService : NSObject

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                         nickName:(NSString *)nickName
                      dateOfBirth:(NSDate *)dateOfBirth
                     avatarBase64:(NSString *)avatarBase64
                           isMale:(NSNumber *)isMale;

- (HWCreateUpdateUserProfileOperation *)createUpdateUserWithCompletion:(HWUserCreateUpdateCompletion)completion;

@end
