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
 *  Validation of email 
 *
 *  @param email Current email 
 *
 *  @return Returns 'YES' if email is valid
 */
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if (!email.length) {
        [self setErrorMessage:LOCALIZED(@"Это поле обязательно для заполнения.\n")];
        return NO;
    } else if (![emailTest evaluateWithObject:email]) {
        [self setErrorMessage:LOCALIZED(@"Пожалуйста, введите действительный адрес электронной почты. Например johndoe@domain.com.\n")];
        /*
        [email shakeView];
         */
        return NO;
    }
    return YES;
}

/**
 *  Validation of password 
 *
 *  @param password Current password 
 *
 *  @return Returns 'YES' if password is valid
 */
+ (BOOL)validatePassword:(NSString *)password
{
    NSString *passwordRegex = [NSString stringWithFormat:@"^.{%li,%li}$", (long)kMinPasswordSymbols, (long)kMaxPasswordSymbols];
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    BOOL isMatchSuccess = [passwordTest evaluateWithObject:password];
    
    if (!password.length) {
        [self setErrorMessage:LOCALIZED(@"Это поле обязательно для заполнения.\n")];
        return NO;
    } else if (!isMatchSuccess) {
        [self setErrorMessage:LOCALIZED(@"Количество символов не менее 6.\n")];
        return NO;
    }
    
    return YES;
}

+ (BOOL)validateFirstName:(NSString *)firstName
{
    if (!firstName.length || firstName.length > kMaxNameCharacters) {
        [self setErrorMessage:LOCALIZED(@"Это поле обязательно для заполнения.\n")];
        return NO;
    }
    return YES;
}

+ (BOOL)validatePhone:(NSString *)phone
{
    NSString *text = [[[[phone stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!text) {
        [self setErrorMessage:LOCALIZED(@"Это поле обязательно для заполнения.\n")];
        return NO;
    }
    return YES;
}

+ (BOOL)validatePassword:(NSString *)password andConfirmPassword:(NSString *)confirmPassword
{
    BOOL isValid = YES;
    
    if (![self validatePassword:password]) {
        return NO;
    }
    if (![password isEqualToString:confirmPassword]) {
        [self setErrorMessage:LOCALIZED(@"Password does not match the confirm password\n")];
        isValid = NO;
    }
    return isValid;
}

#pragma mark - Public methods

/**
 *  Public Validation Methods
 *
 *  @param success      Success Block
 *  @param failure      Failure Block
 */
+ (void)validateFirstName:(NSString *)firstName
                     onSuccess:(ValidationSuccessBlock)success
                     onFailure:(ValidationFailureBlock)failure
{
    if (![self validateFirstName:firstName] && failure) {
        failure([self validationErrorArray]);
    } else if (success) {
        success();
    }
}

+ (void)validateEmail:(NSString *)email
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure
{
    if (![self validateEmail:email] && failure) {

        failure([self validationErrorArray]);
        
    } else if (success) {
        success();
    }
}

+ (void)validateEmail:(NSString *)email
          andPassword:(NSString *)password
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure
{
    BOOL isValid = YES;
    
    if (![self validateEmail:email]) {
        isValid = NO;
    }
    
    if (![self validatePassword:password]) {
        isValid = NO;
    }
    
    if (!isValid && failure) {
        failure([self validationErrorArray]);
    } else if (success) {
        success();
    }
}

+ (void)validateEmail:(NSString *)email
          andPassword:(NSString *)password
         andFirstName:(NSString *)firstName
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure
{
    BOOL isValid = YES;
    
    if (![self validateEmail:email]) {
        isValid = NO;
    }
    
    if (![self validatePassword:password]) {
        isValid = NO;
    }
    
    if (![self validateFirstName:firstName]) {
        isValid = NO;
    }
    
    if (!isValid && failure) {
        failure([self validationErrorArray]);
    } else if (success) {
        success();
    }
}

+ (void)validateEmail:(NSString *)email
          andPassword:(NSString *)password
   andConfirmPassword:(NSString *)confirmPassword
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure
{
    BOOL isValid = YES;
    
    if (![self validateEmail:email]) {
        isValid = NO;
    }
    if (![self validatePassword:password andConfirmPassword:confirmPassword]) {
        isValid = NO;
    }
    
    if (!isValid && failure) {
        failure([self validationErrorArray]);
    } else if (success) {
        success();
    }
}

+ (void)validateEmail:(NSString *)email
                phone:(NSString *)phone
         andFirstName:(NSString *)firstName
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure
{
    BOOL isValid = YES;
    
    if (![self validateEmail:email]) {
        isValid = NO;
    }
    if (![self validateFirstName:firstName]) {
        isValid = NO;
    }
    if (![self validatePhone:phone]) {
        isValid = NO;
    }
    
    if (!isValid && failure) {
        failure([self validationErrorArray]);
    } else if (success) {
        success();
    }
}

+ (void)validatePhone:(NSString *)phone
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure
{
    BOOL isValid = YES;

    if (![self validatePhone:phone]) {
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

+ (void)setErrorMessage:(NSString *)message
{
    NSDictionary *errorDict = @{
                                kValidationErrorMessage: message
                                };
    [[self validationErrorArray] addObject:errorDict];
}

@end
