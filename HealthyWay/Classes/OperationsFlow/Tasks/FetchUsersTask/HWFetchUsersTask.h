//
//  HWFetchUsersTask.h
//  HealthyWay
//
//  Created by Eugenity on 15.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWUserProfile.h"

#import "HWBaseTask.h"

@interface HWFetchUsersTask : HWBaseTask

- (instancetype)initWithUsersFetchingType:(HWFetchUsersTaskType)fetchType;
- (instancetype)initWithUsersFetchingType:(HWFetchUsersTaskType)fetchType
                             searchString:(NSString *)searchedText;

@end
