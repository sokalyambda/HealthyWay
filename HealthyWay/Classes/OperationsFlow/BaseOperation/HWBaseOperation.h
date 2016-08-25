//
//  HWBaseOperation.h
//  HealthyWay
//
//  Created by Eugenity on 10.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWTask.h"

@interface HWBaseOperation : NSOperation

typedef void (^SuccessOperationBlock)(HWBaseOperation* operation);
typedef void (^FailureOperationBlock)(HWBaseOperation* operation, NSError* error, BOOL isCanceled);

@property (strong, nonatomic, readonly)id<HWTask> task;

@property (strong, nonatomic, readonly) NSError *error;

+ (instancetype)operationWithTask:(id<HWTask>)task;

@end
