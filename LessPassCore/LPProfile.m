//
//  LPProfile.m
//  LessPass
//
//  Created by Romain Quidet on 15/12/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import "LPProfile.h"
#import "LPProfileOptions.h"
#import "LPProfileCrypto.h"


@implementation LPProfile

- (instancetype)initWithSite:(NSString *)site andLogin:(NSString *)login {
	self = [super init];
	if (self) {
		_site = site;
		_login = login;
		_options = [LPProfileOptions new];
		_crypto = [LPProfileCrypto new];
	}
	return self;
}


@end
