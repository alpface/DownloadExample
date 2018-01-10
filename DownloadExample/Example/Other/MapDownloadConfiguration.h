//
//  MapDownloadConfiguration.h
//  Boobuz
//
//  Created by xiaoyuan on 06/11/2017.
//  Copyright © 2017 erlinyou.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapDownloadConfiguration : NSObject

/// 是否自动下载失败的
@property (nonatomic, strong, class) NSNumber *shouldAutoDownloadFailure;
/// 是否在wifi下载自动下载地图
@property (nonatomic, strong, class) NSNumber *shouldAutoDownloadInWifi;

@end
