//
//  BZRAlertFacade.h
//  BizrateRewards
//
//  Created by Eugenity on 03.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

extern NSString *const kErrorAlertTitle;
extern NSString *const kErrorAlertMessage;

@interface HWAlertService : NSObject

//Retry internet connection
+ (void)showRetryInternetConnectionAlertForController:(UIViewController *)controller
                                       withCompletion:(void(^)(BOOL retry))completion;

//Common alerts methods
+ (void)showFailureResponseAlertWithError:(NSError *)error
                            forController:(UIViewController *)controller
                            andCompletion:(void(^)(void))completion;
+ (void)showAlertWithTitle:(NSString *)title
                  andError:(NSError *)error
             forController:(UIViewController *)controller
            withCompletion:(void(^)(void))completion;
+ (void)showErrorAlert:(NSError *)error
         forController:(UIViewController *)controller
        withCompletion:(void(^)(void))completion;
+ (void)showAlertWithTitle:(NSString *)title
                andMessage:(NSString *)message
             forController:(UIViewController *)currentController
            withCompletion:(void(^)(void))completion;
+ (void)showAlertWithMessage:(NSString *)message
               forController:(UIViewController *)controller
              withCompletion:(void(^)(void))completion;
+ (void)showDialogAlertWithMessage:(NSString *)message
                     forController:(UIViewController *)controller
                    withCompletion:(void(^)(BOOL cancel))completion;
+ (void)showDialogAlertWithTitle:(NSString *)title message:(NSString *)message forController:(UIViewController *)controller withCompletion:(void(^)(BOOL cancel))completion;
+ (void)showAlertForEmailEnteringForController:(UIViewController *)controller
                                withCompletion:(void(^)(NSString *email, NSError *error))completion;

@end
