//
//  BBTableDataProcessor.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/30.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBTableDataProcessor.h"

@implementation BBTableDataProcessor

@synthesize delegate = _delegate;
@synthesize tableView = _tableView;

- (instancetype)initWithTableView:(UITableView *)tableView {
    if (self = [super init]) {
        [self prepareTableView:tableView];
    }
    return self;
}

- (void)prepareTableView:(UITableView *)tableView {
    NSParameterAssert(tableView && [tableView isKindOfClass:[UITableView class]]);
    _tableView = tableView;
}

- (NSMutableArray<BBTableViewSection *> *)sectionItems {
    if (!_sectionItems) {
        _sectionItems = @[].mutableCopy;
    }
    return _sectionItems;
}


/// 当sections中有数据时，才会添加这些附加组
- (BOOL)needsAdditionalSections {
    if (self.delegate && [self.delegate respondsToSelector:@selector(needsAdditionalSectionsWithTableViewModel:)]) {
        return [self.delegate needsAdditionalSectionsWithTableViewModel:self];
    }
    return self.sectionItems.count && !self.additionalSections.count;
}

/// 需要添加的附加组，当sections中有数据时，才会添加这些附加组
- (NSArray<BBTableViewSection *> *)additionalSections {
    if (self.delegate && [self.delegate respondsToSelector:@selector(additionalSectionsWithTableViewModel:)]) {
        return [self.delegate additionalSectionsWithTableViewModel:self];
    }
    return nil;
}

// 判断剩余的数据是否足以展示
- (BOOL)needsClearTableData {

    if (self.delegate && [self.delegate respondsToSelector:@selector(needsClearTableDataWithTableViewModel:)]) {
        return [self.delegate needsClearTableDataWithTableViewModel:self];
    }
    return !self.sectionItems.count;
}



////////////////////////////////////////////////////////////////////////
#pragma mark - Operation section
////////////////////////////////////////////////////////////////////////


- (BOOL)appendSection:(BBTableViewSection *)section {
    if (!section) {
        return NO;
    }
    NSParameterAssert([section isKindOfClass:[BBTableViewSection class]]);
    if (![self.sectionItems containsSection:section]) {
        [self.sectionItems addObject:section];
        return YES;
    }
    return NO;
}

- (BOOL)appendSections:(NSArray<BBTableViewSection *> *)sections {
    if (!sections.count) {
        return NO;
    }
    NSArray *others = nil;
    [self.sectionItems containsSections:sections containedSections:nil otherSections:&others];
    if (others.count) {
        [self.sectionItems addObjectsFromArray:sections];
        return YES;
    }
    
    return NO;
}

- (BOOL)insertSection:(BBTableViewSection *)section atIndex:(NSInteger)index {
    if (!section) {
        return NO;
    }
    if ([self.sectionItems containsSection:section]) {
        return NO;
    }
    if (index < self.sectionItems.count) {
        [self.sectionItems insertObject:section atIndex:index];
    }
    else {
        [self.sectionItems addObject:section];
    }
    return YES;
}

- (BBTableViewSection *)getSectionWithIdentifier:(NSString *)identifier {
    NSUInteger foundIdx = [self.sectionItems indexOfObjectPassingTest:^BOOL(BBTableViewSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL res = [obj.identifier isEqualToString:identifier];
        if (res) {
            *stop = YES;
        }
        return res;
    }];
    if (self.sectionItems && foundIdx != NSNotFound) {
        return [self.sectionItems objectAtIndex:foundIdx];
    }
    return nil;
}


- (BBTableViewSection *)getSectionWithModel:(id<BBBaseModel>)model cellModel:(__autoreleasing id<CellModelProtocol> *)cellModel {
    if (!model) {
        return nil;
    }
    __block BBTableViewSection *sec = nil;
    [self.sectionItems enumerateObjectsUsingBlock:^(BBTableViewSection * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger foundIdx = [section.items indexOfObjectPassingTest:^BOOL(id<CellModelProtocol>  _Nonnull cellModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            BOOL res = NO;
            if ([cellModel.model isEqualToModel:model]) {
                *stop = YES;
                res = YES;
            }
            return res;
        }];
        if (section.items && foundIdx != NSNotFound) {
            if (cellModel) {
                *cellModel = [section.items objectAtIndex:foundIdx];
            }
            *stop = YES;
            sec = section;
        }
    }];
    return sec;
}

