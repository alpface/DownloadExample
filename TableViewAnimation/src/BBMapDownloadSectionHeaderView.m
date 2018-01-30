//
//  BBMapDownloadSectionHeaderView.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/4.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBMapDownloadSectionHeaderView.h"
#import "BBMapDownloadConst.h"

NSString * const BBMapDownloadSectionHeaderViewDefaultIdentifier = @"BBMapDownloadSectionHeaderViewDefaultIdentifier";

@interface BBMapDownloadSectionHeaderView ()

@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation BBMapDownloadSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = BBMapDownloadDownloadSectionBackgroundColor;
        
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-BBMapDownloadViewGlobleMargin-[titleLabel]-(<=BBMapDownloadViewGlobleMargin)-|" options:kNilOptions metrics:@{@"BBMapDownloadViewGlobleMargin": @(BBMapDownloadViewGlobleMargin)} views:@{@"titleLabel": self.titleLabel}]];
        [NSLayoutConstraint activateConstraints:@[[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]]];
        
    }
    return self;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    self.titleLabel.attributedText = attributedText;
}

- (NSAttributedString *)attributedText {
    return self.titleLabel.attributedText;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [UILabel new];
        _titleLabel = label;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.numberOfLines = 1;
        [label setFont:BBMapDownloadFontWithSize(BBMapDownloadMiddleFontSize)];
        [label setTextColor:BBMapDownloadLightTextColor];
        [self.contentView addSubview:label];
    }
    return _titleLabel;
}

@end
