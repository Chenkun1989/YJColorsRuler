//
//  YJRulerScrollView.m
//
//  Created by ChenKun on 08/09/2017.
//  Copyright © 2017 YunTu.Inc. All rights reserved.
//

#import "YJRulerScrollView.h"
#import "YJRuler.h"

@implementation YJRulerScrollView {
    CGFloat _rulerWidth;
    CGFloat _rulerHeight;
    
    NSMutableArray *_tempLayers;
    NSMutableArray *_tempRulerLabels;
    
    NSMutableArray *_colorsArray;
}

#pragma mark - Life cycle.
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _rulerWidth = frame.size.width;
        _rulerHeight = frame.size.height;
        _tempLayers = [NSMutableArray new];
        _tempRulerLabels = [NSMutableArray new];
        _colorsArray = [NSMutableArray new];
        self.backgroundColor = Color_clear;
    }
    return self;
}

#pragma mark - Custom draw.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
  
    // Avoid memory leak.
    for (CALayer *alayer in _tempLayers) {
        [alayer removeFromSuperlayer];
    }
    for (UILabel *label in _tempRulerLabels) {
        [label removeFromSuperview];
    }
    [_tempLayers removeAllObjects];
    [_tempRulerLabels removeAllObjects];
    
    // Draw the line on the left of marker.
    NSUInteger colorIndex = 0, gradientCount = [_colorsArray count];
    for (int i = _rulerValue; i >= 0; i--) {
        @autoreleasepool {
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            if (gradientCount > 0 && colorIndex < gradientCount) {
                shapeLayer.strokeColor = ((UIColor *)[_colorsArray objectAtIndex:colorIndex++]).CGColor;
            } else {
                shapeLayer.strokeColor = [_ytStyle tickColor].CGColor;
            }
            shapeLayer.fillColor = [Color_clear CGColor];
            shapeLayer.lineWidth = _ytStyle.lineWidth;
            shapeLayer.lineCap = kCALineCapButt;
            
            if (i % 10 == 0) {
                CGPathMoveToPoint(pathRef, NULL, _ytStyle.stepLength * i , _rulerHeight - _ytStyle.lineHeight10);
                CGPathAddLineToPoint(pathRef, NULL, _ytStyle.stepLength * i, _rulerHeight);
                
                // Add title text.
                UILabel *ruleLabel = [[UILabel alloc] init];
                ruleLabel.textColor = [_ytStyle tickColor];
				ruleLabel.font = [UIFont systemFontOfSize:ceil([_ytStyle labelFontSize])];
                ruleLabel.text = [NSString stringWithFormat:@"%.0f", i * _ytStyle.unitValue + _ytStyle.minValue];
                CGSize textSize = [ruleLabel.text sizeWithAttributes:@{ NSFontAttributeName : ruleLabel.font }];
                ruleLabel.frame = CGRectMake(_ytStyle.stepLength * i - textSize.width / 2, 5, 0, 0);
                [ruleLabel sizeToFit];
                [self addSubview:ruleLabel];
                [_tempRulerLabels addObject:ruleLabel];
            } else if (i % 5 == 0) {
                CGPathMoveToPoint(pathRef, NULL, _ytStyle.stepLength * i , _rulerHeight - _ytStyle.lineHeight5);
                CGPathAddLineToPoint(pathRef, NULL, _ytStyle.stepLength * i, _rulerHeight);
            } else {
                CGPathMoveToPoint(pathRef, NULL, _ytStyle.stepLength * i , _rulerHeight - _ytStyle.lineHeight1);
                CGPathAddLineToPoint(pathRef, NULL, _ytStyle.stepLength * i, _rulerHeight);
            }
            shapeLayer.path = pathRef;
            CGPathRelease(pathRef);
            [self.layer addSublayer:shapeLayer];
            [_tempLayers addObject:shapeLayer];
        }
    }
    
    // Draw line on the right of marker.
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [_ytStyle tickColor].CGColor;
    shapeLayer.fillColor = [Color_clear CGColor];
    shapeLayer.lineWidth = [_ytStyle lineWidth];
    shapeLayer.lineCap = kCALineCapButt;

    for (int i = _rulerValue; i <= _unitCount; i++) {
        @autoreleasepool {
            if (i % 10 == 0) {
                CGPathMoveToPoint(pathRef, NULL, _ytStyle.stepLength * i , _rulerHeight - _ytStyle.lineHeight10);
                CGPathAddLineToPoint(pathRef, NULL, _ytStyle.stepLength * i, _rulerHeight);
                
                UILabel *ruleLabel = [[UILabel alloc] init];
                ruleLabel.textColor = [_ytStyle tickColor];
				ruleLabel.font = [UIFont systemFontOfSize:ceil([_ytStyle labelFontSize])];
                ruleLabel.text = [NSString stringWithFormat:@"%.0f", i * _ytStyle.unitValue + _ytStyle.minValue];
                CGSize textSize = [ruleLabel.text sizeWithAttributes:@{ NSFontAttributeName : ruleLabel.font }];
                ruleLabel.frame = CGRectMake(_ytStyle.stepLength * i - textSize.width / 2, 5, 0, 0);
                [ruleLabel sizeToFit];
                [self addSubview:ruleLabel];
                [_tempRulerLabels addObject:ruleLabel];
            } else if (i % 5 == 0) {
                CGPathMoveToPoint(pathRef, NULL, _ytStyle.stepLength * i , _rulerHeight - _ytStyle.lineHeight5);
                CGPathAddLineToPoint(pathRef, NULL, _ytStyle.stepLength * i, _rulerHeight);
            } else {
                CGPathMoveToPoint(pathRef, NULL, _ytStyle.stepLength * i , _rulerHeight - _ytStyle.lineHeight1);
                CGPathAddLineToPoint(pathRef, NULL, _ytStyle.stepLength * i, _rulerHeight);
            }
        }
    }
    shapeLayer.path = pathRef;
    CGPathRelease(pathRef);
    [self.layer addSublayer:shapeLayer];
    [_tempLayers addObject:shapeLayer];
}

