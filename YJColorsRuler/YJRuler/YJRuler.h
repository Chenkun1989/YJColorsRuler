//
//  YJRuler.h
//
//  Created by ChenKun on 08/09/2017.
//  Copyright © 2017 YunTu.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BearDefines.h"
#import "UIView+BearSet.h"

NS_ASSUME_NONNULL_BEGIN

#define UIColorFromHEX(rgbValue) \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                     blue:((float)(rgbValue & 0xFF))/255.0 \
                    alpha:1.0]

#define Color_d8d8d8            UIColorFromHEX(0xd8d8d8)
#define Color_29b0e6            UIColorFromHEX(0x29b0e6)
#define Color_fe0058            UIColorFromHEX(0xfe0058)
#define Color_3d4552            UIColorFromHEX(0x3d4552)
#define Color_ff4139            UIColorFromHEX(0xff4139)
#define Color_clear             [UIColor clearColor]

#define SCREEN_WIDTH ([UIScreen  mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@protocol YJRulerDelegate;


// `YJRulerStyle` instances define the feel for ruler views.
@interface YJRulerStyle : NSObject

@property (nonatomic) UIColor *backgroundColor;

// For mark current value.
@property (nonatomic) UIColor *markerColor;

// every tick color of ruler
@property (nonatomic) UIColor *tickColor;

// If this value is nil, every tick line have the same color.
// Or, ticks before marker will stroke by these colors.
// Default is nil.
@property (nonatomic) NSArray *gradientColors;

// The minimum value and max value of the ruler.
// Default is 200.
@property (nonatomic) CGFloat minValue;

// Default is 10000.
@property (nonatomic) CGFloat maxValue;

// Current value.
@property (nonatomic) CGFloat rulerValue;

// basic measurement unit, every unit may be represent 100 RMB, or 10 cm, and so on.
@property (nonatomic) CGFloat unitValue;

// for draw unit.
@property (nonatomic) CGFloat stepLength;

@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGFloat markerLineWidth;
@property (nonatomic) CGFloat lineHeight1;
@property (nonatomic) CGFloat lineHeight5;
@property (nonatomic) CGFloat lineHeight10;

@property (nonatomic) CGFloat labelFontSize;

@end


@interface YJRuler : UIView

@property (nonatomic, weak) id<YJRulerDelegate> delegate;

@property (nonatomic, readonly) CGFloat rulerValue;

- (instancetype)initWithFrame:(CGRect)frame rulerStyle:(YJRulerStyle *)style;
- (void)updateMinValue:(NSString *)minValue maxValue:(NSString *)maxValue;

@end

@protocol YJRulerDelegate <NSObject>

// Get ruler value when scroll stop.
- (void)rulerDidScroll:(YJRuler *)ruler;

@end

NS_ASSUME_NONNULL_END
