//
//  HWBaseOperation.h
//  HealthyWay
//
//  Created by Eugenity on 10.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

@class HWBaseTask;

@interface HWBaseOperation : NSOperation

typedef void (^SuccessOperationBlock)(HWBaseOperation* operation);
typedef void (^FailureOperationBlock)(HWBaseOperation* operation, NSError* error, BOOL isCanceled);

@property (strong, nonatomic, readonly) HWBaseTask *task;

@property (strong, nonatomic, readonly) NSError *error;

+ (instancetype)operationWithTask:(HWBaseTask *)task;

@end
