//
//  HWAuthorizationViewController+AuthViewTransitionSubtype.m
//  HealthyWay
//
//  Created by Eugenity on 08.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAuthorizationViewController+AuthViewTransitionSubtype.h"

@implementation HWAuthorizationViewController (AuthViewTransitionSubtype)

- (NSString *)authViewTransitionSubtypeForSourceAuthViewType:(HWAuthViewType)sourceType
                                             destinationType:(HWAuthViewType)destinationType
{
    switch (sourceType) {
        case HWAuthViewTypeSignIn:
            switch (destinationType) {
                case HWAuthViewTypeForgotPassword:
                    return kCATransitionFromLeft;
                case HWAuthViewTypeSignUp:
                    return kCATransitionFromRight;
                default: break;
        }
        case HWAuthViewTypeSignUp:
            return kCATransitionFromLeft;
        case HWAuthViewTypeForgotPassword:
            return kCATransitionFromRight;
    }
}

@end
