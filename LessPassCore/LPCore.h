//
//  LPCore.h
//  LessPass
//
//  Created by Romain Quidet on 15/12/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPProfile;

@interface LPCore : NSObject

+ (BOOL)isSupported;
+ (NSString *)generatePasswordWithProfile:(LPProfile *)profile andMasterPassword:(NSString *)masterPassword;
+ (NSString *)fingerPrintWithPassword:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
