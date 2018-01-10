//
//  BBTableViewSection+BBDownloadManagerExtend.h
//  DownloadExample
//
//  Created by swae on 2018/1/10.
//  Copyright © 2018年 xiaoyuan. All rights reserved.
//

#import "BBTableViewSection.h"

@interface BBTableViewSection (BBDownloadManagerExtend)

/// 已下载
+ (BBTableViewSection *)createDownloadedSection;
/// 下载中的
+ (BBTableViewSection *)createDownloadingSection;
/// 待更新
+ (BBTableViewSection *)createDownloadUpdateSection;
- (void)initDownloadedItemsWithTarget:(id)target selector:(SEL)selector;
- (void)initDownloadingItemsWithTarget:(id)target selector:(SEL)selector;
- (void)initDownloadUpdateItemsWithTarget:(id)target selector:(SEL)selector;



@end
