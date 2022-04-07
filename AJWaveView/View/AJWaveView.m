//
//  AJWaveView.m
//  AJWaveView
//
//  Created by ChuanJie Jhuang on 2020/5/21.
//  Copyright © 2020 ChuanJie Jhuang. All rights reserved.
//

#import "AJWaveView.h"

#define FirstAndSecondWaveAmplitude 60
#define ThirdWaveAmplitude 80
#define FirstAndSecondWaveIntervalPortion 1.3
#define ThirdWaveIntervalPortion 2.5

static NSString *moveWaveAnimationKeyName = @"moveWavePosition";
static NSString *shiftColorsAnimationKeyName = @"shiftColorsGradient";


@interface AJWaveView()<CAAnimationDelegate> {
    NSArray *_lastEndAnimationColors;
    CFTimeInterval _waveMovingBaseDuration;
    void (^_gradientShiftingColorsCompletion)(void);
    BOOL _isStartingWaveAnimation;
}

@property (nonatomic, strong) CAGradientLayer *firstWaveGradientLayer;
@property (nonatomic, strong) CAGradientLayer *secondWaveGradientLayer;
@property (nonatomic, strong) CAGradientLayer *thirdWaveGradientLayer;

@end

@implementation AJWaveView

#pragma mark - Initialize

- (instancetype)init {
    self = [super init];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

#pragma mark - Life Cycle

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutIfNeeded];
    
    if (self.firstWaveGradientLayer && self.secondWaveGradientLayer && self.thirdWaveGradientLayer) {
        
        [self updateGradientLayer:self.firstWaveGradientLayer withColors:[self getGradientColorsByWaveColor:self.color] interval:self.bounds.size.width * FirstAndSecondWaveIntervalPortion amplitude:FirstAndSecondWaveAmplitude baseline:self.bounds.size.height - FirstAndSecondWaveAmplitude / 3 andIsUpToDown:YES];
        
        [self updateGradientLayer:self.secondWaveGradientLayer withColors:[self getGradientColorsByWaveColor:self.color] interval:self.bounds.size.width * FirstAndSecondWaveIntervalPortion amplitude:FirstAndSecondWaveAmplitude baseline:self.bounds.size.height - FirstAndSecondWaveAmplitude / 3 andIsUpToDown:NO];
        
        [self updateGradientLayer:self.thirdWaveGradientLayer withColors:[self getGradientColorsByWaveColor:self.color] interval:self.bounds.size.width * ThirdWaveIntervalPortion amplitude:ThirdWaveAmplitude baseline:self.bounds.size.height - ThirdWaveAmplitude / 3 andIsUpToDown:YES];
        
        [self animateMovingWaveWithBaseDuration:_waveMovingBaseDuration];
    }
}

- (void)didMoveToWindow {
    if (self.window) {
        // Added to a window, similar to -viewDidLoad.
        // Subscribe to notifications here.
        [self addNotificationObserver];
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow == nil) {
        // Will be removed from window, similar to -viewDidUnload.
        // Unsubscribe from any notifications here.
        [self removeNotificationObserver];
    }
}

#pragma mark - Override

- (void)setColor:(AJWaveColorType)color {
    _color = color;
    _lastEndAnimationColors = [self getGradientColorsByWaveColor:color];
    if (self.firstWaveGradientLayer && self.secondWaveGradientLayer && self.thirdWaveGradientLayer) {
        self.firstWaveGradientLayer.colors = [self getGradientColorsByWaveColor:color];
        self.secondWaveGradientLayer.colors = [self getGradientColorsByWaveColor:color];
        self.thirdWaveGradientLayer.colors = [self getGradientColorsByWaveColor:color];
    }
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CABasicAnimation *shiftingColorsAnimation = (CABasicAnimation *)anim;
    if (shiftingColorsAnimation != nil && [shiftingColorsAnimation.keyPath isEqualToString:@"colors"] && self.color != [self getAJWaveColorTypeFromGradientColors:_lastEndAnimationColors]) {
        self.color = [self getAJWaveColorTypeFromGradientColors:_lastEndAnimationColors];
        if (_gradientShiftingColorsCompletion) {
            _gradientShiftingColorsCompletion();
            _gradientShiftingColorsCompletion = nil;
        }
    }
}

#pragma mark - Public Method

- (void)animateMovingWaveWithBaseDuration:(CFTimeInterval)duration {
    _waveMovingBaseDuration = duration;
    [self removeAllAnimations];
    [self addAllAnimations];
    _isStartingWaveAnimation = YES;
}

- (void)animateShfitingColorsToAJWaveColorType:(AJWaveColorType)toColorType andDuration:(CFTimeInterval)duration withCompletion:(void(^)(void))completion {
    [self animateShfitingColorsToAJWaveColorType:toColorType withDuration:duration];
    if (completion) {
        _gradientShiftingColorsCompletion = completion;
    }
}

#pragma mark - Private Method

