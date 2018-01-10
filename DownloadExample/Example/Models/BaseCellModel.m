//
//  BaseCellModel.m
//  Boobuz
//
//  Created by xiaoyuan on 10/08/2017.
//  Copyright © 2017 erlinyou.com. All rights reserved.
//

#import "BaseCellModel.h"

@interface BaseCellModel ()

@property (nonatomic, strong) id model;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat estimatedHeight;
@property (nonatomic, copy) void (^heightChangeCallBack)(CGFloat changeHeight, NSIndexPath *indexPathOfView);
@property (nonatomic, strong) NSIndexPath *indexPathOfTable;

@end

@implementation BaseCellModel

@synthesize height = _height;

- (instancetype)initWithHeight:(CGFloat)height {
    if (self = [super init]) {
        _height = height;
    }
    return self;
}

- (void)setHeight:(CGFloat)height {
    if (_height == height) {
        return;
    }
    _height = height;
    _estimatedHeight = height;
    if (self.heightChangeCallBack) {
        self.heightChangeCallBack(height, self.indexPathOfTable);
    }
}

- (CGFloat)height {
    _height = MAX(0, _height) ?: _estimatedHeight;
    return MAX(_height, 0);
}

@end

