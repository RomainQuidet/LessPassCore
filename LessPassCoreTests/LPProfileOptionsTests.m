//
//  LPProfileOptionsTests.m
//  LessPassTests
//
//  Created by Romain Quidet on 16/12/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LPProfileOptions.h"

@interface LPProfileOptionsTests : XCTestCase

@end

@implementation LPProfileOptionsTests

- (void)setUp {
    [super setUp];
    //
}

- (void)tearDown {
    //
    [super tearDown];
}

- (void)testDefaultInit {
	LPProfileOptions *options = [[LPProfileOptions alloc] init];
	XCTAssertTrue(options.lowercase == YES);
	XCTAssertTrue(options.uppercase == YES);
	XCTAssertTrue(options.digits == YES);
	XCTAssertTrue(options.symbols == YES);
	XCTAssertTrue(options.length == 16);
	XCTAssertTrue(options.counter == 1);
}

@end
