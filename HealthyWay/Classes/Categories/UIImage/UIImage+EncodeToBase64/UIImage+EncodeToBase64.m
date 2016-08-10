//
//  UIImage+HWEncodeToBase64.m
//  HealthyWay
//
//  Created by Eugenity on 10.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "UIImage+EncodeToBase64.h"

@implementation UIImage (EncodeToBase64)

- (NSString *)encodeToBase64String
{
    return [UIImagePNGRepresentation(self) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

@end
