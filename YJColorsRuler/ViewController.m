//
//  ViewController.m
//  YJColorsRuler
//
//  Created by ChenKun on 06/10/2017.
//  Copyright © 2017 ChenKun. All rights reserved.
//

#import "ViewController.h"
#import "YJRuler.h"

@interface ViewController ()<YJRulerDelegate>

@property (nonatomic, strong) YJRuler *ruler;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.contentView addSubview:self.ruler];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.ruler updateMinValue:@"1" maxValue:@"100"];
}

#pragma mark
- (void)rulerDidScroll:(YJRuler *)ruler {
    
    NSLog(@"ruler = %f", ruler.rulerValue);
}

- (YJRuler *)ruler {
    
    if (!_ruler) {
        CGRect frameRect = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.contentView.frame));
        _ruler = [[YJRuler alloc] initWithFrame:frameRect];
        _ruler.delegate = self;
    }
    return _ruler;
}

@end
