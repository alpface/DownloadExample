//
//  BBMapContinentTableViewCell.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/3.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBMapContinentTableViewCell.h"
#import "BBMapDownloadConst.h"
#import "BBMapDownloadBaseItem.h"

@interface BBMapContinentTableViewCell ()

@property (nonatomic, strong) UILabel *continentNameLabel;
@property (nonatomic, strong) UIImageView *nextPageView;
@property (nonatomic, strong) UIImageView *bottomeLineView;
@property (nonatomic, strong) BBMapDownloadBaseItem *cellModel;

@end

@implementation BBMapContinentTableViewCell

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
    [self.contentView addSubview:self.continentNameLabel];
    NSLayoutConstraint *continentLeft = [NSLayoutConstraint constraintWithItem:self.continentNameLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:BBMapDownloadViewGlobleMargin];
    NSLayoutConstraint *continentCenterY = [NSLayoutConstraint constraintWithItem:self.continentNameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    [NSLayoutConstraint activateConstraints:@[continentLeft, continentCenterY]];
    
    [self.contentView addSubview:self.nextPageView];
    NSLayoutConstraint *nextPageRight = [NSLayoutConstraint constraintWithItem:self.nextPageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-BBMapDownloadViewGlobleMargin];
    NSLayoutConstraint *nextPageCenterY = [NSLayoutConstraint constraintWithItem:self.nextPageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    NSLayoutConstraint *nextPageWidth = [NSLayoutConstraint constraintWithItem:self.nextPageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:26.0];
     NSLayoutConstraint *nextPageHeight = [NSLayoutConstraint constraintWithItem:self.nextPageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.nextPageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    [NSLayoutConstraint activateConstraints:@[nextPageRight, nextPageCenterY, nextPageWidth, nextPageHeight]];
    
    [self.contentView addSubview:self.bottomeLineView];
    NSMutableArray *bottomeLineViewConstrints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[bottomeLineView]|" options:kNilOptions metrics:nil views:@{@"bottomeLineView": self.bottomeLineView}].mutableCopy;
    [bottomeLineViewConstrints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomeLineView(==1)]|" options:kNilOptions metrics:nil views:@{@"bottomeLineView": self.bottomeLineView}]];
    [NSLayoutConstraint activateConstraints:bottomeLineViewConstrints];
    
    
}

- (void)setCellModel:(BBMapDownloadBaseItem *)cellModel {
    _cellModel = cellModel;
    
    self.continentNameLabel.text = cellModel.model;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


////////////////////////////////////////////////////////////////////////
#pragma mark - Lazy
////////////////////////////////////////////////////////////////////////

- (UILabel *)continentNameLabel {
    if (!_continentNameLabel) {
        UILabel *continentNameLabel = [UILabel new];
        _continentNameLabel = continentNameLabel;
        continentNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [continentNameLabel setTextColor:BBMapDownloadDarkTextColor];
        [continentNameLabel setFont:BBMapDownloadFontWithSize(BBMapDownloadDefaultFontSize)];
    }
    return _continentNameLabel;
}

- (UIImageView *)nextPageView {
    if (!_nextPageView) {
        _nextPageView = [UIImageView new];
        _nextPageView.accessibilityIdentifier = NSStringFromSelector(_cmd);
        _nextPageView.contentMode = UIViewContentModeScaleAspectFit;
        [_nextPageView setImage:[UIImage imageNamed:@"z_nextpage"]];
        _nextPageView.translatesAutoresizingMaskIntoConstraints = NO;
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
    }
    return _bottomeLineView;
}

+ (NSString *)defaultIdentifier {
    return [NSStringFromClass([self class]) stringByAppendingString:NSStringFromSelector(_cmd)];
}

@end
