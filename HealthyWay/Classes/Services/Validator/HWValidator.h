//
//  Validator.h
//  Allo
//
//  Created by Eugenity on 26.05.15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

typedef void(^ValidationSuccessBlock)(void);
typedef void(^ValidationFailureBlock)(NSMutableArray *errorArray);

extern NSString *const kValidationErrorMessage;

@interface HWValidator : NSObject

+ (NSMutableArray *)validationErrorArray;
+ (void)setValidationErrorArray:(NSMutableArray *)validationErrorArray;

+ (void)validateEmail:(NSString *)email
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure;

+ (void)validateEmail:(NSString *)email
          andPassword:(NSString *)password
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure;

+ (void)validateEmail:(NSString *)email
          andPassword:(NSString *)password
         andFirstName:(NSString *)firstName
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure;

+ (void)validatePhone:(NSString *)phone
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure;
+ (void)validateFirstName:(NSString *)firstName
                     onSuccess:(ValidationSuccessBlock)success
                     onFailure:(ValidationFailureBlock)failure;

+ (void)validateEmail:(NSString *)email
          andPassword:(NSString *)password
   andConfirmPassword:(NSString *)confirmPassword
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure;

+ (void)validateFirstName:(NSString *)firstName
                 lastName:(NSString *)lastName
                 nickName:(NSString *)nickName
              dateOfBirth:(NSDate *)dateOfBirth
                onSuccess:(ValidationSuccessBlock)success
                onFailure:(ValidationFailureBlock)failure;

+ (void)cleanValidationErrorArray;

@end
