//
//  LPProfileTests.m
//  LessPassTests
//
//  Created by Romain Quidet on 16/12/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LPProfile.h"

@interface LPProfileTests : XCTestCase

@end

@implementation LPProfileTests

- (void)setUp {
    [super setUp];
    //
}

- (void)tearDown {
    //
    [super tearDown];
}

- (void)testInit {
	LPProfile *profile = [[LPProfile alloc] initWithSite:@"example.org" andLogin:@"contact@example.org"];
	XCTAssertTrue([profile.site isEqualToString:@"example.org"]);
	XCTAssertTrue([profile.login isEqualToString:@"contact@example.org"]);
	XCTAssertNotNil(profile.options);
	XCTAssertNotNil(profile.crypto);
}

@end
