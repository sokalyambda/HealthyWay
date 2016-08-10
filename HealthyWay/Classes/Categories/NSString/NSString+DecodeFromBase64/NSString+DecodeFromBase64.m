//
//  NSString+DecodeFromBase64.m
//  HealthyWay
//
//  Created by Eugenity on 10.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "NSString+DecodeFromBase64.h"

@implementation NSString (DecodeFromBase64)

- (UIImage *)decodeBase64ToImage
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

@end
