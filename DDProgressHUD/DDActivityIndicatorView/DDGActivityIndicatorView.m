//
//  DDGActivityIndicatorView.m
//  DDGActivityIndicatorExample
//
//  Created by Danil Gontovnik on 5/23/15.
//  Copyright (c) 2015 Danil Gontovnik. All rights reserved.
//

#import "DDGActivityIndicatorView.h"

#import "DDGActivityIndicatorNineDotsAnimation.h"
#import "DDGActivityIndicatorTriplePulseAnimation.h"
#import "DDGActivityIndicatorFiveDotsAnimation.h"
#import "DDGActivityIndicatorRotatingSquaresAnimation.h"
#import "DDGActivityIndicatorDoubleBounceAnimation.h"
#import "DDGActivityIndicatorTwoDotsAnimation.h"
#import "DDGActivityIndicatorThreeDotsAnimation.h"
#import "DDGActivityIndicatorBallPulseAnimation.h"
#import "DDGActivityIndicatorBallClipRotateAnimation.h"
#import "DDGActivityIndicatorBallClipRotatePulseAnimation.h"
#import "DDGActivityIndicatorBallClipRotateMultipleAnimation.h"
#import "DDGActivityIndicatorBallRotateAnimation.h"
#import "DDGActivityIndicatorBallZigZagAnimation.h"
#import "DDGActivityIndicatorBallZigZagDeflectAnimation.h"
#import "DDGActivityIndicatorBallTrianglePathAnimation.h"
#import "DDGActivityIndicatorBallScaleAnimation.h"
#import "DDGActivityIndicatorLineScaleAnimation.h"
#import "DDGActivityIndicatorLineScalePartyAnimation.h"
#import "DDGActivityIndicatorBallScaleMultipleAnimation.h"
#import "DDGActivityIndicatorBallPulseSyncAnimation.h"
#import "DDGActivityIndicatorBallBeatAnimation.h"
#import "DDGActivityIndicatorLineScalePulseOutAnimation.h"
#import "DDGActivityIndicatorLineScalePulseOutRapidAnimation.h"
#import "DDGActivityIndicatorBallScaleRippleAnimation.h"
#import "DDGActivityIndicatorBallScaleRippleMultipleAnimation.h"
#import "DDGActivityIndicatorTriangleSkewSpinAnimation.h"
#import "DDGActivityIndicatorBallGridBeatAnimation.h"
#import "DDGActivityIndicatorBallGridPulseAnimation.h"
#import "DDGActivityIndicatorRotatingSandglassAnimation.h"
#import "DDGActivityIndicatorRotatingTrigonAnimation.h"
#import "DDGActivityIndicatorTripleRingsAnimation.h"
#import "DDGActivityIndicatorCookieTerminatorAnimation.h"
#import "DDGActivityIndicatorBallSpinFadeLoader.h"
#import "DDGActivityIndicatorClockAnimation.h"

static const CGFloat kDDGActivityIndicatorDefaultSize = 40.0f;

@interface DDGActivityIndicatorView () {
    CALayer *_animationLayer;
}

@end

@implementation DDGActivityIndicatorView

#pragma mark -
#pragma mark Constructors

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _tintColor = [UIColor whiteColor];
        _size = kDDGActivityIndicatorDefaultSize;
        [self commonInit];
    }
    return self;
}

- (id)initWithType:(DDGActivityIndicatorAnimationType)type {
    return [self initWithType:type tintColor:[UIColor whiteColor] size:kDDGActivityIndicatorDefaultSize];
}

