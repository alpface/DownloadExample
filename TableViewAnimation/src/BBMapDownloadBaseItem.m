//
//  BBMapDownloadBaseItem.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/5.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBMapDownloadBaseItem.h"

@interface BBMapDownloadBaseItem ()

@property (nonatomic, assign, readwrite) SEL actionSelector;
@property (nonatomic, weak, readwrite) id actionTarget;

@end

@implementation BBMapDownloadBaseItem

- (instancetype)initWithHeight:(CGFloat)height target:(id)target action:(SEL)actionSelector {
    if (self = [super initWithHeight:height]) {
        self.actionTarget = target;
        self.actionSelector = actionSelector;
    }
    return self;
}

- (void)setCellClass:(Class)cellClass {
    NSAssert(cellClass != NULL && [cellClass isSubclassOfClass:[UITableViewCell class]], @"cellClass 必须是UITableViewCell或其子类class");
    _cellClass = cellClass;
}

@end

@implementation BBMapDownloadHotCityTableViewCellModel

- (instancetype)init {
    NSAssert(NO, nil);
    @throw nil;
}

- (instancetype)initWithHeight:(CGFloat)height target:(id)target action:(SEL)actionSelector {
    NSAssert(NO, nil);
    @throw nil;
}


- (instancetype)initWithItemTarget:(id)itemTarget itemAction:(SEL)itemAction {
    return [super initWithHeight:0 target:itemTarget action:itemAction];
}

@end

@implementation BBMapDownloadNodeTableViewCellModel

@end

@implementation BBMapDownloadTableViewCellModel {
    BBMapDownloadTableViewCellArrtibuted *_attributed;
    SEL _longPressGestureActionSel;
}

@synthesize longPressGestureActionSel = _longPressGestureActionSel;

- (instancetype)initWithHeight:(CGFloat)height
                        target:(id)target
                        action:(SEL)actionSelector
              longPressGesture:(SEL)longPressGestureActionSel
                     cellClass:(__unsafe_unretained Class)cellClass
                         model:(id)model {
    if (self = [super initWithHeight:height target:target action:actionSelector]) {
        self.cellClass = cellClass;
        _longPressGestureActionSel = longPressGestureActionSel;
        self.model = model;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (object != nil && [object isMemberOfClass:BBMapDownloadTableViewCellModel.class]) {
        BBMapDownloadTableViewCellModel *target = (BBMapDownloadTableViewCellModel *)object;
        return [target.model isEqualToModel:self.model];
    }
    return NO;
}


+ (NSString *)mapSizeToString:(NSNumber *)sizeNum {
    double mapSize = sizeNum.doubleValue;
    NSString *mapSizeStr = nil;
    double gsize = mapSize / 1024;
    if (gsize >= 1.0) {
        mapSizeStr = [NSString stringWithFormat:@"%.fG", gsize];
    }
    else {
        mapSizeStr = [NSString stringWithFormat:@"%.fM", mapSize];
    }
    return mapSizeStr;
}
@end

@implementation BBMapDownloadTableViewCellArrtibuted

@end

@interface BBSettingsCellModel ()

@property (nonatomic, copy, readwrite) NSAttributedString *attributedTitle;

@property (nonatomic, copy, readwrite) UIImage *icon;

@property (nonatomic, assign, readwrite) BBSettingsCellDisclosureType disclosureType;

@property (nonatomic, copy, readwrite) NSAttributedString *disclosureAttributedText;

@end

@implementation BBSettingsCellModel

+ (instancetype)switchCellForSel:(SEL)sel
                          target:(id)target
                 attributedTitle:(NSAttributedString *)attributedTitle
                            icon:(UIImage *)icon
                              on:(BOOL)isOn
                          height:(CGFloat)height {
    BBSettingsCellModel *item = [[self alloc] initWithTitle:attributedTitle
                                                       icon:icon
                                             disclosureType:BBSettingsCellDisclosureTypeSwitch
                                             disclosureText:nil
                                                 isSwitchOn:isOn
                                                     height:height
                                                     target:target
                                                     action:sel];

    item.actionSelector = sel;
    item.actionTarget = target;
    
    return item;
    
}

+ (instancetype)normalCellForSel:(SEL)sel
                          target:(id)target
                 attributedTitle:(NSAttributedString *)attributedTitle
        disclosureAttributedText:(NSAttributedString *)disclosureAttributedText
                            icon:(UIImage *)icon
                          height:(CGFloat)height  {
    BBSettingsCellModel *item = [[self alloc] initWithTitle:attributedTitle
                                                  icon:icon
                                            disclosureType:BBSettingsCellDisclosureTypeNormal
                                            disclosureText:nil
                                                isSwitchOn:NO
                                                     height:height
                                                     target:target
                                                     action:sel];
    
    return item;
}

+ (instancetype)cellForSel:(SEL)sel
                    target:(id)target
           attributedTitle:(NSAttributedString *)attributedTitle
  disclosureAttributedText:(NSAttributedString *)disclosureAttributedText
                      icon:(UIImage *)icon
            disclosureType:(BBSettingsCellDisclosureType)disclosureType
                    height:(CGFloat)height {
    BBSettingsCellModel *item = [[self alloc] initWithTitle:attributedTitle
                                                       icon:icon
                                             disclosureType:disclosureType
                                             disclosureText:disclosureAttributedText
                                                 isSwitchOn:NO
                                                     height:height
                                                     target:target
                                                     action:sel];
    return item;
}

- (instancetype)initWithTitle:(NSAttributedString *)attributedTitle
                         icon:(UIImage *)icon
               disclosureType:(BBSettingsCellDisclosureType)disclosureType
               disclosureText:(NSAttributedString *)disclosureText
                   isSwitchOn:(BOOL)isSwitchOn
                       height:(CGFloat)height
                       target:(id)target
                       action:(SEL)actionSelector {
    self = [super initWithHeight:height target:target action:actionSelector];
    if (self) {
        self.cellClass = NSClassFromString(@"BBMapDownloadSettingTableViewCell");
        self.disclosureType = disclosureType;
        self.attributedTitle = attributedTitle;
        self.icon = icon;
        self.disclosureType = disclosureType;
        self.disclosureAttributedText = disclosureText;
        self.isSwitchOn = isSwitchOn;
        
    }
    return self;
}
@end



