//
//  UIImage+Additions.h
//  FaceSharp
//
//  Created by 阿凡树 on 2017/5/17.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)

+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size;
/**
 修正图片的转向(从相机中取出的照片容易转向)
 */
- (UIImage *)orientationFixed;
/**
 提取子图片
 @param rect 提取大小
 @returns 子图片
 */
- (UIImage *)subImageAtRect:(CGRect)rect;

- (NSString *)base64EncodedString;

- (NSData *)dataWithCompress:(CGFloat)compress;

- (NSData *)data;

- (UIImage *)resizedToSize:(CGSize)size;

- (UIImage *)resizedFix;


@end
