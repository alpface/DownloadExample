//
//  BBTableViewModel.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/19.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBTableViewModel.h"
#import "BBMapDownloadSectionHeaderView.h"
#import "BBBaseTableViewCell.h"
#import "BBMapDownloadConst.h"


@implementation BBTableViewModel {
    __weak id<BBTableViewModelDelegate> _delegate;
}

@synthesize delegate = _delegate;

- (void)setDelegate:(id<BBTableViewModelDelegate>)delegate {
    _delegate = delegate;
}

- (id<BBTableViewModelDelegate>)delegate {
    return _delegate;
}

- (void)prepareTableView:(UITableView *)tableView {
    [super prepareTableView:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[BBMapDownloadSectionHeaderView class] forHeaderFooterViewReuseIdentifier:BBMapDownloadSectionHeaderViewDefaultIdentifier];
}


////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource
////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *items = self.sectionItems[section].items;
    return items.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBMapDownloadBaseItem *item = self.sectionItems[indexPath.section].items[indexPath.row];
    return item.height;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    BBTableViewSection *sec = self.sectionItems[indexPath.section];
//    BaseCellModel *cellModel = sec.items[indexPath.row];
//    return cellModel.estimatedHeight;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self _tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    BOOL shouldDisplay = [self _tableView:tableView shouldDisplayHeaderInSection:section];
    if (shouldDisplay) {
        BBMapDownloadSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BBMapDownloadSectionHeaderViewDefaultIdentifier];
        headerView.attributedText = [self _tableView:tableView titleForHeaderInSection:section];
        return headerView;
    }
    else {
        return nil;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    BOOL shouldDisplay = [self _tableView:tableView shouldDisplayFooterInSection:section];
    if (shouldDisplay) {
        BBMapDownloadSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BBMapDownloadSectionHeaderViewDefaultIdentifier];
        headerView.attributedText = [self _tableView:tableView titleForHeaderInSection:section];
        return headerView;
    }
    else {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    BOOL shouldDisplay = [self _tableView:tableView shouldDisplayHeaderInSection:section];
    if (shouldDisplay) {
        return BBMapDownloadDownloadSectionHeaderHeight;
    }
    else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    BOOL shouldDisplay = [self _tableView:tableView shouldDisplayFooterInSection:section];
    if (shouldDisplay) {
        return BBMapDownloadDownloadSectionHeaderHeight;
    }
    else {
        return 0.01;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Private methods
////////////////////////////////////////////////////////////////////////

- (UITableViewCell *)_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BBTableViewSection *section = self.sectionItems[indexPath.section];
    section.sectionOfTable = indexPath.section;
    BBMapDownloadBaseItem *item = self.sectionItems[indexPath.section].items[indexPath.row];
    id<BBBaseTableViewCell> cell = [tableView dequeueReusableCellWithIdentifier:[item.cellClass defaultIdentifier] forIndexPath:indexPath];
    
    item.indexPathOfTable = indexPath;
    cell.cellModel = item;
    return (UITableViewCell *)cell;
}

- (BOOL)_tableView:(UITableView *)tableView shouldDisplayHeaderInSection:(NSInteger)section {
    BBTableViewSection *sec = self.sectionItems[section];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewModel:shouldDisplayHeaderInSection:)]) {
        return [self.delegate tableViewModel:self shouldDisplayHeaderInSection:sec];
    }
   
    return sec.items.count && sec.headerTitle != nil;
}

- (BOOL)_tableView:(UITableView *)tableView shouldDisplayFooterInSection:(NSInteger)section {
    BBTableViewSection *sec = self.sectionItems[section];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewModel:shouldDisplayFooterInSection:)]) {
        return [self.delegate tableViewModel:self shouldDisplayFooterInSection:sec];
    }
    return sec.items.count && sec.footerTitle != nil;
}

- (NSAttributedString *)_tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    BBTableViewSection *sec = self.sectionItems[section];
    return sec.headerTitle;
}

- (NSAttributedString *)mapDownloadTableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    BBTableViewSection *sec = self.sectionItems[section];
    return sec.footerTitle;
}


@end

