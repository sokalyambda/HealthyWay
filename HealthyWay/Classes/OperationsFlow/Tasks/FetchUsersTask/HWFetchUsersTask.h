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
    HWFetchUsersTaskTypeTypeAll
};

@interface HWFetchUsersTask : HWBaseTask

@property (nonatomic, readonly) NSArray<id<HWUserProfile>> *users;

- (instancetype)initWithUsersFetchingType:(HWFetchUsersTaskType)fetchType;

@end
