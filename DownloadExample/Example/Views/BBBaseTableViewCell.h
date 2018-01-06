//
//  BBBaseTableViewCell.h
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/5.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellModelProtocol;

@protocol BBBaseTableViewCell <NSObject>

- (void)setCellModel:(id<CellModelProtocol>)cellModel;
- (id<CellModelProtocol>)cellModel;

+ (NSString *)defaultIdentifier;

@end


