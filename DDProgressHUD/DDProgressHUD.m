//
//  DDProgressHUD.m
//  DDProgressHUD
//
//  Created by lilingang on 8/17/16.
//  Copyright © 2016 LiLingang. All rights reserved.
//

#import "DDProgressHUD.h"
#import "DDActivityIndicatorView.h"
#import "DDActivityIndicatorGradientCircleView.h"

/**@brief 定义了HUD显示的风格*/
typedef NS_ENUM(NSUInteger, DDProgressHUDType) {
    DDProgressHUDTypeInit,         /**初始值*/
    DDProgressHUDTypeLoading,      /**等待框*/
    DDProgressHUDTypeText,         /**纯文字*/
    DDProgressHUDTypeImage,        /**图片+文字*/
};

@interface DDProgressHUD ()

/**@brief DDProgressHUDType*/
@property (nonatomic, assign) DDProgressHUDType hudType;

/**@brief Window上的蒙层*/
@property (nonatomic, strong) UIView *overlayView;
/**@brief 提示框容器*/
@property (nonatomic, strong) UIView *hudView;
/**@brief 指示器*/
@property (nonatomic, strong) DDActivityIndicatorView *activityIndicatorView;
/**@brief 渐变圆圈*/
@property (nonatomic, strong) DDActivityIndicatorGradientCircleView *indicatorGradientCircleView;
/**@brief 图片View*/
@property (nonatomic, strong) UIImageView *imageView;
/**@brief 提示文案*/
@property (nonatomic, strong) UILabel *statusLabel;

/**@brief showtext 和 showImage 消失定时器*/
@property (nonatomic, strong) NSTimer *fadeOutTimer;
@property (nonatomic, copy) DDProgressHUDDismissCompletion completionBlock;

/**@brief statusLabel显示的是否是富文本，默认NO*/
@property (nonatomic, assign) BOOL isAttributedString;
/**@brief 元素水平方向边距, 默认12.0f*/
@property (nonatomic, assign) CGFloat itemsHorizontalMargin;
/**@brief 元素垂直方向边距, 默认24.0f*/
@property (nonatomic, assign) CGFloat itemsVerticalMargin;

//------------------UI Config

@property (nonatomic, assign) CGFloat minDismissDuration;
@property (nonatomic, assign) CGFloat maxDismissDuration;

@property (nonatomic, assign) DDProgressHUDMaskStyle maskStyle;
@property (nonatomic, strong) UIColor *maskColor;

@property (nonatomic, assign) CGFloat hudMinWidth;
@property (nonatomic, assign) CGFloat hudMaxWidth;
@property (nonatomic, strong) UIColor *hudBackgroundColor;
@property (nonatomic, assign) CGFloat hudCornerRadius;
@property (nonatomic, strong) UIColor *hudShadowColor;
@property (nonatomic, assign) CGSize hudShadowOffset;
@property (nonatomic, assign) CGFloat hudShadowRadius;


@property (nonatomic, assign) DDProgressHUDActivityType activityType;
@property (nonatomic, assign) DDProgressHUDActivityType lastActivityType;

@property (nonatomic, strong) UIFont *labelFont;
@property (nonatomic, assign) CGFloat labelLineSpacing;
@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, strong) UIColor *activityColor;
@property (nonatomic, assign) CGFloat activitySize;

@property (nonatomic, strong) UIImage *successImage;
@property (nonatomic, strong) UIImage *errorImage;


//------------------NSLayoutConstraint
@property (nonatomic, strong) NSLayoutConstraint *hudViewHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *hudViewWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *hudCenterXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *hudCenterYConstraint;

@property (nonatomic, strong) NSLayoutConstraint *indefiniteTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *indefiniteCenterXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *indefiniteWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *indefiniteHeightConstraint;


@property (nonatomic, strong) NSLayoutConstraint *statusLabelTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *statusLabelCenterXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *statusLabelHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *statusLabelWidthConstraint;

@end

@implementation DDProgressHUD

