//
//  AJWaveView.h
//  AJWaveView
//
//  Created by ChuanJie Jhuang on 2020/5/21.
//  Copyright © 2020 ChuanJie Jhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AJWaveColorType) {
    AJWaveColorTypeUnknown = -1,
    AJWaveColorTypeDeepRed = 0,
    AJWaveColorTypeRed,
    AJWaveColorTypeOrange,
    AJWaveColorTypeBlue
};

@interface AJWaveView : UIView

@property (nonatomic, assign) AJWaveColorType color;

/// Adjust cycle duration time.
/// @param duration wave cycle duration time
- (void)animateMovingWaveWithBaseDuration:(CFTimeInterval)duration;

/// Animating change wave color.
/// @param toColorType which color to change
/// @param duration wave cycle duration time
/// @param completion animating end completion block
- (void)animateShfitingColorsToAJWaveColorType:(AJWaveColorType)toColorType andDuration:(CFTimeInterval)duration withCompletion:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
