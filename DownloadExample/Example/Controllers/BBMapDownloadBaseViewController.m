//
//  BBMapDownloadBaseViewController.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/4.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBMapDownloadBaseViewController.h"
#import "BBMapDownloadConst.h"
#import "BBMapDownloadSectionHeaderView.h"
#import "BBBaseTableViewCell.h"

@interface BBMapDownloadBaseViewController ()

@end

@implementation BBMapDownloadBaseViewController

@synthesize tableView = _tableView;
@synthesize customNavView = _customNavView;

- (void)dealloc {
    self.sectionItems = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)_setupViews {
    
    self.view.backgroundColor = BBMapDownloadViewBackgroundColor;
    [self.view addSubview:self.tableView];
    NSMutableDictionary *viewsDict = @{@"tableView": self.tableView}.mutableCopy;
    NSString *topViewVFormat = @"V:|[tableView]|";
    if ([self shouldDisplayCustomNavView]) {
        [self _setupTopView];
        [viewsDict setObject:self.customNavView forKey:@"customNavView"];
        topViewVFormat = @"V:[customNavView]-0-[tableView]|";
    }
    NSArray *constraints = @[
                             [NSLayoutConstraint constraintsWithVisualFormat:@"|[tableView]|" options:kNilOptions metrics:nil views:viewsDict],
                             [NSLayoutConstraint constraintsWithVisualFormat:topViewVFormat options:kNilOptions metrics:nil views:viewsDict],
                             ];
    [self.view addConstraints:[constraints valueForKeyPath:@"@unionOfArrays.self"]];
}

- (void)_setupTopView {
    BBMapDownloadNavigationView *topView = [BBMapDownloadNavigationView new];
    [self.view addSubview:topView];
    _customNavView = topView;
    topView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *topViewTop = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:BBMapDownloadStateBarHeight];
    NSLayoutConstraint *topViewLeft = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
    NSLayoutConstraint *topViewRight = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
    NSLayoutConstraint *topViewHeight = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:BBMapDownloadNavHeight];
    [NSLayoutConstraint activateConstraints:@[topViewTop, topViewLeft, topViewRight, topViewHeight]];
    
    self.customNavView.titleAttributedText = self.navTitle;
    __weak typeof(&*self) weakSelf = self;
    self.customNavView.backActionCallBack = ^(UIButton *backButton) {
        __strong typeof(&*weakSelf) self = weakSelf;
        [self navigateBackAction:backButton];
    };

}


- (void)setNavTitle:(NSAttributedString *)navTitle {
    if (_navTitle == navTitle) {
        return;
    }
    _navTitle = navTitle;
    
    self.customNavView.titleAttributedText = navTitle;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Section
////////////////////////////////////////////////////////////////////////

- (void)loadSectionItems {
    
}

- (void)clearSectionItems {
    [self.sectionItems removeAllObjects];
    [self.tableView reloadData];
}

- (BOOL)appendSection:(BBTableViewSection *)section {
    if (!section) {
        return NO;
    }
    NSParameterAssert([section isKindOfClass:[BBTableViewSection class]]);
    [self.sectionItems addObject:section];
    return YES;
}

- (BOOL)insertSection:(BBTableViewSection *)section atIndex:(NSInteger)index {
    if (!section) {
        return NO;
    }
    NSParameterAssert(index < self.sectionItems.count);
    [self.sectionItems insertObject:section atIndex:index];
    return YES;
}

- (BBTableViewSection *)getSectionWithIdentifier:(NSString *)identifier {
    NSUInteger foundIdx = [self.sectionItems indexOfObjectPassingTest:^BOOL(BBTableViewSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL res = [obj.identifier isEqualToString:identifier];
        if (res) {
            *stop = YES;
        }
        return res;
    }];
    if (self.sectionItems && foundIdx != NSNotFound) {
        return [self.sectionItems objectAtIndex:foundIdx];
    }
    return nil;
}

- (BBTableViewSection *)getSectionWithIndex:(NSInteger)index {
    if (index >= self.sectionItems.count) {
        return nil;
    }
    return [self.sectionItems objectAtIndex:index];
}

- (NSIndexPath *)getIndexPathWithCellModel:(id<CellModelProtocol>)cellModel {
    
    if (!cellModel) {
        return nil;
    }
    
    __block NSIndexPath *indexPath = nil;
    [self.sectionItems enumerateObjectsUsingBlock:^(BBTableViewSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger foundIdx = NSNotFound;
        if (obj.items) {
          foundIdx = [obj.items indexOfObject:cellModel];
        }
        if (foundIdx != NSNotFound) {
            *stop = YES;
            indexPath = [NSIndexPath indexPathForRow:foundIdx inSection:idx];
        }
    }];

    return indexPath;
}

- (id<CellModelProtocol>)getCellModelWithIndexPath:(NSIndexPath *)indexPath {
    BBTableViewSection *section = [self getSectionWithIndex:indexPath.section];
    if (!section) {
        return nil;
    }
    
    if (indexPath.row >= section.items.count) {
        return nil;
    }
    return [section.items objectAtIndex:indexPath.row];
}

- (void)removeCellModelsInSectionsAtIndexPath:(NSArray<NSIndexPath *> *)indexPaths {
    
    if (!indexPaths.count) {
        return;
    }
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        if (indexPath.section >= self.sectionItems.count) {
            return;
        }
        NSMutableArray *items = self.sectionItems[indexPath.section].items;
        if (!items.count || indexPath.row >= items.count) {
            [items removeObjectAtIndex:indexPath.row];
        }
    }];
}