- (void)baseInit {
    self.firstWaveGradientLayer = [CAGradientLayer layer];
    [self.layer addSublayer:self.firstWaveGradientLayer];
    
    self.secondWaveGradientLayer = [CAGradientLayer layer];
    [self.layer addSublayer:self.secondWaveGradientLayer];
    
    self.thirdWaveGradientLayer = [CAGradientLayer layer];
    [self.layer addSublayer:self.thirdWaveGradientLayer];
    
    _lastEndAnimationColors = [self getGradientColorsByWaveColor:AJWaveColorTypeBlue];
    _isStartingWaveAnimation = NO;
    _waveMovingBaseDuration = 3;
    self.color = AJWaveColorTypeBlue;
}

- (NSArray *)getGradientColorsByWaveColor:(AJWaveColorType)color {
    switch (color) {
        case AJWaveColorTypeDeepRed: {
            return @[(id)[UIColor colorWithRed:213 / 255.0 green:0 blue:0 alpha:1.0].CGColor,
                     (id)[UIColor colorWithRed:229 / 255.0 green:57 / 255.0 blue:53 / 255.0 alpha:0.5].CGColor,
                     (id)[UIColor colorWithRed:255 / 255.0 green:188 / 255.0 blue:188 / 255.0 alpha:0.16].CGColor];
        }
        case AJWaveColorTypeRed: {
            return @[(id)[UIColor colorWithRed:208 / 255.0 green:0 blue:0 alpha:1.0].CGColor,
                     (id)[UIColor colorWithRed:255 / 255.0 green:135 / 255.0 blue:82 / 255.0 alpha:0.47].CGColor,
                     (id)[UIColor colorWithRed:255 / 255.0 green:188 / 255.0 blue:188 / 255.0 alpha:0.16].CGColor];
        }
        case AJWaveColorTypeOrange: {
            return @[(id)[UIColor colorWithRed:237 / 255.0 green:101 / 255.0 blue:0 alpha:1.0].CGColor,
                     (id)[UIColor colorWithRed:255 / 255.0 green:143 / 255.0 blue:0 / 255.0 alpha:0.27].CGColor,
                     (id)[UIColor colorWithRed:255 / 255.0 green:198 / 255.0 blue:126 / 255.0 alpha:0.15].CGColor];
        }
        case AJWaveColorTypeBlue: {
            return @[(id)[UIColor colorWithRed:100 / 255.0 green:181 / 255.0 blue:246 / 255.0 alpha:0.5].CGColor,
                     (id)[UIColor colorWithRed:144 / 255.0 green:202 / 255.0 blue:249 / 255.0 alpha:0.26].CGColor,
                     (id)[UIColor colorWithRed:187 / 255.0 green:222 / 255.0 blue:251 / 255.0 alpha:0.36].CGColor];
        }
        default:
            return @[];
    }
}

- (AJWaveColorType)getAJWaveColorTypeFromGradientColors:(NSArray *)gradientColors {
    if ([gradientColors isEqualToArray:[self getGradientColorsByWaveColor:AJWaveColorTypeDeepRed]]) {
        return AJWaveColorTypeDeepRed;
    }
    if ([gradientColors isEqualToArray:[self getGradientColorsByWaveColor:AJWaveColorTypeRed]]) {
        return AJWaveColorTypeRed;
    }
    if ([gradientColors isEqualToArray:[self getGradientColorsByWaveColor:AJWaveColorTypeOrange]]) {
        return AJWaveColorTypeOrange;
    }
    if ([gradientColors isEqualToArray:[self getGradientColorsByWaveColor:AJWaveColorTypeBlue]]) {
        return AJWaveColorTypeBlue;
    }
    return AJWaveColorTypeUnknown;
}

- (UIBezierPath *)createWavePathWithInterval:(CGFloat)interval amplitude:(CGFloat)amplitude baseline:(CGFloat)baseline andIsUpToDown:(BOOL)isUpToDown {
    CGFloat ampMultiplier = isUpToDown ? 1 : -1;
    UIBezierPath *wavePath = [UIBezierPath bezierPath];
    [wavePath moveToPoint:CGPointMake(0, 0)];
    [wavePath addLineToPoint:CGPointMake(0, baseline)];
    [wavePath addCurveToPoint:CGPointMake(interval, baseline)
                controlPoint1:CGPointMake(interval * 0.35, baseline + amplitude * ampMultiplier)
                controlPoint2:CGPointMake(interval * 0.65, baseline - amplitude * ampMultiplier)];
    [wavePath addCurveToPoint:CGPointMake(2 * interval, baseline)
                controlPoint1:CGPointMake(interval * 1.35, baseline + amplitude * ampMultiplier)
                controlPoint2:CGPointMake(interval * 1.65, baseline - amplitude * ampMultiplier)];
    [wavePath addLineToPoint:CGPointMake(interval * 2, 0)];
    [wavePath addLineToPoint:CGPointMake(0, 0)];
    return wavePath;
}

