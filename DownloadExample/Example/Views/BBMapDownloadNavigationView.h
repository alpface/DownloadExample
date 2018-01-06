//
//  BBMapDownloadNavigationView.h
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/4.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBMapDownloadNavigationView : UIView

@property (nonatomic, strong) UIView *customTitleView;
@property (nonatomic, assign) CGFloat customTittleViewWidthConstraintMultiplier; // 0.0~1.0 之间

@property (nonatomic, copy) void (^backActionCallBack)(UIButton *backButton);
@property (nonatomic, copy) NSAttributedString *titleAttributedText;

@end
