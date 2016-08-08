//
//  NSString+ErrorString.m
//  HealthyWay
//
//  Created by Eugenity on 08.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "NSString+ErrorString.h"

@implementation NSString (ErrorString)

+ (NSString *)errorStringFromErrorsArray:(NSArray *)errorsArray
{
    NSMutableString *message = [@"" mutableCopy];
    
    [errorsArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull errDict, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![message containsString:errDict[kValidationErrorMessage]]) {
            [message appendString:[NSString stringWithFormat:@"\n%@", errDict[kValidationErrorMessage]]];
        }
    }];
    
    return message;
}

@end
