//
//  LPCore.m
//  LessPass
//
//  Created by Romain Quidet on 15/12/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#import <CommonCrypto/CommonHMAC.h>

#import "LPCore.h"
#import "LPProfile.h"
#import "LPProfileOptions.h"
#import "LPProfileCrypto.h"
#import "LPRenderPassword.h"

@implementation LPCore

#pragma mark - Public

+ (NSString *)generatePasswordWithProfile:(LPProfile *)profile andMasterPassword:(NSString *)masterPassword {
	NSString *entropy = [self calcEntropyWithProfile:profile andMasterPassword:masterPassword];
	NSString *result = [LPRenderPassword renderPasswordWithEntropy:entropy andOptions:profile.options];

	return result;
}

+ (BOOL)isSupported {
	BOOL result = NO;
	LPProfile *simpleProfile = [[LPProfile alloc] initWithSite:@"" andLogin:@""];
	simpleProfile.crypto.iterations = 1;

	NSString *generatedPassword = [self generatePasswordWithProfile:simpleProfile andMasterPassword:@"LessPass"];
	result = [generatedPassword isEqualToString:@"n'LTsjPA#3E$e*2'"];
	return result;
}

+ (NSString *)fingerPrintWithPassword:(NSString *)password {
	const char *cData = [@"" cStringUsingEncoding:NSUTF8StringEncoding];
	const char *cKey = [password cStringUsingEncoding:NSUTF8StringEncoding];
	unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
	CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
	NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
	NSString *HMAC = [self hexadecimalStringFromData:HMACData];

	return HMAC;
}

#pragma mark - Private

+ (NSString *)calcEntropyWithProfile:(LPProfile *)profile andMasterPassword:(NSString *)masterPassword {
	NSString *salt = [NSString stringWithFormat:@"%@%@%@", profile.site, profile.login, @(profile.options.counter)];
	NSData *saltData = [salt dataUsingEncoding:NSUTF8StringEncoding];

	NSMutableData *derivedKey = [NSMutableData dataWithLength:profile.crypto.keyLen];
	int result = CCKeyDerivationPBKDF(kCCPBKDF2,            // algorithm
									  masterPassword.UTF8String,  // password
									  [masterPassword lengthOfBytesUsingEncoding:NSUTF8StringEncoding],  // passwordLength
									  saltData.bytes,           // salt
									  saltData.length,          // saltLen
									  kCCPRFHmacAlgSHA256,    // PRF
									  profile.crypto.iterations,         // rounds
									  derivedKey.mutableBytes, // derivedKey
									  derivedKey.length); // derivedKeyLen

	NSAssert(result == kCCSuccess, @"Unable to create derived key for password: %d", result);

	NSString *derivedKeyString = [self hexadecimalStringFromData:derivedKey];
	return derivedKeyString;
}

+ (NSString *)hexadecimalStringFromData:(NSData *)data {
	const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
	if (!dataBuffer) {
		return [NSString string];
	}

	NSUInteger dataLength  = [data length];
	NSMutableString *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];

	for (NSUInteger i = 0; i < dataLength; ++i) {
		[hexString appendString:[NSString stringWithFormat:@"%02x", dataBuffer[i]]];
	}

	return [NSString stringWithString:hexString];
}

@end
