//
//  BBMapDownloadBaseItem.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/5.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBMapDownloadBaseItem.h"
#import "BBMapDownloadConst.h"

@implementation BBMapDownloadBaseItem

- (void)setCellClass:(Class)cellClass {
    NSAssert(cellClass != NULL && [cellClass.superclass isEqual:[UITableViewCell class]], @"cellClass 必须是UITableViewCell或其子类class");
    _cellClass = cellClass;
}

@end

@implementation BBMapDownloadHotCityTableViewCellModel

@end

@implementation BBMapContinentTableViewCellModel

@end

@implementation BBMapDownloadTableViewCellModel

@end

@interface BBSettingsCellModel ()

@property (nonatomic, copy, readwrite) NSString *title;

@property (nonatomic, copy, readwrite) NSString *iconName;

@property (nonatomic, copy, readwrite) UIColor *iconColor;

@property (nonatomic, assign, readwrite) BBSettingsCellDisclosureType disclosureType;

@property (nonatomic, copy, readwrite) NSString *disclosureText;

@end

@implementation BBSettingsCellModel

+ (instancetype)switchCellForSel:(SEL)sel
                          target:(id)target
                           title:(NSString *)title
                        iconName:(NSString *)iconName
                              on:(BOOL)isOn
                          height:(CGFloat)height {
    BBSettingsCellModel *item = [[self alloc] initWithTitle:title
                                                  iconName:iconName
                                                 iconColor:UIColorFromRGB(0xFF1B33)
                                            disclosureType:BBSettingsCellDisclosureTypeSwitch
                                            disclosureText:nil
                                                isSwitchOn:isOn height:height];
    item.actionSelector = sel;
    item.actionTarget = target;
    
    return item;
    
}

+ (instancetype)normalCellForSel:(SEL)sel
                          target:(id)target
                           title:(NSString *)title
                        iconName:(NSString *)iconName
                          height:(CGFloat)height  {
    BBSettingsCellModel *item = [[self alloc] initWithTitle:title
                                                  iconName:iconName
                                                 iconColor:UIColorFromRGB(0xFF1B33)
                                            disclosureType:BBSettingsCellDisclosureTypeNormal
                                            disclosureText:nil
                                                isSwitchOn:NO height:height];
    item.actionSelector = sel;
    item.actionTarget = target;
    
    return item;
}

+ (instancetype)cellForSel:(SEL)sel
                    target:(id)target
                     title:(NSString *)title
            disclosureText:(NSString *)disclosureText
                  iconName:(NSString *)iconName
            disclosureType:(BBSettingsCellDisclosureType)disclosureType
                    height:(CGFloat)height {
    BBSettingsCellModel *item = [[self alloc] initWithTitle:title
                                                  iconName:iconName
                                                 iconColor:UIColorFromRGB(0xFF1B33)
                                            disclosureType:disclosureType
                                            disclosureText:disclosureText
                                                isSwitchOn:NO height:height];
    item.actionSelector = sel;
    item.actionTarget = target;
    
    return item;
}

- (instancetype)initWithTitle:(NSString *)title
                     iconName:(NSString *)iconName
                    iconColor:(UIColor *)iconColor
               disclosureType:(BBSettingsCellDisclosureType)disclosureType
               disclosureText:(NSString *)disclosureText
                   isSwitchOn:(BOOL)isSwitchOn
                       height:(CGFloat)height {
    self = [super initWithHeight:height];
    if (self) {
        self.disclosureType = disclosureType;
        self.title = title;
        self.iconName = iconName;
        self.iconColor = iconColor;
        self.disclosureType = disclosureType;
        self.disclosureText = disclosureText;
        self.isSwitchOn = isSwitchOn;
        
    }
    return self;
}
@end



