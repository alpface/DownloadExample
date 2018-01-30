//
//  BBTableDataProcessor.h
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/30.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBTableViewSection.h"

@class BBTableDataProcessor;

@protocol BBTableDataProcessorDelegate <NSObject>

@optional;
- (BOOL)needsClearTableDataWithTableViewModel:(BBTableDataProcessor *)tableViewModel;
- (BOOL)needsAdditionalSectionsWithTableViewModel:(BBTableDataProcessor *)tableViewModel;
- (NSArray<BBTableViewSection *> *)additionalSectionsWithTableViewModel:(BBTableDataProcessor *)tableViewModel;

@end

@protocol BBTableDataProcessor <NSObject>

- (BOOL)appendSection:(BBTableViewSection *)section;
- (BOOL)appendSections:(NSArray<BBTableViewSection *> *)sections;
- (BOOL)insertSection:(BBTableViewSection *)section atIndex:(NSInteger)index;
- (BOOL)removeSection:(BBTableViewSection *)section removedElements:(NSArray<BBTableViewSection *> * __autoreleasing *)removedElements;

- (BBTableViewSection *)getSectionWithIdentifier:(NSString *)identifier;
- (BBTableViewSection *)getSectionWithIndex:(NSInteger)index;
- (id<CellModelProtocol>)getCellModelWithIndexPath:(NSIndexPath *)indexPath;
- (id<CellModelProtocol>)getCellModelWithModel:(id<BBBaseModel>)model inSection:(BBTableViewSection *)section;
- (NSArray<id<CellModelProtocol>> *)getCellModelsWithModel:(id<BBBaseModel>)model;
- (NSArray<UITableViewCell *> *)getCellsWithModel:(id<BBBaseModel>)model;
- (NSArray<NSIndexPath *> *)getIndexPathsWithModel:(id<BBBaseModel>)model;

/// 根据一个model 查找其所在的section
/// cellModel 若要获取model所属的cellModel，可传入其地址，回调给cellModel指针对象
/// @return BBTableViewSection对象 model所在的组
- (BBTableViewSection *)getSectionWithModel:(id<BBBaseModel>)model cellModel:(id<CellModelProtocol> __autoreleasing *)cellModel;

- (BOOL)updateSectionOfTableViewSection:(BBTableViewSection *)section;

- (void)moveCellModel:(id<CellModelProtocol>)cellModel toSection:(BBTableViewSection *)toSection completionBlock:(void (^)(BBTableDataProcessor *processor))completion;
- (void)moveCellModels:(NSMutableArray<id<CellModelProtocol>> *)cellModels toSection:(BBTableViewSection *)toSection completionBlock:(void (^)(BBTableDataProcessor *processor))completion;
- (void)moveCellModelAtIndexPath:(NSIndexPath *)indexPath toSection:(BBTableViewSection *)toSection completionBlock:(void (^)(BBTableDataProcessor *processor))completion;
- (void)deleteCellModelsInSectionsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths completionBlock:(void (^)(BBTableDataProcessor *processor))completion;
- (void)deleteCellModels:(NSArray<id<CellModelProtocol>> *)cellModels inSection:(BBTableViewSection *)section completionBlock:(void (^)(BBTableDataProcessor *processor))completion;
- (void)deleteCellModels:(NSArray<id<CellModelProtocol>> *)cellModels completionBlock:(void (^)(BBTableDataProcessor *processor))completion;
- (void)appendCellModels:(NSArray<id<CellModelProtocol>> *)cellmodels toSection:(BBTableViewSection *)section completionBlock:(void (^)(BBTableDataProcessor *processor))completion;
- (void)appendCellModel:(id<CellModelProtocol>)cellmodel toSection:(BBTableViewSection *)section completionBlock:(void (^)(BBTableDataProcessor *processor))completion;

@end


@interface BBTableDataProcessor : NSObject <BBTableDataProcessor> {
    __weak UITableView *_tableView;
    __weak id<BBTableDataProcessorDelegate> _delegate;
}

@property (nonatomic, strong) NSMutableArray<BBTableViewSection *> *sectionItems;
@property (nonatomic, weak) id<BBTableDataProcessorDelegate> delegate;
@property (nonatomic, weak, readonly) UITableView *tableView;
- (instancetype)initWithTableView:(UITableView *)tableView;
- (void)prepareTableView:(UITableView *)tableView;
- (void)reloadTableWithBlock:(void (^)(void))updateTableBlock completionBlock:(void (^)(BBTableDataProcessor *processor))completion;
@end

