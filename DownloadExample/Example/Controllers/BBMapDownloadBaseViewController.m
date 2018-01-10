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
    if (!section) {
        return NO;
    }
    [self.sectionItems addObject:section];
    return YES;
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
