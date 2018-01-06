//
//  UIImage+Extend.m
//  DownloadExample
//
//  Created by swae on 2018/1/6.
//  Copyright © 2018年 xiaoyuan. All rights reserved.
//

#import "UIImage+Extend.h"

@implementation UIImage (Extend)

+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
