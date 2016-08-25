//
//  HWTask.h
//  HealthyWay
//
//  Created by Eugenity on 15.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWTasksParametersKeys.h"

typedef void(^TaskSuccess)();
typedef void(^TaskFailure)(NSError *error);

@protocol HWTask <NSObject>

@property (strong, nonatomic, readonly) NSError *error;

@property (strong, nonatomic, readonly) NSDictionary *outputFields;

@property (copy, nonatomic, readonly) TaskSuccess successBlock;
@property (copy, nonatomic, readonly) TaskFailure failureBlock;

- (void)performCurrentTaskOnSuccess:(TaskSuccess)success
                          onFailure:(TaskFailure)failure;

@end
