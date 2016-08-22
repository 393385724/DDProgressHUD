//
//  DDIndefiniteClockAnimatedView.m
//  DDProgressHUD
//
//  Created by lilingang on 16/8/22.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDIndefiniteClockAnimatedView.h"

/**@brief 秒针与表盘半径的长度比例*/
CGFloat const DDClocKLengthOfSecondHandToDialWidthRatio = 0.375;
/**@brief 分针与秒针的长度比例*/
CGFloat const DDClocKLengthOfMinuteHandToSecondHandRatio = 0.618;

@interface DDIndefiniteClockAnimatedView ()

/**@brief 表盘*/
@property (nonatomic, strong) CAShapeLayer *clockDialLayer;
/**@brief 时钟的分针*/
@property (nonatomic, strong) CAShapeLayer *minuteHandLayer;
/**@brief 时钟的秒针*/
@property (nonatomic, strong) CAShapeLayer *secondHandLayer;
/**@brief 表盘上的锚点*/
@property (nonatomic, strong) CAShapeLayer *capLayer;

@end

@implementation DDIndefiniteClockAnimatedView{
    BOOL _isAnimating;
}

#pragma mark - Life

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSettings];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initSettings];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSettings];
    }
    return self;
}

- (void)initSettings{
    self.backgroundColor = [UIColor clearColor];
    self.handColor = [UIColor whiteColor];
    self.handWidth = 1.5f;
    self.capRadius = 1.5f;
    [self.layer addSublayer:self.clockDialLayer];
}

#pragma mark - Private Methods

- (CGFloat)currentWidth{
    return CGRectGetWidth(self.bounds);
}

- (CAShapeLayer *)handLayerWithWidth:(CGFloat)width height:(CGFloat)height tailLength:(CGFloat)tailLength tickLength:(CGFloat)tickLength {
    CGPoint dialCenter = CGPointMake([self currentWidth]/ 2.0, [self currentWidth] / 2.0);
    CGFloat layerWidth = width;
    CGFloat layerHeight = height;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    CGPoint addingPoint, controlPoint1, controlPoint2;
    addingPoint = CGPointMake(dialCenter.x - tailLength, dialCenter.y  - layerHeight / 2.0); // 左上顶点
    [bezierPath moveToPoint:addingPoint];
    addingPoint = CGPointMake(dialCenter.x - tailLength, dialCenter.y  + layerHeight / 2.0); // 左下顶点
    controlPoint1 = CGPointMake(dialCenter.x  - layerHeight * 3.0 / 4.0 - tailLength,dialCenter.y  - layerHeight / 2.0); // 最左端圆弧控制点 1
    controlPoint2 = CGPointMake(dialCenter.x  - layerHeight * 3.0 / 4.0 - tailLength,dialCenter.y  + layerHeight / 2.0); // 最左端圆弧控制点 2
    
    
    [bezierPath addCurveToPoint:addingPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    addingPoint = CGPointMake(dialCenter.x + layerWidth, dialCenter.y + layerHeight / 2.0); // 右下顶点
    [bezierPath addLineToPoint:addingPoint];
    addingPoint =  CGPointMake(dialCenter.x + layerWidth + tickLength,dialCenter.y); // 最右端尖点
    [bezierPath addLineToPoint:addingPoint];
    addingPoint = CGPointMake(dialCenter.x + layerWidth, dialCenter.y - layerHeight / 2.0); // 右上顶点
    [bezierPath addLineToPoint:addingPoint];
    [bezierPath closePath];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.frame = CGRectMake(0, 0, [self currentWidth], [self currentWidth]);
    shapeLayer.lineWidth = 0.2;
    shapeLayer.strokeColor = [UIColor grayColor].CGColor;
    shapeLayer.fillColor = self.handColor.CGColor;
    return shapeLayer;
}

- (void)pasueLayer:(CALayer *)layer{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

- (void)resumeLayer:(CALayer *)layer{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

#pragma mark - DDIndefiniteAnimatedProtocol

- (BOOL)isAnimating{
    return _isAnimating;
}

- (void)startAnimation{
    if (_isAnimating) {
        return;
    }
    _isAnimating = YES;
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 30;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT32_MAX;
    rotationAnimation.removedOnCompletion = NO;
    [self.minuteHandLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT32_MAX;
    rotationAnimation.removedOnCompletion = NO;
    [self.secondHandLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)stopAnimation{
    if (!_isAnimating) {
        return;
    }
    _isAnimating = NO;
    [self.minuteHandLayer removeAllAnimations];
    [self.secondHandLayer removeAllAnimations];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Notification

- (void)applicationDidEnterBackgroundNotification{
    if (_isAnimating) {
        [self pasueLayer:self.secondHandLayer];
        [self pasueLayer:self.minuteHandLayer];
    }
}

- (void)applicationDidBecomeActiveNotification{
    if (_isAnimating) {
        [self resumeLayer:self.secondHandLayer];
        [self resumeLayer:self.minuteHandLayer];
    }
}

#pragma mark - Getter and setter

- (CAShapeLayer *)clockDialLayer{
    if (!_clockDialLayer) {
        _clockDialLayer = [CAShapeLayer layer];
        _clockDialLayer.frame = CGRectMake(0, 0, [self currentWidth], [self currentWidth]);
        _clockDialLayer.cornerRadius = [self currentWidth]/2.0;
        _clockDialLayer.masksToBounds = YES;
        [_clockDialLayer addSublayer:self.minuteHandLayer];
        [_clockDialLayer addSublayer:self.secondHandLayer];
        [_clockDialLayer addSublayer:self.capLayer];
    }
    _clockDialLayer.borderWidth = 1.5;
    _clockDialLayer.borderColor = self.handColor.CGColor;
    return _clockDialLayer;
}

- (CAShapeLayer *)secondHandLayer{
    if (!_secondHandLayer) {
        CGFloat secondLayerLength = [self currentWidth]/2.0 * DDClocKLengthOfSecondHandToDialWidthRatio;
        CGFloat secondLayerWidth = self.handWidth;
        _secondHandLayer = [self handLayerWithWidth:secondLayerLength height:secondLayerWidth tailLength:0 tickLength:secondLayerWidth];
    }
    return _secondHandLayer;
}

- (CAShapeLayer *)minuteHandLayer{
    if (!_minuteHandLayer) {
        CGFloat secondLayerLength = [self currentWidth]/2.0 * DDClocKLengthOfSecondHandToDialWidthRatio;
        CGFloat minuteLayerLenght = secondLayerLength * DDClocKLengthOfMinuteHandToSecondHandRatio;
        CGFloat minuteLayerWidth = self.handWidth;
        _minuteHandLayer = [self handLayerWithWidth:minuteLayerLenght height:minuteLayerWidth tailLength:0 tickLength:minuteLayerWidth];
    }
    return _minuteHandLayer;
}

- (CAShapeLayer *)capLayer{
    if (!_capLayer) {
        _capLayer = [CAShapeLayer layer];
        _capLayer.masksToBounds = YES;
        CGFloat width = [self currentWidth];
        _capLayer.frame = CGRectMake(width / 2 - self.capRadius, width / 2 - self.capRadius, self.capRadius * 2, self.capRadius * 2);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_capLayer.bounds cornerRadius:self.capRadius];
        _capLayer.path = path.CGPath;
        _capLayer.cornerRadius = width/2.0;
    }
    _capLayer.fillColor = self.handColor.CGColor;
    _capLayer.strokeColor = self.handColor.CGColor;
    return _capLayer;
}

@end
