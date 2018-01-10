//
//  BBMapDownloadBaseViewController.h
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/4.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBMapDownloadNavigationView.h"
#import "BBTableViewSection.h"

@protocol BBMapDownloadViewController <NSObject>

- (void)loadSectionItems;
- (void)clearSectionItems;
- (BOOL)appendSection:(BBTableViewSection *)section;
- (BBTableViewSection *)getSectionWithIdentifier:(NSString *)identifier;
- (BBTableViewSection *)getSectionWithIndex:(NSInteger)index;
- (id<CellModelProtocol>)getCellModelWithIndexPath:(NSIndexPath *)indexPath;
- (void)updateSectionOfTableViewSection:(BBTableViewSection *)section;

@end

@interface BBMapDownloadBaseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, BBMapDownloadViewController>
{
@public
    BBMapDownloadNavigationView *_customNavView;
    UITableView *_tableView;
}

@property (nonatomic, strong) NSMutableArray<BBTableViewSection *> *sectionItems;
@property (nonatomic, strong) BBMapDownloadNavigationView *customNavView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSAttributedString *navTitle;
@property (nonatomic, weak) NSLayoutConstraint *tableViewTopConstraint;
@property (nonatomic, weak) NSLayoutConstraint *tableViewBottomConstraint;


/// 以下方法需要子类重写
- (BOOL)shouldDisplayCustomNavView;
- (void)navigateBackAction:(id)sender;
/// 若重写此方法，则不要重写- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
- (NSAttributedString *)mapDownloadTableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
/// 是否显示组头部视图
- (BOOL)mapDownloadTableView:(UITableView *)tableView shouldDisplayHeaderInSection:(NSInteger)section;
- (BOOL)mapDownloadTableView:(UITableView *)tableView shouldDisplayFooterInSection:(NSInteger)section;
- (NSAttributedString *)mapDownloadTableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
- (UITableViewCell *)mapDownloadTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;


@end