- (BBTableViewSection *)getSectionWithCellModel:(id<CellModelProtocol>)cm indexPathOfSection:(NSIndexPath * __autoreleasing *)idxPathOfSec {
    if (!cm) {
        return nil;
    }
    __block BBTableViewSection *sec = nil;
    [self.sectionItems enumerateObjectsUsingBlock:^(BBTableViewSection * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger foundIdx = [section.items indexOfObjectPassingTest:^BOOL(id<CellModelProtocol>  _Nonnull cellModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            BOOL res = NO;
            if (cm == cellModel) {
                *stop = YES;
                res = YES;
            }
            return res;
        }];
        section.sectionOfTable = idx;
        if (section.items && foundIdx != NSNotFound) {
            if (idxPathOfSec) {
                *idxPathOfSec = [NSIndexPath indexPathForRow:foundIdx inSection:idx];
            }
            *stop = YES;
            sec = section;
        }
    }];
    return sec;
}


- (BBTableViewSection *)getSectionWithIndex:(NSInteger)index {
    if (index >= self.sectionItems.count) {
        return nil;
    }
    return [self.sectionItems objectAtIndex:index];
}

- (NSIndexPath *)getIndexPathWithCellModel:(id<CellModelProtocol>)cellModel {
    
    if (!cellModel) {
        return nil;
    }
    
    __block NSIndexPath *indexPath = nil;
    [self.sectionItems enumerateObjectsUsingBlock:^(BBTableViewSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger foundIdx = NSNotFound;
        obj.sectionOfTable = idx;
        if (obj.items) {
            foundIdx = [obj.items indexOfObject:cellModel];
        }
        if (foundIdx != NSNotFound) {
            *stop = YES;
            indexPath = [NSIndexPath indexPathForRow:foundIdx inSection:idx];
        }
    }];
    
    return indexPath;
}

- (id<CellModelProtocol>)getCellModelWithIndexPath:(NSIndexPath *)indexPath {
    BBTableViewSection *section = [self getSectionWithIndex:indexPath.section];
    if (!section) {
        return nil;
    }
    
    if (indexPath.row >= section.items.count) {
        return nil;
    }
    return [section.items objectAtIndex:indexPath.row];
}


- (BOOL)removeObjectInSectionsAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!indexPath) {
        return NO;
    }
    if (indexPath.section >= self.sectionItems.count) {
        return NO;
    }
    NSMutableArray *items = self.sectionItems[indexPath.section].items;
    if (!items.count || indexPath.row >= items.count) {
        [items removeObjectAtIndex:indexPath.row];
        return YES;
    }
    return NO;
}

- (void)removeObjectsInSectionsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths removedIndexPaths:(NSArray<NSIndexPath *> * __autoreleasing *)removedIndexPaths {
    
    if (!indexPaths.count) {
        return;
    }
    
    NSMutableArray *removeds = @[].mutableCopy;
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        if (indexPath.section >= self.sectionItems.count) {
            return;
        }
        NSMutableArray *items = self.sectionItems[indexPath.section].items;
        if (!items.count || indexPath.row >= items.count) {
            [items removeObjectAtIndex:indexPath.row];
            [removeds addObject:indexPath];
        }
    }];
    
    if (removedIndexPaths) {
        *removedIndexPaths = removeds;
    }
}

