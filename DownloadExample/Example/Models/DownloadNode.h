//
//  DownloadNode.h
//  nav
//
//  Created by chenyueqing on 15/5/6.
//  Copyright (c) 2015年 erlinyou.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadNode : NSObject

@property (nonatomic, assign) int  nodeLevel; //节点所处层次
@property (nonatomic, assign) int  type;      //节点类型
@property (nonatomic, strong) id   nodeData;  //节点数据
@property (nonatomic, assign) BOOL isExpanded;//节点是否展开
@property (nonatomic, strong) NSMutableArray  * sonNodes;//子节点

@end
