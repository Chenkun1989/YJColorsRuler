//
//  YJRuler.m
//
//  Created by ChenKun on 08/09/2017.
//  Copyright © 2017 YunTu.Inc. All rights reserved.
//

#import "YJRuler.h"
#import "YJRulerScrollView.h"
#import "NSString+AddSeperator.h"
#import "YJRulerConstants.h"

#define kFloatCompareDelta	0.1

@interface YJRuler () <UIScrollViewDelegate>

@property (nonatomic) YJRulerStyle *rulerStyle;
@property (nonatomic) YJRulerScrollView *rulerScrollView;

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *moneyLabel;
@property (nonatomic) UIImageView *markerImageView;

@end

@implementation YJRuler

#pragma mark - Life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    return [self initWithFrame:frame rulerStyle:[YJRulerStyle new]];
}

- (instancetype)initWithFrame:(CGRect)frame rulerStyle:(YJRulerStyle *)style {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [style backgroundColor];
        
        _rulerStyle = style;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.moneyLabel];
        [self p_drawBottomLine];
        [self addSubview:self.rulerScrollView];
        [self addSubview:self.markerImageView];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.titleLabel BearSetRelativeLayoutWithDirection:kDIR_UP
                                        destinationView:nil
                                         parentRelation:YES
                                               distance:XX_6(21)
                                                 center:YES
                                              sizeToFit:YES];
    
    [self.moneyLabel BearSetRelativeLayoutWithDirection:kDIR_UP
                                        destinationView:nil
                                         parentRelation:YES
                                               distance:XX_6(41)
                                                 center:YES
                                              sizeToFit:NO];
    
    [self.markerImageView BearSetRelativeLayoutWithDirection:kDIR_DOWN
                                             destinationView:nil
                                              parentRelation:YES
                                                    distance:0
                                                      center:YES];
}

#pragma mark - Public.
- (void)updateMinValue:(NSString *)minValue maxValue:(NSString *)maxValue {
    
    YJRulerStyle *rulerStyle = [[YJRulerStyle alloc] init];
    rulerStyle.minValue = [minValue integerValue];
    rulerStyle.maxValue = [maxValue integerValue];
	
    CGFloat amount = [[[YJRulerConstants sharedInstance] amount] integerValue];
    if (amount >= rulerStyle.minValue && amount <= rulerStyle.maxValue) {
        NSInteger rulerValue = (amount - rulerStyle.minValue) / rulerStyle.unitValue;
        rulerStyle.rulerValue = rulerValue;
    } else {
        [[YJRulerConstants sharedInstance] setAmount:[NSString stringWithFormat:@"%f", rulerStyle.minValue]];
    }
	
    self.rulerStyle = rulerStyle;
    self.rulerScrollView.ytStyle = rulerStyle;
    
    self.moneyLabel.text = [[NSString stringWithFormat:@"%0.f", self.rulerValue] stringBySeperator:@"," withDistance:3];
    
    [self.rulerScrollView setNeedsDisplay];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(YJRulerScrollView *)scrollView {
    
    CGFloat rulerValue = (scrollView.contentOffset.x + self.frame.size.width / 2) / _rulerStyle.stepLength;
    if (rulerValue < 0 || rulerValue > scrollView.unitCount + kFloatCompareDelta) {
        return;
    }
    rulerValue = [self p_roundWihtValue:rulerValue];
    [scrollView setRulerValue:rulerValue];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(rulerDidScroll:)]) {
        [self.delegate rulerDidScroll:self];
    }
    self.moneyLabel.text = [[NSString stringWithFormat:@"%0.f", self.rulerValue] stringBySeperator:@"," withDistance:3];
}

- (void)scrollViewDidEndDecelerating:(YJRulerScrollView *)scrollView {
	
    [self p_animationRebound:scrollView];
}

- (void)scrollViewDidEndDragging:(YJRulerScrollView *)scrollView willDecelerate:(BOOL)decelerate {

	[self p_animationRebound:scrollView];
}

