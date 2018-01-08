//
//  BBAllMapViewController.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/3.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBAllMapViewController.h"
#import "BBMapContinentTableViewCell.h"
#import "BBMapDownloadTableViewCell.h"
#import "BBMapDownloadNodeViewController.h"
#import "BBMapDownloadConst.h"
#import "BBMapDownloadHotCityTableViewCell.h"
#import "BBMapDownloadSettingTableViewCell.h"
#import "BBMapDownloadSearchView.h"

@interface BBAllMapViewController ()

@property (nonatomic, strong) BBMapDownloadSearchView *searchView;

@end

@implementation BBAllMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[BBMapContinentTableViewCell class] forCellReuseIdentifier:BBMapContinentTableViewCell.defaultIdentifier];
    [self.tableView registerClass:[BBMapDownloadTableViewCell class] forCellReuseIdentifier:BBMapDownloadTableViewCell.defaultIdentifier];
    [self.tableView registerClass:[BBMapDownloadHotCityTableViewCell class] forCellReuseIdentifier:BBMapDownloadHotCityTableViewCell.defaultIdentifier];
    [self.tableView registerClass:[BBMapDownloadSettingTableViewCell class] forCellReuseIdentifier:BBMapDownloadSettingTableViewCell.defaultIdentifier];
    
    [self setupSearchView];
    [self loadSectionItems];
    
}

