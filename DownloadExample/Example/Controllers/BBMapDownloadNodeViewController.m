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
    
    else if(node.type == 1){
        Download_level1_Model *nodeData = node.nodeData;
        title = nodeData.countryName;
    }
    
    self.navTitle = [[NSAttributedString alloc] initWithString:title];
}

- (void)loadSectionItems {
    [self.sectionItems removeAllObjects];
    [self appendSection:[self section_1]];
    [self.tableView reloadData];
}

- (BBTableViewSection *)section_1 {
    NSMutableArray *items = @[].mutableCopy;
    for (NSInteger i = 0; i < self.node.sonNodes.count; i++) {
        DownloadNode *node = self.node.sonNodes[i];
        if (node.sonNodes.count > 1) {
            // 还有子节点，还可以往下跳
            BBMapDownloadNodeTableViewCellModel *model = [[BBMapDownloadNodeTableViewCellModel alloc] initWithHeight:BBMapDownloadDownloadCellHeight];
            model.model = node;
            model.cellClass = [BBMapDownloadNodeTableViewCell class];
            [items addObject:model];
        }
        else if (node.sonNodes.count == 1) {
            // 类似韩国那种的，只有一个城市，显示BBMapDownloadTableViewCell，点击时不能往下跳
            BBMapDownloadTableViewCellModel *model = [[BBMapDownloadTableViewCellModel alloc] initWithHeight:BBMapDownloadDownloadCellHeight];
            model.model = node.sonNodes.firstObject;
            model.cellClass = [BBMapDownloadTableViewCell class];
            [items addObject:model];
        }
        else {
            // 子节点都没有，就是城市啦
            // 类似韩国那种的，只有一个城市，显示BBMapDownloadTableViewCell，点击时不能往下跳
            BBMapDownloadTableViewCellModel *model = [[BBMapDownloadTableViewCellModel alloc] initWithHeight:BBMapDownloadDownloadCellHeight];
            model.model = node;
            model.cellClass = [BBMapDownloadTableViewCell class];
            [items addObject:model];
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
#pragma mark - UITableViewDelegate
////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BBTableViewSection *section = self.sectionItems[indexPath.section];
    BBMapDownloadBaseItem *item = section.items[indexPath.row];
    if (item.cellClass == [BBMapDownloadNodeTableViewCell class]) {
        [self showDownloadNodePageWithNode:item.model];
    }
    else if (item.class == [BBMapDownloadTableViewCell class]) {
        
    }
    
}


- (NSAttributedString *)mapDownloadTableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    BBTableViewSection *sec = self.sectionItems[section];
    return sec.headerTitle;
}

- (NSAttributedString *)mapDownloadTableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    BBTableViewSection *sec = self.sectionItems[section];
    return sec.footerTitle;
}

- (BOOL)mapDownloadTableView:(UITableView *)tableView shouldDisplayHeaderInSection:(NSInteger)section {
    BBTableViewSection *sec = self.sectionItems[section];
    return sec.headerTitle != nil;
}

- (BOOL)mapDownloadTableView:(UITableView *)tableView shouldDisplayFooterInSection:(NSInteger)section {
    BBTableViewSection *sec = self.sectionItems[section];
    return sec.footerTitle != nil;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Actions
////////////////////////////////////////////////////////////////////////

/// 查看子节点
- (void)showDownloadNodePageWithNode:(DownloadNode *)node {
    BBMapDownloadNodeViewController *vc = [[BBMapDownloadNodeViewController alloc] initWithNode:node];
    [[UIViewController xy_getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

@end
