//
//  BBTableViewSection.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/5.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBTableViewSection.h"

@interface BBTableViewSection ()

@property (nonatomic, strong, readwrite) NSMutableArray<id<CellModelProtocol>> *items;

@end

@implementation BBTableViewSection

- (instancetype)initWithItems:(NSMutableArray<id<CellModelProtocol>> *)items
                  headerTitle:(NSAttributedString *)headerTitle
                  footerTitle:(NSAttributedString *)footerTitle {
    if (self = [super init]) {
        if (!items.count) {
            return nil;
        }
        self.items = items;
        self.headerTitle = headerTitle;
        self.footerTitle = footerTitle;
    }
    return self;
}

@end

