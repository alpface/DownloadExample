//
//  BBDownloadManagementViewController.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/3.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBDownloadManagementViewController.h"
#import "UIScrollView+NoDataExtend.h"
#import "BBMapDownloadConst.h"
#import "BBMapDownloadTableViewCell.h"
#import "BBMapDownloadNetworkStateView.h"
#import "BBMapDownloadBottomView.h"
#import "BBMapDownloadSettingTableViewCell.h"

@interface BBDownloadManagementViewController () <NoDataPlaceholderDelegate, BBMapDownloadBottomViewDelegate>

@property (nonatomic, strong) BBMapDownloadNetworkStateView *networkStateView;
@property (nonatomic, assign) BOOL shouldDiaplaySectionHeader;
@property (nonatomic, strong) BBMapDownloadBottomView *bottomView;

@end

@implementation BBDownloadManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    
    [self loadSectionItems];
}


- (void)setupViews {

    [self.tableView registerClass:[BBMapDownloadTableViewCell class] forCellReuseIdentifier:BBMapDownloadTableViewCell.defaultIdentifier];
    [self.tableView registerClass:[BBMapDownloadSettingTableViewCell class] forCellReuseIdentifier:BBMapDownloadSettingTableViewCell.defaultIdentifier];
    [self setupNoData];
    [self setupBottomView];
}

- (void)setupBottomView {
    [self.view addSubview:self.bottomView];
    NSArray *bottomViewConstraints = @[
                                       [NSLayoutConstraint constraintsWithVisualFormat:@"|[bottomView]|" options:kNilOptions metrics:nil views:@{@"bottomView": self.bottomView}],
                                       [NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomView(==BBMapDownloadBottomViewHeight)]|" options:kNilOptions metrics:@{@"BBMapDownloadBottomViewHeight": @(BBMapDownloadBottomViewHeight)} views:@{@"bottomView": self.bottomView}]
                                       ];
    [self.view addConstraints:[bottomViewConstraints valueForKeyPath:@"@unionOfArrays.self"]];
}

- (void)setupNoData {
    self.tableView.noDataPlaceholderDelegate = self;
    self.tableView.noDataDetailTextLabelBlock = ^(UILabel * _Nonnull textLabel) {
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = BBMapDownloadLightTextColor;
        textLabel.font = BBMapDownloadFontWithSize(BBMapDownloadMiddleFontSize);
        textLabel.text = @"暂无下载，点击“全部地图”开始下载吧";
    };
}

- (void)loadSectionItems {
    [self.sectionItems removeAllObjects];
    [self appendSection:[self downloadingSection]];
    [self appendSection:[self downloadUpdateSection]];
    [self appendSection:[self downloadedSection]];
    if (self.sectionItems.count) {
        [self appendSection:[self settingSection]];
    }
    [self.tableView reloadData];
}


/// 下载中的
- (BBTableViewSection *)downloadingSection {
    NSMutableArray *items = @[].mutableCopy;
    for (NSInteger i = 0; i < 10; i++) {
       BBMapDownloadTableViewCellModel *model = [[BBMapDownloadTableViewCellModel alloc] initWithHeight:BBMapDownloadDownloadCellHeight];
        model.cellClass = [BBMapDownloadTableViewCell class];
        [items addObject:model];
    }
    BBTableViewSection *section = [[BBTableViewSection alloc] initWithItems:items headerTitle:[[NSAttributedString alloc] initWithString:@"下载中"] footerTitle:nil];
    return section;
}

/// 待更新
- (BBTableViewSection *)downloadUpdateSection {
    NSMutableArray *items = @[].mutableCopy;
    for (NSInteger i = 0; i < 10; i++) {
        BBMapDownloadTableViewCellModel *model = [[BBMapDownloadTableViewCellModel alloc] initWithHeight:BBMapDownloadDownloadCellHeight];
        model.cellClass = [BBMapDownloadTableViewCell class];
        [items addObject:model];
    }
    BBTableViewSection *section = [[BBTableViewSection alloc] initWithItems:items headerTitle:[[NSAttributedString alloc] initWithString:@"待更新"] footerTitle:nil];
    return section;
}

/// 已下载
- (BBTableViewSection *)downloadedSection {
    NSMutableArray *items = @[].mutableCopy;
    for (NSInteger i = 0; i < 10; i++) {
        BBMapDownloadTableViewCellModel *model = [[BBMapDownloadTableViewCellModel alloc] initWithHeight:BBMapDownloadDownloadCellHeight];
        model.cellClass = [BBMapDownloadTableViewCell class];
        [items addObject:model];
    }
    BBTableViewSection *section = [[BBTableViewSection alloc] initWithItems:items headerTitle:[[NSAttributedString alloc] initWithString:@"已下载"] footerTitle:nil];
    return section;
}

/// WiFi下自动下载
- (BBTableViewSection *)settingSection {
    NSMutableArray *items = @[].mutableCopy;
    BBSettingsCellModel *item = [BBSettingsCellModel switchCellForSel:@selector(applyWifiAutoSwitch:) target:self attributedTitle:[[NSAttributedString alloc] initWithString:@"WIFI下自动更新"] icon:nil on:YES height:40.0];
    item.cellClass = [BBMapDownloadSettingTableViewCell class];
    [items addObject:item];
    BBTableViewSection *section = [[BBTableViewSection alloc] initWithItems:items headerTitle:nil footerTitle:nil];
    return section;
}

