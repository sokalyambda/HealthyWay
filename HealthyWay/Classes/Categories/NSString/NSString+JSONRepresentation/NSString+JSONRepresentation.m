//
//  NSString+JSONRepresentation.m
//  Allo
//
//  Created by Eugenity on 23.07.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import "NSString+JSONRepresentation.h"

@implementation NSString (JSONRepresentation)

- (NSDictionary *)dictionaryFromJSONString
{
    NSError *error;
    NSData *objectData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *jsonErrorDict = [NSJSONSerialization JSONObjectWithData:objectData
                                                                  options:NSJSONReadingMutableContainers
                                                                    error:&error];
    
    if (!jsonErrorDict) {
        DLog(@"Error: %@", error);
        return nil;
    }
    
    return jsonErrorDict;
}


@end
