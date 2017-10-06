//
//  YJRulerConstants.m
//  YJColorsRuler
//
//  Created by ChenKun on 06/10/2017.
//  Copyright © 2017 ChenKun. All rights reserved.
//

#import "YJRulerConstants.h"

@implementation YJRulerConstants

static YJRulerConstants *manager;
static dispatch_once_t once = 0;

+ (instancetype)sharedInstance {
    
    dispatch_once(&once, ^{
        manager = [[YJRulerConstants alloc] init];
    });
    return manager;
}

@end
