//
//  DDProgressHUD.h
//  DDProgressHUD
//
//  Created by lilingang on 8/17/16.
//  Copyright © 2016 LiLingang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DDProgressHUDStyle) {
    DDProgressHUDStyleDark,         // default style, black HUD and white text
    DDProgressHUDStyleLight        // white HUD with black text
};

typedef NS_ENUM(NSUInteger, DDProgressHUDMaskStyle) {
    DDProgressHUDMaskStyleCustom = 1,     // default style, don't allow user interactions and dim the UI in the back of the HUD with a custom color
    DDProgressHUDMaskStyleNone            //  allow user interactions while HUD is displayed
};

typedef void (^DDProgressHUDDismissCompletion)(void);

@interface DDProgressHUD : UIView

/**
 *  @brief 设置默认的HUD风格,默认DDProgressHUDStyleDark
 *
 *  @param style DDProgressHUDStyle
 */
+ (void)setDefaultStyle:(DDProgressHUDStyle)style;
/**
 *  @brief 设置背景mask,默认DDProgressHUDMaskStyleCustom
 *
 *  @param maskType DDProgressHUDMaskStyle
 */
+ (void)setDefaultMaskStyle:(DDProgressHUDMaskStyle)maskStyle;
/**
 *  @brief 设置蒙层颜色，默认透明色，当DDProgressHUDMaskTypeCustom时生效
 *
 *  @param color UIColor
 */
+ (void)setDefaultMaskColor:(UIColor *)color;
/**
 *  @brief 设置默认的主题颜色，默认白色 eg 文字 loading状态颜色
 *
 *  @param tintColor UIColor
 */
+ (void)setDefaultTintColor:(UIColor *)tintColor;

/**
 *  @brief 设置text字体大小,默认12pt
 *
 *  @param font UIFont
 */
+ (void)setDefaultFont:(UIFont *)font;
/**
 *  @brief 设置text行间距,默认8.0f
 *
 *  @param lineSpacing CGFloat
 */
+ (void)setDefaultLineSpacing:(CGFloat)lineSpacing;
/**
 *  @brief 设置成功alter图片,默认为bundle中的图片
 *
 *  @param image UIImage
 */
+ (void)setDefaultSuccessImage:(UIImage *)image;
/**
 *  @brief 设置错误alter图片,默认为bundle中的图片
 *
 *  @param image UIImage
 */
+ (void)setDefaultErrorImage:(UIImage *)image;

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
