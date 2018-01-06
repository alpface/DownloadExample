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

@interface BBMapDownloadSettingTableViewCell ()

@property (nonatomic, strong) BBSettingsCellModel *cellModel;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UISwitch *disclosureSwitch;
@property (nonatomic, weak) UIView *bottomeLineView;

@end

@implementation BBMapDownloadSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-BBMapDownloadViewGlobleMargin-[titleLabel]-(<=BBMapDownloadViewGlobleMargin)-[sw]-BBMapDownloadViewGlobleMargin-|" options:NSLayoutFormatAlignAllCenterY metrics:@{@"BBMapDownloadViewGlobleMargin": @(BBMapDownloadViewGlobleMargin)} views:@{@"titleLabel": self.titleLabel, @"sw": self.disclosureSwitch}]];
        [NSLayoutConstraint activateConstraints:@[[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]]];
        
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[bottomeLineView]|" options:kNilOptions metrics:nil views:@{@"bottomeLineView": self.bottomeLineView}]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomeLineView(==1)]|" options:kNilOptions metrics:nil views:@{@"bottomeLineView": self.bottomeLineView}]];
    }
    return self;
}

- (void)setCellModel:(BBSettingsCellModel *)cellModel {
    _cellModel = cellModel;
    
    self.titleLabel.text = cellModel.title;
    
    [self.disclosureSwitch removeTarget:cellModel.actionTarget action:cellModel.actionSelector forControlEvents:UIControlEventValueChanged];
    if (cellModel.disclosureType == BBSettingsCellDisclosureTypeSwitch) {
        [self.disclosureSwitch setOn:cellModel.isSwitchOn animated:YES];
        [self.disclosureSwitch addTarget:cellModel.actionTarget action:cellModel.actionSelector forControlEvents:UIControlEventValueChanged];
    }
    
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
        if (!self.cellModel.actionTarget || !self.cellModel.actionSelector) {
            return;
        }
        SEL selector = self.cellModel.actionSelector;
        NSString *selString = NSStringFromSelector(selector);
        NSInteger strCount = [selString length] - [[selString stringByReplacingOccurrencesOfString:@":" withString:@""] length];
        NSAssert(strCount <= 1, @"最多只能有一个参数");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[self.cellModel.actionTarget class] instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:self.cellModel.actionTarget];
        
        if (strCount > 0) {
            id target = self;
            [invocation setArgument:&target atIndex:2];
        }
        [invocation invoke];
    }
}


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

+ (NSString *)defaultIdentifier {
    return [NSStringFromClass([self class]) stringByAppendingString:NSStringFromSelector(_cmd)];
}

@end
