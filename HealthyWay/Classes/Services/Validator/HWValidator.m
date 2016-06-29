//
//  Validator.m
//  Allo
//
//  Created by Eugenity on 26.05.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "HWValidator.h"

static const NSInteger kMinPasswordSymbols = 6.f;
static const NSInteger kMaxPasswordSymbols = 16.f;
static const NSInteger kMaxNameCharacters = 30.f;

static NSString *const kEmailErrorImageName = @"";
static NSString *const kPasswordErrorImageName = @"";

NSString *const kValidationErrorField = @"validationErrorField";
NSString *const kValidationErrorMessage = @"validationErrorMessage";

@implementation HWValidator

static NSMutableArray *_errorArray;

#pragma mark - Accessors

+ (NSMutableArray *)validationErrorArray
{
    @synchronized(self) {
        if (!_errorArray) {
            _errorArray = [NSMutableArray array];
        }
        return _errorArray;
    }
}

+ (void)setValidationErrorArray:(NSMutableArray *)validationErrorArray
{
    @synchronized(self) {
        _errorArray = validationErrorArray;
    }
}

#pragma mark - Private methods

/**
 *  Validation of email field
 *
 *  @param emailField Current email field
 *
 *  @return Returns 'YES' if email is valid
 */
+ (BOOL)validateEmailField:(UITextField *)emailField
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if (!emailField.text.length) {
        [self setErrorField:emailField andMessage:LOCALIZED(@"Это поле обязательно для заполнения.\n")];
        return NO;
    } else if (![emailTest evaluateWithObject:emailField.text]) {
        [self setErrorField:emailField andMessage:LOCALIZED(@"Пожалуйста, введите действительный адрес электронной почты. Например johndoe@domain.com.\n")];
        /*
        [emailField shakeView];
         */
        return NO;
    }
    return YES;
}

/**
 *  Validation of password field
 *
 *  @param passwordField Current password field
 *
 *  @return Returns 'YES' if password is valid
 */
+ (BOOL)validatePasswordField:(UITextField *)passwordField
{
    NSString *passwordRegex = [NSString stringWithFormat:@"^.{%li,%li}$", (long)kMinPasswordSymbols, (long)kMaxPasswordSymbols];
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    BOOL isMatchSuccess = [passwordTest evaluateWithObject:passwordField.text];
    
    if (!passwordField.text.length) {
        
        [self setErrorField:passwordField andMessage:LOCALIZED(@"Это поле обязательно для заполнения.\n")];
        return NO;
    } else if (!isMatchSuccess) {
        
        [self setErrorField:passwordField andMessage:LOCALIZED(@"Количество символов не менее 6.\n")];
        /*
        [passwordField shakeView];
         */
        return NO;
    }
    
    return YES;
}

+ (BOOL)validateFirstNameField:(UITextField *)firstNameField
{
    if (!firstNameField.text.length || firstNameField.text.length > kMaxNameCharacters) {
        /*
        [firstNameField shakeView];
         */
        [self setErrorField:firstNameField andMessage:LOCALIZED(@"Это поле обязательно для заполнения.\n")];
        
        return NO;
    }
    return YES;
}

