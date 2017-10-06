//
//  NSString+AddSeperator.m
//  EasyLoan
//
//  Created by ChenKun on 14/09/2017.
//  Copyright © 2017 YT. All rights reserved.
//

#import "NSString+AddSeperator.h"

@implementation NSString (AddSeperator)

//-------------------------------------------------------
// 1000 => 1,000
// 1000000 => 1,000,000
//-------------------------------------------------------
- (NSString *)stringBySeperator:(NSString *)seperator withDistance:(NSInteger)distance {
  
    NSString *originString = [self copy];
    
    if ([originString length] < distance) return originString;
    
    NSUInteger start = [originString length] % distance;
    NSString *str = [originString substringWithRange:NSMakeRange(start, originString.length - start)];
    
    NSString *newString = [originString substringWithRange:NSMakeRange(0, start)];
    for (NSUInteger i = 0; i < str.length; i = i + distance) {
        NSString *sss = [str substringWithRange:NSMakeRange(i, distance)];
        newString = [newString stringByAppendingString:[NSString stringWithFormat:@"%@%@", seperator, sss]];
    }
    if ([[newString substringWithRange:NSMakeRange(0, 1)] isEqualToString:seperator]) {
        newString = [newString substringWithRange:NSMakeRange(1, newString.length - 1)];
    }
    return newString;
}

@end
