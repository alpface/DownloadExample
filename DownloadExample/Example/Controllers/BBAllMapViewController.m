//
//  BBAllMapViewController.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/3.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBAllMapViewController.h"
#import "BBMapDownloadNodeTableViewCell.h"
#import "BBMapDownloadTableViewCell.h"
#import "BBMapDownloadNodeViewController.h"
#import "BBMapDownloadConst.h"
#import "BBMapDownloadHotCityTableViewCell.h"
#import "NewDownloadModule.h"
#import "BBMapDownloadSettingTableViewCell.h"
#import "BBMapDownloadSearchView.h"
#import "Download_level2_Model.h"
#import "DownloadNode.h"

@interface BBAllMapViewController ()

@property (nonatomic, strong) BBMapDownloadSearchView *searchView;

@end

@implementation BBAllMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[BBMapDownloadNodeTableViewCell class] forCellReuseIdentifier:BBMapDownloadNodeTableViewCell.defaultIdentifier];
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
    NSMutableArray *items = @[].mutableCopy;
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:@"导航地图、旅游地图说明" attributes:@{NSFontAttributeName: BBMapDownloadFontWithSize(BBMapDownloadMiddleFontSize)}];
    BBSettingsCellModel *model = [BBSettingsCellModel cellForSel:@selector(clickMapDescription:) target:self attributedTitle:attributedTitle disclosureAttributedText:nil icon:nil disclosureType:BBSettingsCellDisclosureTypeNext height:34.0];
    [items addObject:model];
    BBTableViewSection *section = [[BBTableViewSection alloc] initWithItems:items headerTitle:nil footerTitle:nil];
    return section;
}

/// 当前查看/定位地区
- (BBTableViewSection *)currentLocationSection {
    
    NSMutableArray *citys = @[].mutableCopy;
    NSMutableArray *items = @[].mutableCopy;
#if DEBUG
   [citys addObjectsFromArray:[[NewDownloadModule getInstance].allMapArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 3)]]];
#else
    if ([NewDownloadModule getInstance].autoDownloadHelper.curMapModel) {
        [citys addObject:[NewDownloadModule getInstance].autoDownloadHelper.curMapModel];
    }
#endif
    for (MapModel *map in citys) {
        BBMapDownloadTableViewCellModel *cellModel = [[BBMapDownloadTableViewCellModel alloc] initWithHeight:BBMapDownloadDownloadCellHeight target:self action:@selector(clickDownloadAction:)];
        cellModel.cellClass = [BBMapDownloadTableViewCell class];
        cellModel.model = map;
        [items addObject:cellModel];
    }
    BBTableViewSection *section = [[BBTableViewSection alloc] initWithItems:items headerTitle:[[NSAttributedString alloc] initWithString:@"当前查看/定位"] footerTitle:nil];
#if !DEBUG
    __weak typeof(&*section) weakSection = section;
    __weak typeof(&*self) weakSelf = self;
    [[NewDownloadModule getInstance] getCurGpsMapModelCallBack:^( MapModel * map) {
        __strong typeof(&*weakSection) section = weakSection;
        __strong typeof(&*weakSelf) self = weakSelf;
        if (map) {
            NSIndexSet *indexSet = [section.items indexesOfObjectsPassingTest:^BOOL(id<CellModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MapModel *m = obj.model;
                BOOL res = [m.mapId isEqualToString:map.mapId];
                return res;
            }];
            if (indexSet.count) {
                [section.items removeAllObjects];
            }
            BBMapDownloadTableViewCellModel *cellModel = [[BBMapDownloadTableViewCellModel alloc] initWithHeight:BBMapDownloadDownloadCellHeight target:self action:@selector(clickDownloadAction:)];
            cellModel.cellClass = [BBMapDownloadTableViewCell class];
            cellModel.model = map;
            [section.items addObject:cellModel];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section.sectionOfTable] withRowAnimation:UITableViewRowAnimationAutomatic];

        }
    }];
#endif
    return section;
}

/// 热门城市
- (BBTableViewSection *)hotCitySection {
    BBMapDownloadHotCityTableViewCellModel *hotCityCellModel = [[BBMapDownloadHotCityTableViewCellModel alloc] initWithItemTarget:self itemAction:@selector(clickHotCity:cell:)];
    hotCityCellModel.itemHeight = BBMapDownloadHotCityButtonHeight;
    NSMutableArray *items = @[].mutableCopy;
    
    NSArray *array = [[[NewDownloadModule getInstance] allMapArray] objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 10)]];
    hotCityCellModel.model = array;
    
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
    NSMutableArray *dataSource = [[NewDownloadModule getInstance] dataArray];
    NSMutableArray *items = @[].mutableCopy;
    for (DownloadNode *node in dataSource) {
        BBMapDownloadNodeTableViewCellModel *model = [[BBMapDownloadNodeTableViewCellModel alloc] initWithHeight:BBMapDownloadContinentCellHeight target:self action:@selector(clickNodeAction:)];
        model.model = node;
        model.cellClass = [BBMapDownloadNodeTableViewCell class];
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


////////////////////////////////////////////////////////////////////////
#pragma mark - Actions
////////////////////////////////////////////////////////////////////////

/// 点击热门城市
- (void)clickHotCity:(NSInteger)indexOfItem cell:(BBMapDownloadHotCityTableViewCell *)cell {
    MapModel *city = cell.hotCityList[indexOfItem];
    // 根据city创建一个DownloadNode
    DownloadNode *node = [[DownloadNode alloc] init];
    Download_level2_Model *model = [Download_level2_Model new];
    model.model = city;
    node.type = 2;
    node.isExpanded = NO;
    node.nodeData = model;
    node.sonNodes = @[node].mutableCopy;
    [self showDownloadNodePageWithNode:node];
}


/// 查看导航、旅游说明
- (void)clickMapDescription:(id)sender {
    
}

/// 去搜索
- (void)clickSearch {
    
}
/// 点击当前定位城市或当前地图中心的城市
- (void)clickDownloadAction:(id<BBBaseTableViewCell>)cell {
    
}

/// 点击洲节点
- (void)clickNodeAction:(id<BBBaseTableViewCell>)cell {
    [self showDownloadNodePageWithNode:cell.cellModel.model];
}

/// 查看子节点
- (void)showDownloadNodePageWithNode:(DownloadNode *)node {
    BBMapDownloadNodeViewController *vc = [[BBMapDownloadNodeViewController alloc] initWithNode:node];
    [[UIViewController xy_getCurrentUIVC].navigationController pushViewController:vc animated:YES];
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
