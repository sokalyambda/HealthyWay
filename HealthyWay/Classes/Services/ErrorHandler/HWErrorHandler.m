//
//  ALLOErrorHandler.m
//  Allo
//
//  Created by Eugenity on 23.07.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "HWErrorHandler.h"

#import "NSString+JSONRepresentation.h"

@implementation HWErrorHandler

#pragma mark - Accessors

static NSString *_errorAlertTitle = nil;

+ (NSString *)getErrorAlertTitle
{
    if (!_errorAlertTitle) {
        _errorAlertTitle = @"";
    }
    return _errorAlertTitle;
}

+ (void)setErrorAlertTitle:(NSString *)title
{
    _errorAlertTitle = title;
}

#pragma mark - Public methods

/**
 *  Parse error and get alert title and message
 *
 *  @param error      Error that should be parsed
 *  @param completion Completion Block
 */
+ (void)parseError:(NSError *)error withCompletion:(ErrorParsingCompletion)completion
{
    [self setErrorAlertTitle:@""];
    
    NSString *errFromResponseString = error.userInfo[ErrorMessage];
    if (errFromResponseString) {
        return completion([self getErrorAlertTitle], errFromResponseString);
    }
    
    NSString *errFromJsonString = [self errorStringFromJSONResponseError:error];
    if (errFromJsonString) {
        return completion([self getErrorAlertTitle], errFromJsonString);
    }
    NSString *errFromCodeString = [self errorStringFromErrorCode:error];
    if (errFromCodeString) {
        return completion([self getErrorAlertTitle], errFromCodeString);
    }
    
    NSString *errLocalizedDescription = error.localizedDescription;
    
    return completion([self getErrorAlertTitle], errLocalizedDescription);
}

+ (void)parseSocialError:(NSError *)error withCompletion:(SocialErrorParsingCompletion)completion
{
    BOOL isRegistered = YES;
    if (error.code == HWErrorCodeNotRegistered || error.code == HWErrorCodeUserDoesntExist) {
        isRegistered = NO;
    }
    if (completion) {
        completion(isRegistered);
    }
}

/**
 *  Checking whether error is a network error
 *
 *  @param error Error for checking
 *
 *  @return If error is network error - returns 'YES'
 */
+ (BOOL)errorIsNetworkError:(NSError *)error
{
    if (!error) {
        return NO;
    }
    
    NSError *innerError = error.userInfo[NSUnderlyingErrorKey];
    if ([self errorIsNetworkError:innerError]) {
        return YES;
    }
    
    DLog(@"error code %li", (long)error.code);
    
    switch (error.code) {
        case NSURLErrorTimedOut:
        case NSURLErrorCannotFindHost:
        case NSURLErrorCannotConnectToHost:
        case NSURLErrorNetworkConnectionLost:
        case NSURLErrorDNSLookupFailed:
        case NSURLErrorNotConnectedToInternet:
        case NSURLErrorInternationalRoamingOff:
        case NSURLErrorCallIsActive:
        case NSURLErrorDataNotAllowed:
            return YES;
        default:
            return NO;
    }
}

#pragma mark - Private methods

/**
 *  Get string value from server response error
 *
 *  @param error Error that should be parsed
 *
 *  @return String value from current error
 */
+ (NSString *)errorStringFromJSONResponseError:(NSError *)error
{
    NSMutableString *outputErrorString = [NSMutableString string];
    
    NSDictionary *jsonErrorDict = [self getErrorsDictDataFromError:error];
    
    NSString *errorDescriptionString = jsonErrorDict[ErrorMessage];
    if (errorDescriptionString.length) {
        [outputErrorString appendString:errorDescriptionString];
    }
    
    return outputErrorString.length > 0 ? outputErrorString : nil;
}

/**
 *  Get dictionary thar represents an error
 *
 *  @param error Error that should be parsed
 *
 *  @return Error dictionaty
 */
+ (NSDictionary *)getErrorsDictDataFromError:(NSError *)error
{
    NSData *errData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    NSDictionary *jsonErrorDict;
    if (errData) {
        NSString *jsonErrorString = [[NSString alloc] initWithData:errData encoding:NSUTF8StringEncoding];
        jsonErrorDict = [jsonErrorString dictionaryFromJSONString];
    }
    return jsonErrorDict;
}

/**
 *  Get string value from error by code
 *
 *  @param error Error that should be parsed
 *
 *  @return String value from current error
 */
+ (NSString *)errorStringFromErrorCode:(NSError *)error
{
    NSString *errString;
    switch (error.code) {
        case NSURLErrorTimedOut: {
            errString = LOCALIZED(@"Время выполнения запроса истекло.");   //The connection timed out
            break;
        }
        case NSURLErrorDNSLookupFailed: {
            errString = LOCALIZED(@"DNS lookup failed.");
            break;
        }
        case NSURLErrorCannotFindHost:
        case NSURLErrorCannotConnectToHost:
        case NSURLErrorNotConnectedToInternet:
        case NSURLErrorNetworkConnectionLost: {
            errString = LOCALIZED(@"Ошибка сети Интернет. Проверьте соединение и попробуйте снова."); //Network connection failed. Check your signal and try again
            break;
        }
        case NSURLErrorInternationalRoamingOff: {
            errString = LOCALIZED(@"Отключен роуминг данных."); //International roaming is off
            break;
        }
        case NSURLErrorCallIsActive: {
            errString = LOCALIZED(@"Call is active.");
            break;
        }
        case NSURLErrorDataNotAllowed: {
            errString = LOCALIZED(@"Data not allowed.");
            break;
        }
        default:
            break;
    }
    
    return errString.length > 0 ? errString : nil;
}

@end
