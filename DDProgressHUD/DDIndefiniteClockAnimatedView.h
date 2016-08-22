//
//  DDIndefiniteClockAnimatedView.h
//  DDProgressHUD
//
//  Created by lilingang on 16/8/22.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDIndefiniteAnimatedProtocol.h"

@interface DDIndefiniteClockAnimatedView : UIView<DDIndefiniteAnimatedProtocol>

/**@brief 表针的宽度, 默认1.5*/
@property (nonatomic, assign) CGFloat handWidth;

/**@brief 表针的颜色, 默认WhiteColor*/
@property (nonatomic, strong) UIColor *handColor;

/**@brief 中心点的宽度， 默认1.5*/
@property (nonatomic, assign) CGFloat capRadius;

@end
