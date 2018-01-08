//
//  BBMapDownloadTableViewCell.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/3.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBMapDownloadTableViewCell.h"
#import "BBMapDownloadConst.h"
#import "BBMapDownloadBaseItem.h"
#import "Download_level2_Model.h"
#import "DownloadNode.h"

@interface BBMapDownloadTableViewCell ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *navStateImageView;
@property (nonatomic, strong) UIImageView *tourStateImageView;
@property (nonatomic, strong) UILabel *navSizeLabel;
@property (nonatomic, strong) UILabel *tourSizeLabel;
@property (nonatomic, strong) UIView *bottomeLineView;
@property (nonatomic, strong) UILabel *totalStateLabel;

@property (nonatomic, strong) BBMapDownloadBaseItem *cellModel;
@property (nonatomic, strong) MapModel *mapModel;

@end

@implementation BBMapDownloadTableViewCell

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
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.navStateImageView];
    [self.contentView addSubview:self.tourStateImageView];
    [self.contentView addSubview:self.navSizeLabel];
    [self.contentView addSubview:self.tourSizeLabel];
    [self.contentView addSubview:self.bottomeLineView];
    [self.contentView addSubview:self.totalStateLabel];
    
    [self makeConstraint];
    
    [self test];
}

- (void)test {
    self.iconView.image = [UIImage imageNamed:@"country_1"];
    self.titleLabel.text = @"北京市(中国)";
    self.descLabel.text = @"上海、深圳、台湾、南京、安徽、郑州、苏州、杭州、北京、哈哈哈哈哈啊啊哈横说竖说收拾收拾";
    self.navStateImageView.image = [UIImage imageWithColor:[UIColor blueColor]];
    self.navSizeLabel.text = @"导航1111.0b";
    self.tourStateImageView.image = [UIImage imageWithColor:[UIColor grayColor]];
    self.tourSizeLabel.text = @"导航1111.0b";
    self.totalStateLabel.text = @"下载中19%";
}

- (void)setCellModel:(BBMapDownloadBaseItem *)cellModel {
    _cellModel = cellModel;
    
    if ([cellModel.model isKindOfClass:[MapModel class]]) {
        self.mapModel = cellModel.model;
    }
    else if ([cellModel.model isKindOfClass:[DownloadNode class]]) {
        DownloadNode *node = (DownloadNode *)cellModel.model;
        Download_level2_Model *m = node.nodeData;
        if ([m isKindOfClass:[Download_level2_Model class]]) {
            self.mapModel = m.model;
        }
    }
    
}

- (void)setMapModel:(MapModel *)mapModel {
    _mapModel = mapModel;
    if ([mapModel.countryName isEqualToString:mapModel.titleStr]) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@", mapModel.countryName];
    }
    else{
        self.titleLabel.text = [NSString stringWithFormat:@"%@(%@)", mapModel.titleStr, mapModel.countryName];
    }
    
    self.descLabel.text = _mapModel.cityDescriptionStr;
    self.iconView.image = [UIImage imageNamed:_mapModel.imageStr];

}

