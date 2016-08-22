//
//  HWTask.h
//  HealthyWay
//
//  Created by Eugenity on 15.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

typedef void(^TaskSuccess)();
typedef void(^TaskFailure)(NSError *error);

@protocol HWTask <NSObject>

@property (strong, nonatomic, readonly) NSError *error;

@property (copy, nonatomic, readonly) TaskSuccess successBlock;
@property (copy, nonatomic, readonly) TaskFailure failureBlock;

- (void)performCurrentTaskOnSuccess:(TaskSuccess)success
                          onFailure:(TaskFailure)failure;

@end
