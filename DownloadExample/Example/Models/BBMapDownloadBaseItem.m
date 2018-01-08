//
//  BBMapDownloadBaseItem.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/5.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBMapDownloadBaseItem.h"

@implementation BBMapDownloadBaseItem

- (void)setCellClass:(Class)cellClass {
    NSAssert(cellClass != NULL && [cellClass.superclass isEqual:[UITableViewCell class]], @"cellClass 必须是UITableViewCell或其子类class");
    _cellClass = cellClass;
}

@end

@implementation BBMapDownloadHotCityTableViewCellModel

@end

@implementation BBMapDownloadNodeTableViewCellModel

@end

@implementation BBMapDownloadTableViewCellModel

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
                                                     height:height];

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
                                                     height:height];
    item.actionSelector = sel;
    item.actionTarget = target;
    
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
                                                     height:height];
    item.actionSelector = sel;
    item.actionTarget = target;
    
    return item;
}

- (instancetype)initWithTitle:(NSAttributedString *)attributedTitle
                         icon:(UIImage *)icon
               disclosureType:(BBSettingsCellDisclosureType)disclosureType
               disclosureText:(NSAttributedString *)disclosureText
                   isSwitchOn:(BOOL)isSwitchOn
                       height:(CGFloat)height {
    self = [super initWithHeight:height];
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



