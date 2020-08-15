//
//  MBProgressHUD+LFYAdd.h
//  THT
//
//  Created by LFY on 2017/8/1.
//  Copyright © 2017年 tuling. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (LFYAdd)

#pragma mark - 
+ (MBProgressHUD *)show;

#pragma mark - Success
- (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

#pragma mark - Error
- (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

#pragma mark - Tip
+ (void)showTip:(NSString *)tip;
+ (void)showTip:(NSString *)tip toView:(UIView *)view;
+ (void)showTip:(NSString *)tip time:(NSTimeInterval)time;
+ (void)showTip:(NSString *)tip offset:(CGPoint)offset;
+ (void)showTip:(NSString *)tip time:(NSTimeInterval)time toView:(UIView *)view;

#pragma mark - Message
+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

#pragma mark - Hide
+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

#pragma mark - Download
+ (MBProgressHUD *)determinateDownloadHUD;

@end
