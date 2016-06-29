//
//  Validator.h
//  Allo
//
//  Created by Eugenity on 26.05.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

typedef void(^ValidationSuccessBlock)(void);
typedef void(^ValidationFailureBlock)(NSMutableArray *errorArray);

extern NSString *const kValidationErrorField;
extern NSString *const kValidationErrorMessage;

@interface HWValidator : NSObject

+ (NSMutableArray *)validationErrorArray;
+ (void)setValidationErrorArray:(NSMutableArray *)validationErrorArray;

+ (void)validateEmailField:(UITextField *)emailField
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure;

+ (void)validateEmailField:(UITextField *)emailField
          andPasswordField:(UITextField *)passwordField
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure;

+ (void)validateEmailField:(UITextField *)emailField
          andPasswordField:(UITextField *)passwordField
         andFirstNameField:(UITextField *)firstNameField
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure;

+ (void)validatePhoneField:(UITextField *)phoneField
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure;
+ (void)validateFirstNameField:(UITextField *)firstNameField
                     onSuccess:(ValidationSuccessBlock)success
                     onFailure:(ValidationFailureBlock)failure;

+ (void)validateEmailField:(UITextField *)emailField
          andPasswordField:(UITextField *)passwordField
   andConfirmPasswordField:(UITextField *)confirmPassword
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure;

+ (void)cleanValidationErrorArray;

@end
