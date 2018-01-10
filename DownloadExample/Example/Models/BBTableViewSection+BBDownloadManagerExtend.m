//
//  BBTableViewSection+BBDownloadManagerExtend.m
//  DownloadExample
//
//  Created by swae on 2018/1/10.
//  Copyright © 2018年 xiaoyuan. All rights reserved.
//

#import "BBTableViewSection+BBDownloadManagerExtend.h"
#import "NewDownloadModule.h"
#import "BBMapDownloadConst.h"
#import "MapDownloadConfiguration.h"

@implementation BBTableViewSection (BBDownloadManagerExtend)

/// 已下载
+ (BBTableViewSection *)createDownloadedSection {
  
    BBTableViewSection *section = [[BBTableViewSection alloc] initWithItems:nil headerTitle:[[NSAttributedString alloc] initWithString:@"已下载"] footerTitle:nil];
    section.identifier = NSStringFromSelector(_cmd);
    return section;
}

- (void)initDownloadedItemsWithTarget:(id)target selector:(SEL)selector {
    NSMutableArray *downloadedArray = [NewDownloadModule getInstance].downloadedArray;
#if DEBUG
    if (!downloadedArray.count) {
        downloadedArray = [[NewDownloadModule getInstance].allMapArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(6, 2)]].mutableCopy;
    }
#endif
    for (MapModel *city in downloadedArray) {
        BBMapDownloadTableViewCellModel *model = [[BBMapDownloadTableViewCellModel alloc] initWithHeight:BBMapDownloadDownloadCellHeight
                                                                                                  target:target
                                                                                        action:selector];
        model.cellClass = NSClassFromString(@"BBMapDownloadTableViewCell");
        model.model = city;
        [self.items addObject:model];
    }
}

/// 待更新
+ (BBTableViewSection *)createDownloadUpdateSection {
  
    BBTableViewSection *section = [[BBTableViewSection alloc] initWithItems:nil headerTitle:[[NSAttributedString alloc] initWithString:@"待更新"] footerTitle:nil];
    section.identifier = NSStringFromSelector(_cmd);
    return section;
}

- (void)initDownloadUpdateItemsWithTarget:(id)target selector:(SEL)selector {
    NSMutableArray *updateArray = [NewDownloadModule getInstance].needToUpdateMap;
#if DEBUG
    if (!updateArray.count) {
        updateArray = [[NewDownloadModule getInstance].allMapArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)]].mutableCopy;
    }
#endif
    for (MapModel *city in updateArray) {
        BBMapDownloadTableViewCellModel *model = [[BBMapDownloadTableViewCellModel alloc] initWithHeight:BBMapDownloadDownloadCellHeight
                                                                                                  target:target
                                                                                                  action:selector];
        model.cellClass = NSClassFromString(@"BBMapDownloadTableViewCell");
        model.model = city;
        [self.items addObject:model];
    }
}

/// 下载中的
+ (BBTableViewSection *)createDownloadingSection {
    BBTableViewSection *section = [[BBTableViewSection alloc] initWithItems:nil headerTitle:[[NSAttributedString alloc] initWithString:@"下载中"] footerTitle:nil];
  
    section.identifier = NSStringFromSelector(_cmd);
    return section;
}


- (void)initDownloadingItemsWithTarget:(id)target selector:(SEL)selector {
    NSMutableArray *downloadingArray = [NewDownloadModule getInstance].downloadingArray;
#if DEBUG
    if (!downloadingArray.count) {
        downloadingArray = [[NewDownloadModule getInstance].allMapArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, 1)]].mutableCopy;
    }
#endif
    for (MapModel *ctiy in downloadingArray) {
        BBMapDownloadTableViewCellModel *model = [[BBMapDownloadTableViewCellModel alloc] initWithHeight:BBMapDownloadDownloadCellHeight
                                                                                                  target:target
                                                                                                  action:selector];
        model.cellClass = NSClassFromString(@"BBMapDownloadTableViewCell");
        model.model = ctiy;
        [self.items addObject:model];
    }
    
#if DEBUG
    // 模拟10秒后下载完成
     /*
    __weak typeof(&*section) weakSection = section;
    __weak typeof(&*self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(&*weakSection) section = weakSection;
        __strong typeof(&*weakSelf) self = weakSelf;
        BBTableViewSection *downloadedSection = [self getSectionWithIdentifier:NSStringFromSelector(@selector(downloadedSection))];
        if (!downloadedSection) {
            downloadedSection = []
        }
        self moveCellModel:section.items.lastObject toSection:[<#(BBTableViewSection *)#>]
        
       
         NSArray *downloadedArray = [section.items objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, section.items.count -1)]];
         BBTableViewSection *downloadedSection = [self getSectionWithIdentifier:NSStringFromSelector(@selector(downloadedSection))];
         [self updateSectionOfTableViewSection:section];
         
         [self.tableView beginUpdates];
         NSInteger orginSection = [self.sectionItems indexOfObject:section];
         NSMutableArray *orginIndexPaths = @[].mutableCopy;
         NSMutableArray *newIndexPaths = @[].mutableCopy;
         NSInteger beginRow = downloadedSection.items.count;
         for (id item in downloadedArray) {
         NSInteger row = [section.items indexOfObject:item];
         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:orginSection];
         [orginIndexPaths addObject:indexPath];
         NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:beginRow inSection:downloadedSection.sectionOfTable];
         [newIndexPaths addObject:newIndexPath];
         beginRow++;
         }
         [self.tableView deleteRowsAtIndexPaths:orginIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
         [self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
         [section.items removeObjectsInArray:downloadedArray];
         [downloadedSection.items addObjectsFromArray:downloadedArray];
         [self.tableView endUpdates];
      
    });
       */
#endif
}

@end