- (BOOL)removeObject:(id<CellModelProtocol>)cellModel removedIndexPath:(NSIndexPath * __autoreleasing *)indexPath {
    
    if (!cellModel || !self.sectionItems.count) {
        return NO;
    }
    
    __block BOOL res = NO;
    [self.sectionItems enumerateObjectsUsingBlock:^(BBTableViewSection * _Nonnull obj, NSUInteger sectionIndex, BOOL * _Nonnull stop) {
        obj.sectionOfTable = sectionIndex;
        NSInteger foundIdx = NSNotFound;
        if (obj.items) {
            foundIdx = [obj.items indexOfObject:cellModel];
        }
        if (foundIdx != NSNotFound) {
            *stop = YES;
            if (indexPath) {
                *indexPath = [NSIndexPath indexPathForRow:foundIdx inSection:sectionIndex];
            }
            [obj.items removeObjectAtIndex:foundIdx];
            res = YES;
        }
    }];
    
    
    return res;
}

- (void)removeObjects:(NSArray<id<CellModelProtocol>> *)cellModels removedIndexPaths:(NSArray<NSIndexPath *> * __autoreleasing *)indexPaths {
    
    if (!cellModels.count || !self.sectionItems.count) {
        return;
    }
    
    NSMutableArray *removedIndexPaths = @[].mutableCopy;
    [cellModels enumerateObjectsUsingBlock:^(id<CellModelProtocol>  _Nonnull cellModel, NSUInteger index, BOOL * _Nonnull stop) {
        [self.sectionItems enumerateObjectsUsingBlock:^(BBTableViewSection * _Nonnull section, NSUInteger sectionIndex, BOOL * _Nonnull stop) {
            section.sectionOfTable = sectionIndex;
            NSInteger foundIdx = NSNotFound;
            if (section.items) {
                foundIdx = [section.items indexOfObject:cellModel];
            }
            if (foundIdx != NSNotFound) {
                // 获取最新的indexPath
                cellModel.indexPathOfTable = [NSIndexPath indexPathForRow:foundIdx inSection:sectionIndex];
                if (indexPaths) {
                    [removedIndexPaths addObject:cellModel.indexPathOfTable];
                }
                [section.items removeObjectAtIndex:foundIdx];
                return;
            }
        }];
    }];
    if (indexPaths) {
        *indexPaths = removedIndexPaths.copy;
    }
    
}

- (BOOL)updateSectionOfTableViewSection:(BBTableViewSection *)section {
    return (section.sectionOfTable = [self.sectionItems indexOfObject:section]) != NSNotFound;
}
// 移除某些组时，如果剩余的数据不足以展示了，就把其他的元素都移除掉
- (BOOL)removeSection:(BBTableViewSection *)section removedElements:(NSArray<BBTableViewSection *> *__autoreleasing *)removedElements {
    if (!section || ![self.sectionItems containsSection:section]) {
        return NO;
    }
    // 移除这一组
    [self.sectionItems removeObject:section];
    // 移除组完成后，检查其他组的数据中是否有需要显示的(比如没有下载组、没有完成组、没有更新组，就算么有)，就清空数据源
    NSMutableArray *rm = @[].mutableCopy;
    [rm addObject:section];
    if ([self needsClearTableData]) {
        [rm addObjectsFromArray:self.sectionItems];
        [self.sectionItems removeAllObjects];
    }
    if (removedElements) {
        *removedElements = rm.copy;
    }
    return YES;
}

// 移除某些组时，如果剩余的数据不足以展示了，就把其他的元素都移除掉
- (BOOL)removeSections:(NSArray<BBTableViewSection *> *)sections removedElements:(NSArray<BBTableViewSection *> *__autoreleasing *)removedElements {
    if (!sections.count) {
        return NO;
    }
    // 移除这些组
    [self.sectionItems removeObjectsInArray:sections];
    // 移除组完成后，检查其他组的数据中是否有需要显示的(比如没有下载组、没有完成组、没有更新组，就算么有)，就清空数据源
    if (!self.sectionItems.count) {
        if (removedElements) {
            *removedElements = sections.mutableCopy;
        }
        return YES;
    }
    // 判断sectionItems中剩余的数据是否足以展示，不足展示就移除掉
    NSMutableArray *rm = @[].mutableCopy;
    [rm addObjectsFromArray:sections];
    if ([self needsClearTableData]) {
        [rm addObjectsFromArray:self.sectionItems];
        [self.sectionItems removeAllObjects];
    }
    if (removedElements) {
        *removedElements = rm.copy;
    }
    return YES;
}