- (void)makeConstraint {
    
    [self.totalStateLabel setContentCompressionResistancePriority:998.0 forAxis:UILayoutConstraintAxisHorizontal];
    
    NSLayoutConstraint *iconWidth = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:35.0];
    NSLayoutConstraint *iconHeight = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:24.0];
     NSLayoutConstraint *iconCenterY = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    NSLayoutConstraint *iconLeft = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:BBMapDownloadViewGlobleMargin];
    [NSLayoutConstraint activateConstraints:@[iconWidth, iconHeight, iconLeft, iconCenterY]];
    
    NSLayoutConstraint *titleBottom = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.descLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:-5.0];
    NSLayoutConstraint *titleLeft = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.iconView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10.0];
    NSLayoutConstraint *titleRight = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.totalStateLabel attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-20.0];
    [NSLayoutConstraint activateConstraints:@[titleBottom, titleLeft, titleRight]];
    
    NSLayoutConstraint *descRight = [NSLayoutConstraint constraintWithItem:self.descLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.totalStateLabel attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-20.0];
    NSLayoutConstraint *desCenterY = [NSLayoutConstraint constraintWithItem:self.descLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    NSLayoutConstraint *descLeft = [NSLayoutConstraint constraintWithItem:self.descLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
    [NSLayoutConstraint activateConstraints:@[descRight, desCenterY, descLeft]];
    
    NSLayoutConstraint *navStateImageViewWidth = [NSLayoutConstraint constraintWithItem:self.navStateImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:5.0];
    NSLayoutConstraint *navStateImageViewHeight = [NSLayoutConstraint constraintWithItem:self.navStateImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.navStateImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    NSLayoutConstraint *navStateImageViewLeft = [NSLayoutConstraint constraintWithItem:self.navStateImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
    NSLayoutConstraint *navStateImageViewCenterY = [NSLayoutConstraint constraintWithItem:self.navStateImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.navSizeLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    [NSLayoutConstraint activateConstraints:@[navStateImageViewWidth, navStateImageViewHeight, navStateImageViewLeft, navStateImageViewCenterY]];
    
    NSLayoutConstraint *navSizeLeft = [NSLayoutConstraint constraintWithItem:self.navSizeLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.navStateImageView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:3.0];
    NSLayoutConstraint *navSizeTop = [NSLayoutConstraint constraintWithItem:self.navSizeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.descLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5.0];
    [NSLayoutConstraint activateConstraints:@[navSizeLeft, navSizeTop]];
    
    
    NSLayoutConstraint *tourStateImageViewWidth = [NSLayoutConstraint constraintWithItem:self.tourStateImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.navStateImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    NSLayoutConstraint *tourStateImageViewHeight = [NSLayoutConstraint constraintWithItem:self.tourStateImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.navStateImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *tourStateImageViewLeft = [NSLayoutConstraint constraintWithItem:self.tourStateImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.navSizeLabel attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:20.0];
    NSLayoutConstraint *tourStateImageViewCenterY = [NSLayoutConstraint constraintWithItem:self.tourStateImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.tourSizeLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    [NSLayoutConstraint activateConstraints:@[tourStateImageViewWidth, tourStateImageViewHeight, tourStateImageViewLeft, tourStateImageViewCenterY]];
    
    NSLayoutConstraint *tourSizeLeft = [NSLayoutConstraint constraintWithItem:self.tourSizeLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.tourStateImageView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:3.0];
    NSLayoutConstraint *tourSizeTop = [NSLayoutConstraint constraintWithItem:self.tourSizeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.descLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5.0];
    [NSLayoutConstraint activateConstraints:@[tourSizeLeft, tourSizeTop]];
    
    NSLayoutConstraint *totalStateRight = [NSLayoutConstraint constraintWithItem:self.totalStateLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-BBMapDownloadViewGlobleMargin];
    NSLayoutConstraint *totalStateCenterY = [NSLayoutConstraint constraintWithItem:self.totalStateLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    [NSLayoutConstraint activateConstraints:@[totalStateRight, totalStateCenterY]];
    
    NSMutableArray *bottomeLineViewConstrints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[bottomeLineView]|" options:kNilOptions metrics:nil views:@{@"bottomeLineView": self.bottomeLineView}].mutableCopy;
    [bottomeLineViewConstrints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomeLineView(==1)]|" options:kNilOptions metrics:nil views:@{@"bottomeLineView": self.bottomeLineView}]];
    [NSLayoutConstraint activateConstraints:bottomeLineViewConstrints];
    
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Lazy
////////////////////////////////////////////////////////////////////////

- (UIImageView *)iconView {
    if (!_iconView) {
        UIImageView *iconView = [UIImageView new];
        iconView.translatesAutoresizingMaskIntoConstraints = NO;
        _iconView = iconView;
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [UILabel new];
        _titleLabel = label;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.numberOfLines = 1;
        [label setFont:BBMapDownloadFontWithSize(BBMapDownloadDefaultFontSize)];
        [label setTextColor:BBMapDownloadDarkTextColor];
    }
    return _titleLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        UILabel *label = [UILabel new];
        _descLabel = label;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.numberOfLines = 1;
        [label setFont:BBMapDownloadFontWithSize(BBMapDownloadSmallFontSize)];
        [label setTextColor:BBMapDownloadLightTextColor];
    }
    return _descLabel;
}

- (UIImageView *)navStateImageView {
    if (!_navStateImageView) {
        UIImageView *iconView = [UIImageView new];
        
        iconView.translatesAutoresizingMaskIntoConstraints = NO;
        _navStateImageView = iconView;
    }
    return _navStateImageView;
}

- (UIImageView *)tourStateImageView {
    if (!_tourStateImageView) {
        UIImageView *iconView = [UIImageView new];
        iconView.translatesAutoresizingMaskIntoConstraints = NO;
        _tourStateImageView = iconView;
    }
    return _tourStateImageView;
}

- (UILabel *)navSizeLabel {
    if (!_navSizeLabel) {
        UILabel *label = [UILabel new];
        _navSizeLabel = label;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.numberOfLines = 1;
        [label setFont:BBMapDownloadFontWithSize(BBMapDownloadSmallFontSize)];
        [label setTextColor:BBMapDownloadLightTextColor];
    }
    return _navSizeLabel;
}

- (UILabel *)tourSizeLabel {
    if (!_tourSizeLabel) {
        UILabel *label = [UILabel new];
        _tourSizeLabel = label;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.numberOfLines = 1;
        [label setFont:BBMapDownloadFontWithSize(BBMapDownloadSmallFontSize)];
        [label setTextColor:BBMapDownloadLightTextColor];
    }
    return _tourSizeLabel;
}

- (UIView *)bottomeLineView {
    if (_bottomeLineView == nil) {
        UIImageView *lineView = [UIImageView new];
        _bottomeLineView = lineView;
        lineView.opaque = YES;
        lineView.accessibilityIdentifier = NSStringFromSelector(_cmd);
        lineView.translatesAutoresizingMaskIntoConstraints = NO;
        lineView.image = BBMapDownloadCellLineImage();
    }
    return _bottomeLineView;
}

- (UILabel *)totalStateLabel {
    if (!_totalStateLabel) {
        UILabel *label = [UILabel new];
        _totalStateLabel = label;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        [label setFont:BBMapDownloadFontWithSize(BBMapDownloadMiddleFontSize)];
    }
    return _totalStateLabel;
}

+ (NSString *)defaultIdentifier {
    return [NSStringFromClass([self class]) stringByAppendingString:NSStringFromSelector(_cmd)];
}

@end