#pragma mark - Private.
- (void)p_animationRebound:(YJRulerScrollView *)scrollView {

    CGFloat rulerValue = (scrollView.contentOffset.x + self.frame.size.width / 2) / _rulerStyle.stepLength;
    rulerValue = [self p_roundWihtValue:rulerValue];

	[UIView animateWithDuration:.15f animations:^{
        scrollView.contentOffset = CGPointMake(rulerValue * _rulerStyle.stepLength - self.frame.size.width / 2, 0);
    }];
}

- (CGFloat)p_roundWihtValue:(CGFloat)value {
    
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler
                                                decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                scale:0
                                                raiseOnExactness:NO
                                                raiseOnOverflow:NO
                                                raiseOnUnderflow:NO
                                                raiseOnDivideByZero:NO];
    NSDecimalNumber *decimalNumber = [[NSDecimalNumber alloc] initWithFloat:value];
    NSDecimalNumber *roundedDecimal = [decimalNumber decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [roundedDecimal floatValue];
}

- (void)p_drawBottomLine {
    
    CAShapeLayer *shapeLayerLine = [CAShapeLayer layer];
    shapeLayerLine.strokeColor = [Color_d8d8d8 CGColor];
    shapeLayerLine.fillColor = [Color_d8d8d8 CGColor];
    shapeLayerLine.lineWidth = 0.5f;
    shapeLayerLine.lineCap = kCALineCapSquare;
    
    CGMutablePathRef pathLine = CGPathCreateMutable();
    CGFloat xPoint = CGRectGetWidth(self.frame);
    
    CGPathMoveToPoint(pathLine, NULL, 0, CGRectGetHeight(self.frame));
    CGPathAddLineToPoint(pathLine, NULL, xPoint, CGRectGetHeight(self.frame));
    shapeLayerLine.path = pathLine;
    
    CGPathRelease(pathLine);
    
    [self.layer addSublayer:shapeLayerLine];
}

#pragma mark getter & setter.
- (YJRulerScrollView *)rulerScrollView {
    
    if (!_rulerScrollView) {
        CGRect frame = CGRectMake(0, self.frame.size.height - XX_6(50), self.frame.size.width, XX_6(50));
        _rulerScrollView = [[YJRulerScrollView alloc] initWithFrame:frame];
        _rulerScrollView.showsHorizontalScrollIndicator = NO;
        _rulerScrollView.alwaysBounceVertical = NO;
        _rulerScrollView.delegate = self;
        _rulerScrollView.ytStyle = self.rulerStyle;
    }
    return _rulerScrollView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"Value";
        _titleLabel.font = [UIFont systemFontOfSize:16.f];
        _titleLabel.textColor = Color_3d4552;
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel {
    
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XX_6(200), XX_6(48))];
		_moneyLabel.font = [UIFont fontWithName:@"MuseoSans-500" size:36.f];
        _moneyLabel.textColor = Color_ff4139;
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLabel;
}

- (UIImageView *)markerImageView {
    
    if (!_markerImageView) {
        _markerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mark"]];
        _markerImageView.backgroundColor = Color_clear;
		_markerImageView.frame = CGRectMake(0, self.frame.size.height - XX_6(71), XX_6(16), XX_6(71));
    }
    return _markerImageView;
}

- (CGFloat)rulerValue {
    
    return self.rulerScrollView.rulerValue * _rulerStyle.unitValue + _rulerStyle.minValue;
}

@end


@implementation YJRulerStyle

- (instancetype)init {
    
    if (self = [super init]) {
        _backgroundColor = [UIColor clearColor];
        _tickColor = Color_d8d8d8;
        _gradientColors = @[Color_29b0e6, Color_fe0058];
        _minValue = 0;
        _maxValue = 100;
        _unitValue = 1;
		_rulerValue = 0;
		
        _stepLength = XX_6(8);
        _lineWidth = XX_6(2);

        _lineHeight1 = XX_6(12);
        _lineHeight5 = XX_6(28);
        _lineHeight10 = XX_6(28);
        
        _labelFontSize = XX_6(10);
    }
    return self;
}

@end
