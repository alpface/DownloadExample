//
//  BBTableViewSection.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/5.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBTableViewSection.h"

@implementation BBTableViewSection

- (instancetype)initWithItems:(NSArray<BBMapDownloadBaseItem *> *)items
                  headerTitle:(NSAttributedString *)headerTitle
                  footerTitle:(NSAttributedString *)footerTitle {
    if (self = [super init]) {
        if (!items.count) {
            return nil;
        }
        self.items = items.copy;
        self.headerTitle = headerTitle;
        self.footerTitle = footerTitle;
    }
    return self;
}


@end
