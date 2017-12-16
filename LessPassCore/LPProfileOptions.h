//
//  LPProfileOptions.h
//  LessPass
//
//  Created by Romain Quidet on 15/12/2017.
//  Copyright © 2017 XDAppfactory. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPProfileOptions : NSObject

@property (nonatomic, assign) BOOL uppercase;
@property (nonatomic, assign) BOOL lowercase;
@property (nonatomic, assign) BOOL digits;
@property (nonatomic, assign) BOOL symbols;
@property (nonatomic, assign) NSUInteger length;
@property (nonatomic, assign) NSUInteger counter;

@end

NS_ASSUME_NONNULL_END
