//
//  BBMapDownloadHotCityTableViewCell.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/5.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBMapDownloadHotCityTableViewCell.h"
#import "BBMapDownloadConst.h"
#import "BBMapDownloadBaseItem.h"
#import "MapModel.h"
#import "RuntimeInvoker.h"

@interface BBMapDownloadHotCityTableViewCell ()

@property (nonatomic, strong) NSMutableArray<UIButton *> *cityButtonList;
@property (nonatomic, strong) NSArray<MapModel *> *hotCityList;
@property (nonatomic, strong) BBMapDownloadBaseItem *cellModel;

@end

@implementation BBMapDownloadHotCityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 初始化时预备10个子控件做为循环使用的，为了优化，
        // 如果多了就添加，少了就移除
        for (NSInteger i = 0; i < 10; i++) {
            UIButton *button = [self createCityButton];
            [self.cityButtonList addObject:button];
            [self.contentView addSubview:button];
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
    return self;
}


- (void)setCellModel:(BBMapDownloadBaseItem *)cellModel {
    _cellModel = cellModel;
    
    self.hotCityList = cellModel.model;
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    // 获取contentView的size
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.cellModel.height = size.height;
}

- (void)setHotCityList:(NSArray<MapModel *> *)hotCityList {
    
    if ([hotCityList isEqualToArray:_hotCityList]) {
        return;
    }
    
    _hotCityList = hotCityList;
    
    NSInteger totalCount = hotCityList.count;
    // 计算已有的子控件数量与需要展示的个数的差值
    NSInteger differencesCount = differencesCount = totalCount - self.cityButtonList.count;
    if (differencesCount == 0) {
        // 没有差值，不需要创建新的，也不需要移除多余的
    }
    else if (differencesCount < 0) {
        // 多余的需要移除
        //        differencesCount = labs(differencesCount);
        while (differencesCount < 0) {
            UIButton *button = self.cityButtonList.lastObject;
            [button removeFromSuperview];
            [self.cityButtonList removeObject:button];
            differencesCount++;
        }
    }
    else if (differencesCount > 0) {
        // 缺少控件，就创建
        while (differencesCount > 0) {
            UIButton *button = [self createCityButton];
            [self.cityButtonList addObject:button];
            [self.contentView addSubview:button];
            differencesCount--;
        }
    }
    
    NSParameterAssert(self.cityButtonList.count == totalCount);
    //////////////////
    
    // 给控件设置值
    for (NSInteger i = 0; i < totalCount; ++i) {
        UIButton *button = self.cityButtonList[i];
        button.tag = i;
        MapModel *city = hotCityList[i];
        [button setTitle:city.titleStr forState:UIControlStateNormal];
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)buttonClick:(UIButton *)sender {

    [self.cellModel.actionTarget invoke:NSStringFromSelector(self.cellModel.actionSelector) args:@(sender.tag), self, nil];
}


/// 此约束会根据子控件的高度，固定父控件的高度
- (void)updateConstraints {
    [super updateConstraints];
    NSInteger columnCount = 4;
    //NSInteger rowCount = ceil(self.cityButtonList.count/(CGFloat)columnCount);
    // 将cityButtonList中的所有按钮，按组拆分(按rowCount一组进行分组,目的是为了使用AutoLayout布局)
    NSMutableArray *sectionArray = @[].mutableCopy;
    for (NSInteger i = 0; i < self.cityButtonList.count; i++) {
        NSInteger rowIndex = i / columnCount;
        NSMutableArray *rowArray = nil;
        if (rowIndex >= sectionArray.count) {
            rowArray = [NSMutableArray array];
            [sectionArray addObject:rowArray];
        }
        else {
            rowArray = [sectionArray objectAtIndex:rowIndex];
        }
        UIButton *btn = self.cityButtonList[i];
        [rowArray addObject:btn];
    }
    
    CGFloat hPadding = BBMapDownloadViewGlobleMargin;
    CGFloat vPadiing = hPadding*0.5;
    NSMutableArray *constraints = @[].mutableCopy;
    NSMutableDictionary *metrics = @{@"hPadding": @(hPadding), @"vPadiing": @(vPadiing)}.mutableCopy;
    
    for (NSInteger i = 0; i < sectionArray.count; i++) {
        NSArray *rowArray = sectionArray[i];
        NSMutableString *hFormat = @"".mutableCopy;
        NSDictionary *hSubviewsDict = @{}.mutableCopy;
        UIButton *previousBtn = nil;
        NSString *previousBtnKey = nil;
        for (NSInteger j = 0; j < rowArray.count; j++) {
            UIButton *btn = rowArray[j];
            [btn removeConstraintsOfViewFromView:self.contentView];
            NSString *buttonKey = [NSString stringWithFormat:@"button_%ld", j];
            [hSubviewsDict setValue:btn forKey:buttonKey];
            
            // 子控件之间的列约束
            [hFormat appendFormat:@"-(==hPadding)-[%@%@]", buttonKey, previousBtn?[NSString stringWithFormat:@"(%@)", previousBtnKey]:@""];
            if (j == rowArray.count - 1) {
                // 拼接最后一列的右侧间距
                [hFormat appendFormat:@"-(==hPadding)-"];
            }
            
            // 子控件之间的行约束
            // 取出当前btn顶部依赖的控件，如果没有依赖则为父控件
            NSMutableString *vFormat = @"".mutableCopy;
            NSMutableDictionary *vSubviewsDict = @{}.mutableCopy;
            // 上一行的index
            NSInteger previousRowIndex = i - 1;
            // 取出当前按钮上面的按钮
            UIButton *dependentTopBtn = nil;
            if (previousRowIndex < sectionArray.count) {
                // 取出上一行的所有按钮
                NSArray *previousRowArray = [sectionArray objectAtIndex:previousRowIndex];
                dependentTopBtn = previousRowArray[j];
            }
            
            
            [vSubviewsDict addEntriesFromDictionary:hSubviewsDict];
            if (dependentTopBtn) {
                // 如果上面有按钮就添加和他底部之间的约束
                NSString *dependentButtonKey = [NSString stringWithFormat:@"dependent_button_%ld", previousRowIndex];
                [vSubviewsDict setValue:dependentTopBtn forKey:dependentButtonKey];
                // 拼接与顶部按钮底部的vfl
                [vFormat appendFormat:@"[%@]-(==vPadiing)-[%@%@]", dependentButtonKey, buttonKey, previousBtn?[NSString stringWithFormat:@"(%@)", previousBtnKey]:@""];
                
                // 控制每行高度相同的
                [constraints addObject:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:dependentTopBtn attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
            }
            else {
                // 顶部没有按钮
                [vFormat appendFormat:@"|-(==vPadiing)-[%@%@]", buttonKey, previousBtn?[NSString stringWithFormat:@"(%@)", previousBtnKey]:@""];
            }
            
            if (i == sectionArray.count - 1) {
                // 最后一行, 拼接底部
                [vFormat appendFormat:@"-(==vPadiing)-|"];
            }
            
            if (vFormat.length) {
                [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:%@", vFormat] options:kNilOptions metrics:metrics views:vSubviewsDict]];
            }
            
            // 如果设置了高度，则高度不再自适应
            BBMapDownloadHotCityTableViewCellModel *cm = (BBMapDownloadHotCityTableViewCellModel *)self.cellModel;
            if (cm.itemHeight > 0) {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:cm.itemHeight]];
            }
            
            previousBtn = btn;
            previousBtnKey = buttonKey;
        }
        if (hFormat.length) {
            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"|%@|", hFormat] options:kNilOptions metrics:metrics views:hSubviewsDict]];
        }
        
    }
    
    [NSLayoutConstraint activateConstraints:constraints];
    
    
}

- (UIButton *)createCityButton {
    UIButton *btn = [UIButton new];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn setTitle:@"北京" forState:UIControlStateNormal];
    [btn setTitleColor:BBMapDownloadDarkTextColor forState:UIControlStateNormal];
    btn.layer.cornerRadius = 3.0;
    btn.layer.borderColor = BBMapDownloadDownloadSectionBackgroundColor.CGColor;
    btn.titleLabel.font = BBMapDownloadFontWithSize(BBMapDownloadDefaultFontSize);
    btn.layer.borderWidth = 1.0;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (NSMutableArray *)cityButtonList {
    if (!_cityButtonList) {
        _cityButtonList = [NSMutableArray array];
    }
    return _cityButtonList;
}

+ (NSString *)defaultIdentifier {
    return [NSStringFromClass([self class]) stringByAppendingString:NSStringFromSelector(_cmd)];
}
@end