#pragma mark - Public.
- (void)setRulerValue:(CGFloat)rulerValue {
    
    _rulerValue = rulerValue;
    
    if ([_ytStyle gradientColors]) {
        [self p_getGradientColors];
        [self setNeedsDisplay];
    }
}

- (void)p_getGradientColors {
    
    if (!_ytStyle.gradientColors || _ytStyle.gradientColors.count != 2) return;
    
    CGFloat lRed, lGreen, lBlue, rRed, rGreen, rBlue, alpha;
    
    UIColor *leftColor = [_ytStyle gradientColors][0];
    UIColor *rightColor = [_ytStyle gradientColors][1];
    
    BOOL leftValid = [leftColor getRed:&lRed green:&lGreen blue:&lBlue alpha:&alpha];
    BOOL rightValid = [rightColor getRed:&rRed green:&rGreen blue:&rBlue alpha:&alpha];
    
    if (!leftValid || !rightValid) return;
    
    // Check how many colors will need.
    CGFloat space = _rulerValue * _ytStyle.stepLength;
    CGFloat halfWidth = SCREEN_WIDTH / 2.f;
    if (space > halfWidth) {
        space = halfWidth;
    }
    NSUInteger colorCount = space / _ytStyle.stepLength;
    if (colorCount == 0) return;
    
    // R.G.B steps
    CGFloat redStep = 0.f, greenStep = 0.f, blueStep = 0.f;
    
    redStep = (lRed - rRed) / colorCount;
    greenStep = (lGreen - rGreen) / colorCount;
    blueStep = (lBlue - rBlue) / colorCount;
    
    [_colorsArray removeAllObjects];
    
    // Gradient colors.
    [_colorsArray addObject:[_ytStyle.gradientColors objectAtIndex:1]];
    for (int i = 0; i < colorCount; ++i) {
        rRed += redStep;
        rGreen += greenStep;
        rBlue += blueStep;
        [_colorsArray addObject:[UIColor colorWithRed:rRed green:rGreen blue:rBlue alpha:1.f]];
    }
    [_colorsArray addObject:[_ytStyle gradientColors][0]];;
}

#pragma mark - Setter.
- (void)setYtStyle:(YJRulerStyle *)ytStyle {
    
    _ytStyle = ytStyle;
    _unitCount = (ytStyle.maxValue - ytStyle.minValue) / ytStyle.unitValue;
	_rulerValue = ytStyle.rulerValue;
	
    CGFloat rulerHalfWidth = _rulerWidth / 2.f;
    self.contentInset = UIEdgeInsetsMake(0, rulerHalfWidth, 0, rulerHalfWidth);
    self.contentOffset = CGPointMake(_ytStyle.stepLength * self.rulerValue - rulerHalfWidth, 0);
    self.contentSize = CGSizeMake(_unitCount * _ytStyle.stepLength, _rulerHeight);
}

@end
