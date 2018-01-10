//
//  BBMapDownloadNodeViewController.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/4.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBMapDownloadNodeViewController.h"
#import "BBMapDownloadConst.h"
#import "BBMapDownloadTableViewCell.h"
#import "Download_level0_Model.h"
#import "Download_level1_Model.h"
#import "BBMapDownloadNodeTableViewCell.h"
#import "BBMapDownloadBaseItem.h"
#import "Download_level2_Model.h"
#import "DownloadNode.h"

@interface BBMapDownloadNodeViewController ()

@property (nonatomic, strong) DownloadNode *node;

@end

@implementation BBMapDownloadNodeViewController

- (instancetype)initWithNode:(DownloadNode *)node {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.node = node;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[BBMapDownloadTableViewCell class] forCellReuseIdentifier:BBMapDownloadTableViewCell.defaultIdentifier];
    [self.tableView registerClass:[BBMapDownloadNodeTableViewCell class] forCellReuseIdentifier:BBMapDownloadNodeTableViewCell.defaultIdentifier];
    [self loadSectionItems];
    
    
}

- (void)setNode:(DownloadNode *)node {
    _node = node;
    NSString *title = nil;
    if (node.type == 0){
        Download_level0_Model *nodeData = node.nodeData;
        title = nodeData.continentName;
    }
    
    else if (node.type == 1){
        Download_level1_Model *nodeData = node.nodeData;
        title = nodeData.countryName;
    }
    else if (node.type == 2) {
        Download_level2_Model *nodeData = node.nodeData;
        MapModel *map = nodeData.model;
        title = map.titleStr;
    }
    
    self.navTitle = [[NSAttributedString alloc] initWithString:title];
}

- (void)loadSectionItems {
    [self.sectionItems removeAllObjects];
    [self appendSection:[self section_1]];
    [self.tableView reloadData];
}

- (BBTableViewSection *)section_1 {
    
    MapModel *(^getMapModelByNode)(DownloadNode *node) = ^(DownloadNode *node) {
        Download_level2_Model *m = node.nodeData;
        MapModel *city = nil;
        if ([m isKindOfClass:[Download_level2_Model class]]) {
            city = m.model;
        }
        return city;
    };
    NSMutableArray *items = @[].mutableCopy;
    for (NSInteger i = 0; i < self.node.sonNodes.count; i++) {
        DownloadNode *node = self.node.sonNodes[i];
        if (node.sonNodes.count > 1) {
            // 还有子节点，还可以往下跳
            BBMapDownloadNodeTableViewCellModel *model = [[BBMapDownloadNodeTableViewCellModel alloc] initWithHeight:BBMapDownloadDownloadCellHeight target:self action:@selector(clickNodeAction:)];
            model.model = node;
            model.cellClass = [BBMapDownloadNodeTableViewCell class];
            [items addObject:model];
        }
        else if (node.sonNodes.count == 1) {
            // 类似韩国那种的，只有一个城市，显示BBMapDownloadTableViewCell，点击时不能往下跳
            DownloadNode *node1 = node.sonNodes.firstObject;
            MapModel *city = getMapModelByNode(node1);
            if (city) {
                BBMapDownloadTableViewCellModel *model = [[BBMapDownloadTableViewCellModel alloc] initWithHeight:BBMapDownloadDownloadCellHeight];
                model.model = city;
                model.cellClass = [BBMapDownloadTableViewCell class];
                [items addObject:model];
            }
        }
        else {
            // 子节点都没有，就是城市啦
            // 类似韩国那种的，只有一个城市，显示BBMapDownloadTableViewCell，点击时不能往下跳
            MapModel *city = getMapModelByNode(node);
            if (city) {
                BBMapDownloadTableViewCellModel *model = [[BBMapDownloadTableViewCellModel alloc] initWithHeight:BBMapDownloadDownloadCellHeight];
                model.model = city;
                model.cellClass = [BBMapDownloadTableViewCell class];
                [items addObject:model];
            }
            
        }
        
    }
    return [[BBTableViewSection alloc] initWithItems:items headerTitle:nil footerTitle:nil];
}

- (BOOL)shouldDisplayCustomNavView {
    return YES;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource
////////////////////////////////////////////////////////////////////////

- (UITableViewCell *)mapDownloadTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super mapDownloadTableView:tableView cellForRowAtIndexPath:indexPath];
}


////////////////////////////////////////////////////////////////////////
#pragma mark - Actions
////////////////////////////////////////////////////////////////////////

/// 点击节点
- (void)clickNodeAction:(id<BBBaseTableViewCell>)cell {
    [self showDownloadNodePageWithNode:cell.cellModel.model];
}

/// 查看子节点
- (void)showDownloadNodePageWithNode:(DownloadNode *)node {
    BBMapDownloadNodeViewController *vc = [[BBMapDownloadNodeViewController alloc] initWithNode:node];
    [[UIViewController xy_getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

@end
