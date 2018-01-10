//
//  BBMapDownloadHotCityTableViewCell.h
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/5.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBBaseTableViewCell.h"

@class MapModel;

@interface BBMapDownloadHotCityTableViewCell : UITableViewCell <BBBaseTableViewCell>

@property (nonatomic, strong, readonly) NSArray<MapModel *> *hotCityList;

@end
