//
//  DDProgressHUD.m
//  DDProgressHUD
//
//  Created by lilingang on 8/17/16.
//  Copyright © 2016 LiLingang. All rights reserved.
//

#import "DDProgressHUD.h"
#import "DDIndefiniteCycleAnimatedView.h"
#import "DDIndefiniteClockAnimatedView.h"

/**@brief 各个元素之间的纵向间距*/
CGFloat DDItemsVerticalSpace = 12.0f;
/**@brief 文本框横向边距*/
CGFloat DDStatusLabelHorizontaMargin = 12.0f;

/**@brief 定义了HUD显示的风格*/
typedef NS_ENUM(NSUInteger, DDProgressHUDType) {
    DDProgressHUDTypeInit,         /**初始值*/
    DDProgressHUDTypeCycle,        /**弧形*/
    DDProgressHUDTypeClock,        /**表盘*/
    DDProgressHUDTypeAlter,        /**纯文字*/
    DDProgressHUDTypeImage,        /**图片*/
};

@interface DDProgressHUD ()

/**@brief DDProgressHUDType*/
@property (nonatomic, assign) DDProgressHUDType hudType;

/**@brief Window上的蒙层*/
@property (nonatomic, strong) UIView *overlayView;
/**@brief 提示框容器*/
@property (nonatomic, strong) UIView *hudView;
/**@brief 无限CycleView*/
@property (nonatomic, strong) DDIndefiniteCycleAnimatedView *indefiniteCycleView;
/**@brief 无限ClockView*/
@property (nonatomic, strong) DDIndefiniteClockAnimatedView *indefiniteClockView;
/**@brief 图片View*/
@property (nonatomic, strong) UIImageView *imageView;
/**@brief 提示文案*/
@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) UIImage *successImage;
@property (nonatomic, strong) UIImage *errorImage;

/**@brief showInfo 和 showImage 消失定时器*/
@property (nonatomic, strong) NSTimer *fadeOutTimer;

@property (assign, nonatomic) NSTimeInterval fadeInAnimationDuration;  // default is 0.15
@property (assign, nonatomic) NSTimeInterval fadeOutAnimationDuration; // default is 0.15

/**@brief statusLabel显示的是否是富文本，默认NO*/
@property (nonatomic, assign) BOOL isAttributedString;
@property (nonatomic, assign) CGFloat statusLabelMaxWidth;

//------------------UI Config
@property (nonatomic, strong) UIFont *labelFont;
@property (nonatomic, assign) CGFloat labelLineSpacing;
@property (nonatomic, strong) UIColor *textColor;

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
@property (nonatomic, strong) NSLayoutConstraint *statusLabelHeightConstraint;
@property (nonatomic, copy) NSArray *statusLabelConstraints;

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
        [self resetToDefult];
        NSBundle *bundle = [NSBundle bundleForClass:[DDProgressHUD class]];
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"DDProgressHUD" withExtension:@"bundle"];
        NSBundle *imageBundle = [NSBundle bundleWithURL:url];
        UIImage* successImage = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"success" ofType:@"tiff"]];
        UIImage* errorImage = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"error" ofType:@"tiff"]];
        if ([[UIImage class] instancesRespondToSelector:@selector(imageWithRenderingMode:)]) {
            _successImage = [successImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            _errorImage = [errorImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        } else {
            _successImage = successImage;
            _errorImage = errorImage;
        }
    }
    return self;
}

#pragma mark - Public Methods

+ (void)showHUDWithStatus:(NSString*)status{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self sharedView].hudType == DDProgressHUDTypeCycle) {
            [[self sharedView] updateStatus:status];
        } else {
            [self sharedView].hudType = DDProgressHUDTypeCycle;
            [[self sharedView] showHUDStatus:status];
        }
    });
}

+ (void)showClockWithStatus:(NSString*)status{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self sharedView].hudType == DDProgressHUDTypeClock) {
            [[self sharedView] updateStatus:status];
        } else {
            [self sharedView].hudType = DDProgressHUDTypeClock;
            [[self sharedView] showHUDStatus:status];
        }
    });
}

+ (void)showWithStatus:(NSString*)status{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimeInterval duration = [self displayDurationForString:status];
        [self sharedView].hudType = DDProgressHUDTypeAlter;
        [[self sharedView] showImage:nil status:status duration:duration];
    });
}

