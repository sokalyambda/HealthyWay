//
//  HWOperationsManager.h
//  HealthyWay
//
//  Created by Eugenity on 12.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWBaseOperation.h"

@interface HWOperationsManager : NSObject

+ (instancetype)sharedManager;

- (HWBaseOperation *)enqueueOperationForTask:(HWBaseTask *)task
                                   onSuccess:(SuccessOperationBlock)success
                                   onFailure:(FailureOperationBlock)failure;

@end
