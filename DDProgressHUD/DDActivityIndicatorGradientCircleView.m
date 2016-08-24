//
//  DDActivityIndicatorGradientCircleView.m
//  DDProgressHUDDemo
//
//  Created by lilingang on 16/8/23.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDActivityIndicatorGradientCircleView.h"

const int DDHalfCircleDegree = 180;

#define DDANGLE(a) (M_PI/DDHalfCircleDegree*(a%(DDHalfCircleDegree*2)))

/**@brief 弧度一次增长的数值*/
const int DDAngleIncrementValue = 30;
const int DDAngleMinStartToEndValue = 10;
const int DDAngleMaxStartToEndValue = 160;

@interface DDActivityIndicatorGradientCircleView ()

/**@brief 定时器刷新半圆绘制*/
@property (nonatomic, strong) CADisplayLink *displayLink;
/**@brief 右边弧度结束位置*/
@property (nonatomic, assign) int rightSicircleStartAngle;
/**@brief 右边弧度结束位置*/
@property (nonatomic, assign) int rightSicircleEndAngle;

@end

@implementation DDActivityIndicatorGradientCircleView{
    BOOL _needRollback;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.rightSicircleStartAngle = 0;
        self.rightSicircleEndAngle = 10;
        _needRollback = NO;
        self.tintColor = [UIColor whiteColor];
    }
    return self;
}

- (void)startAnimating{
    if (_animating) {
        return;
    }
    _animating = YES;
    [self startDisplayLink];
    [self.layer addAnimation:[self rotationAnimation] forKey:@"rotationAnimation"];
}

- (void)stopAnimating{
    _animating = NO;
    [self.layer removeAllAnimations];
    [self stopDisplayLink];
}

#pragma mark - Private Methods

#pragma mark - Timer

- (void)startDisplayLink{
    if (!self.displayLink) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawPathAnimation:)];
        self.displayLink.frameInterval = 10;
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)stopDisplayLink{
    if (self.displayLink) {
        [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

#pragma mark - Draw
- (void)drawPathAnimation:(NSTimer *)timer{
    if (_needRollback) {
        self.rightSicircleStartAngle += DDAngleIncrementValue;
        if (abs(self.rightSicircleStartAngle - self.rightSicircleEndAngle) == DDAngleMinStartToEndValue) {
            _needRollback = NO;
        }
    } else {
        self.rightSicircleEndAngle += DDAngleIncrementValue;
        if (abs(self.rightSicircleEndAngle - self.rightSicircleStartAngle) == DDAngleMaxStartToEndValue) {
            _needRollback = YES;
        }
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    CGFloat lineWidth = 1.0f;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, self.tintColor.CGColor);
    CGContextAddArc(context,
                    CGRectGetMidX(self.bounds),
                    CGRectGetMidY(self.bounds),
                    CGRectGetWidth(self.bounds)/2 - lineWidth,
                    DDANGLE(self.rightSicircleStartAngle),
                    DDANGLE(self.rightSicircleEndAngle),
                    0);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextAddArc(context,
                    CGRectGetMidX(self.bounds),
                    CGRectGetMidY(self.bounds),
                    CGRectGetWidth(self.bounds)/2 - lineWidth,
                    DDANGLE(self.rightSicircleStartAngle + DDHalfCircleDegree),
                    DDANGLE(self.rightSicircleEndAngle + DDHalfCircleDegree),
                    0);
    CGContextDrawPath(context, kCGPathStroke);
}

#pragma mark - Getter and Setter

- (CABasicAnimation *)rotationAnimation{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @(0);
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 1.0f;
    rotationAnimation.repeatCount = NSIntegerMax;
    rotationAnimation.removedOnCompletion = NO;
    return rotationAnimation;
}

@end