+ (void)showSucessWithStatus:(NSString*)status{
    [self showImage:[self sharedView].successImage status:status];
}

+ (void)showErrorWithStatus:(NSString*)status{
    [self showImage:[self sharedView].errorImage status:status];
}

+ (void)showImage:(UIImage *)image status:(NSString*)status{
    if (!image) {
        [self showWithStatus:status];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSTimeInterval duration = [self displayDurationForString:status];
            [self sharedView].hudType = DDProgressHUDTypeImage;
            [[self sharedView] showImage:image status:status duration:duration];
        });
    }
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
    return MAX((float)string.length * 0.06 + 0.5, 2.0);
}

- (void)showHUDStatus:(NSString *)status{
    [self.fadeOutTimer invalidate];
    self.fadeOutTimer = nil;
    [self cancelIndefiniteAnimation];
    [self showWithStatus:status];
}

- (void)showImage:(UIImage *)image status:(NSString *)status duration:(NSTimeInterval)duration{
    [self.fadeOutTimer invalidate];
    self.fadeOutTimer = nil;
    [self cancelIndefiniteAnimation];
    self.overlayView.userInteractionEnabled = NO;
    if (self.hudType == DDProgressHUDTypeImage) {
        self.imageView.image = image;
        CGFloat imageWidth = image.size.width/image.scale;
        [self addLayoutConstraintsWithTopView:self.imageView descriptionKey:@"imageView" height:MIN(imageWidth, 18.0f)];
    }
    [self showWithStatus:status];
    self.fadeOutTimer = [NSTimer timerWithTimeInterval:duration target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.fadeOutTimer forMode:NSRunLoopCommonModes];
}


