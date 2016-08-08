//
//  CAAnimation+CompletionBlock.h
//  HealthyWay
//
//  Created by Eugenity on 08.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAAnimation (CompletionBlock)

/// Block called when animation start
@property (copy) void (^begin)(void);

/// Block called when animation stop
@property (copy) void (^end)(BOOL end);

@end