- (void)updateGradientLayer:(CAGradientLayer *)gradientLayer withColors:(NSArray *)colors interval:(CGFloat)interval amplitude:(CGFloat)amplitude baseline:(CGFloat)baseline andIsUpToDown:(BOOL)isUpToDown {
    UIBezierPath *wavePath = [self createWavePathWithInterval:interval amplitude:amplitude baseline:baseline andIsUpToDown:isUpToDown];

    CAShapeLayer *waveShapeLayer = [CAShapeLayer layer];
    waveShapeLayer.path = wavePath.CGPath;
    waveShapeLayer.strokeColor = nil;
    waveShapeLayer.fillColor = [[UIColor whiteColor] CGColor];
    waveShapeLayer.frame = CGRectMake(0, 0, interval * 2, self.bounds.size.height);
    
    gradientLayer.frame = CGRectMake(0, 0, interval * 2, self.bounds.size.height);
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.colors = colors;
    gradientLayer.locations = @[@0, @0.8, @1];
    gradientLayer.mask = waveShapeLayer;
}

- (void)animateMovingWaveGradientLayer:(CAGradientLayer *)waveGradientLayer withInterval:(CGFloat)interval andDuration:(CFTimeInterval)duration {
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.duration = duration;
    moveAnimation.repeatCount = INFINITY;
    moveAnimation.autoreverses = NO;
    moveAnimation.fromValue = [NSValue valueWithCGPoint: CGPointMake(waveGradientLayer.position.x, waveGradientLayer.position.y)];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(waveGradientLayer.position.x - interval, waveGradientLayer.position.y)];
    [waveGradientLayer addAnimation:moveAnimation forKey:moveWaveAnimationKeyName];
}

- (void)animateShfitingColorsToAJWaveColorType:(AJWaveColorType)toColorType withDuration:(CFTimeInterval)duration {
    [self animateShfitingColorsOfWaveGradientLayer:self.firstWaveGradientLayer toAJWaveColorType:toColorType withDuration:duration];
    [self animateShfitingColorsOfWaveGradientLayer:self.secondWaveGradientLayer toAJWaveColorType:toColorType withDuration:duration];
    [self animateShfitingColorsOfWaveGradientLayer:self.thirdWaveGradientLayer toAJWaveColorType:toColorType withDuration:duration];
}

- (void)animateShfitingColorsOfWaveGradientLayer:(CAGradientLayer *)waveGradientLayer toAJWaveColorType:(AJWaveColorType)toColorType withDuration:(CFTimeInterval)duration {
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"colors"];
    colorAnimation.duration = duration;
    colorAnimation.repeatCount = 1;
    colorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    colorAnimation.toValue = [self getGradientColorsByWaveColor:toColorType];
    colorAnimation.removedOnCompletion = NO;
    colorAnimation.fillMode = kCAFillModeForwards;
    
    colorAnimation.delegate = self;
    
    _lastEndAnimationColors = [self getGradientColorsByWaveColor:toColorType];
    
    [waveGradientLayer addAnimation:colorAnimation forKey:shiftColorsAnimationKeyName];
}

- (void)addAllAnimations {
    [self animateMovingWaveGradientLayer:self.firstWaveGradientLayer withInterval:self.bounds.size.width * FirstAndSecondWaveIntervalPortion andDuration:_waveMovingBaseDuration + 2];
    [self animateMovingWaveGradientLayer:self.secondWaveGradientLayer withInterval:self.bounds.size.width * FirstAndSecondWaveIntervalPortion andDuration:_waveMovingBaseDuration];
    [self animateMovingWaveGradientLayer:self.thirdWaveGradientLayer withInterval:self.bounds.size.width * ThirdWaveIntervalPortion andDuration:_waveMovingBaseDuration + 1];
    
//    [self animateShfitingColorsOfWaveGradientLayer:self.firstWaveGradientLayer toAJWaveColorType:AJWaveColorTypeOrange withDuration:1.5];
//    [self animateShfitingColorsOfWaveGradientLayer:self.secondWaveGradientLayer toAJWaveColorType:AJWaveColorTypeOrange withDuration:1.5];
//    [self animateShfitingColorsOfWaveGradientLayer:self.thirdWaveGradientLayer toAJWaveColorType:AJWaveColorTypeOrange withDuration:1.5];
}

- (void)removeAllAnimations {
    
    [self.firstWaveGradientLayer.animationKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:moveWaveAnimationKeyName]) {
            [self.firstWaveGradientLayer removeAnimationForKey:moveWaveAnimationKeyName];
        }
    }];
    
//    [self.firstWaveGradientLayer removeAnimationForKey:shiftColorsAnimationKeyName];
    
    [self.secondWaveGradientLayer.animationKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:moveWaveAnimationKeyName]) {
            [self.firstWaveGradientLayer removeAnimationForKey:moveWaveAnimationKeyName];
        }
    }];
//    [self.secondWaveGradientLayer removeAnimationForKey:shiftColorsAnimationKeyName];
    
    [self.thirdWaveGradientLayer.animationKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:moveWaveAnimationKeyName]) {
            [self.firstWaveGradientLayer removeAnimationForKey:moveWaveAnimationKeyName];
        }
    }];
//    [self.thirdWaveGradientLayer removeAnimationForKey:shiftColorsAnimationKeyName];
}

- (void)addNotificationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllAnimations) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAllAnimations) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)removeNotificationObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
