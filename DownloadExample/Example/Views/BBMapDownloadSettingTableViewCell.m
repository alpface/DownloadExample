//
//  BBMapDownloadSettingTableViewCell.m
//  Boobuz
//
//  Created by swae on 2018/1/5.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBMapDownloadSettingTableViewCell.h"
#import "BBMapDownloadBaseItem.h"
#import "BBMapDownloadConst.h"
#import "RuntimeInvoker.h"

@interface BBMapDownloadSettingTableViewCell ()

@property (nonatomic, strong) BBSettingsCellModel *cellModel;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UISwitch *disclosureSwitch;
@property (nonatomic, weak) UIView *bottomeLineView;
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UIImageView *nextPageView;
@property (nonatomic, weak) UILabel *disclosureTextLabel;
/// 水平约束的数组，方法更新
@property (nonatomic, strong) NSMutableArray *constraintsHArray;

@end

@implementation BBMapDownloadSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.disclosureTextLabel setContentCompressionResistancePriority:998.0 forAxis:UILayoutConstraintAxisHorizontal];
        
        NSMutableArray *constraintsArray = @[].mutableCopy;
        
        /// 水平约束
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(==BBMapDownloadViewGlobleMargin)-[iconView]-(==BBMapDownloadViewGlobleMargin)-[titleLabel]-(<=BBMapDownloadViewGlobleMargin)-[sw]-BBMapDownloadViewGlobleMargin-|" options:NSLayoutFormatAlignAllCenterY metrics:@{@"BBMapDownloadViewGlobleMargin": @(BBMapDownloadViewGlobleMargin)} views:@{@"titleLabel": self.titleLabel, @"sw": self.disclosureSwitch, @"iconView": self.iconView}]];
        
        [self.constraintsHArray addObjectsFromArray:constraintsArray];
        
        NSLayoutConstraint *iconHeight = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.6 constant:0.0];
        NSLayoutConstraint *iconWidth = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.iconView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
        [constraintsArray addObjectsFromArray:@[iconWidth, iconHeight]];
        
        NSLayoutConstraint *nextPageRight = [NSLayoutConstraint constraintWithItem:self.nextPageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-BBMapDownloadViewGlobleMargin];
        NSLayoutConstraint *nextPageCenterY = [NSLayoutConstraint constraintWithItem:self.nextPageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
        NSLayoutConstraint *nextPageWidth = [NSLayoutConstraint constraintWithItem:self.nextPageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:26.0];
        NSLayoutConstraint *nextPageHeight = [NSLayoutConstraint constraintWithItem:self.nextPageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.nextPageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
        [constraintsArray addObjectsFromArray:@[nextPageRight, nextPageCenterY, nextPageWidth, nextPageHeight]];
        
        NSLayoutConstraint *disclosureTextLabelRight = [NSLayoutConstraint constraintWithItem:self.disclosureTextLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-BBMapDownloadViewGlobleMargin];
        NSLayoutConstraint *disclosureTextLabelCenterY = [NSLayoutConstraint constraintWithItem:self.disclosureTextLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
        [constraintsArray addObjectsFromArray:@[disclosureTextLabelRight, disclosureTextLabelCenterY]];
        
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|[bottomeLineView]|" options:kNilOptions metrics:nil views:@{@"bottomeLineView": self.bottomeLineView}]];
        
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomeLineView(==1)]|" options:kNilOptions metrics:nil views:@{@"bottomeLineView": self.bottomeLineView}]];
        
        NSLayoutConstraint *titleLabelCenterY = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-0.5];
        [constraintsArray addObject:titleLabelCenterY];
        
        [NSLayoutConstraint activateConstraints:constraintsArray];
    }
    return self;
}


- (void)setCellModel:(BBSettingsCellModel *)cellModel {
    _cellModel = cellModel;
    
    self.titleLabel.attributedText = cellModel.attributedTitle;
    self.disclosureTextLabel.attributedText = cellModel.disclosureAttributedText;
    [self.disclosureSwitch setOn:cellModel.isSwitchOn animated:YES];
    self.iconView.image = cellModel.icon;
    
    [self updateConstraintsH];
}

- (void)disclosureSwitchValueChanged:(UISwitch *)sw {
    if (self.cellModel.disclosureType == BBSettingsCellDisclosureTypeSwitch) {
        self.cellModel.isSwitchOn = sw.isOn;
        if (!self.cellModel.actionTarget || !self.cellModel.actionSelector) {
            return;
        }
        [self.cellModel.actionTarget invoke:NSStringFromSelector(self.cellModel.actionSelector) args:sw, nil];
    }
}

