//
//  MKBuiltInResponse.m

//
//  Created by liang on 06/01/2018.
//  Copyright © 2018 smilly.co All rights reserved.
//

#import "AHBuiltInResponse.h"
#import "AppHostViewController.h"

@implementation AHBuiltInResponse

- (BOOL)handleAction:(NSString *)action withParam:(NSDictionary *)paramDict
{
    if ([@"toast" isEqualToString:action]) {
        CGFloat delay = [[paramDict objectForKey:@"delay"] floatValue];
        [self showTextTip:[paramDict objectForKey:@"text"] delay:delay];
    } else if ([@"showLoading" isEqualToString:action]) {
        [self showLoading:[paramDict objectForKey:@"text"]];
    } else if ([@"hideLoading" isEqualToString:action]) {
        [self hideHUD];
    } else if ([@"pageBounceEnabled" isEqualToString:action]) {
        BOOL bounce = [[paramDict objectForKey:@"enabled"] boolValue];
        [self enablePageBounce:bounce];
    } else {
        return NO;
    }
    
    return YES;
}

+ (NSDictionary<NSString *, NSString *> *)supportActionList
{
    return @{
             @"toast" : @"1",
             @"showLoading" : @"1",
             @"hideLoading" : @"1",
             @"pageBounceEnabled" : @"1"
             };
}

#pragma mark - inner
- (void)hideHUD
{
    NSLog(@"Info: 关闭显示 HUD ，请使用本 App 的的 HUD 接口实现，以保持一致体验");
}

- (void)showLoading:(NSString *)tip
{
    NSLog(@"Info: 正在显示 Loading 提示: %@，请使用本 App 的的 HUD 接口实现，以保持一致体验", tip);
}

- (void)showTextTip:(NSString *)tip delay:(CGFloat)delay
{
    NSLog(@"Info: 正在显示 Toast 提示: %@, %f秒消失，请使用本 App 的的 HUD 接口实现，以保持一致体验", tip, delay);
}

- (void)enablePageBounce:(BOOL)bounce
{
    self.webView.scrollView.bounces = bounce;
}


@end