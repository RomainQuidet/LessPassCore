//
//  LPRenderPassword_Private.h
//  LessPass
//
//  Created by Romain Quidet on 15/12/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPRenderPassword.h"
#import "libtommath/tommath.h"

NS_ASSUME_NONNULL_BEGIN

@class LPEntropyResponse;

@interface LPRenderPassword ()

+ (LPEntropyResponse *)consumeEntropyWithPwd:(NSString *)generatedPassword quotient:(mp_int *)quotient setOfCharacters:(NSString *)setOfCharacters maxLength:(NSInteger)maxLength;

+ (NSString *)setOfCharactersWithRules:(NSArray<NSString *> *)rules;
+ (LPEntropyResponse *)oneCharPerRuleWithEntropy:(mp_int *)entropy andRules:(NSArray<NSString *> *)rules;
+ (NSArray *)rulesFromOptions:(LPProfileOptions *)options;
+ (NSString *)insertStringPseudoRandomlyWithGeneratedPassword:(NSString *)generatedPassword entropy:(mp_int *)entropy seed:(NSString *)seed;

@end

NS_ASSUME_NONNULL_END
