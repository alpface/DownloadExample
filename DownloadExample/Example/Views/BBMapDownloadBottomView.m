//
//  BBMapDownloadBottomView.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/5.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBMapDownloadBottomView.h"
#import "BBMapDownloadConst.h"

@interface BBMapDownloadBottomItem ()

@property (nonatomic, assign) NSInteger buttonIdx;
@property (nonatomic, strong) NSMutableDictionary *buttonTitleDictionary;
@property (nonatomic, strong) NSMutableDictionary *buttonImageDictionary;
@property (nonatomic, weak) UIButton *button;

@end

@interface BBMapDownloadBottomView ()

@property (nonatomic, strong) NSArray<BBMapDownloadBottomItem *> *items;
@property (nonatomic, strong) NSArray<UIButton *> *buttons;
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *viewConstraints;

@end

@implementation BBMapDownloadBottomView

- (instancetype)initWithItems:(NSArray<BBMapDownloadBottomItem *> *)items {
    if (self = [super initWithFrame:CGRectZero]) {
        self.items = items;
        [self setupViews];
    }
    return self;
}


- (void)setupViews {
    NSMutableArray *btnlist =@[].mutableCopy;
    NSInteger i = 0;
    for (BBMapDownloadBottomItem *item in self.items) {
        BBMapDownloadBottomButton *btn = [BBMapDownloadBottomButton buttonWithType:UIButtonTypeCustom];
        item.button = btn;
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btn.contentMode = UIViewContentModeScaleAspectFit;
        [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:item.title forState:UIControlStateNormal];
        [btn setImage:item.image forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:BBMapDownloadBottomButtonBackgroundBlueColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:40/255.0 green:70/255.0 blue:110/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        btn.hidden = NO;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        item.buttonIdx = i;
        btn.tag = i;
        btn.layer.cornerRadius = 5.0;
        [btn.layer setMasksToBounds:YES];
        [self addSubview:btn];
        [btnlist addObject:btn];
        i++;
    }
    self.buttons = btnlist;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {
    
    [NSLayoutConstraint deactivateConstraints:self.viewConstraints];
    [self.viewConstraints removeAllObjects];
    
    NSMutableDictionary *subviewDict = @{}.mutableCopy;
    NSMutableString *hFormat = [NSMutableString new];
    
    NSInteger i = 0;
    UIButton *previousBtn = nil;
    for (UIButton *btn in self.buttons) {
        NSString *btnKey = [NSString stringWithFormat:@"btn%ld", i];
        subviewDict[btnKey] = btn;
        
        [self.viewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[%@]-%f-|", self.buttonVPadding, btnKey, self.buttonVPadding] options:kNilOptions metrics:nil views:subviewDict]];
        if (previousBtn) {
            [self.viewConstraints addObject:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:previousBtn attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
        }
        [hFormat appendFormat:@"-(%.f@1000)-[%@]", self.buttonHPadding, btnKey];
        if (i == self.buttons.count - 1) {
            // 最后一个控件把距离父控件底部的约束值也加上
            [hFormat appendFormat:@"-(%.f@1000)-", self.buttonHPadding];
        }
        previousBtn = btn;
        i++;
    }
    
    if (hFormat.length) {
        [self.viewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"|%@|", hFormat] options:kNilOptions metrics:nil views:subviewDict]];
    }
    
    [UIView performWithoutAnimation:^{
        [self layoutIfNeeded];
    }];
    
    [NSLayoutConstraint activateConstraints:self.viewConstraints];
    [super updateConstraints];
}

- (void)setButtonHPadding:(CGFloat)buttonHPadding {
    if (_buttonHPadding == buttonHPadding) {
        return;
    }
    _buttonHPadding = buttonHPadding;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)setButtonVPadding:(CGFloat)buttonVPadding {
    if (_buttonVPadding == buttonVPadding) {
        return;
    }
    _buttonVPadding = buttonVPadding;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)btnClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:didClickItem:)]) {
        BBMapDownloadBottomItem *item = [self.items objectAtIndex:btn.tag];
        [self.delegate bottomView:self didClickItem:item];
    }
}

