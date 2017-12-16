//
//  LPProfileCrypto.m
//  LessPass
//
//  Created by Romain Quidet on 15/12/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import "LPProfileCrypto.h"

@implementation LPProfileCrypto

- (instancetype)init {
	self = [super init];
	if (self) {
		_method = LPCryptoMethodPBKDF2;
		_iterations = 100000;
		_keyLen = 32;
		_digest = LPCryptoDigestSHA256;
	}
	return self;
}


@end
