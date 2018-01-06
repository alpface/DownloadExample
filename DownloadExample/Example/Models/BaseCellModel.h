//
//  BaseCellModel.h
//  Boobuz
//
//  Created by xiaoyuan on 10/08/2017.
//  Copyright © 2017 erlinyou.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellModelProtocol <NSObject>

- (void)setModel:(id)model;
- (id)model;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)estimatedHeight;
- (void)setEstimatedHeight:(CGFloat)estimatedHeight;

- (void (^)(CGFloat newHeight, NSIndexPath *indexPathOfView))heightChangeCallBack;
- (void)setHeightChangeCallBack:(void (^)(CGFloat newHeight, NSIndexPath *indexPathOfView))heightChangeCallBack;

- (NSIndexPath *)indexPathOfTableView;
- (void)setIndexPathOfTableView:(NSIndexPath *)indexPathOfTableView;

@end


@interface BaseCellModel : NSObject <CellModelProtocol>

- (instancetype)initWithHeight:(CGFloat)height;

@end
