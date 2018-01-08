//
//  NewDownloadModule.h
//  DownloadExample
//
//  Created by xiaoyuan on 2018/1/8.
//  Copyright © 2018年 xiaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DownloadNode, MapModel;
@interface NewDownloadModule : NSObject

@property(strong, nonatomic) NSMutableArray *dataArray; //保存全部地图数据的数组,每个元素都是node类型
@property(strong, nonatomic) NSMutableArray<DownloadNode *> *displayArray;   //保存要显示在界面上的地图数据的数组(三级目录)
/**
 已经下载完成的地图包(每个元素都是MapModel类型)。
 获取方式:app启动时，通过获取0文件夹下的所有文件夹，文件夹的名称为mapId，根据本地有没有那个文件，而是否添加到_downloadedArray中，添加后从dataArray中移除
 再遍历数据中所有为downloaded状态(下载完成)的地图，从_downloadedArray中查找，如果没有找到，则视为数据库之前未更新，此时更新数据库的状态为未下载和进度为0，
 最后同时遍历_downloadedArray和数据库中已完成的数据，将其替换为数据库中的
 */
@property(strong, nonatomic) NSMutableArray<MapModel *> *downloadedArray;
@property(strong, nonatomic) NSMutableArray *tempDownloadedArray;
@property(strong, nonatomic) NSMutableArray<MapModel *> *downloadFailArray;//下载失败的地图包,用于网络重连时继续下载,下载失败时开启定时下载所有失败的
@property(strong, nonatomic) NSMutableArray<MapModel *> *downloadingArray;//下载中的地图包。(包括暂停、等待、失败、下载中的地图包，每个元素都是MapModel类型)
@property (strong, nonatomic)NSMutableDictionary *mapDic;//保存从json解析下来的所有数据结构, key 为每个洲的名称，value为数组(数组中是字典，为每个洲的国家)
//{欧洲:[{icon:"Country.png, title:England, map:[mapmod,mapmod,...]},...],亚洲:[]...}
@property(strong, nonatomic) NSMutableArray *continentNameArr;//每个元素都是洲名称
@property(strong, nonatomic) NSMutableArray *allMapArray;

+ (NewDownloadModule *)getInstance;
@end
