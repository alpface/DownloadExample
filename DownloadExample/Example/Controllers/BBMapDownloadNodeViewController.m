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

@interface BBMapDownloadNodeViewController ()

@property (nonatomic, strong) id node;

@end

@implementation BBMapDownloadNodeViewController

- (instancetype)initWithNode:(id)node {
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
    [self loadSectionItems];
    
    
}

- (void)setNode:(id)node {
    _node = node;
    NSString *title = node;
    
    self.navTitle = [[NSAttributedString alloc] initWithString:title];
}

- (void)loadSectionItems {
    [self.sectionItems removeAllObjects];
    [self.sectionItems addObject:[self section_1]];
    [self.tableView reloadData];
}

- (BBTableViewSection *)section_1 {
    NSMutableArray *items = @[].mutableCopy;
    for (NSInteger i = 0; i < 10; i++) {
        BBMapDownloadTableViewCellModel *model = [[BBMapDownloadTableViewCellModel alloc] initWithHeight:BBMapDownloadDownloadCellHeight];
        [items addObject:model];
    }
    return [[BBTableViewSection alloc] initWithItems:items headerTitle:nil footerTitle:nil];
}

- (BOOL)shouldDisplayCustomNavView {
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBMapDownloadBaseItem *item = self.sectionItems[indexPath.section].items[indexPath.row];
    if ([item isKindOfClass:[BBMapDownloadTableViewCellModel class]]) {
        BBMapDownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BBMapDownloadTableViewCell.defaultIdentifier forIndexPath:indexPath];
        
        return cell;
        
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBMapDownloadBaseItem *item = self.sectionItems[indexPath.section].items[indexPath.row];
    return item.height;
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

@end