/// 更新水平约束
- (void)updateConstraintsH {
    [NSLayoutConstraint deactivateConstraints:self.constraintsHArray];
    [self.constraintsHArray removeAllObjects];
    NSMutableString *visualFormat = @"".mutableCopy;
    self.iconView.hidden = YES;
    self.titleLabel.hidden = YES;
    self.disclosureSwitch.hidden = YES;
    self.nextPageView.hidden = YES;
    self.disclosureTextLabel.hidden = YES;
    if ([self shouldDisplayIconView]) {
        [visualFormat appendFormat:@"-(==BBMapDownloadViewGlobleMargin)-[iconView]"];
        self.iconView.hidden = NO;
    }
    if ([self shouldDisplayTitleLabel]) {
        [visualFormat appendFormat:@"-(==BBMapDownloadViewGlobleMargin)-[titleLabel]"];
        self.titleLabel.hidden = NO;
    }
    if ([self shouldDisplaySwitch]) {
        [visualFormat appendFormat:@"-(<=BBMapDownloadViewGlobleMargin)-[sw]"];
        self.disclosureSwitch.hidden = NO;
    }
    else if ([self shouldDisplayNextPage]) {
        [visualFormat appendFormat:@"-(<=BBMapDownloadViewGlobleMargin)-[nextPage]"];
        self.nextPageView.hidden = NO;
    }
    else if ([self shouldDisplayDisclosureText]) {
        [visualFormat appendFormat:@"-(<=BBMapDownloadViewGlobleMargin)-[disclosureText]"];
        self.disclosureTextLabel.hidden = NO;
    }
    [visualFormat appendFormat:@"-BBMapDownloadViewGlobleMargin-"];
    
    [self.constraintsHArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"|%@|", visualFormat] options:NSLayoutFormatAlignAllCenterY metrics:@{@"BBMapDownloadViewGlobleMargin": @(BBMapDownloadViewGlobleMargin)} views:@{@"titleLabel": self.titleLabel, @"sw": self.disclosureSwitch, @"iconView": self.iconView, @"disclosureText": self.disclosureTextLabel, @"nextPage": self.nextPageView}]];
    
    [NSLayoutConstraint activateConstraints:self.constraintsHArray];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Touchs
////////////////////////////////////////////////////////////////////////


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.nextResponder touchesEnded:touches withEvent:event];
    
    if (self.cellModel.disclosureType != BBSettingsCellDisclosureTypeSwitch) {
        [self.cellModel.actionTarget invoke:NSStringFromSelector(self.cellModel.actionSelector) args:self, nil];
    }
}


- (BOOL)shouldDisplayTitleLabel {
    return self.titleLabel.text || self.titleLabel.attributedText;
}

- (BOOL)shouldDisplayIconView {
    if (self.iconView.image) {
        return YES;
    }
    return NO;
}

- (BOOL)shouldDisplaySwitch {
    return self.cellModel.disclosureType == BBSettingsCellDisclosureTypeSwitch;
}

- (BOOL)shouldDisplayNextPage {
    return self.cellModel.disclosureType == BBSettingsCellDisclosureTypeNext;
}

- (BOOL)shouldDisplayDisclosureText {
    return self.cellModel.disclosureType == BBSettingsCellDisclosureTypeNormal &&
    (self.disclosureTextLabel.text || self.disclosureTextLabel.attributedText);
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Lazy
////////////////////////////////////////////////////////////////////////
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [UILabel new];
        _titleLabel = label;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.numberOfLines = 1;
        [label setFont:BBMapDownloadFontWithSize(BBMapDownloadDefaultFontSize)];
        [label setTextColor:BBMapDownloadDarkTextColor];
        [self.contentView addSubview:label];
    }
    return _titleLabel;
}

- (UISwitch *)disclosureSwitch {
    if (!_disclosureSwitch) {
        UISwitch *disclosureSwitch = [UISwitch new];
        _disclosureSwitch = disclosureSwitch;
        disclosureSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:disclosureSwitch];
        [disclosureSwitch addTarget:self action:@selector(disclosureSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _disclosureSwitch;
}
- (UIView *)bottomeLineView {
    if (_bottomeLineView == nil) {
        UIImageView *lineView = [UIImageView new];
        _bottomeLineView = lineView;
        lineView.opaque = YES;
        lineView.accessibilityIdentifier = NSStringFromSelector(_cmd);
        lineView.translatesAutoresizingMaskIntoConstraints = NO;
        lineView.image = BBMapDownloadCellLineImage();
        [self.contentView addSubview:lineView];
    }
    return _bottomeLineView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        UIImageView *iconView = [UIImageView new];
        iconView.translatesAutoresizingMaskIntoConstraints = NO;
        _iconView = iconView;
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}

- (UIImageView *)nextPageView {
    if (!_nextPageView) {
        UIImageView *nextPageView = [UIImageView new];
        _nextPageView = nextPageView;
        _nextPageView.accessibilityIdentifier = NSStringFromSelector(_cmd);
        _nextPageView.contentMode = UIViewContentModeScaleAspectFit;
        [_nextPageView setImage:[UIImage imageNamed:@"z_nextpage"]];
        _nextPageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_nextPageView];
        
    }
    return _nextPageView;
}

- (UILabel *)disclosureTextLabel {
    if (!_disclosureTextLabel) {
        UILabel *label = [UILabel new];
        _disclosureTextLabel = label;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        [label setFont:BBMapDownloadFontWithSize(BBMapDownloadMiddleFontSize)];
        [self.contentView addSubview:label];
    }
    return _disclosureTextLabel;
}

- (NSMutableArray *)constraintsHArray {
    if (!_constraintsHArray) {
        _constraintsHArray = @[].mutableCopy;
    }
    return _constraintsHArray;
}

+ (NSString *)defaultIdentifier {
    return [NSStringFromClass([self class]) stringByAppendingString:NSStringFromSelector(_cmd)];
}

@end
