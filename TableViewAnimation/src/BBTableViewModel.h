//
//  BBTableViewModel.h
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/19.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBTableDataProcessor.h"
#import "BBTableViewSection.h"

@class BBTableViewModel;

@protocol BBTableViewModelDelegate <BBTableDataProcessorDelegate>

@optional;
/// 是否显示组头部视图
- (BOOL)tableViewModel:(BBTableViewModel *)tableViewModel shouldDisplayHeaderInSection:(BBTableViewSection *)section;
- (BOOL)tableViewModel:(BBTableViewModel *)tableViewModel shouldDisplayFooterInSection:(BBTableViewSection *)section;

@end

@interface BBTableViewModel : BBTableDataProcessor <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<BBTableViewModelDelegate> delegate;

@end

