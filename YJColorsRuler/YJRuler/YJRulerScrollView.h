//
//  YJRulerScrollView.h
//
//  Created by ChenKun on 08/09/2017.
//  Copyright © 2017 YunTu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YJRulerStyle;

@interface YJRulerScrollView : UIScrollView

@property (nonatomic) YJRulerStyle *ytStyle;
@property (nonatomic) CGFloat rulerValue;
@property (nonatomic) CGFloat unitCount;

@end
