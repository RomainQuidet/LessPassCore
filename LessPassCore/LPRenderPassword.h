//
//  LPRenderPassword.h
//  LessPass
//
//  Created by Romain Quidet on 15/12/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPProfileOptions;

@interface LPRenderPassword : NSObject

+ (NSString *)renderPasswordWithEntropy:(NSString *)entropy andOptions:(LPProfileOptions *)options;

@end

NS_ASSUME_NONNULL_END
