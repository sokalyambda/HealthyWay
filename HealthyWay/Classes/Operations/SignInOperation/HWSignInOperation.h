//
//  HWSignInOperation.h
//  HealthyWay
//
//  Created by Eugene Sokolenko on 08.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

@class HWBaseViewController;

@interface HWSignInOperation : NSOperation

@property (strong, nonatomic, readonly) HWBaseViewController *viewController;
@property (strong, nonatomic, readonly) FIRUser *fetchedUser;
@property (strong, nonatomic, readonly) NSError *error;
@property (strong, nonatomic, readonly) NSString *email;
@property (strong, nonatomic, readonly) NSString *password;

- (instancetype)initWithViewController:(HWBaseViewController *)viewController email:(NSString *)email password:(NSString *)password;

@end