- (void)applyWifiAutoSwitch:(UISwitch *)sw {
    
}
////////////////////////////////////////////////////////////////////////
#pragma mark - 重写父类方法
////////////////////////////////////////////////////////////////////////


- (UITableViewCell *)mapDownloadTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [super mapDownloadTableView:tableView cellForRowAtIndexPath:indexPath];
}

- (NSAttributedString *)mapDownloadTableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    BBTableViewSection *sec = self.sectionItems[section];
    return sec.headerTitle;
}

- (BOOL)mapDownloadTableView:(UITableView *)tableView shouldDisplayHeaderInSection:(NSInteger)section {
    BBTableViewSection *sec = self.sectionItems[section];
    return sec.headerTitle != nil && self.shouldDiaplaySectionHeader;
}

- (NSAttributedString *)mapDownloadTableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    BBTableViewSection *sec = self.sectionItems[section];
    return sec.footerTitle;
}

- (BOOL)mapDownloadTableView:(UITableView *)tableView shouldDisplayFooterInSection:(NSInteger)section {
    BBTableViewSection *sec = self.sectionItems[section];
    return sec.footerTitle != nil && self.shouldDiaplaySectionHeader;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - NoDataPlaceholderDelegate
////////////////////////////////////////////////////////////////////////
- (CGPoint)contentOffsetForNoDataPlaceholder:(UIScrollView *)scrollView {
    return CGPointMake(0, BBMapDownloadDownloadNoDataLabelOffsetY);
}

- (void)noDataPlaceholder:(UIScrollView *)scrollView didTapOnContentView:(UITapGestureRecognizer *)tap {
#if DEBUG
    
    [self loadSectionItems];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self clearSectionItems];
    });
    
#endif
}

- (void)noDataPlaceholderWillAppear:(UIScrollView *)scrollView {
    self.shouldDiaplaySectionHeader = NO;
    self.networkStateView.hidden = YES;
    self.tableViewTopConstraint.constant = 0.0;
    self.bottomView.hidden = YES;
    UIEdgeInsets tableContentInset = self.tableView.contentInset;
    tableContentInset.bottom = 0;
    self.tableView.contentInset = tableContentInset;
}

- (void)noDataPlaceholderDidDisappear:(UIScrollView *)scrollView {
    self.networkStateView.attributedText = [[NSAttributedString alloc] initWithString:@"当前为Wi-Fi网络，切换至运营商流量会自动暂停下载!"];
    self.shouldDiaplaySectionHeader = YES;
    self.networkStateView.hidden = NO;
    self.tableViewTopConstraint.constant = BBMapDownloadDownloadNetworkStateViewHeight;
    self.bottomView.hidden = NO;
    UIEdgeInsets tableContentInset = self.tableView.contentInset;
    tableContentInset.bottom = BBMapDownloadBottomViewHeight;
    self.tableView.contentInset = tableContentInset;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - BBMapDownloadBottomViewDelegate
////////////////////////////////////////////////////////////////////////


- (void)bottomView:(BBMapDownloadBottomView *)bottomView didClickItem:(BBMapDownloadBottomItem *)item {
    
}


////////////////////////////////////////////////////////////////////////
#pragma mark - Lazy
////////////////////////////////////////////////////////////////////////

- (BBMapDownloadNetworkStateView *)networkStateView {
    if (!_networkStateView) {
        _networkStateView = BBMapDownloadNetworkStateView.new;
        _networkStateView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_networkStateView];
        NSDictionary *viewDict = @{@"networkStateView": _networkStateView};
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[networkStateView]|" options:kNilOptions metrics:nil views:viewDict]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[networkStateView(==BBMapDownloadDownloadNetworkStateViewHeight)]" options:kNilOptions metrics:@{@"BBMapDownloadDownloadNetworkStateViewHeight": @(BBMapDownloadDownloadNetworkStateViewHeight)} views:viewDict]];
    }
    return _networkStateView;
}


- (BBMapDownloadBottomView *)bottomView {
    if (!_bottomView) {
        NSArray *items = @[
                           [[BBMapDownloadBottomItem alloc] initWithTitle:@"全部更新" image:nil],
                           [[BBMapDownloadBottomItem alloc] initWithTitle:@"全部下载" image:nil],
                           [[BBMapDownloadBottomItem alloc] initWithTitle:@"全部暂停" image:nil],
                           ];
        BBMapDownloadBottomView *bottomView = [[BBMapDownloadBottomView alloc] initWithItems:items];
        _bottomView = bottomView;
        bottomView.buttonHPadding = BBMapDownloadViewGlobleMargin;
        bottomView.buttonVPadding = 6.0;
        bottomView.translatesAutoresizingMaskIntoConstraints = NO;
        bottomView.backgroundColor = BBMapDownloadBottomViewBackgroundColor;
        bottomView.delegate = self;
        BBMapDownloadBottomButton *btn = nil;
        if (@available(iOS 9.0, *)) {
            btn  = [BBMapDownloadBottomButton appearanceWhenContainedInInstancesOfClasses:@[[BBMapDownloadBottomView class]]];
        } else {
            btn = [BBMapDownloadBottomButton appearanceWhenContainedIn:[BBMapDownloadBottomView class], nil];
        }
        btn.titleLabel.font = BBMapDownloadFontWithSize(BBMapDownloadButtomButtonTitleFontSize);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _bottomView;
}

@end
