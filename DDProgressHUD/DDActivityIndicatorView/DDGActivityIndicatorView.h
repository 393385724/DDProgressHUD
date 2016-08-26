//
//  DDGActivityIndicatorView.h
//  DDGActivityIndicatorExample
//
//  Created by Danil Gontovnik on 5/23/15.
//  Copyright (c) 2015 Danil Gontovnik. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DDGActivityIndicatorAnimationType) {
    DDGActivityIndicatorAnimationTypeNineDots,
    DDGActivityIndicatorAnimationTypeTriplePulse,
    DDGActivityIndicatorAnimationTypeFiveDots,
    DDGActivityIndicatorAnimationTypeRotatingSquares,
    DDGActivityIndicatorAnimationTypeDoubleBounce,
    DDGActivityIndicatorAnimationTypeTwoDots,
    DDGActivityIndicatorAnimationTypeThreeDots,
    DDGActivityIndicatorAnimationTypeBallPulse,
    DDGActivityIndicatorAnimationTypeBallClipRotate,
    DDGActivityIndicatorAnimationTypeBallClipRotatePulse,
    DDGActivityIndicatorAnimationTypeBallClipRotateMultiple,
    DDGActivityIndicatorAnimationTypeBallRotate,
    DDGActivityIndicatorAnimationTypeBallZigZag,
    DDGActivityIndicatorAnimationTypeBallZigZagDeflect,
    DDGActivityIndicatorAnimationTypeBallTrianglePath,
    DDGActivityIndicatorAnimationTypeBallScale,
    DDGActivityIndicatorAnimationTypeLineScale,
    DDGActivityIndicatorAnimationTypeLineScaleParty,
    DDGActivityIndicatorAnimationTypeBallScaleMultiple,
    DDGActivityIndicatorAnimationTypeBallPulseSync,
    DDGActivityIndicatorAnimationTypeBallBeat,
    DDGActivityIndicatorAnimationTypeLineScalePulseOut,
    DDGActivityIndicatorAnimationTypeLineScalePulseOutRapid,
    DDGActivityIndicatorAnimationTypeBallScaleRipple,
    DDGActivityIndicatorAnimationTypeBallScaleRippleMultiple,
    DDGActivityIndicatorAnimationTypeTriangleSkewSpin,
    DDGActivityIndicatorAnimationTypeBallGridBeat,
    DDGActivityIndicatorAnimationTypeBallGridPulse,
    DDGActivityIndicatorAnimationTypeRotatingSanDDGlass,
    DDGActivityIndicatorAnimationTypeRotatingTrigons,
    DDGActivityIndicatorAnimationTypeTripleRings,
    DDGActivityIndicatorAnimationTypeCookieTerminator,
    DDGActivityIndicatorAnimationTypeBallSpinFadeLoader,
    DDGActivityIndicatorAnimationTypeClock,
};

@interface DDGActivityIndicatorView : UIView

- (id)initWithType:(DDGActivityIndicatorAnimationType)type;
- (id)initWithType:(DDGActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor;
- (id)initWithType:(DDGActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor size:(CGFloat)size;

@property (nonatomic) DDGActivityIndicatorAnimationType type;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic) CGFloat size;

@property (nonatomic, readonly) BOOL animating;

- (void)startAnimating;
- (void)stopAnimating;

@end
