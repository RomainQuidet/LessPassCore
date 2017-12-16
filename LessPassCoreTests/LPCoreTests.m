//
//  LPCoreTests.m
//  LessPassTests
//
//  Created by Romain Quidet on 16/12/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LPCore.h"
#import "LPProfile.h"
#import "LPProfileOptions.h"
#import "LPProfileCrypto.h"

@interface LPCoreTests : XCTestCase

@end

@implementation LPCoreTests

- (void)setUp {
    [super setUp];
    //
}

- (void)tearDown {
    //
    [super tearDown];
}

- (void)testGeneratePasswordWithDefaultProfile {
	LPProfile *profile = [[LPProfile alloc] initWithSite:@"example.org" andLogin:@"contact@example.org"];
	NSString *masterPassword = @"password";
	NSString *generatedPassword = [LPCore generatePasswordWithProfile:profile andMasterPassword:masterPassword];
	XCTAssertTrue(generatedPassword.length == profile.options.length);
	XCTAssertTrue([generatedPassword isEqualToString:@"WHLpUL)e00[iHR+w"]);
}

- (void)testGeneratePasswordWithCustomProfile {
	LPProfile *profile = [[LPProfile alloc] initWithSite:@"example.org" andLogin:@"contact@example.org"];
	profile.options.symbols = NO;
	profile.options.length = 14;
	profile.options.counter = 2;
	NSString *masterPassword = @"password";
	NSString *generatedPassword = [LPCore generatePasswordWithProfile:profile andMasterPassword:masterPassword];
	XCTAssertTrue(generatedPassword.length == profile.options.length);
	XCTAssertTrue([generatedPassword isEqualToString:@"MBAsB7b1Prt8Sl"]);
}

- (void)testGeneratePasswordWithDigitsOnlyProfile {
	LPProfile *profile = [[LPProfile alloc] initWithSite:@"example.org" andLogin:@"contact@example.org"];
	profile.options.symbols = NO;
	profile.options.lowercase = NO;
	profile.options.uppercase = NO;
	profile.options.length = 6;
	profile.options.counter = 3;
	NSString *masterPassword = @"password";
	NSString *generatedPassword = [LPCore generatePasswordWithProfile:profile andMasterPassword:masterPassword];
	XCTAssertTrue(generatedPassword.length == profile.options.length);
	XCTAssertTrue([generatedPassword isEqualToString:@"117843"]);
}

- (void)testGeneratePasswordWithNoDigitsProfile {
	LPProfile *profile = [[LPProfile alloc] initWithSite:@"example.org" andLogin:@"contact@example.org"];
	profile.options.digits = NO;
	NSString *masterPassword = @"password";
	NSString *generatedPassword = [LPCore generatePasswordWithProfile:profile andMasterPassword:masterPassword];
	XCTAssertTrue(generatedPassword.length == profile.options.length);
	XCTAssertTrue([generatedPassword isEqualToString:@"s>{F}RwkN/-fmM.X"]);
}

- (void)testIsSupported {
	BOOL result = [LPCore isSupported];
	XCTAssertTrue(result);
}

- (void)testFingerPrintWithPassword {
	NSString *fingerPrint = [LPCore fingerPrintWithPassword:@"password"];
	XCTAssertTrue([fingerPrint isEqualToString:@"e56a207acd1e6714735487c199c6f095844b7cc8e5971d86c003a7b6f36ef51e"]);
}

@end