+ (DDProgressHUD*)sharedView {
    static dispatch_once_t once;
    static DDProgressHUD *sharedView;
    dispatch_once(&once, ^{
        sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    return sharedView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0.0;
        self.hudType = DDProgressHUDTypeInit;
        self.isAttributedString = NO;
        self.itemsVerticalMargin = 12.0f;
        self.itemsHorizontalMargin = 24.0f;

        self.minDismissDuration = 1.5f;
        self.maxDismissDuration = 5.0f;
        
        self.maskStyle = DDProgressHUDMaskStyleNone;
        self.maskColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.54f];
        
        self.hudMinWidth = 108.0f;
        self.hudMaxWidth = 216.0f;
        self.hudBackgroundColor = [UIColor blackColor];
        self.hudCornerRadius = 4.0f;
        self.hudShadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.82f];
        self.hudShadowOffset = CGSizeMake(2.0, 2.0);
        self.hudShadowRadius = 8.0;
        
        self.activityType = DDProgressHUDActivityTypeLineChange;
        self.activityColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:0 alpha:1];
        self.activitySize = 22.0f;
        
        self.labelFont = [UIFont systemFontOfSize:14.0f];
        self.labelLineSpacing = 8.0f;
        self.tintColor = [UIColor whiteColor];
        
        _successImage = [[UIImage imageNamed:@"success"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _errorImage = [[UIImage imageNamed:@"error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return self;
}

#pragma mark - Public Methods

#pragma mark - UI Confige

+ (void)setDefaultMinDismissDuration:(CGFloat)minDismissDuration{
    [self sharedView].minDismissDuration = minDismissDuration;
}
+ (void)setDefaultMaxDismissDuration:(CGFloat)maxDismissDuration{
    [self sharedView].maxDismissDuration = maxDismissDuration;
}

+ (void)setDefaultMaskStyle:(DDProgressHUDMaskStyle)maskStyle{
    [self sharedView].maskStyle = maskStyle;
}
+ (void)setDefaultMaskColor:(UIColor *)color{
    [self sharedView].maskColor = color;
}


+ (void)setDefaultHUDBackGroudColor:(UIColor *)color{
    [self sharedView].hudBackgroundColor = color;
}
+ (void)setDefaultHUDCornerRadius:(CGFloat)cornerRadius{
    [self sharedView].hudCornerRadius = cornerRadius;
}
+ (void)setDefaultHUDShadowColor:(UIColor *)color{
    [self sharedView].hudShadowColor = color;
}
+ (void)setDefaultHUDShadowOffset:(CGSize)shadowOffset{
    [self sharedView].hudShadowOffset = shadowOffset;
}
+ (void)setDefaultHUDShadowRadius:(CGFloat)shadowRadius{
    [self sharedView].hudShadowRadius = shadowRadius;
}


+ (void)setDefaultActivityType:(DDProgressHUDActivityType)activityType{
    [self sharedView].activityType = activityType;
}
+ (void)setDefaultActivityColor:(UIColor *)activityColor{
    [self sharedView].activityColor = activityColor;
}
+ (void)setDefaultActivitySize:(CGFloat)activitySize{
    [self sharedView].activitySize = activitySize;
}


+ (void)setDefaultFont:(UIFont *)font{
    [self sharedView].labelFont = font;
}

+ (void)setDefaultTintColor:(UIColor *)tintColor{
    [self sharedView].tintColor = tintColor;
}

+ (void)setDefaultLineSpacing:(CGFloat)lineSpacing{
    [self sharedView].labelLineSpacing = lineSpacing;
}



+ (void)setDefaultSuccessImage:(UIImage *)image{
    [self sharedView].successImage = image;
}

+ (void)setDefaultErrorImage:(UIImage *)image{
    [self sharedView].errorImage = image;
}


#pragma mark - Show and Dismiss
+ (void)showHUDWithStatus:(NSString*)status{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self sharedView].hudType == DDProgressHUDTypeLoading && [self sharedView].activityType == [self sharedView].lastActivityType) {
            [[self sharedView] updateStatus:status];
        } else {
            [self sharedView].hudType = DDProgressHUDTypeLoading;
            [[self sharedView] showHUDStatus:status];
        }
    });
}

+ (void)showWithStatus:(NSString*)status{
    [self showImage:nil status:status];
}

+ (void)showSucessWithStatus:(NSString*)status{
    [self showImage:[self sharedView].successImage status:status];
}

+ (void)showErrorWithStatus:(NSString*)status{
    [self showImage:[self sharedView].errorImage status:status];
}

+ (void)dismiss{
    [self dismissWithDelay:0 completion:nil];
}

