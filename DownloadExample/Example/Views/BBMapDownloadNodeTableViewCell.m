//
//  BBMapDownloadNodeTableViewCell.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/3.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBMapDownloadNodeTableViewCell.h"
#import "BBMapDownloadConst.h"
#import "BBMapDownloadBaseItem.h"
#import "DownloadNode.h"
#import "Download_level0_Model.h"
#import "Download_level1_Model.h"

@interface BBMapDownloadNodeTableViewCell ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *nextPageView;
@property (nonatomic, weak) UIImageView *bottomeLineView;
@property (nonatomic, strong) BBMapDownloadBaseItem *cellModel;
@property (nonatomic, strong) DownloadNode *model;
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) NSLayoutConstraint *titleLabelLeftConstraint;

@end

@implementation BBMapDownloadNodeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupViews];
}

- (void)setupViews {
    
    NSLayoutConstraint *iconWidth = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:35.0];
    NSLayoutConstraint *iconHeight = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:24.0];
    NSLayoutConstraint *iconCenterY = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    NSLayoutConstraint *iconLeft = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:BBMapDownloadViewGlobleMargin];
    [NSLayoutConstraint activateConstraints:@[iconWidth, iconHeight, iconLeft, iconCenterY]];
    
    NSLayoutConstraint *continentLeft = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:BBMapDownloadViewGlobleMargin];
    _titleLabelLeftConstraint = continentLeft;
    NSLayoutConstraint *continentCenterY = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    [NSLayoutConstraint activateConstraints:@[continentLeft, continentCenterY]];
    
    
    NSLayoutConstraint *nextPageRight = [NSLayoutConstraint constraintWithItem:self.nextPageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-BBMapDownloadViewGlobleMargin];
    NSLayoutConstraint *nextPageCenterY = [NSLayoutConstraint constraintWithItem:self.nextPageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    NSLayoutConstraint *nextPageWidth = [NSLayoutConstraint constraintWithItem:self.nextPageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:26.0];
     NSLayoutConstraint *nextPageHeight = [NSLayoutConstraint constraintWithItem:self.nextPageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.nextPageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    [NSLayoutConstraint activateConstraints:@[nextPageRight, nextPageCenterY, nextPageWidth, nextPageHeight]];
    
    NSMutableArray *bottomeLineViewConstrints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[bottomeLineView]|" options:kNilOptions metrics:nil views:@{@"bottomeLineView": self.bottomeLineView}].mutableCopy;
    [bottomeLineViewConstrints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomeLineView(==1)]|" options:kNilOptions metrics:nil views:@{@"bottomeLineView": self.bottomeLineView}]];
    [NSLayoutConstraint activateConstraints:bottomeLineViewConstrints];
    
    
}

- (void)setCellModel:(BBMapDownloadBaseItem *)cellModel {
    _cellModel = cellModel;
    
    self.model = cellModel.model;
}

- (void)setModel:(DownloadNode *)model {
    _model = model;
    
    id nodeData = model.nodeData;
    if ([nodeData isKindOfClass:[Download_level0_Model class]]) {
        Download_level0_Model *m = (Download_level0_Model *)nodeData;
        self.titleLabel.text = m.continentName;
    }
    else if ([nodeData isKindOfClass:[Download_level1_Model class]]) {
        Download_level1_Model *m = (Download_level1_Model *)nodeData;
       self.titleLabel.text = m.countryName;
       self.iconView.image = [UIImage imageNamed:m.headImgPath];
    }
    
    [self updateTitleLabelConstraint];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateTitleLabelConstraint {
    _titleLabelLeftConstraint.active = NO;
    if (self.shouldDisplayIconView) {
        NSLayoutConstraint *titleLabelLeftConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.iconView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:BBMapDownloadViewGlobleMargin];
        _titleLabelLeftConstraint = titleLabelLeftConstraint;
        self.iconView.hidden = NO;
    }
    else {
        self.iconView.hidden = YES;
        NSLayoutConstraint *titleLabelLeftConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:BBMapDownloadViewGlobleMargin];
        _titleLabelLeftConstraint = titleLabelLeftConstraint;
    }
    _titleLabelLeftConstraint.active = YES;
}

- (BOOL)shouldDisplayIconView {
    return self.iconView.image != nil;
}


////////////////////////////////////////////////////////////////////////
#pragma mark - Lazy
////////////////////////////////////////////////////////////////////////

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [UILabel new];
        _titleLabel = titleLabel;
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [titleLabel setTextColor:BBMapDownloadDarkTextColor];
        [titleLabel setFont:BBMapDownloadFontWithSize(BBMapDownloadDefaultFontSize)];
        [self.contentView addSubview:titleLabel];
    }
    return _titleLabel;
}

- (UIImageView *)nextPageView {
    if (!_nextPageView) {
        UIImageView *nextPageView = [UIImageView new];
        _nextPageView = nextPageView;
        _nextPageView.accessibilityIdentifier = NSStringFromSelector(_cmd);
        _nextPageView.contentMode = UIViewContentModeScaleAspectFit;
        [_nextPageView setImage:[UIImage imageNamed:@"z_nextpage"]];
        _nextPageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:nextPageView];
    }
    return _nextPageView;
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
        [self.contentView addSubview:iconView];
    }
    return _iconView;
}


@end
