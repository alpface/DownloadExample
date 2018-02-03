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

/// 添加、删除
- (BOOL)appendSection:(BBTableViewSection *)section;
- (BOOL)appendSections:(NSArray<BBTableViewSection *> *)sections;
- (BOOL)insertSection:(BBTableViewSection *)section atIndex:(NSInteger)index;
- (BOOL)removeSection:(BBTableViewSection *)section removedElements:(NSArray<BBTableViewSection *> * __autoreleasing *)removedElements;

/// 查找
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

/// 更新某个section的索引
/// @param section 指定的section
/// @return 如果更新成功返回YES，如未找到则返回NO
- (BOOL)updateSectionOfTableViewSection:(BBTableViewSection *)section;

/// 移动一组cellModel到一个BBTableViewSection中，并刷新tableView
/// @param cellModels 需要移动的cellModels
/// @param toSection 指定的那组对象
/// @param completion 刷新tableView完成后回调block
- (void)moveCellModels:(NSMutableArray<id<CellModelProtocol>> *)cellModels toSection:(BBTableViewSection *)toSection completionBlock:(void (^)(BBTableDataProcessor *processor))completion;
- (void)moveCellModel:(id<CellModelProtocol>)cellModel toSection:(BBTableViewSection *)toSection completionBlock:(void (^)(BBTableDataProcessor *processor))completion;
- (void)moveCellModelAtIndexPath:(NSIndexPath *)indexPath toSection:(BBTableViewSection *)toSection completionBlock:(void (^)(BBTableDataProcessor *processor))completion;

/// 从section中 删除一组cellModel，并刷新tableView，如果section为nil则从当前sectionItems中查找其所在的section，找到了就移除
/// @param cellModels 需要删除cellModels
/// @param section 指定的那组对象
/// @param completion 刷新tableView完成后回调block
- (void)deleteCellModels:(NSArray<id<CellModelProtocol>> *)cellModels inSection:(BBTableViewSection *)section completionBlock:(void (^)(BBTableDataProcessor *processor))completion;
- (void)deleteCellModelsInSectionsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths completionBlock:(void (^)(BBTableDataProcessor *processor))completion;
- (void)deleteCellModels:(NSArray<id<CellModelProtocol>> *)cellModels completionBlock:(void (^)(BBTableDataProcessor *processor))completion;

/// 添加一组cellModel 到某组中，并刷新tableView
/// @param cellmodels 需要添加的cellModels
/// @param section 指定添加到的那组
/// @param completion 刷新tableView完成后回调block
- (void)appendCellModels:(NSArray<id<CellModelProtocol>> *)cellmodels toSection:(BBTableViewSection *)section completionBlock:(void (^)(BBTableDataProcessor *processor))completion;
- (void)appendCellModel:(id<CellModelProtocol>)cellmodel toSection:(BBTableViewSection *)section completionBlock:(void (^)(BBTableDataProcessor *processor))completion;

/// 刷新一组cellModel对应的cells
/// @param cellModels 需要刷新的cellModels
/// @param section 指定其所在的组，如果cellModels的每一个元素都不在该组中，则不执行任何操作
/// @param animation 指定刷新tableView的动画效果
/// @param reloadElements 刷新完成后回调的，已刷新的数组指针对象
- (void)reloadCellModels:(NSArray<id<CellModelProtocol>> *)cellModels
               atSection:(BBTableViewSection *)section
        withRowAnimation:(UITableViewRowAnimation)animation
          reloadElements:(NSArray<id<CellModelProtocol>> *__autoreleasing *)reloadElements;
- (void)reloadCellModels:(NSArray<id<CellModelProtocol>> *)cellModels
               atSection:(BBTableViewSection *)section
        withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadCellModels:(NSArray<id<CellModelProtocol>> *)cellModels;
- (void)reloadCellModels:(NSArray<id<CellModelProtocol>> *)cellModels
               atSection:(BBTableViewSection *)section;
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

