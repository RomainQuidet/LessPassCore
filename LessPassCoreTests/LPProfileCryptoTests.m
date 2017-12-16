//
//  LPProfileCryptoTests.m
//  LessPassTests
//
//  Created by Romain Quidet on 16/12/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LPProfileCrypto.h"

@interface LPProfileCryptoTests : XCTestCase

@end

@implementation LPProfileCryptoTests

- (void)setUp {
    [super setUp];
    //
}

- (void)tearDown {
    //
    [super tearDown];
}

- (void)testDefaultInit {
	LPProfileCrypto *crypto = [[LPProfileCrypto alloc] init];
	XCTAssertTrue(crypto.method == LPCryptoMethodPBKDF2);
	XCTAssertTrue(crypto.iterations == 100000);
	XCTAssertTrue(crypto.keyLen == 32);
	XCTAssertTrue(crypto.digest == LPCryptoDigestSHA256);
}


@end