////////////////////////////////////////////////////////////////////////
#pragma mark - Get table data
////////////////////////////////////////////////////////////////////////


- (NSArray<UITableViewCell *> *)getCellsWithModel:(id<BBBaseModel>)model {
    if (!model) {
        return nil;
    }
    NSMutableArray<UITableViewCell *> *items = @[].mutableCopy;
    [self.sectionItems enumerateObjectsUsingBlock:^(BBTableViewSection * _Nonnull section, NSUInteger sectionIdx, BOOL * _Nonnull stop) {
        NSInteger foundIdx = [section.items indexOfObjectPassingTest:^BOOL(id<CellModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL res = NO;
            if ([model isEqualToModel:obj.model]) {
                *stop = YES;
                res = YES;
            }
            return res;
        }];
        
        if (section.items.count && foundIdx != NSNotFound) {
            BBMapDownloadTableViewCellModel *cellModel = section.items[foundIdx];
            cellModel.indexPathOfTable = [NSIndexPath indexPathForRow:foundIdx inSection:sectionIdx];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:cellModel.indexPathOfTable];
            if (cell) {
                [items addObject:cell];
            }
        }
    }];
    return items;
}


- (id<CellModelProtocol>)getCellModelWithModel:(id<BBBaseModel>)model inSection:(BBTableViewSection *)section {
    
    if (model == nil) {
        return nil;
    }
    
    NSInteger foundIdx = [section.items indexOfObjectPassingTest:^BOOL(id<CellModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL res = NO;
        if ([model isEqualToModel:obj.model]) {
            *stop = YES;
            res = YES;
        }
        return res;
    }];
    if (section.items.count && foundIdx != NSNotFound) {
        return section.items[foundIdx];
    }
    
    return nil;
}

- (NSArray<id<CellModelProtocol>> *)getCellModelsWithModel:(id<BBBaseModel>)model {
    NSMutableArray<id<CellModelProtocol>> *items = @[].mutableCopy;
    [self.sectionItems enumerateObjectsUsingBlock:^(BBTableViewSection * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger foundIdx = [section.items indexOfObjectPassingTest:^BOOL(id<CellModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL res = NO;
            if ([model isEqualToModel:obj.model]) {
                *stop = YES;
                res = YES;
            }
            return res;
        }];
        if (section.items.count && foundIdx != NSNotFound) {
            [items addObject:section.items[foundIdx]];
        }
    }];
    return items;
}




- (NSArray<NSIndexPath *> *)getIndexPathsWithModel:(id<BBBaseModel>)model {
    NSMutableArray<NSIndexPath *> *items = @[].mutableCopy;
    [self.sectionItems enumerateObjectsUsingBlock:^(BBTableViewSection * _Nonnull section, NSUInteger secIdx, BOOL * _Nonnull stop) {
        NSInteger foundIdx = [section.items indexOfObjectPassingTest:^BOOL(id<CellModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL res = NO;
            if ([model isEqualToModel:obj.model]) {
                *stop = YES;
                res = YES;
            }
            return res;
        }];
        if (section.items.count && foundIdx != NSNotFound) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:foundIdx inSection:secIdx];
            [items addObject:indexPath];
        }
    }];
    return items;
}


