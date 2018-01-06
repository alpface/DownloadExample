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
#import "BBMapContinentDetailViewController.h"
#import "BBMapDownloadConst.h"
#import "BBMapDownloadHotCityTableViewCell.h"
#import "UIViewController+XYExtensions.h"

@interface BBAllMapViewController ()

@end

@implementation BBAllMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[BBMapContinentTableViewCell class] forCellReuseIdentifier:BBMapContinentTableViewCell.defaultIdentifier];
    [self.tableView registerClass:[BBMapDownloadTableViewCell class] forCellReuseIdentifier:BBMapDownloadTableViewCell.defaultIdentifier];
    [self.tableView registerClass:[BBMapDownloadHotCityTableViewCell class] forCellReuseIdentifier:BBMapDownloadHotCityTableViewCell.defaultIdentifier];
    
    [self loadSectionItems];
    
}

- (void)loadSectionItems {
    [self.sectionItems removeAllObjects];
    [self appendSection:[self currentLocationSection]];
    [self appendSection:[self hotCitySection]];
    [self appendSection:[self allMapsSection]];
    [self.tableView reloadData];
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
    for (NSInteger i = 0; i < 6; i++) {
        BBMapContinentTableViewCellModel *model = [[BBMapContinentTableViewCellModel alloc] initWithHeight:BBMapDownloadContinentCellHeight];
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
    
    if (indexPath.section == 2) {
        BBMapContinentDetailViewController *vc = [[BBMapContinentDetailViewController alloc] init];
        vc.navTitle = [[NSAttributedString alloc] initWithString:@"亚洲"];
        [[UIViewController xy_getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }
}

@end
