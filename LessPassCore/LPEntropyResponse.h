//
//  LPEntropyResponse.h
//  LessPass
//
//  Created by Romain Quidet on 15/12/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <tommath_superclass.h>
#import <tommath_class.h>
#import <tommath_private.h>
#import <tommath.h>


NS_ASSUME_NONNULL_BEGIN

@interface LPEntropyResponse : NSObject

- (instancetype)initWithValue:(NSString *)value andEntropy:(mp_int *)entropy;

@property (nonatomic, strong, readonly) NSString *value;
@property (nonatomic, assign, readonly) mp_int *entropy;

@end

NS_ASSUME_NONNULL_END
