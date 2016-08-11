//
//  HWSignInOperation.h
//  HealthyWay
//
//  Created by Eugene Sokolenko on 08.08.16.
//  Copyright © 2016 Eugenity. All rights reserved.
//

#import "HWAuthTypes.h"

#import "HWBaseOperation.h"

@class HWCredentials;

@interface HWAuthorizationOperation : HWBaseOperation

@property (strong, nonatomic, readonly) HWCredentials *credentials;

- (instancetype)initWithCredentials:(HWCredentials *)credentials;

@end