- (void)resetToDefult{
    self.hudType = DDProgressHUDTypeInit;
    self.fadeInAnimationDuration = 0.15;
    self.fadeOutAnimationDuration = 0.15;
    self.isAttributedString = NO;
    self.statusLabelMaxWidth = ceil(CGRectGetWidth(self.bounds)*0.6 - 2*DDStatusLabelHorizontaMargin);
    
    self.labelFont = [UIFont systemFontOfSize:12.0f];
    self.labelLineSpacing = 8.0f;
    self.textColor = [UIColor whiteColor];
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

- (void)showWithStatus:(NSString*)status {
    [self updateViewHierarchy];
    switch (self.hudType) {
        case DDProgressHUDTypeCycle: {
            self.overlayView.userInteractionEnabled = YES;
            [self addLayoutConstraintsWithTopView:self.indefiniteCycleView descriptionKey:@"indefiniteCycleView" height:18.0f];
            [self.indefiniteCycleView startAnimation];
            break;
        }
        case DDProgressHUDTypeClock: {
            self.overlayView.userInteractionEnabled = YES;
            [self addLayoutConstraintsWithTopView:self.indefiniteClockView descriptionKey:@"indefiniteClockView" height:32.0f];
            [self.indefiniteClockView startAnimation];
            break;
        }
        default:{
            self.overlayView.userInteractionEnabled = NO;
            break;
        }
    }
    [self updateStatus:status];
    
    if (self.alpha != 1.0 || self.hudView.alpha != 1.0) {
        self.alpha = 0.0f;
        self.hudView.alpha = 0.0f;
        
        __weak DDProgressHUD *weakSelf = self;
        __block void (^animationsBlock)(void) = ^{
            __strong DDProgressHUD *strongSelf = weakSelf;
            if(strongSelf) {
                strongSelf.alpha = 1.0f;
                strongSelf.hudView.alpha = 1.0f;
            }
        };
        [UIView transitionWithView:self.hudView
                          duration:self.fadeInAnimationDuration
                           options:UIViewAnimationOptionAllowUserInteraction |
         UIViewAnimationCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                        animations:^{
                            animationsBlock();
                        } completion:^(BOOL finished) {
                        }];
    }
}

- (void)cancelIndefiniteAnimation{
    [self.hudView removeConstraint:self.indefiniteCenterXConstraint];
    self.indefiniteCenterXConstraint = nil;

    [self.hudView removeConstraint:self.indefiniteTopConstraint];
    self.indefiniteTopConstraint = nil;

    [self.indefiniteClockView removeConstraint:self.indefiniteWidthConstraint];
    [self.indefiniteCycleView removeConstraint:self.indefiniteWidthConstraint];
    [self.imageView removeConstraint:self.indefiniteWidthConstraint];
    self.indefiniteWidthConstraint = nil;
    
    [self.indefiniteClockView removeConstraint:self.indefiniteHeightConstraint];
    [self.indefiniteCycleView removeConstraint:self.indefiniteHeightConstraint];
    [self.imageView removeConstraint:self.indefiniteHeightConstraint];
    self.indefiniteHeightConstraint = nil;
    
    if (self.hudType != DDProgressHUDTypeCycle) {
        [self.indefiniteCycleView stopAnimation];
        [self.indefiniteCycleView removeFromSuperview];
    }

    if (self.hudType != DDProgressHUDTypeClock) {
        [self.indefiniteClockView stopAnimation];
        [self.indefiniteClockView removeFromSuperview];
    }
    
    if (self.hudType != DDProgressHUDTypeImage) {
        [self.imageView removeFromSuperview];
    }
}
#pragma mark - ----------Frame

- (CGSize)calculateStatusLabelSizeWithString:(NSString *)string isAttributedString:(BOOL)isAttributedString{
    if (!string || [string length] == 0) {
        return CGSizeZero;
    }
    CGSize constraintSize = CGSizeMake(self.statusLabelMaxWidth, CGFLOAT_MAX);
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
    self.statusLabelTopConstraint.constant = DDItemsVerticalSpace;
    if (self.hudType == DDProgressHUDTypeCycle ||
        self.hudType == DDProgressHUDTypeClock ||
        self.hudType == DDProgressHUDTypeImage) {
        self.statusLabelTopConstraint.constant += self.indefiniteTopConstraint.constant + self.indefiniteHeightConstraint.constant;
    }
    self.statusLabelHeightConstraint.constant = ceil(statusLabelSize.height);
    
    self.hudViewWidthConstraint.constant = MAX(100, statusLabelSize.width + 2*DDStatusLabelHorizontaMargin);
    self.hudViewHeightConstraint.constant = self.statusLabelTopConstraint.constant + self.statusLabelHeightConstraint.constant + DDItemsVerticalSpace;
    [self layoutIfNeeded];
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

- (void)dismiss{
    [self dismissWithDelay:0 completion:nil];
}

- (void)dismissWithDelay:(NSTimeInterval)delay completion:(DDProgressHUDDismissCompletion)completion {
    __weak DDProgressHUD *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong DDProgressHUD *strongSelf = weakSelf;
        if (strongSelf) {
            __block void (^animationsBlock)(void) = ^{
                strongSelf.alpha = 0.0f;
                strongSelf.hudView.alpha = 0.0f;
            };
            __block void (^completionBlock)(void) = ^{
                if(strongSelf.alpha == 0.0f && strongSelf.hudView.alpha == 0.0f){
                    [strongSelf resetToDefult];
                    [strongSelf cancelIndefiniteAnimation];
                    [strongSelf clearAllLayoutConstraints];
                    [strongSelf.fadeOutTimer invalidate];
                    strongSelf.fadeOutTimer = nil;
                    [strongSelf.overlayView removeFromSuperview];
                    strongSelf.overlayView = nil;
                    [strongSelf.hudView removeFromSuperview];
                    strongSelf.hudView = nil;
                    [strongSelf removeFromSuperview];
                    if (completion) {
                        completion();
                    }
                }
            };
            if (strongSelf.fadeOutAnimationDuration) {
                [UIView transitionWithView:strongSelf.hudView
                                  duration:strongSelf.fadeOutAnimationDuration
                                   options:UIViewAnimationOptionAllowUserInteraction |
                 UIViewAnimationCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                                animations:^{
                                    animationsBlock();
                                } completion:^(BOOL finished) {
                                    if (finished) {
                                        completionBlock();
                                    }
                                }];
            } else {
                animationsBlock();
                completionBlock();
            }
        } else if (completion){
            completion();
        }

    });
}

#pragma mark - NSLayoutConstraint

