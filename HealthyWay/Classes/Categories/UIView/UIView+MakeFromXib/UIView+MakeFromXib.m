//
//  UIView+MakeFromXib.m
//
//  Created by Eugenity on 29/08/2014.
//  Copyright (c) 2014 Mobindustry. All rights reserved.
//

#import "UIView+MakeFromXib.h"

@implementation UIView (MakeFromXib)

+ (instancetype)makeFromXibWithFileOwner:(id)owner
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:owner options:nil];
    return [nibs firstObject];
}

+ (instancetype)makeFromXib
{
    return [self makeFromXibWithFileOwner:nil];
}

@end
