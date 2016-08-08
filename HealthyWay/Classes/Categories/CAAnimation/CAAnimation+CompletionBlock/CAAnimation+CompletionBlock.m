//
//  CAAnimation+CompletionBlock.m
//  HealthyWay
//
//  Created by Eugenity on 08.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "CAAnimation+CompletionBlock.h"

@implementation CAAnimation (CompletionBlock)

@dynamic begin;
@dynamic end;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)animationDidStart:(CAAnimation *)anim
{
    if (self.begin) {
        self.begin();
        self.begin = nil;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.end) {
        self.end(flag);
        self.end = nil;
    }
}

@end
