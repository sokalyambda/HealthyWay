//
//  HWAuthorizationViewController+AuthViewTransitionSubtype.m
//  HealthyWay
//
//  Created by Eugenity on 08.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAuthorizationViewController+AuthViewTransitionSubtype.h"

@implementation HWAuthorizationViewController (AuthViewTransitionSubtype)

- (NSString *)authViewTransitionSubtypeForSourceAuthViewType:(HWAuthType)sourceType
                                             destinationType:(HWAuthType)destinationType
{
    switch (sourceType) {
        case HWAuthTypeSignIn:
            switch (destinationType) {
                case HWAuthTypeForgotPassword:
                    return kCATransitionFromLeft;
                case HWAuthTypeSignUp:
                    return kCATransitionFromRight;
                default: break;
        }
        case HWAuthTypeSignUp:
            return kCATransitionFromLeft;
        case HWAuthTypeForgotPassword:
            return kCATransitionFromRight;
    }
}

@end
