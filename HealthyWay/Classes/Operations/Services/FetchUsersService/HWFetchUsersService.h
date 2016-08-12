//
//  HWFetchUsersService.h
//  HealthyWay
//
//  Created by Eugenity on 11.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

typedef void(^HWFetchUsersCompletion)(NSArray *users, NSError *error);

#import "HWFetchUsersOperation.h"

@interface HWFetchUsersService : NSObject

- (instancetype)initWithFetchUsersOperationType:(HWFetchUsersOperationType)fetchType;

- (HWFetchUsersOperation *)fetchUsersWithCompletion:(HWFetchUsersCompletion)completion;

@end
