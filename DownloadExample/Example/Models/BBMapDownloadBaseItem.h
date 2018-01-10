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
@property (nonatomic, assign, readonly) SEL actionSelector;
@property (nonatomic, weak, readonly) id actionTarget;

- (instancetype)initWithHeight:(CGFloat)height target:(id)target action:(SEL)actionSelector;

@end

@interface BBMapDownloadHotCityTableViewCellModel : BBMapDownloadBaseItem

/// 每个button的高度
@property (nonatomic, assign) CGFloat itemHeight;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHeight:(CGFloat)height target:(id)target action:(SEL)actionSelector NS_UNAVAILABLE;
- (instancetype)initWithHeight:(CGFloat)height NS_UNAVAILABLE;
/// 指定初始化方法
/// @param itemTarget button 点击事件监听者
/// @param itemAction 点击button的响应方法，最多有两个参数，第一个参数为当前item的index，第二个参数为当前所在的Cell
/// @return 初始化对象 BBMapDownloadHotCityTableViewCellModel
- (instancetype)initWithItemTarget:(id)itemTarget itemAction:(SEL)itemAction NS_DESIGNATED_INITIALIZER;

@end

@interface BBMapDownloadNodeTableViewCellModel : BBMapDownloadBaseItem

@end

@interface BBMapDownloadTableViewCellModel : BBMapDownloadBaseItem

@end

@interface BBSettingsCellModel : BBMapDownloadBaseItem

@property (nonatomic, assign, readonly) BBSettingsCellDisclosureType disclosureType;

@property (nonatomic, copy, readonly) NSAttributedString *attributedTitle;

@property (nonatomic, copy, readonly) UIImage *icon;

@property (nonatomic, copy, readonly) NSAttributedString *disclosureAttributedText;

@property (nonatomic, assign, readwrite) BOOL isSwitchOn;


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
