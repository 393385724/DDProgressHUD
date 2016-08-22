//
//  DDIndefiniteCycleAnimatedView.h
//  DDProgressHUD
//
//  Created by lilingang on 8/16/16.
//  Copyright © 2016 LiLingang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDIndefiniteAnimatedProtocol.h"

/**
 无限转动动画
 */
@interface DDIndefiniteCycleAnimatedView : UIView<DDIndefiniteAnimatedProtocol>

/**@brief 绘制弧线的宽度,默认1.0*/
@property (nonatomic, assign) CGFloat lineWidth;

/**@brief 绘制弧线的颜色,默认[UIColor whiteColor]*/
@property (nonatomic, strong) UIColor *lineColor;

@end
