//
//  MBProgressHUD+LFYAdd.m
//  THT
//
//  Created by LFY on 2017/8/1.
//  Copyright © 2017年 tuling. All rights reserved.
//

#import "MBProgressHUD+LFYAdd.h"

@implementation MBProgressHUD (LFYAdd)

#pragma mark - 
+ (MBProgressHUD *)show{
    
    UIView *view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    return hud;
}

#pragma mark - Private
+ (void)show:(NSString *)text
        icon:(NSString *)icon
        view:(UIView *)view{
    
    if (view == nil) view = [[UIApplication sharedApplication]keyWindow];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    [hud show:text icon:icon];
}

- (void)show:(NSString *)text
        icon:(NSString *)icon{
    
    if (text.length > 10) {
        
        NSMutableString *mutableString = [NSMutableString stringWithString:text];
        for (NSInteger i = 0; i < text.length; i ++) {
            
            if (i % 10 == 0 && i != 0) {
                
                [mutableString insertString:@"\n" atIndex:i];
            }
        }
        self.detailsLabel.text = mutableString;
    }else{
        
        self.label.text = text;
    }
    
    // 设置图片
    if (icon) {
        self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    }
    // 再设置模式
    self.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    self.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [self hideAnimated:YES afterDelay:1.0];
}

#pragma mark - Success
- (void)showSuccess:(NSString *)success{

    [self show:success icon:@"success.png"];
}

+ (void)showSuccess:(NSString *)success {
    [self showSuccess:success toView:nil];
}

+ (void)showSuccess:(NSString *)success
             toView:(UIView *)view {
    [self show:success icon:@"success.png" view:view];
}

#pragma mark - Error
- (void)showError:(NSString *)error {
    [self show:error icon:@"error.png"];
}

+ (void)showError:(NSString *)error {
    [self showError:error toView:nil];
}

+ (void)showError:(NSString *)error
           toView:(UIView *)view {
    [self show:error icon:@"error.png" view:view];
}

#pragma mark - Tip
+ (void)showTip:(NSString *)tip{

    [self showTip:tip
             time:1.5
           offset:CGPointZero
           toView:nil];
}

+ (void)showTip:(NSString *)tip
         toView:(UIView *)view{
    
    [self showTip:tip
             time:1.0
           offset:CGPointZero
           toView:view];
}

+ (void)showTip:(NSString *)tip
           time:(NSTimeInterval)time{
    
    [self showTip:tip
             time:time
           offset:CGPointZero
           toView:nil];
}

+ (void)showTip:(NSString *)tip
         offset:(CGPoint)offset{

    [self showTip:tip
             time:1.0
           offset:offset
           toView:nil];
}

+ (void)showTip:(NSString *)tip
           time:(NSTimeInterval)time
         toView:(UIView *)view{

    [self showTip:tip
             time:time
           offset:CGPointZero
           toView:view];
}

+ (void)showTip:(NSString *)tip
           time:(NSTimeInterval)time
         offset:(CGPoint)offset
         toView:(UIView *)view {
    
    if (view == nil) view = [[UIApplication sharedApplication]keyWindow];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = tip;
    hud.label.font = [UIFont systemFontOfSize:13];
    hud.label.textColor = [UIColor whiteColor];
    hud.label.numberOfLines = 0;
    hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
//    hud.mj_x = offset.x;
//    hud.mj_y= offset.y;
    
    [hud hideAnimated:YES afterDelay:time];
}

#pragma mark - Message
+ (MBProgressHUD *)showMessage:(NSString *)message{
    
    return [self showMessage:message toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication]keyWindow];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
//    hud.dimBackground = YES;
    return hud;
}

#pragma mark - Hide
+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}


#pragma mark - Download
+ (MBProgressHUD *)determinateDownloadHUD{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.label.text = @"下载中...";
//    [hud.button setTitle:@"取消" forState:UIControlStateNormal];
    return hud;
}

@end
