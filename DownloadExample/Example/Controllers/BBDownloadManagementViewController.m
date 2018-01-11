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
#import "NewDownloadModule.h"
#import "MapDownloadConfiguration.h"
#import "BBTableViewSection+BBDownloadManagerExtend.h"

@interface BBDownloadManagementViewController () <NoDataPlaceholderDelegate, BBMapDownloadBottomViewDelegate>

@property (nonatomic, strong) BBMapDownloadNetworkStateView *networkStateView;
@property (nonatomic, strong) BBMapDownloadBottomView *bottomView;

@end

@implementation BBDownloadManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    
    [self loadSectionItems];
    
    [self testData];
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
    BBTableViewSection *downloadedSection = [BBTableViewSection createDownloadedSection];
//    [downloadedSection initDownloadedItemsWithTarget:self selector:@selector(clickDownloadAction:)];
    if (!downloadedSection.items.count) {
        downloadedSection = nil;
    }
    BBTableViewSection *downloadIngSection = [BBTableViewSection createDownloadingSection];
    [downloadIngSection initDownloadingItemsWithTarget:self selector:@selector(clickDownloadAction:)];
    if (!downloadIngSection.items.count) {
        downloadIngSection = nil;
    }
    BBTableViewSection *updateSection = [BBTableViewSection createDownloadUpdateSection];
    [updateSection initDownloadUpdateItemsWithTarget:self selector:@selector(clickDownloadAction:)];
    if (!updateSection.items.count) {
        updateSection = nil;
    }
    [self appendSection:downloadIngSection];
    [self appendSection:updateSection];
    [self appendSection:downloadedSection];
    if (self.sectionItems.count) {
        [self appendSection:[self settingSection]];
    }
    [self.tableView reloadData];
}

- (void)testData {
    
    // 模拟10秒钟后文件下载完成
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        BBTableViewSection *downloadIngSection = [self getSectionWithIdentifier:NSStringFromSelector(@selector(createDownloadingSection))];
        BBTableViewSection *downloadedSection = [self getSectionWithIdentifier:NSStringFromSelector(@selector(createDownloadedSection))];
        if (!downloadedSection) {
            downloadedSection = [BBTableViewSection createDownloadedSection];
            BBTableViewSection *downloadUpdateSection = [self getSectionWithIdentifier:NSStringFromSelector(@selector(settingSection))];
            [self updateSectionOfTableViewSection:downloadUpdateSection];
            downloadedSection.sectionOfTable = downloadUpdateSection.sectionOfTable;
//            [self insertSection:downloadedSection atIndex:downloadUpdateSection.sectionOfTable];
        }
        [self moveCellModels:downloadIngSection.items.mutableCopy toSection:downloadedSection];
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            BBTableViewSection *downloadIngSection = [self getSectionWithIdentifier:NSStringFromSelector(@selector(createDownloadingSection))];
            BBTableViewSection *downloadedSection = [self getSectionWithIdentifier:NSStringFromSelector(@selector(createDownloadedSection))];
            if (!downloadIngSection) {
                downloadIngSection = [BBTableViewSection createDownloadingSection];
                downloadIngSection.sectionOfTable = 1;
            }
            if (!downloadedSection) {
                downloadedSection = [BBTableViewSection createDownloadedSection];
                BBTableViewSection *downloadUpdateSection = [self getSectionWithIdentifier:NSStringFromSelector(@selector(settingSection))];
                [self updateSectionOfTableViewSection:downloadUpdateSection];
                downloadedSection.sectionOfTable = downloadUpdateSection.sectionOfTable;
            }
            [self moveCellModel:downloadedSection.items.lastObject toSection:downloadIngSection];
        });
    });
}


/// WiFi下自动下载
- (BBTableViewSection *)settingSection {
    NSMutableArray *items = @[].mutableCopy;
    BBSettingsCellModel *item = [BBSettingsCellModel switchCellForSel:@selector(applyWifiAutoSwitch:) target:self attributedTitle:[[NSAttributedString alloc] initWithString:@"WIFI下自动更新"] icon:nil on:[MapDownloadConfiguration shouldAutoDownloadInWifi].boolValue height:40.0];
    item.cellClass = [BBMapDownloadSettingTableViewCell class];
    [items addObject:item];
    BBTableViewSection *section = [[BBTableViewSection alloc] initWithItems:items headerTitle:nil footerTitle:nil];
    section.identifier = NSStringFromSelector(_cmd);
    return section;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Actions
////////////////////////////////////////////////////////////////////////
- (void)applyWifiAutoSwitch:(UISwitch *)sw {
    [MapDownloadConfiguration setShouldAutoDownloadInWifi:@(sw.isOn)];
}

- (void)clickDownloadAction:(id<BBBaseTableViewCell>)cell {
    
}

////////////////////////////////////////////////////////////////////////
#pragma mark - 重写父类方法
////////////////////////////////////////////////////////////////////////


- (UITableViewCell *)mapDownloadTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [super mapDownloadTableView:tableView cellForRowAtIndexPath:indexPath];
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
    self.networkStateView.hidden = YES;
    self.tableViewTopConstraint.constant = 0.0;
    self.bottomView.hidden = YES;
    UIEdgeInsets tableContentInset = self.tableView.contentInset;
    tableContentInset.bottom = 0;
    self.tableView.contentInset = tableContentInset;
}

- (void)noDataPlaceholderDidDisappear:(UIScrollView *)scrollView {
    self.networkStateView.attributedText = [[NSAttributedString alloc] initWithString:@"当前为Wi-Fi网络，切换至运营商流量会自动暂停下载!"];
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
