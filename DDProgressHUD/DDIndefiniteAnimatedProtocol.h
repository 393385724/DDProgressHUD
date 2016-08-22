//
//  DDIndefiniteAnimatedProtocol.h
//  DDProgressHUD
//
//  Created by lilingang on 16/8/22.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *遵循该协议的无限循环动画
 */
@protocol DDIndefiniteAnimatedProtocol <NSObject>

/**
 *  @brief 是否正在动画
 *
 *  @return YES ? 是的 : 不是
 */
- (BOOL)isAnimating;

/**
 *  @brief 开始时动画
 */
- (void)startAnimation;

/**
 *  @brief 停止动画
 */
- (void)stopAnimation;

@end
