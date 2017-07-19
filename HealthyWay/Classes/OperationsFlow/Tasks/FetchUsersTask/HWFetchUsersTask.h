//
//  HWFetchUsersTask.h
//  HealthyWay
//
//  Created by Eugenity on 15.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWUserProfile.h"

#import "HWBaseTask.h"

typedef NS_ENUM(NSUInteger, HWFetchUsersTaskType) {
    HWFetchUsersTaskTypeCurrent,
    HWFetchUsersTaskTypeTypeAll,
    HWFetchUsersTaskTypeTypeAllExceptExistedFriends
};

@interface HWFetchUsersTask : HWBaseTask

@property (nonatomic, readonly) NSArray<id<HWUserProfile>> *users;

@property (nonatomic, readonly) NSString *searchedText;

- (instancetype)initWithUsersFetchingType:(HWFetchUsersTaskType)fetchType;

- (instancetype)initWithUsersFetchingType:(HWFetchUsersTaskType)fetchType
                             searchString:(NSString *)searchedText;

@end
