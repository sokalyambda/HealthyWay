//
//  BZRAlertFacade.m
//  BizrateRewards
//
//  Created by Eugenity on 03.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "HWAlertService.h"
#import "HWErrorHandler.h"

#import "HWBaseNavigationController.h"

#import "AppDelegate.h"

NSString *const kErrorAlertTitle = @"AlertTitle";
NSString *const kErrorAlertMessage = @"AlertMessage";

@implementation HWAlertService

#pragma mark - Actions

/**
 *  Show retry internet connection alert
 *
 *  @param completion Completion Block
 */
+ (void)showRetryInternetConnectionAlertForController:(UIViewController *)controller
                                       withCompletion:(void(^)(BOOL retry))completion
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:LOCALIZED(@"Ошибка сети. Попробовать снова?") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Нет") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (completion) {
            completion(NO);
        }
    }];
    UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Да") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (completion) {
            completion(YES);
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:acceptAction];
    
    [self showCurrentAlertController:alertController forController:controller];
}

#pragma mark - Private methods

/**
 *  Show alert controller
 *
 *  @param alertController Alert Controller that should be presented
 */
+ (void)showCurrentAlertController:(UIAlertController *)alertController forController:(UIViewController *)currentController
{
    if (!currentController) {
        UIStoryboard *currentBoard = currentController.storyboard;
        HWBaseNavigationController *navigationController = [currentBoard instantiateInitialViewController];
        UIViewController *lastPresentedViewController = ((UIViewController *)navigationController.viewControllers.lastObject).presentedViewController;
        
        if (lastPresentedViewController) {
            
            if ([lastPresentedViewController.presentedViewController isKindOfClass:[UIAlertController class]] || [lastPresentedViewController isKindOfClass:[UIAlertController class]]) {
                return;
            }
            
            [lastPresentedViewController presentViewController:alertController animated:YES completion:nil];

        } else {
            
            if ([navigationController.visibleViewController isKindOfClass:[UIAlertController class]]) {
                return;
            }
            
            [navigationController presentViewController:alertController animated:YES completion:nil];
        }
    } else {
        [currentController presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - Alerts

/**
 *  Show error alert with title and message
 *
 *  @param title      Alert Title
 *  @param error      Alert Message
 *  @param completion Completion Block
 */
+ (void)showAlertWithTitle:(NSString *)title
                  andError:(NSError *)error
             forController:(UIViewController *)controller
            withCompletion:(void(^)(void))completion
{
    if (!error) {
        return;
    }
    
    NSMutableString *errStr = [NSMutableString stringWithString: LOCALIZED(@"Error")];

    [errStr appendFormat:@"\n%@", error.localizedDescription];
    
    if (error.localizedFailureReason)
        [errStr appendFormat:@"\n%@", error.localizedFailureReason];
    
    if (error.localizedRecoverySuggestion)
        [errStr appendFormat:@"\n%@", error.localizedRecoverySuggestion];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LOCALIZED(title) message:errStr preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:LOCALIZED(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (completion) {
            completion();
        }
    }];
    
    [alertController addAction:okAction];
    [self showCurrentAlertController:alertController forController:controller];
}

/**
 *  Show alert with error
 *
 *  @param error      Error that should be parsed
 *  @param completion Completion Block
 */
+ (void)showErrorAlert:(NSError *)error
         forController:(UIViewController *)controller
        withCompletion:(void(^)(void))completion
{
    [self showAlertWithTitle:@"" andError:error forController:controller withCompletion:completion];
}

/**
 *  Show alert with title and message
 *
 *  @param title      Alert Title
 *  @param message    Alert Message
 *  @param completion Completion Block
 */
+ (void)showAlertWithTitle:(NSString *)title
                andMessage:(NSString *)message
             forController:(UIViewController *)currentController
            withCompletion:(void(^)(void))completion
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:LOCALIZED(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (completion) {
            completion();
        }
    }];
    
    [alertController addAction:okAction];
    [self showCurrentAlertController:alertController forController:currentController];
}

/**
 *  Show Alert with message
 *
 *  @param message    Alert Message
 *  @param completion Completion Block
 */
+ (void)showAlertWithMessage:(NSString *)message
               forController:(UIViewController *)controller
              withCompletion:(void(^)(void))completion
{
    [self showAlertWithTitle:@"" andMessage:message forController:controller withCompletion:completion];
}

/**
 *  Show response error alert
 *
 *  @param error      Error that shoud be parsed
 *  @param completion Completion Block
 */
+ (void)showFailureResponseAlertWithError:(NSError *)error
                            forController:(UIViewController *)controller
                            andCompletion:(void(^)(void))completion
{
    if (!error) {
        return;
    }
    
    WEAK_SELF;
    [HWErrorHandler parseError:error withCompletion:^(NSString *alertTitle, NSString *alertMessage) {
        [weakSelf showAlertWithTitle:alertTitle andMessage:alertMessage forController:controller withCompletion:completion];
    }];
}

/**
 *  Show dialog alert with completion and two buttons (ok and cancel)
 *
 *  @param message    Message for alert
 *  @param controller Presenting controller
 *  @param completion Completion Block
 */
+ (void)showDialogAlertWithMessage:(NSString *)message forController:(UIViewController *)controller withCompletion:(void(^)(BOOL cancel))completion
{
    [self showDialogAlertWithTitle:@"" message:message forController:controller withCompletion:completion];
}

+ (void)showDialogAlertWithTitle:(NSString *)title message:(NSString *)message forController:(UIViewController *)controller withCompletion:(void(^)(BOOL cancel))completion
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Да") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (completion) {
            completion(NO);
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Нет") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (completion) {
            completion(YES);
        }
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self showCurrentAlertController:alertController forController:controller];
}

@end
