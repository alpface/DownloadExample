//
//  BBMapDownloadNetworkStateView.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/4.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBMapDownloadNetworkStateView.h"
#import "BBMapDownloadConst.h"

@interface BBMapDownloadNetworkStateView ()

@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation BBMapDownloadNetworkStateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    NSDictionary *viewDict = @{@"titleLabel": self.titleLabel};
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[titleLabel]|" options:kNilOptions metrics:nil views:viewDict]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]|" options:kNilOptions metrics:nil views:viewDict]];
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
        label.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
        [label setFont:BBMapDownloadFontWithSize(BBMapDownloadMiddleFontSize)];
        [label setTextColor:BBMapDownloadDarkTextColor];
        [self addSubview:label];
    }
    return _titleLabel;
}
@end