+ (BOOL)validatePhoneField:(UITextField *)phoneField
{
    NSString *text = [[[[phoneField.text stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (!text) {
        [self setErrorField:phoneField andMessage:LOCALIZED(@"Это поле обязательно для заполнения.\n")];
        return NO;
    }
    return YES;
}

+ (BOOL)validatePasswordField:(UITextField *)passwordField andConfirmPasswordField:(UITextField *)confirmPasswordField
{
    BOOL isValid = YES;
    
    if (![self validatePasswordField:passwordField]) {
        return NO;
    }
    
    if (![passwordField.text isEqualToString:confirmPasswordField.text]) {

        [self setErrorField:confirmPasswordField andMessage:LOCALIZED(@"Password does not match the confirm password\n")];
        [self setErrorField:passwordField andMessage:LOCALIZED(@"Password does not match the confirm password\n")];
        
        /*
        [confirmPasswordField shakeView];
         */
        
        isValid = NO;
    }
    return isValid;
}

#pragma mark - Public methods

/**
 *  Public Validation Methods
 *
 *  @param currentField Current field for validation
 *  @param success      Success Block
 *  @param failure      Failure Block
 */

+ (void)validateFirstNameField:(UITextField *)firstNameField
                     onSuccess:(ValidationSuccessBlock)success
                     onFailure:(ValidationFailureBlock)failure
{
    if (![self validateFirstNameField:firstNameField] && failure) {
        
        failure([self validationErrorArray]);
        
    } else if (success) {
        success();
    }
}

+ (void)validateEmailField:(UITextField *)emailField
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure
{
    if (![self validateEmailField:emailField] && failure) {

        failure([self validationErrorArray]);
        
    } else if (success) {
        success();
    }
}

+ (void)validateEmailField:(UITextField *)emailField
          andPasswordField:(UITextField *)passwordField
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure
{
    BOOL isValid = YES;
    
    if (![self validateEmailField:emailField]) {
        isValid = NO;
    }
    
    if (![self validatePasswordField:passwordField]) {
        isValid = NO;
    }
    
    if (!isValid && failure) {
        failure([self validationErrorArray]);
    } else if (success) {
        success();
    }
}

+ (void)validateEmailField:(UITextField *)emailField
          andPasswordField:(UITextField *)passwordField
         andFirstNameField:(UITextField *)firstNameField
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure
{
    BOOL isValid = YES;
    
    if (![self validateEmailField:emailField]) {
        isValid = NO;
    }
    
    if (![self validatePasswordField:passwordField]) {
        isValid = NO;
    }
    
    if (![self validateFirstNameField:firstNameField]) {
        isValid = NO;
    }
    
    if (!isValid && failure) {
        failure([self validationErrorArray]);
    } else if (success) {
        success();
    }
}

+ (void)validateEmailField:(UITextField *)emailField
          andPasswordField:(UITextField *)passwordField
   andConfirmPasswordField:(UITextField *)confirmPassword
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure
{
    BOOL isValid = YES;
    
    if (![self validateEmailField:emailField]) {
        isValid = NO;
    }
    if (![self validatePasswordField:passwordField andConfirmPasswordField:confirmPassword]) {
        isValid = NO;
    }
    
    if (!isValid && failure) {
        failure([self validationErrorArray]);
    } else if (success) {
        success();
    }
}

+ (void)validateEmailField:(UITextField *)emailField
                phoneField:(UITextField *)phoneField
         andFirstNameField:(UITextField *)firstNameField
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure
{
    BOOL isValid = YES;
    
    if (![self validateEmailField:emailField]) {
        isValid = NO;
    }
    if (![self validateFirstNameField:firstNameField]) {
        isValid = NO;
    }
    if (![self validatePhoneField:phoneField]) {
        isValid = NO;
    }
    
    if (!isValid && failure) {
        failure([self validationErrorArray]);
    } else if (success) {
        success();
    }
}

+ (void)validatePhoneField:(UITextField *)phoneField
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure
{
    BOOL isValid = YES;

    if (![self validatePhoneField:phoneField]) {
        isValid = NO;
    }
    
    if (!isValid && failure) {
        failure([self validationErrorArray]);
    } else if (success) {
        success();
    }
}

#pragma mark - Other actions

/**
 *  Clean the validation error string, after validation this array should always be cleaned
 */
+ (void)cleanValidationErrorArray
{
    [self setValidationErrorArray:[@[] mutableCopy]];
}

+ (void)setErrorField:(id)errorField andMessage:(NSString *)message
{
    NSDictionary *errorDict = @{
                                kValidationErrorField: errorField,
                                kValidationErrorMessage: message
                                };
    [[self validationErrorArray] addObject:errorDict];
}

@end
