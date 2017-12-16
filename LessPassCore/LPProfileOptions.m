//
//  LPProfileOptions.m
//  LessPass
//
//  Created by Romain Quidet on 15/12/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import "LPProfileOptions.h"

@implementation LPProfileOptions

- (instancetype)init {
	self = [super init];
	if (self) {
		_uppercase = YES;
		_lowercase = YES;
		_digits = YES;
		_symbols = YES;
		_length = 16;
		_counter = 1;
	}
	return self;
}

@end