- (id)initWithType:(DDGActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor {
    return [self initWithType:type tintColor:tintColor size:kDDGActivityIndicatorDefaultSize];
}

- (id)initWithType:(DDGActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor size:(CGFloat)size {
    self = [super init];
    if (self) {
        _type = type;
        _size = size;
        _tintColor = tintColor;
        [self commonInit];
    }
    return self;
}

#pragma mark -
#pragma mark Methods

- (void)commonInit {
    self.userInteractionEnabled = NO;
    self.hidden = YES;
    
    _animationLayer = [[CALayer alloc] init];
    [self.layer addSublayer:_animationLayer];
}

- (void)setupAnimation {
    _animationLayer.sublayers = nil;
    
    id<DDGActivityIndicatorAnimationProtocol> animation = [DDGActivityIndicatorView activityIndicatorAnimationForAnimationType:_type];
    
    if ([animation respondsToSelector:@selector(setupAnimationInLayer:withSize:tintColor:)]) {
        [animation setupAnimationInLayer:_animationLayer withSize:CGSizeMake(_size, _size) tintColor:_tintColor];
        _animationLayer.speed = 0.0f;
    }
}

- (void)startAnimating {
    if (!_animationLayer.sublayers) {
        [self setupAnimation];
    }
    self.hidden = NO;
    _animationLayer.speed = 1.0f;
    _animating = YES;
}

- (void)stopAnimating {
    _animationLayer.speed = 0.0f;
    _animating = NO;
    self.hidden = YES;
}

#pragma mark -
#pragma mark Setters

- (void)setType:(DDGActivityIndicatorAnimationType)type {
    if (_type != type) {
        _type = type;
        
        [self setupAnimation];
    }
}

- (void)setSize:(CGFloat)size {
    if (_size != size) {
        _size = size;
        
        [self setupAnimation];
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    if (![_tintColor isEqual:tintColor]) {
        _tintColor = tintColor;
        
        CGColorRef tintColorRef = tintColor.CGColor;
        for (CALayer *sublayer in _animationLayer.sublayers) {
            sublayer.backgroundColor = tintColorRef;
            
            if ([sublayer isKindOfClass:[CAShapeLayer class]]) {
                CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
                shapeLayer.strokeColor = tintColorRef;
                shapeLayer.fillColor = tintColorRef;
            }
        }
    }
}

#pragma mark -
#pragma mark Getters

+ (id<DDGActivityIndicatorAnimationProtocol>)activityIndicatorAnimationForAnimationType:(DDGActivityIndicatorAnimationType)type {
    switch (type) {
        case DDGActivityIndicatorAnimationTypeNineDots:
            return [[DDGActivityIndicatorNineDotsAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeTriplePulse:
            return [[DDGActivityIndicatorTriplePulseAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeFiveDots:
            return [[DDGActivityIndicatorFiveDotsAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeRotatingSquares:
            return [[DDGActivityIndicatorRotatingSquaresAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeDoubleBounce:
            return [[DDGActivityIndicatorDoubleBounceAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeTwoDots:
            return [[DDGActivityIndicatorTwoDotsAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeThreeDots:
            return [[DDGActivityIndicatorThreeDotsAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeBallPulse:
            return [[DDGActivityIndicatorBallPulseAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeBallClipRotate:
            return [[DDGActivityIndicatorBallClipRotateAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeBallClipRotatePulse:
            return [[DDGActivityIndicatorBallClipRotatePulseAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeBallClipRotateMultiple:
            return [[DDGActivityIndicatorBallClipRotateMultipleAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeBallRotate:
            return [[DDGActivityIndicatorBallRotateAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeBallZigZag:
            return [[DDGActivityIndicatorBallZigZagAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeBallZigZagDeflect:
            return [[DDGActivityIndicatorBallZigZagDeflectAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeBallTrianglePath:
            return [[DDGActivityIndicatorBallTrianglePathAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeBallScale:
            return [[DDGActivityIndicatorBallScaleAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeLineScale:
            return [[DDGActivityIndicatorLineScaleAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeLineScaleParty:
            return [[DDGActivityIndicatorLineScalePartyAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeBallScaleMultiple:
            return [[DDGActivityIndicatorBallScaleMultipleAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeBallPulseSync:
            return [[DDGActivityIndicatorBallPulseSyncAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeBallBeat:
            return [[DDGActivityIndicatorBallBeatAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeLineScalePulseOut:
            return [[DDGActivityIndicatorLineScalePulseOutAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeLineScalePulseOutRapid:
            return [[DDGActivityIndicatorLineScalePulseOutRapidAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeBallScaleRipple:
            return [[DDGActivityIndicatorBallScaleRippleAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeBallScaleRippleMultiple:
            return [[DDGActivityIndicatorBallScaleRippleMultipleAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeTriangleSkewSpin:
            return [[DDGActivityIndicatorTriangleSkewSpinAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeBallGridBeat:
            return [[DDGActivityIndicatorBallGridBeatAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeBallGridPulse:
            return [[DDGActivityIndicatorBallGridPulseAnimation alloc] init];
        case DDGActivityIndicatorAnimationTypeRotatingSanDDGlass:
            return [[DDGActivityIndicatorRotatingSandglassAnimation alloc]init];
        case DDGActivityIndicatorAnimationTypeRotatingTrigons:
            return [[DDGActivityIndicatorRotatingTrigonAnimation alloc]init];
        case DDGActivityIndicatorAnimationTypeTripleRings:
            return [[DDGActivityIndicatorTripleRingsAnimation alloc]init];
        case DDGActivityIndicatorAnimationTypeCookieTerminator:
            return [[DDGActivityIndicatorCookieTerminatorAnimation alloc]init];
        case DDGActivityIndicatorAnimationTypeBallSpinFadeLoader:
            return [[DDGActivityIndicatorBallSpinFadeLoader alloc] init];
        case DDGActivityIndicatorAnimationTypeClock:
            return [[DDGActivityIndicatorClockAnimation alloc] init];
    }
    return nil;
}

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _animationLayer.frame = self.bounds;
    
    if (_animating) {
        [self stopAnimating];
        [self setupAnimation];
        [self startAnimating];
    }
}

@end