- (void)setupSearchView {
    self.searchView.title = @"输入城市名称或国家";
    self.tableViewTopConstraint.constant = BBMapDownloadDownloadSearchViewHeight;
    [self.searchView addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadSectionItems {
    [self.sectionItems removeAllObjects];
    [self appendSection:[self mapDescriptionSection]];
    [self appendSection:[self currentLocationSection]];
    [self appendSection:[self hotCitySection]];
    [self appendSection:[self allMapsSection]];
    [self.tableView reloadData];
}

- (BBTableViewSection *)mapDescriptionSection {
    NSMutableArray<BBSettingsCellModel *> *items = @[].mutableCopy;
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:@"导航地图、旅游地图说明" attributes:@{NSFontAttributeName: BBMapDownloadFontWithSize(BBMapDownloadMiddleFontSize)}];
    BBSettingsCellModel *model = [BBSettingsCellModel cellForSel:@selector(clickMapDescription) target:self attributedTitle:attributedTitle disclosureAttributedText:nil icon:nil disclosureType:BBSettingsCellDisclosureTypeNext height:34.0];
    [items addObject:model];
    BBTableViewSection *section = [[BBTableViewSection alloc] initWithItems:items headerTitle:nil footerTitle:nil];
    return section;
}

/// 当前查看/定位地区
- (BBTableViewSection *)currentLocationSection {
    BBMapDownloadTableViewCellModel *mapCenterCellModel = [[BBMapDownloadTableViewCellModel alloc] initWithHeight:BBMapDownloadDownloadCellHeight];
    __weak typeof(&*self) weakSelf = self;
    [mapCenterCellModel setHeightChangeCallBack:^(CGFloat newHeight, NSIndexPath *indexPathOfView) {
        __strong typeof(&*weakSelf) self = weakSelf;
        if (indexPathOfView) {
            [self.tableView reloadRowsAtIndexPaths:@[indexPathOfView] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else {
            [self.tableView reloadData];
        }
    }];
    NSMutableArray<BBMapDownloadTableViewCellModel *> *items = @[].mutableCopy;
    [items addObject:mapCenterCellModel];
    BBMapDownloadTableViewCellModel *gpsCellModel = [[BBMapDownloadTableViewCellModel alloc] initWithHeight:BBMapDownloadDownloadCellHeight];
    [items addObject:gpsCellModel];
    
    // 注册cell高度改变的事件
    for (BBMapDownloadTableViewCellModel *model in items) {
        model.cellClass = [BBMapDownloadTableViewCell class];
        [model setHeightChangeCallBack:^(CGFloat newHeight, NSIndexPath *indexPathOfView) {
            __strong typeof(&*weakSelf) self = weakSelf;
            if (indexPathOfView) {
                [self.tableView reloadRowsAtIndexPaths:@[indexPathOfView] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else {
                [self.tableView reloadData];
            }
        }];
    }
    
    BBTableViewSection *section = [[BBTableViewSection alloc] initWithItems:items headerTitle:[[NSAttributedString alloc] initWithString:@"当前查看/定位"] footerTitle:nil];
    return section;
}

/// 热门城市
- (BBTableViewSection *)hotCitySection {
    BBMapDownloadHotCityTableViewCellModel *hotCityCellModel = [[BBMapDownloadHotCityTableViewCellModel alloc] init];
    hotCityCellModel.buttonHeight = BBMapDownloadHotCityButtonHeight;
    NSMutableArray<BBMapDownloadHotCityTableViewCellModel *> *items = @[].mutableCopy;
    
    NSMutableArray *l = @[].mutableCopy;
    for (NSInteger i = 0; i<37; i++) {
        [l addObject:@(i)];
    }
    hotCityCellModel.model = l;
    
    [items addObject:hotCityCellModel];
    __weak typeof(&*self) weakSelf = self;
    // 注册cell高度改变的事件
    for (BBMapDownloadHotCityTableViewCellModel *model in items) {
        model.cellClass = [BBMapDownloadHotCityTableViewCell class];
        [model setHeightChangeCallBack:^(CGFloat newHeight, NSIndexPath *indexPathOfView) {
            __strong typeof(&*weakSelf) self = weakSelf;
            if (indexPathOfView) {
                [self.tableView reloadRowsAtIndexPaths:@[indexPathOfView] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else {
                [self.tableView reloadData];
            }
        }];
    }
    BBTableViewSection *section = [[BBTableViewSection alloc] initWithItems:items headerTitle:[[NSAttributedString alloc] initWithString:@"热门城市"] footerTitle:nil];
    return section;
}

/// 全部地图
- (BBTableViewSection *)allMapsSection {
    NSMutableArray<BBMapContinentTableViewCellModel *> *items = @[].mutableCopy;
    for (NSInteger i = 0; i < 5; i++) {
        BBMapContinentTableViewCellModel *model = [[BBMapContinentTableViewCellModel alloc] initWithHeight:BBMapDownloadContinentCellHeight];
        model.model = @(i).stringValue;
        model.cellClass = [BBMapContinentTableViewCell class];
        [items addObject:model];
    }
    BBTableViewSection *section = [[BBTableViewSection alloc] initWithItems:items headerTitle:[[NSAttributedString alloc] initWithString:@"全部地图"] footerTitle:nil];
    return section;
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
    return sec.headerTitle != nil;
}

- (NSAttributedString *)mapDownloadTableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    BBTableViewSection *sec = self.sectionItems[section];
    return sec.footerTitle;
}

- (BOOL)mapDownloadTableView:(UITableView *)tableView shouldDisplayFooterInSection:(NSInteger)section {
    BBTableViewSection *sec = self.sectionItems[section];
    return sec.footerTitle != nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BBTableViewSection *section = self.sectionItems[indexPath.section];
    BBMapDownloadBaseItem *item = section.items[indexPath.row];
    if (item.cellClass == [BBMapContinentTableViewCell class]) {
        [self showDownloadNodePageWithNode:item.model];
    }
    else if (item.class == [BBMapDownloadTableViewCell class]) {
        [self clickCurrentLocationCity];
    }
    else if (item.class == [BBMapDownloadHotCityTableViewCell class]) {
        [self clickHotCity];
    }
    
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Actions
////////////////////////////////////////////////////////////////////////

/// 查看洲详情页
- (void)showDownloadNodePageWithNode:(id)node {
    BBMapDownloadNodeViewController *vc = [[BBMapDownloadNodeViewController alloc] initWithNode:node];
    [[UIViewController xy_getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

/// 点击热门城市
- (void)clickHotCity {
    
}

/// 点击当前定位城市或当前地图中心的城市
- (void)clickCurrentLocationCity {
    
}

/// 查看导航、旅游说明
- (void)clickMapDescription {
    
}

/// 去搜索
- (void)clickSearch {
    
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Lazy
////////////////////////////////////////////////////////////////////////
- (BBMapDownloadSearchView *)searchView {
    if (!_searchView) {
        BBMapDownloadSearchView *view = BBMapDownloadSearchView.new;
        _searchView = view;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:view];
        NSDictionary *viewDict = @{@"_searchView": view};
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_searchView]|" options:kNilOptions metrics:nil views:viewDict]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_searchView(==BBMapDownloadDownloadSearchViewHeight)]" options:kNilOptions metrics:@{@"BBMapDownloadDownloadSearchViewHeight": @(BBMapDownloadDownloadSearchViewHeight)} views:viewDict]];
    }
    return _searchView;
}

@end
