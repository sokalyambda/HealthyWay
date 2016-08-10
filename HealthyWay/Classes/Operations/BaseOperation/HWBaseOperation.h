//
//  HWBaseOperation.h
//  HealthyWay
//
//  Created by Eugenity on 10.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

@interface HWBaseOperation : NSOperation {
    BOOL _isFinished;
    BOOL _isExecuting;
    BOOL _isReady;
}

@property (strong, nonatomic, readonly) NSError *error;

- (void)completeTheExecution;

- (void)finish:(BOOL)finish;
- (void)execute;
- (void)makeReady;

@end
