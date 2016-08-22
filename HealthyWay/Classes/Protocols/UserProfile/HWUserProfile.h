//
//  HWUserProfile.h
//  HealthyWay
//
//  Created by Eugenity on 11.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

@protocol HWUserProfile <NSObject>

@property (strong, nonatomic, readonly) NSString *firstName;
@property (strong, nonatomic, readonly) NSString *lastName;
@property (strong, nonatomic, readonly) NSString *fullName;
@property (strong, nonatomic, readonly) NSString *nickName;
@property (strong, nonatomic, readonly) NSDate *dateOfBirth;
@property (strong, nonatomic, readonly) NSString *avatarBase64;
@property (strong, nonatomic, readonly) NSNumber *isMale;
@property (strong, nonatomic, readonly) NSString *userId;

@end
