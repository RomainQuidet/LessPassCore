//
//  LPProfile.h
//  LessPass
//
//  Created by Romain Quidet on 15/12/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPProfileOptions, LPProfileCrypto;

NS_ASSUME_NONNULL_BEGIN

@interface LPProfile : NSObject

- (instancetype)initWithSite:(NSString *)site andLogin:(NSString *)login;

@property (nonatomic, readonly) NSString *site;
@property (nonatomic, readonly) NSString *login;
@property (nonatomic, readonly) LPProfileOptions *options;
@property (nonatomic, readonly) LPProfileCrypto *crypto;

@end

NS_ASSUME_NONNULL_END