+ (void)dismissWithCompletion:(DDProgressHUDDismissCompletion)completion{
    [self dismissWithDelay:0 completion:completion];
}

+ (void)dismissWithDelay:(NSTimeInterval)delay{
    [self dismissWithDelay:delay completion:nil];
}

+ (void)dismissWithDelay:(NSTimeInterval)delay completion:(DDProgressHUDDismissCompletion)completion{
    [[self sharedView] dismissWithDelay:delay completion:completion];
}

#pragma mark - Private Methods

+ (NSTimeInterval)displayDurationForString:(NSString*)string {
    CGFloat currentDuration = (float)string.length * 0.05;
    return MIN([self sharedView].maxDismissDuration, MAX([self sharedView].minDismissDuration, currentDuration));
}

+ (void)showImage:(UIImage *)image status:(NSString*)status{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimeInterval duration = [self displayDurationForString:status];
        [self sharedView].hudType = image ? DDProgressHUDTypeImage : DDProgressHUDTypeText;
        [[self sharedView] showImage:image status:status duration:duration];
    });
}

- (void)showHUDStatus:(NSString *)status{
    [self.fadeOutTimer invalidate];
    self.fadeOutTimer = nil;
    [self cancelImageView];
    [self updateViewHierarchy];
    switch (self.activityType) {
        case DDProgressHUDActivityTypeLineChange: {
            [self cancelActivityAnimation];
            if (!self.indicatorGradientCircleView) {
                self.indicatorGradientCircleView = [[DDActivityIndicatorGradientCircleView alloc] initWithFrame:CGRectMake(0, 0, self.activitySize, self.activitySize)];
                self.indicatorGradientCircleView.translatesAutoresizingMaskIntoConstraints = NO;
                [self.hudView addSubview:self.indicatorGradientCircleView];
                [self addLayoutConstraintsWithTopView:self.indicatorGradientCircleView descriptionKey:@"indicatorGradientCircleView" height:CGRectGetWidth(self.indicatorGradientCircleView.bounds)];
            }
            self.indicatorGradientCircleView.tintColor = self.activityColor;
            [self.indicatorGradientCircleView startAnimating];

            break;
        }
        case DDProgressHUDActivityTypeNineDots:
        case DDProgressHUDActivityTypeTriplePulse:
        case DDProgressHUDActivityTypeFiveDots:
        case DDProgressHUDActivityTypeRotatingSquares:
        case DDProgressHUDActivityTypeDoubleBounce:
        case DDProgressHUDActivityTypeTwoDots:
        case DDProgressHUDActivityTypeThreeDots:
        case DDProgressHUDActivityTypeBallPulse:
        case DDProgressHUDActivityTypeBallClipRotate:
        case DDProgressHUDActivityTypeBallClipRotatePulse:
        case DDProgressHUDActivityTypeBallClipRotateMultiple:
        case DDProgressHUDActivityTypeBallRotate:
        case DDProgressHUDActivityTypeBallZigZag:
        case DDProgressHUDActivityTypeBallZigZagDeflect:
        case DDProgressHUDActivityTypeBallTrianglePath:
        case DDProgressHUDActivityTypeBallScale:
        case DDProgressHUDActivityTypeLineScale:
        case DDProgressHUDActivityTypeLineScaleParty:
        case DDProgressHUDActivityTypeBallScaleMultiple:
        case DDProgressHUDActivityTypeBallPulseSync:
        case DDProgressHUDActivityTypeBallBeat:
        case DDProgressHUDActivityTypeLineScalePulseOut:
        case DDProgressHUDActivityTypeLineScalePulseOutRapid:
        case DDProgressHUDActivityTypeBallScaleRipple:
        case DDProgressHUDActivityTypeBallScaleRippleMultiple:
        case DDProgressHUDActivityTypeTriangleSkewSpin:
        case DDProgressHUDActivityTypeBallGridBeat:
        case DDProgressHUDActivityTypeBallGridPulse:
        case DDProgressHUDActivityTypeRotatingSanDDGlass:
        case DDProgressHUDActivityTypeRotatingTrigons:
        case DDProgressHUDActivityTypeTripleRings:
        case DDProgressHUDActivityTypeCookieTerminator:
        case DDProgressHUDActivityTypeBallSpinFadeLoader:
        case DDProgressHUDActivityTypeClock: {
            [self cancelCircleAniamtion];
            if (!self.activityIndicatorView) {
                self.activityIndicatorView = [[DDActivityIndicatorView alloc] initWithType:self.activityType - 1];
                self.activityIndicatorView.size = self.activitySize;
                self.activityIndicatorView.frame = CGRectMake(0, 0, self.activitySize, self.activitySize);
                self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
                [self.hudView addSubview:self.activityIndicatorView];
                [self addLayoutConstraintsWithTopView:self.activityIndicatorView descriptionKey:@"activityIndicatorView" height:CGRectGetWidth(self.activityIndicatorView.bounds)];
            }
            self.activityIndicatorView.type = self.activityType - 1;
            self.activityIndicatorView.tintColor = self.activityColor;
            [self.activityIndicatorView startAnimating];
            break;
        }
    }
    [self showWithStatus:status];
}