////////////////////////////////////////////////////////////////////////
#pragma mark - Operation table view
////////////////////////////////////////////////////////////////////////
- (void)deleteCellModelsInSectionsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths completionBlock:(void (^)(BBTableDataProcessor *processor))completion {
    
    if (!indexPaths.count) {
        return;
    }
    
    [self reloadTableWithBlock:^{
        // 移动时，如果这一组只有这一个元素，就从sectionItems中移除这组
        NSArray *removedIndexPaths = nil;
        [self removeObjectsInSectionsAtIndexPaths:indexPaths removedIndexPaths:&removedIndexPaths];
        
        NSMutableArray *needRemoveSections = @[].mutableCopy;
        // 移除成功时，且此时removedIndexPaths中每一组的items，只要个数为0.就将这一组从sectionItems中移除
        [removedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath *  _Nonnull removedIndexPath, NSUInteger idx, BOOL * _Nonnull stop) {
            BBTableViewSection *sec1 = self.sectionItems[removedIndexPath.section];
            if (![needRemoveSections containsSection:sec1] &&
                !sec1.items.count) {
                // 注意: 遍历中不要直接移除sectionItems的元素，不然对下次遍历有影响
                [needRemoveSections addObject:sec1];
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:removedIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else {
                [self.tableView deleteRowsAtIndexPaths:@[removedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
        
        if (needRemoveSections.count) {
            [self.sectionItems removeObjectsInArray:needRemoveSections];
        }
        if ([self needsClearTableData]) {
            // 移除某些组时，如果剩余的数据不足以展示了，就把其他的元素都移除掉
            [self.sectionItems enumerateObjectsUsingBlock:^(BBTableViewSection * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:section.sectionOfTable] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
            [self.sectionItems removeAllObjects];
        }
    } completionBlock:completion];
    
}

- (void)deleteCellModels:(NSArray<id<CellModelProtocol>> *)cellModels completionBlock:(void (^)(BBTableDataProcessor *processor))completion {
    [self deleteCellModels:cellModels inSection:nil completionBlock:completion];
}

- (void)deleteCellModels:(NSArray<id<CellModelProtocol>> *)cellModels inSection:(BBTableViewSection *)section completionBlock:(void (^)(BBTableDataProcessor *processor))completion {
    
    if (!cellModels.count) {
        return;
    }
    
    if (!section) {
        [self reloadTableWithBlock:^{
            // 移动时，如果这一组只有这一个元素，就从sectionItems中移除这组
            NSArray *removedIndexPaths = nil;
            [self removeObjects:cellModels removedIndexPaths:&removedIndexPaths];
            NSMutableArray *needRemoveSections = @[].mutableCopy;
            // 移除成功时，且此时removedIndexPaths中每一组的items，只要个数为0.就将这一组从sectionItems中移除
            [removedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath *  _Nonnull removedIndexPath, NSUInteger idx, BOOL * _Nonnull stop) {
                BBTableViewSection *sec1 = self.sectionItems[removedIndexPath.section];
                if (![needRemoveSections containsSection:sec1] &&
                    !sec1.items.count) {
                    // 注意: 遍历中不要直接移除sectionItems的元素，不然对下次遍历有影响
                    [needRemoveSections addObject:sec1];
                    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:removedIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                else {
                    [self.tableView deleteRowsAtIndexPaths:@[removedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }];
            // 当某一组移除了，新的组的index就要减1
            if (needRemoveSections.count) {
                [self.sectionItems removeObjectsInArray:needRemoveSections];
            }
            if ([self needsClearTableData]) {
                // 移除某些组时，如果剩余的数据不足以展示了，就把其他的元素都移除掉
                [self.sectionItems enumerateObjectsUsingBlock:^(BBTableViewSection * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:section.sectionOfTable] withRowAnimation:UITableViewRowAnimationAutomatic];
                }];
                [self.sectionItems removeAllObjects];
            }
        } completionBlock:completion];
    }
    else {
        // 移动时，如果这一组只有这一个元素，就从sectionItems中移除这组
        [section.items removeObjectsInArray:cellModels];
        [self updateSectionOfTableViewSection:section];
        if (!section.items.count) {
            [self reloadTableWithBlock:^{
                // 移除这一组的同时，如果其他组没有数据了，就要移除全部的组
                NSArray *removedElements = nil;
                BOOL isSuccess = [self removeSection:section removedElements:&removedElements];
                if (isSuccess) {
                    __weak typeof (&*self) weakSelf = self;
                    [removedElements enumerateObjectsUsingBlock:^(BBTableViewSection *  _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
                        __strong typeof(&*weakSelf) self = weakSelf;
                        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:section.sectionOfTable] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }];
                }
                
            } completionBlock:completion];
        }
        else {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section.sectionOfTable] withRowAnimation:UITableViewRowAnimationAutomatic];
            if (completion) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    completion(self);
                });
            }
        }
        
    }
    
}

- (void)appendCellModels:(NSArray<id<CellModelProtocol>> *)cellmodels toSection:(BBTableViewSection *)section completionBlock:(void (^)(BBTableDataProcessor *processor))completion {
    if (!cellmodels.count || !section) {
        return;
    }
    NSArray *otherCellModels = nil;
    [section containsCellModels:cellmodels containedCellModels:nil otherCellModels:&otherCellModels];
    [section.items addObjectsFromArray:otherCellModels];
    if (![self.sectionItems containsSection:section]) {
        [self reloadTableWithBlock:^{
            [self insertSection:section atIndex:section.sectionOfTable];
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:section.sectionOfTable] withRowAnimation:UITableViewRowAnimationAutomatic];
            if (self.needsAdditionalSections) {
                __block NSInteger newSectionIdx = self.sectionItems.count;
                [self.additionalSections enumerateObjectsUsingBlock:^(BBTableViewSection * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:newSectionIdx] withRowAnimation:UITableViewRowAnimationAutomatic];
                    newSectionIdx++;
                }];
                [self.sectionItems addObjectsFromArray:self.additionalSections];
            }
        } completionBlock:completion];
    }
    else {
        [self updateSectionOfTableViewSection:section];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section.sectionOfTable] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (completion) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                completion(self);
            });
        }
    }
    
}

