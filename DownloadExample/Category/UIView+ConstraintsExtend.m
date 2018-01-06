//
//  UIView+ConstraintsExtend.m
//  Boobuz
//
//  Created by xiaoyuan on 28/08/2017.
//  Copyright © 2017 erlinyou.com. All rights reserved.
//

#import "UIView+ConstraintsExtend.h"

@implementation UIView (ConstraintsExtend)

- (void)removeConstraintsOfViewFromView:(UIView *)view {
    for (NSLayoutConstraint *c in view.constraints.copy) {
        if (c.firstItem == self || c.secondItem == self) {
            [view removeConstraint:c];
        }
    }
}

@end