- (BOOL)removeObjectInSectionsAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!indexPath) {
        return NO;
    }
    if (indexPath.section >= self.sectionItems.count) {
        return NO;
    }
    NSMutableArray *items = self.sectionItems[indexPath.section].items;
    if (!items.count || indexPath.row >= items.count) {
        [items removeObjectAtIndex:indexPath.row];
        return YES;
    }
    return NO;
}

- (BOOL)removeObjectInSections:(id<CellModelProtocol>)cellModel removedIndexPath:(NSIndexPath * __autoreleasing *)indexPath {
    
    if (!cellModel || !self.sectionItems.count) {
        return NO;
    }
    
    __block BOOL res = NO;
    [self.sectionItems enumerateObjectsUsingBlock:^(BBTableViewSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger foundIdx = NSNotFound;
        if (obj.items) {
            foundIdx = [obj.items indexOfObject:cellModel];
        }
        if (foundIdx != NSNotFound) {
            *stop = YES;
            if (indexPath) {
                *indexPath = [NSIndexPath indexPathForRow:foundIdx inSection:idx];
            }
            [obj.items removeObjectAtIndex:foundIdx];
            res = YES;
        }
    }];
    
    
    return res;
}


- (void)updateSectionOfTableViewSection:(BBTableViewSection *)section {
    section.sectionOfTable = [self.sectionItems indexOfObject:section];
}

//- (void)moveCellModelsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths toSection:(BBTableViewSection *)section {
//
//    [self updateSectionOfTableViewSection:section];
//    [self.tableView beginUpdates];
//    
//    NSMutableArray *newIndexPaths = @[].mutableCopy;
//    NSInteger beginRow = section.items.count;
//    for (NSIndexPath *indexPath in indexPaths) {
//        if (indexPath.section >= self.sectionItems.count) {
//            continue;
//        }
//        if (indexPath.row >= self.sectionItems[indexPath.section].items.count) {
//            continue;
//        }
//        [section.items addObject:self.sectionItems[indexPath.section].items[indexPath.row]];
//        [self.sectionItems[indexPath.section].items removeObjectAtIndex:indexPath.row];
//        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:beginRow inSection:section.sectionOfTable];
//        [newIndexPaths addObject:newIndexPath];
//        
//        beginRow++;
//    }
//    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.tableView endUpdates];
//}

- (void)moveCellModelAtIndexPath:(NSIndexPath *)indexPath toSection:(BBTableViewSection *)toSection {
    
    // 当传入参数是错误的时，会导致下面的逻辑错误，所以不要传错数据
    NSParameterAssert(toSection && indexPath.section < self.sectionItems.count && indexPath.row < self.sectionItems[indexPath.section].items.count);
    
    if (!toSection) {
        return;
    }
    if (indexPath.section >= self.sectionItems.count) {
        return;
    }
    BBTableViewSection *orSec = self.sectionItems[indexPath.section];
    if (indexPath.row >= orSec.items.count) {
        return;
    }
    
    [self.tableView beginUpdates];
    
    // 移动时，如果这一组只有这一个元素，就从sectionItems中移除这组
   id<CellModelProtocol> cellModel = orSec.items[indexPath.row];
    if (orSec.items.count == 1) {
        [self.sectionItems removeObject:orSec];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [self updateSectionOfTableViewSection:toSection];
    
    // 当toSection.items的count为0时，我会认定他为刚添加的一组
    // 因为当item.count为0时，我会将他从sectionItems移除
    BOOL isNewSection = toSection.items.count == 0;
    if (!isNewSection) {
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:toSection.sectionOfTable] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:toSection.items.count inSection:toSection.sectionOfTable];
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [toSection.items addObject:cellModel];
    
    [self.tableView endUpdates];
}

