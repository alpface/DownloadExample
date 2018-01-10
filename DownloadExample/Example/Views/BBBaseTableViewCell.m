//
//  BBBaseTableViewCell.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/9.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBBaseTableViewCell.h"
#import "BBMapDownloadBaseItem.h"
#import "RuntimeInvoker.h"

@interface BBBaseTableViewCell ()

@property (nonatomic, strong) BBMapDownloadBaseItem *cellModel;

@end

@implementation BBBaseTableViewCell

////////////////////////////////////////////////////////////////////////
#pragma mark - Touchs
////////////////////////////////////////////////////////////////////////


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.nextResponder touchesEnded:touches withEvent:event];
    
    [self.cellModel.actionTarget invoke:NSStringFromSelector(self.cellModel.actionSelector) args:self, nil];
    
}


+ (NSString *)defaultIdentifier {
    return [NSStringFromClass([self class]) stringByAppendingString:NSStringFromSelector(_cmd)];
}


@end
