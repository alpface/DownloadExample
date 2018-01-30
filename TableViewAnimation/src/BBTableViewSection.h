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
@property (nonatomic, strong, readonly) NSArray<NSIndexPath *> *indexPtahsOfSection;
@property (nonatomic, assign) NSInteger sectionOfTable;
@property (nonatomic, copy) NSString *identifier;

- (instancetype)initWithItems:(NSMutableArray<id<CellModelProtocol>> *)items
                  headerTitle:(NSAttributedString *)headerTitle
                  footerTitle:(NSAttributedString *)footerTitle;

- (BOOL)containsCellModel:(id<CellModelProtocol>)anCellModel;
- (BOOL)containsCellModels:(NSArray<id<CellModelProtocol>> *)cellModels
       containedCellModels:(NSArray<id<CellModelProtocol>> *__autoreleasing *)containedCellModels
           otherCellModels:(NSArray<id<CellModelProtocol>> *__autoreleasing *)otherCellModels;
@end

@interface NSArray (BBTableViewSectionExtend)

- (BOOL)containsSection:(BBTableViewSection *)anSection;
- (BOOL)containsSections:(NSArray<BBTableViewSection *> *)anSections
       containedSections:(NSArray<BBTableViewSection *> *__autoreleasing *)containedSections
           otherSections:(NSArray<BBTableViewSection *> *__autoreleasing *)otherSections;

@end
