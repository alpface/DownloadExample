//
//  BBMapDownloadNavigationView.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/4.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBMapDownloadNavigationView.h"
#import "BBMapDownloadConst.h"

@interface BBMapDownloadNavigationView ()

@property (nonatomic, weak) UIView *bottomeLineView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *backButton;
@property (nonatomic, strong) NSMutableArray *subviewsConstraints;

@end

@implementation BBMapDownloadNavigationView

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
    self.backgroundColor = BBMapDownloadNavBackgroundColor;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {
    
    [NSLayoutConstraint deactivateConstraints:self.subviewsConstraints];
    [self.subviewsConstraints removeAllObjects];
    
    if (![self shouldDisplayCustomTitleView]) {
        NSLayoutConstraint *labelLeft = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.backButton attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10.0];
        NSLayoutConstraint *labelCenterY = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
        NSLayoutConstraint *labelCenterX = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
        [self.subviewsConstraints addObjectsFromArray:@[labelLeft, labelCenterY, labelCenterX]];
    }
    else {
        [_titleLabel removeFromSuperview];
        _titleLabel = nil;
        
        NSLayoutConstraint *customTitleViewLeft = [NSLayoutConstraint constraintWithItem:self.customTitleView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.backButton attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10.0];
        NSLayoutConstraint *customTitleViewTop = [NSLayoutConstraint constraintWithItem:self.customTitleView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0];
        NSLayoutConstraint *customTitleViewCenterY = [NSLayoutConstraint constraintWithItem:self.customTitleView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
        NSLayoutConstraint *customTitleViewCenterX = [NSLayoutConstraint constraintWithItem:self.customTitleView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
        
        [self.subviewsConstraints addObjectsFromArray:@[customTitleViewLeft, customTitleViewCenterY, customTitleViewCenterX, customTitleViewTop]];
        
        if (self.customTittleViewWidthConstraintMultiplier) {
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.customTitleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:self.customTittleViewWidthConstraintMultiplier constant:0.0];
            width.priority = 995.0;
            [self.subviewsConstraints addObject:width];
        }
        else if (self.customTitleView.frame.size.width > 0) {
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.customTitleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.customTitleView.frame.size.width];
            width.priority = 995.0;
            [self.subviewsConstraints addObject:width];
        }
        
        if (self.customTitleView.frame.size.height > 0) {
            [self.subviewsConstraints addObject:[NSLayoutConstraint constraintWithItem:self.customTitleView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.customTitleView.frame.size.height]];
        }
    }
    
    NSLayoutConstraint *backButtonLeft = [NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:4.0];
    NSLayoutConstraint *backButtonWidth = [NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0];
    NSLayoutConstraint *backButtonHeight = [NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.backButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    NSLayoutConstraint *backButtonCenterY = [NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    [self.subviewsConstraints addObjectsFromArray:@[backButtonLeft, backButtonWidth, backButtonHeight, backButtonCenterY]];
    
    NSMutableArray *bottomeLineViewConstrints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[bottomeLineView]|" options:kNilOptions metrics:nil views:@{@"bottomeLineView": self.bottomeLineView}].mutableCopy;
    [bottomeLineViewConstrints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomeLineView(==1)]|" options:kNilOptions metrics:nil views:@{@"bottomeLineView": self.bottomeLineView}]];
    [self.subviewsConstraints addObjectsFromArray:bottomeLineViewConstrints];
    
    [NSLayoutConstraint activateConstraints:self.subviewsConstraints];
    
    [super updateConstraints];
}


- (void)navigateBackAction:(id)sender {
    if (self.backActionCallBack) {
        self.backActionCallBack(sender);
    }
}

- (BOOL)shouldDisplayCustomTitleView {
    if (self.customTitleView.superview) {
        return YES;
    }
    return NO;
}

- (void)setTitleAttributedText:(NSAttributedString *)titleAttributedText {
    if (_titleAttributedText == titleAttributedText) {
        return;
    }
    _titleAttributedText = titleAttributedText;
    
    if (_customTitleView) {
        [_customTitleView removeFromSuperview];
        _customTitleView = nil;
    }
    
    self.titleLabel.attributedText = titleAttributedText;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)setCustomTitleView:(UIView *)customTitleView {
    if (!customTitleView) {
        return;
    }
    
    if (_customTitleView) {
        [_customTitleView removeFromSuperview];
        _customTitleView = nil;
    }
    _customTitleView = customTitleView;
    _customTitleView.translatesAutoresizingMaskIntoConstraints = NO;
    _customTitleView.accessibilityIdentifier = @"customTitleView";
    [self addSubview:_customTitleView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)setCustomTittleViewWidthConstraintMultiplier:(CGFloat)customTittleViewWidthConstraintMultiplier {
    if (customTittleViewWidthConstraintMultiplier == _customTittleViewWidthConstraintMultiplier) {
        return;
    }
    _customTittleViewWidthConstraintMultiplier = MIN(MAX(customTittleViewWidthConstraintMultiplier, 0.0), 1.0);
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
}

- (UIButton *)backButton {
    if (!_backButton) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton = backButton;
        backButton.layer.cornerRadius = 15.f;
        backButton.contentEdgeInsets = UIEdgeInsetsMake(9, 8, 9, 8);
        [backButton setImage:[UIImage imageNamed:@"z_back"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"z_back_night"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(navigateBackAction:) forControlEvents:UIControlEventTouchUpInside];
        backButton.translatesAutoresizingMaskIntoConstraints = NO;
        [backButton setContentCompressionResistancePriority:999 forAxis:UILayoutConstraintAxisHorizontal];
        [self addSubview:backButton];
    }
    return _backButton;
}

- (UIView *)bottomeLineView {
    if (_bottomeLineView == nil) {
        UIImageView *lineView = [UIImageView new];
        _bottomeLineView = lineView;
        lineView.opaque = YES;
        lineView.accessibilityIdentifier = NSStringFromSelector(_cmd);
        lineView.translatesAutoresizingMaskIntoConstraints = NO;
        lineView.image = BBMapDownloadNavLineImage();
        [self addSubview:lineView];
    }
    return _bottomeLineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [UILabel new];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:label];
        _titleLabel = label;
        [label setFont:BBMapDownloadFontWithSize(BBMapDownloadDefaultFontSize)];
    }
    return _titleLabel;
}

- (NSMutableArray *)subviewsConstraints {
    if (!_subviewsConstraints) {
        _subviewsConstraints = [NSMutableArray array];
    }
    return _subviewsConstraints;
}
@end