- (void)appendCellModel:(id)cellmodel toSection:(BBTableViewSection *)section completionBlock:(void (^)(BBTableDataProcessor *processor))completion {
    if (!cellmodel || !section) {
        return;
    }
    if (![section containsCellModel:cellmodel]) {
        [section.items addObject:cellmodel];
    }
    if (![self.sectionItems containsSection:section]) {
        [self reloadTableWithBlock:^{
            [self insertSection:section atIndex:section.sectionOfTable];////////// section.sectionOfTable尽然没找到/////////////
            [self updateSectionOfTableViewSection:section];
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:section.sectionOfTable] withRowAnimation:UITableViewRowAnimationAutomatic];
            if (self.needsAdditionalSections) {
                __block NSInteger newSectionIdx = self.sectionItems.count;
                [self.additionalSections enumerateObjectsUsingBlock:^(BBTableViewSection * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:newSectionIdx] withRowAnimation:UITableViewRowAnimationAutomatic];
                    newSectionIdx++;
                }];
                [self.sectionItems addObjectsFromArray:self.additionalSections];
            }
        } completionBlock:completion];
    }
    else {
        [self updateSectionOfTableViewSection:section];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section.sectionOfTable] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (completion) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                completion(self);
            });
        }
    }
}

- (void)moveCellModelAtIndexPath:(NSIndexPath *)indexPath toSection:(BBTableViewSection *)toSection completionBlock:(void (^)(BBTableDataProcessor *processor))completion {
    
    // 当传入参数是错误的时，会导致下面的逻辑错误，所以不要传错数据
    NSParameterAssert(toSection && indexPath.section < self.sectionItems.count && indexPath.row < self.sectionItems[indexPath.section].items.count);
    
    if (!toSection) {
        return;
    }
    if (indexPath.section >= self.sectionItems.count) {
        return;
    }
    BBTableViewSection *orSec = self.sectionItems[indexPath.section];
    if (indexPath.row >= orSec.items.count) {
        return;
    }
    
    [self reloadTableWithBlock:^{
        // 移动时，如果这一组只有这一个元素，就从sectionItems中移除这组
        id<CellModelProtocol> cellModel = orSec.items[indexPath.row];
        if (orSec.items.count == 1) {
            [self.sectionItems removeObject:orSec];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        if (![self.sectionItems containsSection:toSection]) {
            [self insertSection:toSection atIndex:MAX(0, toSection.sectionOfTable)];
        }
        [self updateSectionOfTableViewSection:toSection];
        
        // 当toSection.items的count为0时，我会认定他为刚添加的一组
        // 因为当item.count为0时，我会将他从sectionItems移除
        BOOL isNewSection = toSection.items.count == 0;
        BOOL isConstaintsCellModel = [toSection containsCellModel:cellModel];
        if (!isConstaintsCellModel) {
            [toSection.items addObject:cellModel];
        }
        if (isNewSection) {
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:toSection.sectionOfTable] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else {
            if (!isConstaintsCellModel) {
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:toSection.items.count-1 inSection:toSection.sectionOfTable];
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    } completionBlock:completion];
}

- (void)moveCellModel:(id<CellModelProtocol>)cellModel toSection:(BBTableViewSection *)toSection completionBlock:(void (^)(BBTableDataProcessor *processor))completion {
    // 当传入参数是错误的时，会导致下面的逻辑错误，所以不要传错数据
    NSParameterAssert(toSection && cellModel);
    
    if (!toSection) {
        return;
    }
    
    [self reloadTableWithBlock:^{
        // 移动时，如果这一组只有这一个元素，就从sectionItems中移除这组
        NSIndexPath *removedIndexPath = nil;
        NSInteger newSectionIndex = toSection.sectionOfTable;
        BOOL isRemoveSuccess = [self removeObject:cellModel removedIndexPath:&removedIndexPath];
        if (isRemoveSuccess) {
            // 移除成功时，且此时removedIndexPath这一组的items个数为0.就将这一组从sectionItems中移除
            BBTableViewSection *sec1 = self.sectionItems[removedIndexPath.section];
            if (!sec1.items.count) {
                [self.sectionItems removeObjectAtIndex:removedIndexPath.section];
                // @note deleteSections:时， 没有执行endUpdates时，不要section的index还是原index，不要--
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:removedIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                newSectionIndex--;
                newSectionIndex = MAX(0, newSectionIndex);
            }
            else {
                [self.tableView deleteRowsAtIndexPaths:@[removedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
        }
        
        if (![self.sectionItems containsSection:toSection]) {
            [self insertSection:toSection atIndex:MAX(0, newSectionIndex)];
        }
        [self updateSectionOfTableViewSection:toSection];
        
        
        // 当toSection.items的count为0时，我会认定他为刚添加的一组
        // 因为当item.count为0时，我会将他从sectionItems移除
        BOOL isNewSection = toSection.items.count == 0;
        BOOL isConstaintsCellModel = [toSection containsCellModel:cellModel];
        if (!isConstaintsCellModel) {
            [toSection.items addObject:cellModel];
        }
        if (isNewSection) {
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:toSection.sectionOfTable] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else {
            if (!isConstaintsCellModel) {
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:toSection.items.count-1 inSection:toSection.sectionOfTable];
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    } completionBlock:completion];
}

- (void)moveCellModels:(NSMutableArray<id<CellModelProtocol>> *)cellModels toSection:(BBTableViewSection *)toSection completionBlock:(void (^)(BBTableDataProcessor *processor))completion  {
    // 当传入参数是错误的时，会导致下面的逻辑错误，所以不要传错数据
    NSParameterAssert(cellModels.count && toSection);
    
    if (!toSection) {
        return;
    }
    
    [self reloadTableWithBlock:^{
        // 移动时，如果这一组只有这一个元素，就从sectionItems中移除这组
        NSArray *removedIndexPaths = nil;
        [self removeObjects:cellModels removedIndexPaths:&removedIndexPaths];
        NSMutableArray *needRemoveSections = @[].mutableCopy;
        // 移除成功时，且此时removedIndexPaths中每一组的items，只要个数为0.就将这一组从sectionItems中移除
        [removedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath *  _Nonnull removedIndexPath, NSUInteger idx, BOOL * _Nonnull stop) {
            BBTableViewSection *sec1 = self.sectionItems[removedIndexPath.section];
            if (![needRemoveSections containsSection:sec1] &&
                !sec1.items.count) {
                // 注意: 遍历中不要直接移除sectionItems的元素，不然对下次遍历有影响
                [needRemoveSections addObject:sec1];
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:removedIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else {
                [self.tableView deleteRowsAtIndexPaths:@[removedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
        
        // 当某一组移除了，新的组的index就要减1
        NSInteger newSectionIndex = toSection.sectionOfTable;
        if (needRemoveSections.count) {
            [self.sectionItems removeObjectsInArray:needRemoveSections];
            newSectionIndex--;
            newSectionIndex = MAX(0, newSectionIndex);
        }
        
        if (![self.sectionItems containsSection:toSection]) {
            [self insertSection:toSection atIndex:newSectionIndex];
        }
        
        [self updateSectionOfTableViewSection:toSection];
        
        [cellModels enumerateObjectsUsingBlock:^(id<CellModelProtocol>  _Nonnull cellModel, NSUInteger idx, BOOL * _Nonnull stop) {
            // 当toSection.items的count为0时，我会认定他为刚添加的一组
            // 因为当item.count为0时，我会将他从sectionItems移除
            BOOL isNewSection = toSection.items.count == 0;
            BOOL isConstaintsCellModel = [toSection containsCellModel:cellModel];
            if (!isConstaintsCellModel) {
                [toSection.items addObject:cellModel];
            }
            if (isNewSection) {
                
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:toSection.sectionOfTable] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else {
                if (!isConstaintsCellModel) {
                    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:toSection.items.count-1 inSection:toSection.sectionOfTable];
                    [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
        }];
        
    } completionBlock:completion];
}

- (void)reloadCellModels:(NSArray<id<CellModelProtocol>> *)cellModels withRowAnimation:(UITableViewRowAnimation)animation {
    [self reloadCellModels:cellModels atSection:nil withRowAnimation:animation];
}

- (void)reloadCellModels:(NSArray<id<CellModelProtocol>> *)cellModels {
    [self reloadCellModels:cellModels atSection:nil];
}

- (void)reloadCellModels:(NSArray<id<CellModelProtocol>> *)cellModels
               atSection:(BBTableViewSection *)section {
    [self reloadCellModels:cellModels atSection:section withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadCellModels:(NSArray<id<CellModelProtocol>> *)cellModels
               atSection:(BBTableViewSection *)section
        withRowAnimation:(UITableViewRowAnimation)animation {
    
    [self reloadCellModels:cellModels atSection:section withRowAnimation:animation reloadElements:nil];
}

- (void)reloadCellModels:(NSArray<id<CellModelProtocol>> *)cellModels
               atSection:(BBTableViewSection *)section
        withRowAnimation:(UITableViewRowAnimation)animation
          reloadElements:(NSArray<id<CellModelProtocol>> *__autoreleasing *)reloadElements {
    if (cellModels.count == 0) {
        return;
    }
    
    NSMutableArray *indexPaths = @[].mutableCopy;
    NSMutableArray *okElements = @[].mutableCopy;
    if (section) {
        if (section.items.count == 0) {
            return;
        }
        BOOL flag = [self updateSectionOfTableViewSection:section];
        if (flag == NO) {
            return;
        }
        
        for (id<CellModelProtocol> cm in cellModels) {
            NSInteger row = [section.items indexOfObject:cm];
            if (row == NSNotFound) {
                continue;
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section.sectionOfTable];
            cm.indexPathOfTable = indexPath;
            [indexPaths addObject:indexPath];
            [okElements addObject:cm];
        }
    }
    else {
        for (id<CellModelProtocol> cm in cellModels) {
            NSIndexPath *indexPath = nil;
            [self getSectionWithCellModel:cm indexPathOfSection:&indexPath];
            if (indexPath) {
                [indexPaths addObject:indexPath];
                [okElements addObject:cm];
            }
        }
    }
    if (indexPaths.count) {
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if (reloadElements) {
        *reloadElements = okElements;
    }
}



- (void)reloadTableWithBlock:(void (^)(void))updateTableBlock completionBlock:(void (^)(BBTableDataProcessor *))completion {
    [CATransaction begin];
    [self.tableView beginUpdates];
    [CATransaction setCompletionBlock:^{
        if (completion) {
            completion(self);
        }
    }];
    if (updateTableBlock) {
        updateTableBlock();
    }
    [self.tableView endUpdates];
    [CATransaction commit];
}

@end

