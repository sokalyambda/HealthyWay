//
//  HWAuthView.m
//  HealthyWay
//
//  Created by Eugene Sokolenko on 05.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWBaseAuthView.h"

@implementation HWBaseAuthView

- (void)setDelegate:(id<HWAuthViewDelegate>)delegate
{
    _delegate = delegate;
    [self.textFields setValue:_delegate forKey:@"delegate"];
}

@end