- (void)showImage:(UIImage *)image status:(NSString *)status duration:(NSTimeInterval)duration{
    [self.fadeOutTimer invalidate];
    self.fadeOutTimer = nil;
    [self cancelCircleAniamtion];
    [self cancelActivityAnimation];
    [self updateViewHierarchy];
    if (self.hudType == DDProgressHUDTypeImage) {
        if (!self.imageView) {
            self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, image.size.width, image.size.width)];
            self.imageView.backgroundColor = [UIColor clearColor];
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            self.imageView.translatesAutoresizingMaskIntoConstraints=NO;
            [self.hudView addSubview:self.imageView];
            [self addLayoutConstraintsWithTopView:self.imageView descriptionKey:@"imageView" height:CGRectGetWidth(self.imageView.bounds)];
        }
        self.imageView.tintColor = self.activityColor;
        self.imageView.image = image;
    } else {
        [self cancelImageView];
    }
    [self showWithStatus:status];
    [self dismissWithDelay:duration completion:nil];
}

#pragma mark - --------UI----------

- (void)updateViewHierarchy {
    if(!self.overlayView.superview) {
        UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (!keyWindow) {
            NSEnumerator *frontToBackWindows = [[UIApplication sharedApplication].windows reverseObjectEnumerator];
            for (UIWindow *window in frontToBackWindows) {
                BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
                BOOL windowIsVisible = !window.hidden && window.alpha > 0;
                BOOL windowLevelSupported = window.windowLevel == UIWindowLevelNormal;
                if(windowOnMainScreen && windowIsVisible && windowLevelSupported) {
                    keyWindow = window;
                    break;
                }
            }
        }
        [keyWindow addSubview:self.overlayView];
    } else {
        [self.overlayView.superview bringSubviewToFront:self.overlayView];
    }
    if(!self.superview){
        [self.overlayView addSubview:self];
    }
    if(!self.hudView.superview) {
        [self addSubview:self.hudView];
        [self addHudViewLayoutConstraints];
    }
}

- (void)showWithStatus:(NSString*)status {
    [self updateStatus:status];
    __weak DDProgressHUD *weakSelf = self;
    __block void (^animationsBlock)(void) = ^{
        __strong DDProgressHUD *strongSelf = weakSelf;
        if(strongSelf) {
            strongSelf.alpha = 1.0f;
            strongSelf.hudView.alpha = 1.0f;
        }
    };
    CGFloat duration = 0;
    if (self.alpha != 1.0 || self.hudView.alpha != 1.0) {
        self.alpha = 0.0f;
        self.hudView.alpha = 0.0f;
        duration = 0.25;
    }
    [UIView transitionWithView:self.hudView
                      duration:duration
                       options:UIViewAnimationOptionAllowUserInteraction |
     UIViewAnimationCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                    animations:^{
                        animationsBlock();
                    } completion:^(BOOL finished) {
                    }];
}

- (void)updateStatus:(NSString *)status{
    CGFloat estimateStatusLabelHeight = [self calculateStatusLabelSizeWithString:status isAttributedString:NO].height;
    self.isAttributedString = ABS(estimateStatusLabelHeight - self.statusLabel.font.lineHeight) >= 2.0;
    if (self.isAttributedString) {
        self.statusLabel.attributedText = [[NSAttributedString alloc] initWithString:status attributes:[self statusTextAttributes]];
    } else {
        self.statusLabel.text = status;
    }
    [self updateHUDFrame];
}

