//
//  LPProfileCrypto.h
//  LessPass
//
//  Created by Romain Quidet on 15/12/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LPCryptoMethod) {
	LPCryptoMethodPBKDF2
};

typedef NS_ENUM(NSInteger, LPCryptoDigest) {
	LPCryptoDigestSHA256
};

NS_ASSUME_NONNULL_BEGIN

@interface LPProfileCrypto : NSObject

@property (nonatomic, assign) LPCryptoMethod method;
@property (nonatomic, assign) unsigned int iterations;
@property (nonatomic, assign) NSUInteger keyLen;
@property (nonatomic, assign) LPCryptoDigest digest;

@end

NS_ASSUME_NONNULL_END
