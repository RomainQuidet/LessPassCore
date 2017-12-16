//
//  LPEntropyResponse.m
//  LessPass
//
//  Created by Romain Quidet on 15/12/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import "LPEntropyResponse.h"

@implementation LPEntropyResponse

- (instancetype)initWithValue:(NSString *)value andEntropy:(mp_int *)entropy {
	self = [super init];
	if (self) {
		_value = [value copy];
		_entropy = malloc(sizeof(mp_int));
		mp_init_copy(_entropy, entropy);
	}
	return self;
}

- (void)dealloc {
	mp_clear(_entropy);
	free(_entropy);
}

@end