#pragma mark - Clear
- (void)cancelImageView{
    if (!self.imageView) {
        return;
    }
    [self.hudView removeConstraint:self.indefiniteCenterXConstraint];
    self.indefiniteCenterXConstraint = nil;
    
    [self.hudView removeConstraint:self.indefiniteTopConstraint];
    self.indefiniteTopConstraint = nil;
    
    [self.imageView removeConstraint:self.indefiniteWidthConstraint];
    self.indefiniteWidthConstraint = nil;
    
    [self.imageView removeConstraint:self.indefiniteHeightConstraint];
    self.indefiniteHeightConstraint = nil;
    
    [self.imageView removeFromSuperview];
    self.imageView = nil;
}

- (void)cancelCircleAniamtion{
    if (!self.indicatorGradientCircleView) {
        return;
    }
    [self.hudView removeConstraint:self.indefiniteCenterXConstraint];
    self.indefiniteCenterXConstraint = nil;
    
    [self.hudView removeConstraint:self.indefiniteTopConstraint];
    self.indefiniteTopConstraint = nil;
    
    [self.indicatorGradientCircleView removeConstraint:self.indefiniteWidthConstraint];
    self.indefiniteWidthConstraint = nil;
    
    [self.indicatorGradientCircleView removeConstraint:self.indefiniteHeightConstraint];
    self.indefiniteHeightConstraint = nil;
    
    [self.indicatorGradientCircleView stopAnimating];
    [self.indicatorGradientCircleView removeFromSuperview];
    self.indicatorGradientCircleView = nil;
}

- (void)cancelActivityAnimation{
    if (!self.activityIndicatorView) {
        return;
    }
    [self.hudView removeConstraint:self.indefiniteCenterXConstraint];
    self.indefiniteCenterXConstraint = nil;

    [self.hudView removeConstraint:self.indefiniteTopConstraint];
    self.indefiniteTopConstraint = nil;

    [self.activityIndicatorView removeConstraint:self.indefiniteWidthConstraint];
    self.indefiniteWidthConstraint = nil;
    
    [self.activityIndicatorView removeConstraint:self.indefiniteHeightConstraint];
    self.indefiniteHeightConstraint = nil;

    [self.activityIndicatorView stopAnimating];
    [self.activityIndicatorView removeFromSuperview];
    self.activityIndicatorView = nil;
}

- (void)clearAll{
    self.hudType = DDProgressHUDTypeInit;
    self.isAttributedString = NO;

    [self cancelImageView];
    [self cancelCircleAniamtion];
    [self cancelActivityAnimation];
    
    [self removeConstraint:self.hudCenterXConstraint];
    self.hudCenterXConstraint = nil;
    [self removeConstraint:self.hudCenterYConstraint];
    self.hudCenterYConstraint = nil;
    
    [self.hudView removeConstraint:self.hudViewWidthConstraint];
    self.hudViewWidthConstraint = nil;
    [self.hudView removeConstraint:self.hudViewHeightConstraint];
    self.hudViewHeightConstraint = nil;

    
    [self.hudView removeConstraint:self.statusLabelCenterXConstraint];
    self.statusLabelCenterXConstraint = nil;
    [self.hudView removeConstraint:self.statusLabelTopConstraint];
    self.statusLabelTopConstraint = nil;
    [self.statusLabel removeConstraint:self.statusLabelHeightConstraint];
    self.statusLabelHeightConstraint = nil;
    [self.statusLabel removeConstraint:self.statusLabelWidthConstraint];
    self.statusLabelWidthConstraint = nil;
    [self.statusLabel removeFromSuperview];
    self.statusLabel = nil;

    [self.hudView removeFromSuperview];
    self.hudView = nil;
    [self.overlayView removeFromSuperview];
    self.overlayView = nil;
    [self.fadeOutTimer invalidate];
    self.fadeOutTimer = nil;
    [self removeFromSuperview];
}

#pragma mark - ----------Frame

- (CGSize)calculateStatusLabelSizeWithString:(NSString *)string isAttributedString:(BOOL)isAttributedString{
    if (!string || [string length] == 0) {
        return CGSizeZero;
    }
    CGSize constraintSize = CGSizeMake(self.hudMaxWidth - 2*self.itemsHorizontalMargin, CGFLOAT_MAX);
    CGRect stringRect = [string boundingRectWithSize:constraintSize
                                             options:
                         NSStringDrawingUsesFontLeading|
                         NSStringDrawingTruncatesLastVisibleLine|
                         NSStringDrawingUsesLineFragmentOrigin
                                   attributes:isAttributedString ? [self statusTextAttributes] : nil
                                      context:NULL];
    return stringRect.size;
}

