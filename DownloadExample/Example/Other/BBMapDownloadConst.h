//
//  BBMapDownloadConst.h
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/4.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+Extend.h"
#import "UIView+ConstraintsExtend.h"
#import "UIViewController+XYExtensions.h"

#define BBMapDownloadNavBackgroundColor [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0]
#define BBMapDownloadNavLineBackgroundColor [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]
#define BBMapDownloadCellLineBackgroundColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]
#define BBMapDownloadDownloadSectionBackgroundColor BBMapDownloadCellLineBackgroundColor
#define BBMapDownloadDarkTextColor [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1.0f]
#define BBMapDownloadLightTextColor [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0f]
#define BBMapDownloadViewBackgroundColor BBMapDownloadNavBackgroundColor
#define BBMapDownloadBottomButtonBackgroundBlueColor [UIColor colorWithRed:0.0 green:105.0/255.0 blue:210.0/255.0 alpha:1.0f]
#define BBMapDownloadBottomViewBackgroundColor [UIColor colorWithRed:0.0 green:105.0/255.0 blue:210.0/255.0 alpha:.7]
#define kScreenWidth (CGRectGetWidth([[UIScreen mainScreen] bounds]))
#define kScreenHeight (CGRectGetHeight([[UIScreen mainScreen] bounds]))
#define iPhoneX (kScreenWidth == 375.f && kScreenHeight == 812.f ? YES : NO)
#define kStateBarHeight (iPhoneX ? 44.0 : 20.0)
#define BBMapDownloadStateBarHeight kStateBarHeight
#define BBMapDownloadFontWithSize(size) [UIFont systemFontOfSize:size]


static CGFloat const BBMapDownloadViewGlobleMargin = 16.0;
static CGFloat const BBMapDownloadNavHeight = 52.0;
static CGFloat const BBMapDownloadDefaultFontSize = 14.0;
static CGFloat const BBMapDownloadSmallFontSize = 10.0;
static CGFloat const BBMapDownloadMiddleFontSize = 12.0;
static CGFloat const BBMapDownloadContinentCellHeight = 39.0;
static CGFloat const BBMapDownloadDownloadCellHeight = 61.0;
static CGFloat const BBMapDownloadDownloadSectionHeaderHeight = 29.0;
static CGFloat const BBMapDownloadDownloadNetworkStateViewHeight = 36.0;
static CGFloat const BBMapDownloadDownloadSearchViewHeight = 39.0;
static CGFloat const BBMapDownloadDownloadNoDataLabelOffsetY = 250.0;
static CGFloat const BBMapDownloadButtomButtonTitleFontSize = 20.0;
static CGFloat const BBMapDownloadBottomViewHeight = 50.0;
static CGFloat const BBMapDownloadHotCityButtonHeight = 22.0;

__unused static UIImage * BBMapDownloadCellLineImage() {
    static UIImage *image = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        image = [UIImage imageWithColor:BBMapDownloadCellLineBackgroundColor];
    });
    return image;
}

__unused static UIImage * BBMapDownloadNavLineImage() {
    static UIImage *image = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        image = [UIImage imageWithColor:BBMapDownloadNavLineBackgroundColor];
    });
    return image;
}
