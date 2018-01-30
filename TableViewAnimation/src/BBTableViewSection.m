//
//  BBTableViewSection.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/5.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBTableViewSection.h"

@interface BBTableViewSection ()

@property (nonatomic, strong, readwrite) NSMutableArray<id<CellModelProtocol>> *items;

@end

@implementation BBTableViewSection

- (instancetype)initWithItems:(NSMutableArray<id<CellModelProtocol>> *)items
                  headerTitle:(NSAttributedString *)headerTitle
                  footerTitle:(NSAttributedString *)footerTitle {
    if (self = [super init]) {
        self.items = items;
        self.headerTitle = headerTitle;
        self.footerTitle = footerTitle;
    }
    return self;
}

- (NSMutableArray<id<CellModelProtocol>> *)items {
    if (!_items) {
        _items = @[].mutableCopy;
    }
    return _items;
}

- (NSArray<NSIndexPath *> *)indexPtahsOfSection {
    if (!self.items.count) {
        return @[];
    }
    NSMutableArray *tempM = @[].mutableCopy;
    [self.items enumerateObjectsUsingBlock:^(id<CellModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:self.sectionOfTable];
        [tempM addObject:indexPath];
    }];
    return tempM;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (object != nil && [object isMemberOfClass:BBTableViewSection.class]) {
        BBTableViewSection *target = (BBTableViewSection *)object;
        return [self.identifier isEqual: target.identifier];
    }
    return NO;
}

- (BOOL)containsCellModel:(id<CellModelProtocol>)anCellModel {
    if (self.items.count == 0) {
        return NO;
    }
    NSUInteger foundIdx = [self.items indexOfObjectPassingTest:^BOOL(id<CellModelProtocol> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL res = [obj isEqual:anCellModel];
        if (res) {
            *stop = YES;
        }
        return res;
    }];
    return foundIdx != NSNotFound;
}

- (BOOL)containsCellModels:(NSArray<id<CellModelProtocol>> *)cellModels
       containedCellModels:(NSArray<id<CellModelProtocol>> *__autoreleasing *)containedCellModels
           otherCellModels:(NSArray<id<CellModelProtocol>> *__autoreleasing *)otherCellModels {
    if (self.items.count == 0 || cellModels.count == 0) {
        return NO;
    }
    __block BOOL result = YES;
    NSMutableArray *csm = @[].mutableCopy;
    NSMutableArray *others = @[].mutableCopy;
    [cellModels enumerateObjectsUsingBlock:^(id<CellModelProtocol> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL flag = [self containsCellModel:obj];
        if (!flag) {
            result = flag;
            [others addObject:obj];
        }
        else {
            [csm addObject:obj];
        }
    }];
    if (containedCellModels) {
        *containedCellModels = csm.copy;
    }
    if (otherCellModels) {
        *otherCellModels = others;
    }
    return result;
}

- (NSString *)description {
    NSArray *items = [self items];
    if (items.count == 0) {
        return @"()";
    }
    
    NSMutableString *description = @"{\n".mutableCopy;
    [description appendFormat:@"headerTitle: %@\n", self.headerTitle];
    [description appendFormat:@"footerTitle: %@\n", self.footerTitle];
    [description appendFormat:@"sectionOfTable: %ld\n", self.sectionOfTable];
    [description appendFormat:@"items: ["];
    
    for (NSDictionary *item in items) {
        [description appendFormat:@"    %@", item];
    }
    [description appendString:@"]\n"];
    [description appendFormat:@"identifier: %ld}\n", self.sectionOfTable];
    return description.copy;
}

- (NSString *)debugDescription {
    return [self description];
}

@end

@implementation NSArray(BBTableViewSectionExtend)

- (BOOL)containsSection:(BBTableViewSection *)anSection {
    if (self.count == 0) {
        return NO;
    }
    NSUInteger foundIdx = [self indexOfObjectPassingTest:^BOOL(BBTableViewSection *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL res = [obj isEqual:anSection];
        if (res) {
            *stop = YES;
        }
        return res;
    }];
    return foundIdx != NSNotFound;
}

- (BOOL)containsSections:(NSArray<BBTableViewSection *> *)anSections
       containedSections:(NSArray<BBTableViewSection *> *__autoreleasing *)containedSections
           otherSections:(NSArray<BBTableViewSection *> *__autoreleasing *)otherSections {
    if (self.count == 0 || anSections.count == 0) {
        return NO;
    }
    __block BOOL result = YES;
    NSMutableArray *csm = @[].mutableCopy;
    NSMutableArray *others = @[].mutableCopy;
    [anSections enumerateObjectsUsingBlock:^(BBTableViewSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL flag = [self containsSection:obj];
        if (!flag) {
            result = flag;
            [others addObject:obj];
        }
        else {
            [csm addObject:obj];
        }
    }];
    if (containedSections) {
        *containedSections = csm.copy;
    }
    if (otherSections) {
        *otherSections = others;
    }
    return result;
}


@end
