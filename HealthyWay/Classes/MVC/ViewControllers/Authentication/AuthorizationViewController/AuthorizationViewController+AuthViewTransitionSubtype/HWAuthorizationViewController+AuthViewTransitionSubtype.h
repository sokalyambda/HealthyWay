//
//  HWAuthorizationViewController+AuthViewTransitionSubtype.h
//  HealthyWay
//
//  Created by Eugenity on 08.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAuthorizationViewController.h"

#import "HWBaseAuthView.h"

@interface HWAuthorizationViewController (AuthViewTransitionSubtype)

- (NSString *)authViewTransitionSubtypeForSourceAuthViewType:(HWAuthViewType)sourceType
                                             destinationType:(HWAuthViewType)destinationType;

@end