- (void)moveCellModel:(id<CellModelProtocol>)cellModel toSection:(BBTableViewSection *)toSection {
    // 当传入参数是错误的时，会导致下面的逻辑错误，所以不要传错数据
    NSParameterAssert(toSection && cellModel);
    
    if (!toSection) {
        return;
    }
 
    [self.tableView beginUpdates];
    
    // 移动时，如果这一组只有这一个元素，就从sectionItems中移除这组
    NSIndexPath *removedIndexPath = nil;
    BOOL isRemoveSuccess = [self removeObjectInSections:cellModel removedIndexPath:&removedIndexPath];
    if (isRemoveSuccess) {
        // 移除成功时，且此时removedIndexPath这一组的items个数为0.就将这一组从sectionItems中移除
        BBTableViewSection *sec1 = self.sectionItems[removedIndexPath.section];
        if (!sec1.items.count) {
            [self.sectionItems removeObjectAtIndex:removedIndexPath.section];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:removedIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else {
           [self.tableView deleteRowsAtIndexPaths:@[removedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    }

    
    [self updateSectionOfTableViewSection:toSection];
    
    // 当toSection.items的count为0时，我会认定他为刚添加的一组
    // 因为当item.count为0时，我会将他从sectionItems移除
    BOOL isNewSection = toSection.items.count == 0;
    if (!isNewSection) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:toSection.items.count inSection:toSection.sectionOfTable];
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else {
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:toSection.sectionOfTable] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    [toSection.items addObject:cellModel];
    
    [self.tableView endUpdates];
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
    
    return [self mapDownloadTableView:tableView cellForRowAtIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    BOOL shouldDisplay = [self mapDownloadTableView:tableView shouldDisplayHeaderInSection:section];
    if (shouldDisplay) {
        BBMapDownloadSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BBMapDownloadSectionHeaderViewDefaultIdentifier];
        headerView.attributedText = [self mapDownloadTableView:tableView titleForHeaderInSection:section];
        return headerView;
    }
    else {
        return nil;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    BOOL shouldDisplay = [self mapDownloadTableView:tableView shouldDisplayFooterInSection:section];
    if (shouldDisplay) {
        BBMapDownloadSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BBMapDownloadSectionHeaderViewDefaultIdentifier];
        headerView.attributedText = [self mapDownloadTableView:tableView titleForHeaderInSection:section];
        return headerView;
    }
    else {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    BOOL shouldDisplay = [self mapDownloadTableView:tableView shouldDisplayHeaderInSection:section];
    if (shouldDisplay) {
        return BBMapDownloadDownloadSectionHeaderHeight;
    }
    else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    BOOL shouldDisplay = [self mapDownloadTableView:tableView shouldDisplayFooterInSection:section];
    if (shouldDisplay) {
        return BBMapDownloadDownloadSectionHeaderHeight;
    }
    else {
        return 0.01;
    }
}


////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////

- (UITableViewCell *)mapDownloadTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BBTableViewSection *section = self.sectionItems[indexPath.section];
    section.sectionOfTable = indexPath.section;
    BBMapDownloadBaseItem *item = self.sectionItems[indexPath.section].items[indexPath.row];
    id<BBBaseTableViewCell> cell = [tableView dequeueReusableCellWithIdentifier:[item.cellClass defaultIdentifier] forIndexPath:indexPath];
    
    item.indexPathOfTable = indexPath;
    cell.cellModel = item;
    return (UITableViewCell *)cell;
}

- (BOOL)mapDownloadTableView:(UITableView *)tableView shouldDisplayHeaderInSection:(NSInteger)section {
    BBTableViewSection *sec = self.sectionItems[section];
    return sec.items.count && sec.headerTitle != nil;
}

- (BOOL)mapDownloadTableView:(UITableView *)tableView shouldDisplayFooterInSection:(NSInteger)section {
    BBTableViewSection *sec = self.sectionItems[section];
    return sec.items.count && sec.footerTitle != nil;
}

- (NSAttributedString *)mapDownloadTableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    BBTableViewSection *sec = self.sectionItems[section];
    return sec.headerTitle;
}

- (NSAttributedString *)mapDownloadTableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    BBTableViewSection *sec = self.sectionItems[section];
    return sec.footerTitle;
}


////////////////////////////////////////////////////////////////////////
#pragma mark - Lazy
////////////////////////////////////////////////////////////////////////
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [UITableView new];
        _tableView = tableView;
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[BBMapDownloadSectionHeaderView class] forHeaderFooterViewReuseIdentifier:BBMapDownloadSectionHeaderViewDefaultIdentifier];
    }
    return _tableView;
}

- (NSMutableArray<BBTableViewSection *> *)sectionItems {
    if (!_sectionItems) {
        _sectionItems = @[].mutableCopy;
    }
    return _sectionItems;
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////

- (BOOL)shouldDisplayCustomNavView {
    return NO;
}

- (void)navigateBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSLayoutConstraint *)tableViewTopConstraint {
    NSEnumerator *enumerator = self.view.constraints.objectEnumerator;
    NSLayoutConstraint *obj = nil;
    while ((obj = enumerator.nextObject)) {
        if ([obj.firstItem isEqual:self.tableView] && obj.firstAttribute == NSLayoutAttributeTop) {
            break;
        }
    }
    return obj;
}

- (NSLayoutConstraint *)tableViewBottomConstraint {
    NSEnumerator *enumerator = self.view.constraints.objectEnumerator;
    NSLayoutConstraint *obj = nil;
    while ((obj = enumerator.nextObject)) {
        if ([obj.firstItem isEqual:self.tableView] && obj.firstAttribute == NSLayoutAttributeBottom) {
            break;
        }
    }
    return obj;
}

@end
