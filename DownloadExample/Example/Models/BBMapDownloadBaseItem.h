//
//  BBMapDownloadBaseItem.h
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/5.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BaseCellModel.h"
#import "MapModel.h"

typedef NS_ENUM(NSInteger, BBSettingsCellDisclosureType) {
    BBSettingsCellDisclosureTypeNormal,
    BBSettingsCellDisclosureTypeSwitch,
};

@interface BBMapDownloadBaseItem : BaseCellModel

@property (nonatomic) Class cellClass;

@end

@interface BBMapDownloadHotCityTableViewCellModel : BBMapDownloadBaseItem

/// 每个button的高度
@property (nonatomic, assign) CGFloat buttonHeight;

@end

@interface BBMapContinentTableViewCellModel : BBMapDownloadBaseItem

@end

@interface BBMapDownloadTableViewCellModel : BBMapDownloadBaseItem

@end

@interface BBSettingsCellModel : BBMapDownloadBaseItem

@property (nonatomic, assign, readonly) BBSettingsCellDisclosureType disclosureType;

@property (nonatomic, copy, readonly) NSString *title;

@property (nonatomic, copy, readonly) NSString *iconName;

@property (nonatomic, copy, readonly) UIColor *iconColor;

@property (nonatomic, copy, readonly) NSString *disclosureText;

@property (nonatomic, assign, readwrite) BOOL isSwitchOn;

@property (nonatomic, assign) SEL actionSelector;
@property (nonatomic, weak) id actionTarget;

+ (instancetype)switchCellForSel:(SEL)sel
                          target:(id)target
                           title:(NSString *)title
                        iconName:(NSString *)iconName
                              on:(BOOL)isOn
                          height:(CGFloat)height;

+ (instancetype)normalCellForSel:(SEL)sel
                          target:(id)target
                           title:(NSString *)title
                        iconName:(NSString *)iconName
                          height:(CGFloat)height;

+ (instancetype)cellForSel:(SEL)sel
                    target:(id)target
                     title:(NSString *)title
            disclosureText:(NSString *)disclosureText
                  iconName:(NSString *)iconName
            disclosureType:(BBSettingsCellDisclosureType)disclosureType
                    height:(CGFloat)height;

@end
