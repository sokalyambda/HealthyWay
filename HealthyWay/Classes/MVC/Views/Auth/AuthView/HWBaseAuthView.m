//
//  HWAuthView.m
//  HealthyWay
//
//  Created by Eugene Sokolenko on 05.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWBaseAuthView.h"

@implementation HWBaseAuthView

#pragma mark - Accessors

- (void)setEmail:(NSString *)email
{}

- (void)setDelegate:(id<HWAuthViewDelegate>)delegate
{
    _delegate = delegate;
    [self.textFields setValue:_delegate forKey:@"delegate"];
}

#pragma mark - Actions

- (IBAction)performAuthAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(authView:didPrepareForAuthWithType:)]) {
        [self.delegate authView:self didPrepareForAuthWithType:self.authViewType];
    }
}

- (void)didCompleteAuthAction
{
    [self.textFields enumerateObjectsUsingBlock:^(UITextField  *_Nonnull field, NSUInteger idx, BOOL * _Nonnull stop) {
        field.text = @"";
    }];
}

@end
