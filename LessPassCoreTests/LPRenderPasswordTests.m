//
//  LPRenderPasswordTests.m
//  LessPassTests
//
//  Created by Romain Quidet on 15/12/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LPRenderPassword_Private.h"
#import "LPEntropyResponse.h"
#import "LPProfileOptions.h"

@interface LPRenderPasswordTests : XCTestCase

@end

@implementation LPRenderPasswordTests

- (void)setUp {
    [super setUp];
    //
}

- (void)tearDown {
    // 
    [super tearDown];
}

#pragma mark - Entropy

- (void)testConsumeEntropy {
	mp_int entropy;
	mp_init_set_int(&entropy, (4 * 4 + 2));
	LPEntropyResponse *password = [LPRenderPassword consumeEntropyWithPwd:@"" quotient:&entropy setOfCharacters:@"abcd" maxLength:2];
	XCTAssertTrue([password.value isEqualToString:@"ca"], @"wrong password string");
	XCTAssertTrue(mp_get_long(password.entropy) == 1, @"wrong password entropy");
	mp_clear(&entropy);
}

#pragma mark - Chars

- (void)testSetOfCharactersWithRules {
	NSString *setOfCharacters = [LPRenderPassword setOfCharactersWithRules:@[]];
	XCTAssertTrue([setOfCharacters isEqualToString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"], @"wrong default set of characters");
	XCTAssertTrue(setOfCharacters.length == 26 * 2 + 10 + 32);

	NSArray *rules = @[@"lowercase", @"uppercase", @"digits"];
	setOfCharacters = [LPRenderPassword setOfCharactersWithRules:rules];
	XCTAssertTrue([setOfCharacters isEqualToString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"], @"wrong set of characters");
	XCTAssertTrue(setOfCharacters.length == 26 * 2 + 10);

	rules = @[@"lowercase"];
	setOfCharacters = [LPRenderPassword setOfCharactersWithRules:rules];
	XCTAssertTrue([setOfCharacters isEqualToString:@"abcdefghijklmnopqrstuvwxyz"], @"wrong set of characters");
	XCTAssertTrue(setOfCharacters.length == 26);

	rules = @[@"uppercase"];
	setOfCharacters = [LPRenderPassword setOfCharactersWithRules:rules];
	XCTAssertTrue([setOfCharacters isEqualToString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"], @"wrong set of characters");
	XCTAssertTrue(setOfCharacters.length == 26);

	rules = @[@"digits"];
	setOfCharacters = [LPRenderPassword setOfCharactersWithRules:rules];
	XCTAssertTrue([setOfCharacters isEqualToString:@"0123456789"], @"wrong set of characters");
	XCTAssertTrue(setOfCharacters.length == 10);

	rules = @[@"symbols"];
	setOfCharacters = [LPRenderPassword setOfCharactersWithRules:rules];
	XCTAssertTrue([setOfCharacters isEqualToString:@"!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"], @"wrong set of characters");
	XCTAssertTrue(setOfCharacters.length == 32);
}

- (void)testOneCharPerRuleWithEntropy {
	NSArray *rules = @[@"lowercase", @"uppercase"];
	mp_int entropy;
	mp_init_set_int(&entropy, (26 * 26));
	LPEntropyResponse *response = [LPRenderPassword oneCharPerRuleWithEntropy:&entropy andRules:rules];
	XCTAssertTrue([response.value isEqualToString:@"aA"]);
	XCTAssertTrue(response.value.length == 2);
	XCTAssertTrue(mp_get_long(response.entropy) == 1);
	mp_clear(&entropy);
}

- (void)testRulesFromOptions {
	LPProfileOptions *options = [[LPProfileOptions alloc] init];

	options.lowercase = NO;
	options.uppercase = YES;
	options.digits = NO;
	options.symbols = NO;
	NSArray *rules = [LPRenderPassword rulesFromOptions:options];
	XCTAssertTrue(rules.count == 1);
	XCTAssertTrue([rules containsObject:@"uppercase"]);

	options.lowercase = YES;
	options.uppercase = YES;
	options.digits = NO;
	options.symbols = NO;
	rules = [LPRenderPassword rulesFromOptions:options];
	XCTAssertTrue(rules.count == 2);
	XCTAssertTrue([rules.firstObject isEqualToString:@"lowercase"]);
	XCTAssertTrue([rules.lastObject isEqualToString:@"uppercase"]);

	options.lowercase = YES;
	options.uppercase = YES;
	options.digits = YES;
	options.symbols = YES;
	rules = [LPRenderPassword rulesFromOptions:options];
	XCTAssertTrue(rules.count == 4);
	XCTAssertTrue([rules.firstObject isEqualToString:@"lowercase"]);
	XCTAssertTrue([rules[1] isEqualToString:@"uppercase"]);
	XCTAssertTrue([rules[2] isEqualToString:@"digits"]);
	XCTAssertTrue([rules.lastObject isEqualToString:@"symbols"]);
}

- (void)testInsertStringPseudoRandomlyWithGeneratedPassword {
	mp_int entropy;
	mp_init_set_int(&entropy, (7 * 6 + 2));
	NSString *result = [LPRenderPassword insertStringPseudoRandomlyWithGeneratedPassword:@"123456" entropy:&entropy seed:@"uT"];
	XCTAssertTrue([result isEqualToString:@"T12u3456"]);
	mp_clear(&entropy);
}

#pragma mark - API

- (void)testRenderPasswordWithEntropy {
	LPProfileOptions *options = [[LPProfileOptions alloc] init];
	options.lowercase = YES;
	options.uppercase = YES;
	options.digits = YES;
	options.symbols = YES;
	options.length = 16;

	NSString *entropy = @"dc33d431bce2b01182c613382483ccdb0e2f66482cbba5e9d07dab34acc7eb1e";

	NSString *result = [LPRenderPassword renderPasswordWithEntropy:entropy andOptions:options];
	XCTAssertTrue(result.length == 16);
	XCTAssertTrue([result characterAtIndex:0] == 'W');
	XCTAssertTrue([result characterAtIndex:1] == 'H');

	options.lowercase = YES;
	options.uppercase = YES;
	options.digits = YES;
	options.symbols = YES;
	options.length = 20;
	result = [LPRenderPassword renderPasswordWithEntropy:entropy andOptions:options];
	XCTAssertTrue(result.length == 20);

	options.lowercase = YES;
	options.uppercase = YES;
	options.digits = YES;
	options.symbols = YES;
	options.length = 6;
	result = [LPRenderPassword renderPasswordWithEntropy:entropy andOptions:options];
	BOOL lowerCaseFound = NO;
	BOOL upperCaseFound = NO;
	BOOL digitsFound = NO;
	BOOL symbolsFound = NO;
	for (NSInteger i=0; i < result.length; i++) {
		NSRange range = NSMakeRange(i, 1);
		NSString *character = [result substringWithRange:range];
		if ([@"abcdefghijklmnopqrstuvwxyz" containsString:character]) {
			lowerCaseFound = YES;
		}
		else if ([@"ABCDEFGHIJKLMNOPQRSTUVWXYZ" containsString:character]) {
			upperCaseFound = YES;
		}
		else if ([@"0123456789" containsString:character]) {
			digitsFound = YES;
		}
		else if ([@"!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" containsString:character]) {
			symbolsFound = YES;
		}
	}
	XCTAssertTrue(result.length == 6);
	XCTAssertTrue(lowerCaseFound);
	XCTAssertTrue(upperCaseFound);
	XCTAssertTrue(digitsFound);
	XCTAssertTrue(symbolsFound);
}

@end
