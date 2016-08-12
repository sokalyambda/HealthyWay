//
//  HWAutologinOperation.m
//  HealthyWay
//
//  Created by Eugenity on 12.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAutologinOperation.h"

@interface HWAutologinOperation ()

@property (strong, nonatomic, readwrite) NSError *error;

@property (strong, nonatomic, readwrite) NSString *token;

@end

@implementation HWAutologinOperation

@synthesize error = _error;

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self makeReady];
    }
    return self;
}

#pragma mark - Actioms

- (void)start
{
    if (![NSThread isMainThread]) {
        return [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
    }
    
    if (self.isCancelled) {
        return [self finish:YES];
    }
    
    /**
     *  The operation begins executing now
     */
    [self execute];
    
    [self performAutologin];
}

- (void)performAutologin
{
    if (self.isCancelled) {
        return [self finish:YES];
    }
    
    WEAK_SELF;
    [[HWBaseAppManager sharedManager] getTokenWithCompletion:^(NSString *token, NSError *error) {
        weakSelf.token = token;
        weakSelf.error = error;
        
        [weakSelf completeTheExecution];
    }];
}

@end