- (void)updateHUDFrame {
    CGSize statusLabelSize = [self calculateStatusLabelSizeWithString:self.statusLabel.text isAttributedString:self.isAttributedString];
    CGFloat verticalMarginSpace = self.itemsVerticalMargin;
    self.statusLabelTopConstraint.constant = verticalMarginSpace;
    if (self.hudType == DDProgressHUDTypeLoading ||
        self.hudType == DDProgressHUDTypeImage) {
        self.statusLabelTopConstraint.constant += self.indefiniteTopConstraint.constant + self.indefiniteHeightConstraint.constant;
    }
    self.statusLabelHeightConstraint.constant = ceil(statusLabelSize.height);
    self.statusLabelWidthConstraint.constant = MAX(self.hudMinWidth - 2*self.itemsHorizontalMargin, statusLabelSize.width);
    
    self.hudViewWidthConstraint.constant = self.statusLabelWidthConstraint.constant + 2*self.itemsHorizontalMargin;
    self.hudViewHeightConstraint.constant = self.statusLabelTopConstraint.constant + self.statusLabelHeightConstraint.constant + verticalMarginSpace;
}

#pragma mark - -----------TextAttribute
- (NSDictionary *)statusTextAttributes{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = self.labelLineSpacing;
    paragraphStyle.maximumLineHeight = self.labelFont.lineHeight;
    paragraphStyle.minimumLineHeight = self.labelFont.lineHeight;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:self.statusLabel.font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    return attributes;
}

#pragma mark - dismiss

- (void)dismissWithDelay:(NSTimeInterval)delay completion:(DDProgressHUDDismissCompletion)completion {
    self.completionBlock = completion;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.fadeOutTimer) {
            [self.fadeOutTimer invalidate];
            self.fadeOutTimer = nil;
        }
        self.fadeOutTimer = [NSTimer timerWithTimeInterval:delay target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:self.fadeOutTimer forMode:NSRunLoopCommonModes];
    });
}

- (void)dismiss{
    __weak DDProgressHUD *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(),^{
        __strong DDProgressHUD *strongSelf = weakSelf;
        if (strongSelf) {
            __block void (^animationsBlock)(void) = ^{
                strongSelf.alpha = 0.0f;
                strongSelf.hudView.alpha = 0.0f;
            };
            __block void (^completionBlock)(void) = ^{
                if(strongSelf.alpha == 0.0f && strongSelf.hudView.alpha == 0.0f){
                    [strongSelf clearAll];
                    if (strongSelf.completionBlock) {
                        strongSelf.completionBlock();
                        strongSelf.completionBlock = nil;
                    }
                }
            };
            [UIView transitionWithView:strongSelf.hudView
                              duration:0.25
                               options:UIViewAnimationOptionAllowUserInteraction |
             UIViewAnimationCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                            animations:^{
                                animationsBlock();
                            } completion:^(BOOL finished) {
                                if (finished) {
                                    completionBlock();
                                }
                            }];
        } else if (strongSelf.completionBlock){
            strongSelf.completionBlock();
            strongSelf.completionBlock = nil;
        }
        
    });
}

#pragma mark - NSLayoutConstraint
- (void)addHudViewLayoutConstraints{
    NSDictionary* views = @{@"hudView":self.hudView};

    self.hudViewWidthConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:@"H:[hudView(100)]" options:0 metrics:nil views:views] firstObject];
    [self.hudView addConstraint:self.hudViewWidthConstraint];
    
    self.hudViewHeightConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:@"V:[hudView(100)]" options:0 metrics:nil views:views] firstObject];
    [self.hudView addConstraint:self.hudViewHeightConstraint];
    
    self.hudCenterYConstraint = [NSLayoutConstraint constraintWithItem:self.hudView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self addConstraint:self.hudCenterYConstraint];
    NSLayoutConstraint *hudCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.hudView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self addConstraint:hudCenterXConstraint];
    self.hudCenterXConstraint = hudCenterXConstraint;
}

