//
//  BBPageScrollView.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/3.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBPageScrollView.h"

@implementation BBPageScrollView {
    NSMutableArray<UIViewController *> * _controllers;
    NSInteger _currentPageIndex;
    // 是否即将旋转屏幕方向
    BOOL _isWillRotateToInterfaceOrientation;
    // 页面是否正在改变中，当正在执行_notifyPageChanged更改页面index时，防止再次调用此方法
    BOOL _isPageChanging;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Initializer
////////////////////////////////////////////////////////////////////////

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (void)commonInit {
    _controllers = [[NSMutableArray alloc] init];
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = false;
    self.showsVerticalScrollIndicator = false;
    self.delegate = self;
    
}

- (void)setupSubviews {
    self.segmentedControl = [self getSegmentedControlFromDataSource];
    self.pageControl = [self getPageControlFromDataSource];
}

- (void)dealloc {
    self.pageDelegate = nil;
    self.delegate = nil;
    self.segmentedControl = nil;
    self.pageControl = nil;
    self.pageDataSource = nil;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Add child controller
////////////////////////////////////////////////////////////////////////

- (void)addViewController:(UIViewController *)controller {
    if (!controller || !controller.view) {
        return;
    }
    
    [_controllers addObject:controller];
    [self addSubview:controller.view];
    [self updateLayoutForPages:NO];
    self.currentPageIndex = _currentPageIndex;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Layout
////////////////////////////////////////////////////////////////////////

- (void)updateLayoutForPages {
    [self updateLayoutForPages:[self shouldScrollAnimated]];
}

- (void)updateLayoutForPages:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.2
                              delay: 0.0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [self layoutUpdating];
                         }
                         completion:^(BOOL finished){
                             [self layoutUpdateCompletion];
                         }];
    }
    else {
        [self layoutUpdating];
        [self layoutUpdateCompletion];
    }
}


/// 更新所有控制器view的frame
- (void)layoutUpdating {
    CGSize currentSize = self.frame.size;
    if (CGSizeEqualToSize(CGSizeZero, currentSize)) {
        // 外界可能使用了AutoLayout，所以我强制更新下布局，不然frame可能为zero
        [self setNeedsLayout];
        [self layoutIfNeeded];
        currentSize = self.frame.size;
    }
    NSInteger index = 0;
    for (UIViewController * controller in _controllers) {
        [controller.view setFrame:CGRectMake(currentSize.width * index,
                                             0,
                                             currentSize.width,
                                             currentSize.height)];
        index++;
    }
    [self setContentSize:CGSizeMake(currentSize.width * index,
                                    currentSize.height)];
}

- (void)layoutUpdateCompletion {
    _isWillRotateToInterfaceOrientation = NO;
    [self updatePage:self.currentPageIndex animated:NO];
}


/// 页面改变时执行，通知代理，并更新页面信息
- (void)_notifyPageChanged {
    
    // 必须设置pageDataSource，不然抛出异常
    if (!self.pageDataSource) {
        @throw [NSException exceptionWithName:@"BBPageScrollViewDataSourceException"
                                       reason:@"pageDataSource为nil，请设置"
                                     userInfo:@{@"BBPageScrollView": self}];
    }
    _isPageChanging = YES;
    // 通知代理
    if ([self.pageDelegate respondsToSelector:@selector(pageScrollView:didChangePage:numberOfPages:)]) {
        [self.pageDelegate pageScrollView:self didChangePage:self.currentPageIndex numberOfPages:self.numberOfPages];
    }
    if (_segmentedControl &&  [_segmentedControl selectedSegmentIndex] != _currentPageIndex) {
        _segmentedControl.selectedSegmentIndex = _currentPageIndex;
    }
    if (_pageControl &&  [_pageControl currentPage] != _currentPageIndex) {
        _pageControl.currentPage = _currentPageIndex;
    }
    if (_pageControl) {
        _pageControl.numberOfPages = self.numberOfPages;
    }
    _isPageChanging = NO;
}


- (void)_willDisplayPage:(NSInteger)pageIndex {
    NSInteger previousIndex = _currentPageIndex;
    if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(pageScrollView:willChangePageFromPageIndex:newPageIndex:)]) {
        [self.pageDelegate pageScrollView:self willChangePageFromPageIndex:previousIndex newPageIndex:pageIndex];
    }
}

- (void)showPage:(NSInteger)pageIndex animated:(BOOL)animated {
    if (pageIndex == self.currentPageIndex) {
        return;
    }
    [self updatePage:pageIndex animated:animated];
}

- (void)updatePage:(NSInteger)pageIndex animated:(BOOL)animated {
    
    CGRect frame = CGRectMake(self.frame.size.width * pageIndex,
                              0,
                              self.frame.size.width,
                              self.frame.size.height);
    [self scrollRectToVisible:frame animated:animated];
    
}

////////////////////////////////////////////////////////////////////////
#pragma mark - BBPageScrollViewDataSource (private methods)
////////////////////////////////////////////////////////////////////////

- (BOOL)shouldAllowScroll {
    BOOL allowScroll = YES;
    if (self.delegate && [self.pageDelegate respondsToSelector:@selector(shouldAllowScrollInPageScrollView:)]) {
        allowScroll = [self.pageDelegate shouldAllowScrollInPageScrollView:self];
    }
    return allowScroll;
}