- (void)clearAllLayoutConstraints{
    [self removeConstraint:self.hudCenterXConstraint];
    self.hudCenterXConstraint = nil;
    [self removeConstraint:self.hudCenterYConstraint];
    self.hudCenterYConstraint = nil;
    
    [self.hudView removeConstraint:self.hudViewWidthConstraint];
    self.hudViewWidthConstraint = nil;
    [self.hudView removeConstraint:self.hudViewHeightConstraint];
    self.hudViewHeightConstraint = nil;
    [self.hudView removeConstraint:self.indefiniteCenterXConstraint];
    self.indefiniteCenterXConstraint = nil;
    [self.hudView removeConstraint:self.indefiniteTopConstraint];
    self.indefiniteTopConstraint = nil;

    
    [self.hudView removeConstraints:self.statusLabelConstraints];
    self.statusLabelConstraints = nil;
    [self.hudView removeConstraint:self.statusLabelTopConstraint];
    self.statusLabelTopConstraint = nil;
    [self.hudView removeConstraint:self.statusLabelHeightConstraint];
    self.statusLabelHeightConstraint = nil;
    
    [self.indefiniteClockView removeConstraint:self.indefiniteWidthConstraint];
    [self.indefiniteCycleView removeConstraint:self.indefiniteWidthConstraint];
    [self.imageView removeConstraint:self.indefiniteWidthConstraint];
    self.indefiniteWidthConstraint = nil;
    
    [self.indefiniteClockView removeConstraint:self.indefiniteHeightConstraint];
    [self.indefiniteCycleView removeConstraint:self.indefiniteHeightConstraint];
    [self.imageView removeConstraint:self.indefiniteHeightConstraint];
    self.indefiniteHeightConstraint = nil;
}

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
    NSLayoutConstraint *indefiniteViewTopConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.hudView attribute:NSLayoutAttributeTop multiplier:1 constant:DDItemsVerticalSpace];
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
    self.statusLabelTopConstraint = [NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.hudView attribute:NSLayoutAttributeTop multiplier:1 constant:DDItemsVerticalSpace];
    [self.hudView addConstraint:self.statusLabelTopConstraint];
    
    self.statusLabelHeightConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:@"V:[statusLabel(14)]" options:0 metrics:nil views:views] firstObject];
    [self.statusLabel addConstraint:self.statusLabelHeightConstraint];

    NSArray *constraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[statusLabel]-12-|"
                                                                  options:NSLayoutAttributeLeft|NSLayoutAttributeRight
                                                                  metrics:nil
                                                                    views:views];
    [self.hudView addConstraints:constraints];
    self.statusLabelConstraints = constraints;
}

#pragma mark - Getter And Setter

- (UIView*)overlayView {
    if(!_overlayView) {
        _overlayView = [[UIView alloc] initWithFrame:self.bounds];
        _overlayView.userInteractionEnabled = NO;
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayView.backgroundColor = [UIColor clearColor];
    }
    return _overlayView;
}

- (UIView *)hudView{
    if (!_hudView) {
        _hudView = [[UIView alloc] initWithFrame:CGRectZero];
        _hudView.translatesAutoresizingMaskIntoConstraints=NO;
        _hudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.82];
        _hudView.layer.shadowColor = _hudView.backgroundColor.CGColor;
        _hudView.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
        _hudView.layer.shadowOpacity = 1.0;
        _hudView.layer.shadowRadius = 8.0f;
        _hudView.layer.cornerRadius = 4.0f;
    }
    return _hudView;
}

- (DDIndefiniteCycleAnimatedView *)indefiniteCycleView{
    if (!_indefiniteCycleView) {
        _indefiniteCycleView = [[DDIndefiniteCycleAnimatedView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 18.0f, 18.0f)];
        _indefiniteCycleView.translatesAutoresizingMaskIntoConstraints=NO;
    }
    if(!_indefiniteCycleView.superview) {
        [self.hudView addSubview:_indefiniteCycleView];
    }
    return _indefiniteCycleView;
}

- (DDIndefiniteClockAnimatedView *)indefiniteClockView{
    if (!_indefiniteClockView) {
        _indefiniteClockView = [[DDIndefiniteClockAnimatedView alloc] initWithFrame:CGRectMake(0, 0, 32.0, 32.0)];
        _indefiniteClockView.translatesAutoresizingMaskIntoConstraints=NO;
    }
    if (!_indefiniteClockView.superview) {
        [self.hudView addSubview:_indefiniteClockView];
    }
    return _indefiniteClockView;
}

- (UIImageView*)imageView {
    if(!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 28.0f, 28.0f)];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.translatesAutoresizingMaskIntoConstraints=NO;
    }
    if(!_imageView.superview) {
        [self.hudView addSubview:_imageView];
    }
    return _imageView;
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
    _statusLabel.textColor = self.textColor;
    _statusLabel.font = self.labelFont;
    return _statusLabel;
}

@end
