//
//  BBMapDownloadSearchView.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/8.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBMapDownloadSearchView.h"
#import "BBMapDownloadConst.h"

@interface BBMapDownloadSearchView ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation BBMapDownloadSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       [self setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-BBMapDownloadViewGlobleMargin-[imageView]-BBMapDownloadViewGlobleMargin-[titleLabel]-BBMapDownloadViewGlobleMargin-|" options:NSLayoutFormatAlignAllCenterY metrics:@{@"BBMapDownloadViewGlobleMargin": @(BBMapDownloadViewGlobleMargin)} views:@{@"imageView": self.imageView, @"titleLabel": self.titleLabel}]];
    [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.6 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0].active = YES;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (NSString *)title {
    return self.titleLabel.text;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (UIImage *)image {
    return self.imageView.image;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [UIImageView new];
        _imageView = imageView;
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"icon_search"];
        [self addSubview:imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [UILabel new];
        _titleLabel = label;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentLeft;
        [label setFont:BBMapDownloadFontWithSize(BBMapDownloadDefaultFontSize)];
        label.textColor = BBMapDownloadLightTextColor;
        [self addSubview:label];
    }
    return _titleLabel;
}


@end
