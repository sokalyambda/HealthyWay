//
//  HWSignInOperation.h
//  HealthyWay
//
//  Created by Eugene Sokolenko on 08.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAuthTypes.h"

@class HWCredentials;

extern NSString *const ErrorsArrayKey;

@interface HWAuthorizationOperation : NSOperation

@property (strong, nonatomic, readonly) HWCredentials *credentials;

@property (strong, nonatomic, readonly) NSError *error;

- (instancetype)initWithCredentials:(HWCredentials *)credentials;

@end
