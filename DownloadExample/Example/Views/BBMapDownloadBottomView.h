//
//  BBMapDownloadBottomView.h
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/5.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBMapDownloadBottomView, BBMapDownloadBottomItem;

@protocol BBMapDownloadBottomViewDelegate <NSObject>

@optional
- (void)bottomView:(BBMapDownloadBottomView *)bottomView didClickItem:(BBMapDownloadBottomItem *)item;

@end

@interface BBMapDownloadBottomItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign, readonly) NSInteger buttonIdx;
@property (nonatomic, weak, readonly) UIButton *button;
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image;
- (NSString *)titleForState:(UIControlState)state;
- (NSString *)imageForState:(UIControlState)state;
- (void)setImage:(UIImage *)image state:(UIControlState)state;
- (void)setTitle:(NSString *)title state:(UIControlState)state;

@end

@interface BBMapDownloadBottomView : UIView

@property (nonatomic, weak) id<BBMapDownloadBottomViewDelegate> delegate;
@property (nonatomic, assign) CGFloat buttonHPadding;
@property (nonatomic, assign) CGFloat buttonVPadding;
- (instancetype)initWithItems:(NSArray<BBMapDownloadBottomItem *> *)items;
- (void)setItemTitle:(NSString *)title index:(NSInteger)index state:(UIControlState)state;
- (void)setItemImage:(UIImage *)image index:(NSInteger)index state:(UIControlState)state;

@end

@interface BBMapDownloadBottomButton : UIButton

@end
