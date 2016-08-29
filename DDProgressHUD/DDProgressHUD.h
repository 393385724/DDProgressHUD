//
//  DDProgressHUD.h
//  DDProgressHUD
//
//  Created by lilingang on 8/17/16.
//  Copyright © 2016 LiLingang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DDProgressHUDMaskStyle) {
    DDProgressHUDMaskStyleCustom = 1,     // default style, don't allow user interactions and dim the UI in the back of the HUD with a custom color
    DDProgressHUDMaskStyleNone            //  allow user interactions while HUD is displayed
};

typedef NS_ENUM(NSUInteger, DDProgressHUDActivityType) {
    DDProgressHUDActivityTypeLineChange,
    DDProgressHUDActivityTypeNineDots,
    DDProgressHUDActivityTypeTriplePulse,
    DDProgressHUDActivityTypeFiveDots,
    DDProgressHUDActivityTypeRotatingSquares,
    DDProgressHUDActivityTypeDoubleBounce,
    DDProgressHUDActivityTypeTwoDots,
    DDProgressHUDActivityTypeThreeDots,
    DDProgressHUDActivityTypeBallPulse,
    DDProgressHUDActivityTypeBallClipRotate,
    DDProgressHUDActivityTypeBallClipRotatePulse,
    DDProgressHUDActivityTypeBallClipRotateMultiple,
    DDProgressHUDActivityTypeBallRotate,
    DDProgressHUDActivityTypeBallZigZag,
    DDProgressHUDActivityTypeBallZigZagDeflect,
    DDProgressHUDActivityTypeBallTrianglePath,
    DDProgressHUDActivityTypeBallScale,
    DDProgressHUDActivityTypeLineScale,
    DDProgressHUDActivityTypeLineScaleParty,
    DDProgressHUDActivityTypeBallScaleMultiple,
    DDProgressHUDActivityTypeBallPulseSync,
    DDProgressHUDActivityTypeBallBeat,
    DDProgressHUDActivityTypeLineScalePulseOut,
    DDProgressHUDActivityTypeLineScalePulseOutRapid,
    DDProgressHUDActivityTypeBallScaleRipple,
    DDProgressHUDActivityTypeBallScaleRippleMultiple,
    DDProgressHUDActivityTypeTriangleSkewSpin,
    DDProgressHUDActivityTypeBallGridBeat,
    DDProgressHUDActivityTypeBallGridPulse,
    DDProgressHUDActivityTypeRotatingSanDDGlass,
    DDProgressHUDActivityTypeRotatingTrigons,
    DDProgressHUDActivityTypeTripleRings,
    DDProgressHUDActivityTypeCookieTerminator,
    DDProgressHUDActivityTypeBallSpinFadeLoader,
    DDProgressHUDActivityTypeClock,
};

typedef void (^DDProgressHUDDismissCompletion)(void);

@interface DDProgressHUD : UIView

/**
 *  @brief 设置默认最小消失时间,当且仅当以alter形式出现的时候生效,默认1.5s
 *
 *  @param minDismissDuration CGFloat
 */
+ (void)setDefaultMinDismissDuration:(CGFloat)minDismissDuration;
/**
 *  @brief 设置默认最大消失时间,当且仅当以alter形式出现的时候生效,默认5s
 *
 *  @param maxDismissDuration CGFloat
 */
+ (void)setDefaultMaxDismissDuration:(CGFloat)maxDismissDuration;



/**
 *  @brief 设置背景mask,默认DDProgressHUDMaskStyleNone
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
 *  @brief 设置HUD默认背景色,默认黑色
 *
 *  @param color UIColor
 */
+ (void)setDefaultHUDBackGroudColor:(UIColor *)color;
/**
 *  @brief 设置HUD默认圆角半径,默认4.0
 *
 *  @param cornerRadius CGFloat
 */
+ (void)setDefaultHUDCornerRadius:(CGFloat)cornerRadius;
/**
 *  @brief 设置HUD默认阴影颜色,默认0.82透明度的黑色
 *
 *  @param color UIColor
 */
+ (void)setDefaultHUDShadowColor:(UIColor *)color;
/**
 *  @brief 设置HUD默认阴影偏移,默认CGSize(2.0,2.0)
 *
 *  @param shadowOffset CGSize
 */
+ (void)setDefaultHUDShadowOffset:(CGSize)shadowOffset;
/**
 *  @brief 设置HUD默认阴影扩散半径,默认8.0
 *
 *  @param shadowRadius CGFloat
 */
+ (void)setDefaultHUDShadowRadius:(CGFloat)shadowRadius;


/**
 *  @brief 设置默认活动指示器动画，默认DDProgressHUDActivityTypeLineChange
 *
 *  @param activityType DDProgressHUDActivityType
 */
+ (void)setDefaultActivityType:(DDProgressHUDActivityType)activityType;
/**
 *  @brief 设置默认的活动指示器颜色，默认whiteColor
 *
 *  @param activityColor UIColor
 */
+ (void)setDefaultActivityColor:(UIColor *)activityColor;
/**
 *  @brief 设置默认活动指示器大小, 默认25.0
 *
 *  @param activitySize CGFloat
 */
+ (void)setDefaultActivitySize:(CGFloat)activitySize;


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
 *  @brief 显示一个无限等待提示框
 *
 *  @param status 提示文案
 */
+ (void)showHUDWithStatus:(NSString*)status;

/**
 *  @brief 显示一个纯文本提示框并在短暂时间后消失
 *
 *  @param status 提示文案
 */
+ (void)showWithStatus:(NSString*)status;

/**
 *  @brief 显示一个带有默认成功图片的提示并在短暂时间后消失
 *
 *  @param status 提示文案
 */
+ (void)showSucessWithStatus:(NSString*)status;

/**
 *  @brief 显示一个带有默认失败图片的提示并在短暂时间后消失
 *
 *  @param status 提示文案
 */
+ (void)showErrorWithStatus:(NSString*)status;


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
