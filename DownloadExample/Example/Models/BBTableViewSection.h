//
//  BBTableViewSection.h
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/5.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBMapDownloadBaseItem.h"

@interface BBTableViewSection : NSObject

@property (nonatomic, copy) NSAttributedString *headerTitle;
@property (nonatomic, copy) NSAttributedString *footerTitle;
@property (nonatomic, strong) NSArray<BBMapDownloadBaseItem *> *items;

- (instancetype)initWithItems:(NSArray<BBMapDownloadBaseItem *> *)items
                  headerTitle:(NSAttributedString *)headerTitle
                  footerTitle:(NSAttributedString *)footerTitle;

@end