/// 滚动页面时是否需要动画
- (BOOL)shouldScrollAnimated {
    BOOL animated = YES;
    if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(shouldAnimatedInPageScrollView:)]) {
        animated = [self.pageDelegate shouldAnimatedInPageScrollView:self];
    }
    return animated;
}

/// 只会在初始化时调用，其他都是引用关系
- (UISegmentedControl *)getSegmentedControlFromDataSource {
    UISegmentedControl *segmentedControl = [self.pageDataSource segmentedControlForPageScrollView:self];
    NSAssert(segmentedControl && [segmentedControl isKindOfClass:[UISegmentedControl class]], @"segmentedControl 不能为nil，并且必须是UISegmentedControl或其子类的实例对象");
    return segmentedControl;
}

/// 只会在初始化时调用，其他都是引用关系
- (UIPageControl *)getPageControlFromDataSource {
    UIPageControl *pageControl = nil;
    if ([self.pageDataSource respondsToSelector:@selector(pageControlForPageScrollView:)]) {
        pageControl = [self.pageDataSource pageControlForPageScrollView:self];
    }
    return pageControl;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Set \ Get
////////////////////////////////////////////////////////////////////////

- (void)setPageDelegate:(id<BBPageScrollViewDelegate>)pageDelegate {
    if (_pageDelegate == pageDelegate) {
        return;
    }
    _pageDelegate = pageDelegate;
    
    self.scrollEnabled = [self shouldAllowScroll];
}

- (void)setPageDataSource:(id<BBPageScrollViewDataSource>)pageDataSource {
    if (_pageDataSource == pageDataSource) {
        return;
    }
    _pageDataSource = pageDataSource;
    
    [self setupSubviews];
}

- (void)setPageControl:(UIPageControl *)pageControl {
    if (_pageControl != nil) {
        [_pageControl removeTarget:self action:@selector(pageValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    _pageControl = pageControl;
    if (_pageControl != nil) {
        [_pageControl addTarget:self action:@selector(pageValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
}

- (void)setSegmentedControl:(UISegmentedControl *)segmentedControl {
    if (_segmentedControl != nil) {
        [_segmentedControl removeTarget:self action:@selector(pageValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    _segmentedControl = segmentedControl;
    if (_segmentedControl != nil) {
        [_segmentedControl addTarget:self action:@selector(pageValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
}

- (NSInteger)numberOfPages {
    return [_controllers count];
}

- (NSInteger)currentPageIndex {
    return _currentPageIndex;
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex {
    // 防止执行-addViewController:时，如果currentPageIndex没有改变，保证只执行一次pageScrollView:willChangePageFromPageIndex:newPageIndex:
    if (_currentPageIndex == currentPageIndex) {
        if (_currentPageIndex != 0 || _controllers.count > 1) {
            return;
        }
    }
    [self willChangeValueForKey:NSStringFromSelector(@selector(currentPageIndex))];
    [self _willDisplayPage:currentPageIndex];
    _currentPageIndex = currentPageIndex;
    [self _notifyPageChanged];
    [self didChangeValueForKey:NSStringFromSelector(@selector(currentPageIndex))];
    
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateLayoutForPages];
}

- (UIViewController *)displayViewController {
    if (self.currentPageIndex < _controllers.count) {
        return _controllers[self.currentPageIndex];
    }
    return nil;
}

- (UIViewController *)getControllerOfIndex:(NSInteger)index {
    if (index >= _controllers.count) {
        return nil;
    }
    return [_controllers objectAtIndex:index];
}


////////////////////////////////////////////////////////////////////////
#pragma mark - InterfaceOrientation
////////////////////////////////////////////////////////////////////////

/// 屏幕方向即将发生改变时，应该执行此方法，更新视图
- (void)willRotateToInterfaceOrientation {
    _isWillRotateToInterfaceOrientation = YES;
    // 获取设备对象
    UIDevice *device = [UIDevice currentDevice];
    // 告诉它开始改变屏幕的方向
    [device beginGeneratingDeviceOrientationNotifications];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(orientationChanged:)
               name:UIDeviceOrientationDidChangeNotification
             object:device];
}

/// 屏幕方向改变时执行，完成后移除监听
- (void)orientationChanged:(NSNotification *)note {
    [self updateLayoutForPages];
    UIDevice *device = [UIDevice currentDevice];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:UIDeviceOrientationDidChangeNotification object:device];
}


////////////////////////////////////////////////////////////////////////
#pragma mark - Events
////////////////////////////////////////////////////////////////////////

/// 监听segmentedControl 和 pageControl 的 value改变
- (void)pageValueChanged:(id)sender {
    if (!_isPageChanging) {
        NSInteger currentPage = -1;
        if([sender isKindOfClass:[UISegmentedControl class]]) {
            currentPage = ((UISegmentedControl*)sender).selectedSegmentIndex;
        } else {
            currentPage = ((UIPageControl*)sender).currentPage;
        }
        if (currentPage > -1) {
            [self showPage:currentPage animated:[self shouldScrollAnimated]];
        }
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollViewDelegate
////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_isWillRotateToInterfaceOrientation) {
        // 当上一页或下一页的50%以上可见时，更新页面
        CGFloat pageWidth = self.frame.size.width;
        // floor 向下取整
        NSInteger page = floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.currentPageIndex = page;
    }
}
@end

