//
//  BBMapDownloadBaseItem.h
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/5.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BaseCellModel.h"

typedef NS_ENUM(NSInteger, BBSettingsCellDisclosureType) {
    BBSettingsCellDisclosureTypeNormal,
    BBSettingsCellDisclosureTypeSwitch,
    BBSettingsCellDisclosureTypeNext,
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

@property (nonatomic, copy, readonly) NSAttributedString *attributedTitle;

@property (nonatomic, copy, readonly) UIImage *icon;

@property (nonatomic, copy, readonly) NSAttributedString *disclosureAttributedText;

@property (nonatomic, assign, readwrite) BOOL isSwitchOn;

@property (nonatomic, assign) SEL actionSelector;
@property (nonatomic, weak) id actionTarget;

+ (instancetype)switchCellForSel:(SEL)sel
                          target:(id)target
                 attributedTitle:(NSAttributedString *)attributedTitle
                            icon:(UIImage *)icon
                              on:(BOOL)isOn
                          height:(CGFloat)height;

+ (instancetype)normalCellForSel:(SEL)sel
                          target:(id)target
                 attributedTitle:(NSAttributedString *)attributedTitle
        disclosureAttributedText:(NSAttributedString *)disclosureAttributedText
                            icon:(UIImage *)icon
                          height:(CGFloat)height;

+ (instancetype)cellForSel:(SEL)sel
                    target:(id)target
           attributedTitle:(NSAttributedString *)attributedTitle
  disclosureAttributedText:(NSAttributedString *)disclosureAttributedText
                      icon:(UIImage *)icon
            disclosureType:(BBSettingsCellDisclosureType)disclosureType
                    height:(CGFloat)height;

@end
