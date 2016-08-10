//
//  HWUserProfileData.h
//  HealthyWay
//
//  Created by Eugenity on 10.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

@interface HWUserProfileData : NSObject

@property (strong, nonatomic, readonly) NSString *firstName;
@property (strong, nonatomic, readonly) NSString *lastName;
@property (strong, nonatomic, readonly) NSString *nickName;
@property (strong, nonatomic, readonly) NSDate *dateOfBirth;
@property (strong, nonatomic, readonly) NSString *avatarBase64;
@property (assign, nonatomic, readonly) BOOL isMale;

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                         nickName:(NSString *)nickName
                      dateOfBirth:(NSDate *)dateOfBirth
                     avatarBase64:(NSString *)avatarBase64
                           isMale:(BOOL)isMale;

@end
