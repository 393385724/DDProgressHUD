//
//  DDActivityIndicatorGradientCircleView.h
//  DDProgressHUDDemo
//
//  Created by lilingang on 16/8/23.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDActivityIndicatorGradientCircleView : UIView

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, readonly) BOOL animating;

- (void)startAnimating;
- (void)stopAnimating;

@end
