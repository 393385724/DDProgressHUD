//
//  DDProgressHUD.h
//  DDProgressHUD
//
//  Created by lilingang on 8/17/16.
//  Copyright © 2016 LiLingang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DDProgressHUDDismissCompletion)(void);

@interface DDProgressHUD : UIView

/**
 *  @brief 显示一个无限等待转圈提示框，并锁住屏幕
 *
 *  @param status 提示文案
 */
+ (void)showHUDWithStatus:(NSString*)status;
/**
 *  @brief 显示一个无限等待表针提示框，并锁住屏幕
 *
 *  @param status 提示文案
 */
+ (void)showClockWithStatus:(NSString*)status;
/**
 *  @brief 显示一个纯文本提示框并在短暂时间后消失
 *
 *  @param status 提示文案
 */
+ (void)showWithStatus:(NSString*)status;

/**
 *  @brief 显示一个带有默认成功图片的提示
 *
 *  @param status 提示文案
 */
+ (void)showSucessWithStatus:(NSString*)status;

/**
 *  @brief 显示一个带有默认失败图片的提示
 *
 *  @param status 提示文案
 */
+ (void)showErrorWithStatus:(NSString*)status;

/**
 *  @brief 显示一个带图片的提示框并在短暂时间后消失
 *
 *  @param image  图片 nil则效果等同于showInfoWithStatus
 *  @param status 提示文案
 */
+ (void)showImage:(UIImage *)image status:(NSString*)status;

/**
 *  @brief 立即消失
 */
+ (void)dismiss;
/**
 *  @brief 立即消失并返回一个callback
 *
 *  @param completion 回调
 */
+ (void)dismissWithCompletion:(DDProgressHUDDismissCompletion)completion;
/**
 *  @brief 一段延迟后消失
 *
 *  @param delay 延迟时间
 */
+ (void)dismissWithDelay:(NSTimeInterval)delay;
/**
 *  @brief 一段时间延迟后消失并返回一个回调
 *
 *  @param delay      延迟时间
 *  @param completion 回调
 */
+ (void)dismissWithDelay:(NSTimeInterval)delay completion:(DDProgressHUDDismissCompletion)completion;

@end
