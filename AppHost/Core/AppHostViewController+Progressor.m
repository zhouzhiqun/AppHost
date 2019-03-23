//
//  AppHostViewController+Progressor.m
//  AppHost
//
//  Created by liang on 2019/3/23.
//  Copyright © 2019 liang. All rights reserved.
//

#import "AppHostViewController+Progressor.h"
#import <objc/runtime.h>

@implementation AppHostViewController (Progressor)

- (void)startProgressor
{
    if (self.progressorView == nil) {
        [self addWebviewProgressor];
    }

    [self resetProgressor];
}

- (void)addWebviewProgressor
{
    // 仿微信进度条
    self.progressorView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, AH_NAVIGATION_BAR_HEIGHT, AH_SCREEN_WIDTH, 20.0f)];
    
    self.progressorView.progressTintColor = kWebViewProgressTintColorRGB > 0? AHColorFromRGB(kWebViewProgressTintColorRGB):[UIColor grayColor];
    self.progressorView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:self.progressorView];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        double progress = [change[@"new"] doubleValue];
        if (progress >= 1) {
            // 0.25s 后消失
            [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                
                self.clearProgressorTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(resetProgressor) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:self.clearProgressorTimer forMode:NSRunLoopCommonModes];
            }];
            [self.progressorView setProgress:1 animated:YES];
            [CATransaction commit];
        } else {
            [self.progressorView setProgress:progress animated:YES];
        }
        NSLog(@"progress = %f", progress);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)stopProgressor
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self resetProgressor];
}

- (void)resetProgressor
{
    [self.progressorView setProgress:0];
    [self.clearProgressorTimer invalidate];
}

#pragma mark - setter, setter

- (NSTimer *)clearProgressorTimer
{
    return objc_getAssociatedObject(self, @selector(clearProgressorTimer));
}

- (void)setClearProgressorTimer:(NSTimer *)clearProgressorTimer
{
    objc_setAssociatedObject(self, @selector(clearProgressorTimer), clearProgressorTimer, OBJC_ASSOCIATION_RETAIN);
}

- (UIProgressView *)progressorView
{
    return objc_getAssociatedObject(self, @selector(progressorView));
}

- (void)setProgressorView:(UIProgressView *)progressorView
{
    objc_setAssociatedObject(self, @selector(progressorView), progressorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
