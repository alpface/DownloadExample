//
//  BBTableViewSection.h
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/5.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBMapDownloadBaseItem.h"

@interface BBTableViewSection : NSObject

@property (nonatomic, copy) NSAttributedString *headerTitle;
@property (nonatomic, copy) NSAttributedString *footerTitle;
@property (nonatomic, strong, readonly) NSMutableArray<id<CellModelProtocol>> *items;
@property (nonatomic, assign) NSInteger sectionOfTable;
@property (nonatomic, copy) NSString *identifier;

- (instancetype)initWithItems:(NSMutableArray<id<CellModelProtocol>> *)items
                  headerTitle:(NSAttributedString *)headerTitle
                  footerTitle:(NSAttributedString *)footerTitle;

@end