- (void)addLayoutConstraintsWithTopView:(id)view descriptionKey:(NSString *)descriptionKey height:(CGFloat)height{
    NSDictionary* views = @{descriptionKey:view};
    NSLayoutConstraint *indefiniteViewTopConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.hudView attribute:NSLayoutAttributeTop multiplier:1 constant:self.itemsVerticalMargin];
    [self.hudView addConstraint:indefiniteViewTopConstraint];
    self.indefiniteTopConstraint = indefiniteViewTopConstraint;
    
    NSLayoutConstraint *indefiniteViewCenterXConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.hudView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self.hudView addConstraint:indefiniteViewCenterXConstraint];
    self.indefiniteCenterXConstraint = indefiniteViewCenterXConstraint;
    
    NSString *widthVisualFormat = [NSString stringWithFormat:@"H:[%@(%f)]",descriptionKey,height];
    NSLayoutConstraint *indefiniteViewWidthConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:widthVisualFormat options:0 metrics:nil views:views] firstObject];
    [view addConstraint:indefiniteViewWidthConstraint];
    self.indefiniteWidthConstraint = indefiniteViewWidthConstraint;
    
    NSString *heightVisualFormat = [NSString stringWithFormat:@"V:[%@(%f)]",descriptionKey,height];
    NSLayoutConstraint *indefiniteViewHeightConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:heightVisualFormat options:0 metrics:nil views:views] firstObject];
    [view addConstraint:indefiniteViewHeightConstraint];
    self.indefiniteHeightConstraint = indefiniteViewHeightConstraint;
}

- (void)addStatusLabelLayoutConstraints{
    NSDictionary* views = @{@"statusLabel":self.statusLabel};
    self.statusLabelTopConstraint = [NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.hudView attribute:NSLayoutAttributeTop multiplier:1 constant:self.itemsVerticalMargin];
    [self.hudView addConstraint:self.statusLabelTopConstraint];
    
    self.statusLabelCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.hudView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self.hudView addConstraint:self.statusLabelCenterXConstraint];
    
    self.statusLabelWidthConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:@"H:[statusLabel(100)]" options:0 metrics:nil views:views] firstObject];
    [self.hudView addConstraint:self.statusLabelWidthConstraint];
    
    self.statusLabelHeightConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:@"V:[statusLabel(14)]" options:0 metrics:nil views:views] firstObject];
    [self.statusLabel addConstraint:self.statusLabelHeightConstraint];
}

#pragma mark - Getter And Setter
- (void)setActivityType:(DDProgressHUDActivityType)activityType{
    if (_activityType != activityType) {
        self.lastActivityType = _activityType;
        _activityType = activityType;
    }
}

- (UIView*)overlayView {
    if(!_overlayView) {
        _overlayView = [[UIView alloc] initWithFrame:self.bounds];
        _overlayView.userInteractionEnabled = NO;
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayView.userInteractionEnabled = NO;
    }
    if (self.maskStyle == DDProgressHUDMaskStyleCustom){
        _overlayView.backgroundColor = self.maskColor;
        _overlayView.userInteractionEnabled = YES;
    } else {
        _overlayView.backgroundColor = [UIColor clearColor];
        _overlayView.userInteractionEnabled = NO;
    }
    return _overlayView;
}

- (UIView *)hudView{
    if (!_hudView) {
        _hudView = [[UIView alloc] initWithFrame:CGRectZero];
        _hudView.translatesAutoresizingMaskIntoConstraints=NO;
        _hudView.layer.shadowOpacity = 1.0;
    }
    _hudView.backgroundColor = self.hudBackgroundColor;
    _hudView.layer.shadowOffset = self.hudShadowOffset;
    _hudView.layer.shadowRadius = self.hudShadowRadius;
    _hudView.layer.cornerRadius = self.hudCornerRadius;
    _hudView.layer.shadowColor = self.hudShadowColor.CGColor;
    return _hudView;
}

- (UILabel*)statusLabel {
    if(!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.adjustsFontSizeToFitWidth = YES;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _statusLabel.numberOfLines = 0;
        _statusLabel.translatesAutoresizingMaskIntoConstraints=NO;
    }
    if(!_statusLabel.superview) {
        [self.hudView addSubview:_statusLabel];
        [self addStatusLabelLayoutConstraints];
    }
    _statusLabel.textColor = self.tintColor;
    _statusLabel.font = self.labelFont;
    return _statusLabel;
}

@end
