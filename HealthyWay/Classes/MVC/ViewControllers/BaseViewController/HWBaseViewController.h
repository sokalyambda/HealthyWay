//
//  BaseViewController.h
//  HealthyWay
//
//  Created by Eugenity on 24.06.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

@interface HWBaseViewController : UIViewController

// For Validation Alert Purposes
- (void)showAlertViewForErrors:(NSArray *)errors;

// Show hud
- (void)showProgressHud;
- (void)hideProgressHud;

// Alerts
- (void)showAlertWithMessage:(NSString *)message
                onCompletion:(void(^)())completion;
- (void)showAlertWithError:(NSError *)error
              onCompletion:(void(^)())completion;

@end
