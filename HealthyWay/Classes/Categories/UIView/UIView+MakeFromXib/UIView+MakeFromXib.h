//
//  UIView+MakeFromXib.h
//
//  Created by Eugenity on 29/08/2014.
//  Copyright (c) 2014 Mobindustry. All rights reserved.
//

@interface UIView (MakeFromXib)

+ (instancetype)makeFromXibWithFileOwner:(id)owner;
+ (instancetype)makeFromXib;

@end
