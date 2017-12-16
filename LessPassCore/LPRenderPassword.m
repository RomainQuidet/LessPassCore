//
//  LPRenderPassword.m
//  LessPass
//
//  Created by Romain Quidet on 15/12/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import "LPRenderPassword_Private.h"
#import "LPEntropyResponse.h"
#import "LPProfileOptions.h"

static NSString * const kLowerCaseSubset = @"abcdefghijklmnopqrstuvwxyz";
static NSString * const kUpperCaseSubset = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
static NSString * const kDigitsSubset = @"0123456789";
static NSString * const kSymbolsSubset = @"!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~";

static NSString * const kLowerCaseRule = @"lowercase";
static NSString * const kUpperCaseRule = @"uppercase";
static NSString * const kDigitsRule = @"digits";
static NSString * const kSymbolsRule = @"symbols";

@implementation LPRenderPassword

#pragma mark - Public

+ (NSString *)renderPasswordWithEntropy:(NSString *)entropy andOptions:(LPProfileOptions *)options {
	NSString *renderedPassword = @"";
	NSArray *rules = [self rulesFromOptions:options];
	NSString *setOfCharacters = [self setOfCharactersWithRules:rules];
	mp_int quotient;
	mp_init(&quotient);
	const char *hexBytes = [entropy cStringUsingEncoding:NSUTF8StringEncoding];
	mp_read_radix(&quotient, hexBytes, 16);
	LPEntropyResponse *password = [self consumeEntropyWithPwd:@"" quotient:&quotient setOfCharacters:setOfCharacters maxLength:(options.length - rules.count)];
	LPEntropyResponse *charsToAdd = [self oneCharPerRuleWithEntropy:password.entropy andRules:rules];
	renderedPassword = [self insertStringPseudoRandomlyWithGeneratedPassword:password.value entropy:charsToAdd.entropy seed:charsToAdd.value];
	mp_clear(&quotient);
	return renderedPassword;
}

#pragma mark - Private
#pragma mark - Entropy

+ (LPEntropyResponse *)consumeEntropyWithPwd:(NSString *)generatedPassword quotient:(mp_int *)quotient setOfCharacters:(NSString *)setOfCharacters maxLength:(NSInteger)maxLength {
	if (generatedPassword.length >= maxLength) {
		LPEntropyResponse *response = [[LPEntropyResponse alloc] initWithValue:generatedPassword andEntropy:quotient];
		return response;
	}

	mp_int multiplier;
	mp_init(&multiplier);
	mp_int remainder;
	mp_init(&remainder);
	mp_int divider;
	mp_init_set_int(&divider, setOfCharacters.length);
	mp_div(quotient, &divider, &multiplier, &remainder);
	unichar character = [setOfCharacters characterAtIndex:mp_get_long(&remainder)];
	NSString *updatedPwd = [NSString stringWithFormat:@"%@%c", generatedPassword, character];
	LPEntropyResponse *response = [self consumeEntropyWithPwd:updatedPwd quotient:&multiplier setOfCharacters:setOfCharacters maxLength:maxLength];
	mp_clear(&multiplier);
	mp_clear(&remainder);
	mp_clear(&divider);
	return response;
}

#pragma mark - Chars

+ (NSString *)setOfCharactersWithRules:(NSArray<NSString *> *)rules {
	if (rules.count == 0) {
		return [NSString stringWithFormat:@"%@%@%@%@", kLowerCaseSubset, kUpperCaseSubset, kDigitsSubset, kSymbolsSubset];
	}
	NSMutableString *tmp = [NSMutableString new];
	if ([rules containsObject:kLowerCaseRule]) {
		[tmp appendString:kLowerCaseSubset];
	}
	if ([rules containsObject:kUpperCaseRule]) {
		[tmp appendString:kUpperCaseSubset];
	}
	if ([rules containsObject:kDigitsRule]) {
		[tmp appendString:kDigitsSubset];
	}
	if ([rules containsObject:kSymbolsRule]) {
		[tmp appendString:kSymbolsSubset];
	}
	return [NSString stringWithString:tmp];
}

+ (NSArray *)rulesFromOptions:(LPProfileOptions *)options {
	NSMutableArray *tmp = [NSMutableArray array];
	if (options.lowercase) {
		[tmp addObject:kLowerCaseRule];
	}
	if (options.uppercase) {
		[tmp addObject:kUpperCaseRule];
	}
	if (options.digits) {
		[tmp addObject:kDigitsRule];
	}
	if (options.symbols) {
		[tmp addObject:kSymbolsRule];
	}

	return [NSArray arrayWithArray:tmp];
}

+ (LPEntropyResponse *)oneCharPerRuleWithEntropy:(mp_int *)entropy andRules:(NSArray<NSString *> *)rules {
	NSMutableString *oneCharPerRule = [NSMutableString stringWithString:@""];
	mp_int quotient;
	mp_init_copy(&quotient, entropy);
	for (NSString *rule in rules) {
		NSString *setOfCharacters = [self setOfCharactersForRule:rule];
		LPEntropyResponse *pwd = [self consumeEntropyWithPwd:@"" quotient:&quotient setOfCharacters:setOfCharacters maxLength:1];
		[oneCharPerRule appendString:pwd.value];
		mp_copy(pwd.entropy, &quotient);
	}
	LPEntropyResponse *response = [[LPEntropyResponse alloc] initWithValue:oneCharPerRule andEntropy:&quotient];
	mp_clear(&quotient);
	return response;
}

+ (NSString *)setOfCharactersForRule:(NSString *)rule {
	if ([rule isEqualToString:kLowerCaseRule]) {
		return kLowerCaseSubset;
	}
	else if ([rule isEqualToString:kUpperCaseRule]) {
		return kUpperCaseSubset;
	}
	else if ([rule isEqualToString:kDigitsRule]) {
		return kDigitsSubset;
	}
	else if ([rule isEqualToString:kSymbolsRule]) {
		return kSymbolsSubset;
	}
	return @"";
}

+ (NSString *)insertStringPseudoRandomlyWithGeneratedPassword:(NSString *)generatedPassword entropy:(mp_int *)entropy seed:(NSString *)seed {
	NSString *result = [NSString stringWithString:generatedPassword];
	mp_int tempEntropy;
	mp_init_copy(&tempEntropy, entropy);
	for (NSInteger i = 0; i < seed.length; i++) {
		mp_int divider;
		mp_init_set_int(&divider, result.length);
		mp_int quotient;
		mp_init(&quotient);
		mp_int remainder;
		mp_init(&remainder);
		/* a/b => cb + d == a */
		mp_div(&tempEntropy, &divider, &quotient, &remainder);
		result = [NSString stringWithFormat:@"%@%c%@",
				  [result substringToIndex:mp_get_long(&remainder)],
				  [seed characterAtIndex:i],
				  [result substringFromIndex:mp_get_long(&remainder)]];
		mp_copy(&quotient, &tempEntropy);
		mp_clear(&divider);
		mp_clear(&quotient);
		mp_clear(&remainder);
	}
	return result;
}

@end