- (void)setItemTitle:(NSString *)title index:(NSInteger)index state:(UIControlState)state {
    NSAssert(index < self.items.count, @"index 必须在items的范围内");
    [self.items[index] setTitle:title state:state];
}
- (void)setItemImage:(UIImage *)image index:(NSInteger)index state:(UIControlState)state {
    NSAssert(index < self.items.count, @"index 必须在items的范围内");
    [self.items[index] setImage:image state:state];
}

- (NSMutableArray<NSLayoutConstraint *> *)viewConstraints {
    if (!_viewConstraints) {
        _viewConstraints = [NSMutableArray array];
    }
    return _viewConstraints;
}

@end


@implementation BBMapDownloadBottomItem

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image {
    if (self = [super init]) {
        self.title = title;
        self.image = image;
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if (title) {
        self.buttonTitleDictionary[@(UIControlStateNormal)] = title;
    }
    else {
        [self.buttonTitleDictionary removeObjectForKey:@(UIControlStateNormal)];
    }
    [self.button setTitle:title forState:UIControlStateNormal];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    if (image) {
        self.buttonImageDictionary[@(UIControlStateNormal)] = image;
    }
    else {
        [self.buttonImageDictionary removeObjectForKey:@(UIControlStateNormal)];
    }
    [self.button setImage:image forState:UIControlStateNormal];
}

- (void)setImage:(UIImage *)image state:(UIControlState)state {
    _image = image;
    self.buttonImageDictionary[@(state)] = image;
    [self.button setImage:image forState:state];
}

- (void)setTitle:(NSString *)title state:(UIControlState)state {
    _title = title;
    self.buttonTitleDictionary[@(state)] = title;
    [self.button setTitle:title forState:state];
}

- (NSMutableDictionary *)buttonTitleDictionary {
    if (!_buttonTitleDictionary) {
        _buttonTitleDictionary = @{}.mutableCopy;
    }
    return _buttonTitleDictionary;
}

- (NSMutableDictionary *)buttonImageDictionary {
    if (!_buttonImageDictionary) {
        _buttonImageDictionary = @{}.mutableCopy;
    }
    return _buttonImageDictionary;
}

- (NSString *)titleForState:(UIControlState)state {
    return self.buttonTitleDictionary[@(state)];
}

- (NSString *)imageForState:(UIControlState)state {
    return self.buttonImageDictionary[@(state)];
}

@end


@implementation BBMapDownloadBottomButton {
    CGSize _titleLabelSize;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}


// 图片太大，文本显示不出来，控制button中image的尺寸
// imageRectForContentRect:和titleRectForContentRect:不能互相调用imageView和titleLael,不然会死循环
- (CGRect)imageRectForContentRect:(CGRect)bounds {
    if (CGSizeEqualToSize(_titleLabelSize, CGSizeZero)) {
        return CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
    }
    return CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height-_titleLabelSize.height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    if (self.imageView.image) {
        return CGRectMake(0.0, self.imageView.bounds.size.height, self.bounds.size.width, self.bounds.size.height-self.imageView.bounds.size.height);
    }
    return CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
    
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    _titleLabelSize = [self string:title sizeWithMaxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) font:self.titleLabel.font];
}

- (CGSize)string:(NSString *)string sizeWithMaxSize:(CGSize)maxSize font:(UIFont*)font {
    
    CGSize textSize = CGSizeZero;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
        NSStringDrawingUsesFontLeading;
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineBreakMode:NSLineBreakByCharWrapping];
        
        NSDictionary *attributes = @{NSFontAttributeName : font, NSParagraphStyleAttributeName : style };
        
        CGRect rect = [string boundingRectWithSize:maxSize
                                           options:opts
                                        attributes:attributes
                                           context:nil];
        textSize = rect.size;
    }
    else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        textSize = [string sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
#pragma clang diagnostic pop
    }
    
    return textSize;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *touchView = [super hitTest:point withEvent:event];
    return touchView;
}

@end


