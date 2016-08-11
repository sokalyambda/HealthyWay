//
//  HWFetchUsersOperation.h
//  HealthyWay
//
//  Created by Eugenity on 11.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWBaseOperation.h"

#import "HWUserProfile.h"

typedef NS_ENUM(NSUInteger, HWFetchUsersOperationType) {
    HWFetchUsersOperationTypeCurrent,
    HWFetchUsersOperationTypeAll
};

@interface HWFetchUsersOperation : HWBaseOperation

@property (strong, nonatomic, readonly) NSArray<id<HWUserProfile>> *users;

- (instancetype)initWithFetchingType:(HWFetchUsersOperationType)fetchingType;

@end
