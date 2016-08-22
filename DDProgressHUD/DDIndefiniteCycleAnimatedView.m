//
//  DDIndefiniteCycleAnimatedView.m
//  DDProgressHUD
//
//  Created by lilingang on 8/16/16.
//  Copyright © 2016 LiLingang. All rights reserved.
//

#import "DDIndefiniteCycleAnimatedView.h"

const int DDHalfCircleDegree = 180;

#define DDANGLE(a) (M_PI/DDHalfCircleDegree*(a%(DDHalfCircleDegree*2)))

/**@brief 弧度一次增长的数值*/
const int DDAngleIncrementValue = 30;
const int DDAngleMinStartToEndValue = 10;
const int DDAngleMaxStartToEndValue = 160;

@interface DDIndefiniteCycleAnimatedView ()

/**@brief 定时器刷新半圆绘制*/
@property (nonatomic, strong) CADisplayLink *displayLink;

/**@brief 左边弧度开始位置*/
@property (nonatomic, assign) int leftSicircleStartAngle;
/**@brief 左边弧度结束位置*/
@property (nonatomic, assign) int leftSicircleEndAngle;

/**@brief 右边弧度结束位置*/
@property (nonatomic, assign) int rightSicircleStartAngle;
/**@brief 右边弧度结束位置*/
@property (nonatomic, assign) int rightSicircleEndAngle;

@end

@implementation DDIndefiniteCycleAnimatedView{
    BOOL _needRollback;
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
    self.lineColor = [UIColor whiteColor];
    self.lineWidth = 1.0f;
    
    self.rightSicircleStartAngle = 0;
    self.rightSicircleEndAngle = 10;
    self.leftSicircleStartAngle = DDHalfCircleDegree;
    self.leftSicircleEndAngle = DDHalfCircleDegree + 10;
    _isAnimating = NO;
    _needRollback = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - Private Methods

#pragma mark - Timer

- (void)startDisplayLink{
    if (!self.displayLink) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawPathAnimation:)];
        self.displayLink.frameInterval = 10;
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)stopDisplayLink{
    if (self.displayLink) {
        [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

#pragma mark - Draw
- (void)drawPathAnimation:(NSTimer *)timer{
    if (_needRollback) {
        self.leftSicircleStartAngle += DDAngleIncrementValue;
        self.rightSicircleStartAngle += DDAngleIncrementValue;
        if (abs(self.rightSicircleStartAngle - self.rightSicircleEndAngle) == DDAngleMinStartToEndValue) {
            _needRollback = NO;
        }
    } else {
        self.leftSicircleEndAngle += DDAngleIncrementValue;
        self.rightSicircleEndAngle += DDAngleIncrementValue;
        if (abs(self.rightSicircleEndAngle - self.rightSicircleStartAngle) == DDAngleMaxStartToEndValue) {
            _needRollback = YES;
        }
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextAddArc(context,
                    CGRectGetMidX(self.bounds),
                    CGRectGetMidY(self.bounds),
                    CGRectGetWidth(self.bounds)/2 - self.lineWidth,
                    DDANGLE(self.rightSicircleStartAngle),
                    DDANGLE(self.rightSicircleEndAngle),
                    0);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextAddArc(context,
                    CGRectGetMidX(self.bounds),
                    CGRectGetMidY(self.bounds),
                    CGRectGetWidth(self.bounds)/2 - self.lineWidth,
                    DDANGLE(self.leftSicircleStartAngle),
                    DDANGLE(self.leftSicircleEndAngle),
                    0);
    CGContextDrawPath(context, kCGPathStroke);
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
    [self startDisplayLink];
    [self.layer addAnimation:[self rotationAnimation] forKey:@"rotationAnimation"];
}

- (void)stopAnimation{
    if (!_isAnimating) {
        return;
    }
    _isAnimating = NO;
    [self.layer removeAllAnimations];
    [self stopDisplayLink];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (!_isAnimating) {
        return;
    }
    [self.layer addAnimation:[self rotationAnimation] forKey:@"rotationAnimation"];
}

#pragma mark - Notification

- (void)applicationDidEnterBackgroundNotification{
    if (_isAnimating) {
        [self stopDisplayLink];
    }
}

- (void)applicationDidBecomeActiveNotification{
    if (_isAnimating) {
        [self startDisplayLink];
    }
}

#pragma mark - Getter and Setter

- (CABasicAnimation *)rotationAnimation{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @(0);
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 1.0f;
    rotationAnimation.delegate = self;
    return rotationAnimation;
}
@end
