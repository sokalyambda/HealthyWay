//
//  HWSignInViewController.h
//  HealthyWay
//
//  Created by Eugenity on 24.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWBaseKeyboardHandlerViewController.h"

#import "HWBaseAuthView.h"

@interface HWAuthorizationViewController : HWBaseKeyboardHandlerViewController

@property (strong, nonatomic, readonly) HWBaseAuthView *currentAuthView;

- (void)setupAuthViewWithType:(HWAuthType)authViewType;

@end
