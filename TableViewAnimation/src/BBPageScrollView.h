//
//  BBPageScrollView.h
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/3.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBPageScrollViewDelegate;
@protocol BBPageScrollViewDataSource;

@interface BBPageScrollView : UIScrollView<UIScrollViewDelegate>

// 代理对象，实现代理后，可监听页面改变的回调
@property (nonatomic, weak) id<BBPageScrollViewDelegate> pageDelegate;

/// 数据源对象，实现此数据源后可获取UIPageControl和UISegmentedControl对象
/// @note: 必须设置，不能为nil，且一定要在addViewController:方法执行前设置
@property (nonatomic, weak) id<BBPageScrollViewDataSource> pageDataSource;

/// 当前页的索引, 当上一页或下一页的50%以上可见时，会更新currentPageIndex
@property (nonatomic, assign, readonly) NSInteger currentPageIndex;

/// 当前显示的viewController
- (UIViewController *)displayViewController;
- (UIViewController *)getControllerOfIndex:(NSInteger)index;

// 页面的数量
@property (nonatomic, assign, readonly) NSInteger numberOfPages;

/// 当前BBPageScrollView的UIPageControl对象 用来显示当前页面的指示器
@property (nonatomic, weak, readonly) UIPageControl *pageControl;

/// 当前BBPageScrollView的UISegmentedControl对象 用来处理切换页面的
@property (nonatomic, weak, readonly) UISegmentedControl *segmentedControl;

/// 添加一个控制器
/// @param controller 将其view添加到子控件
- (void)addViewController:(UIViewController *)controller;

/// 显示指定的页面
/// @param pageIndex 要进入的页面
/// @param animated 更新布局时是否有动画效果
/// @note 要在-addViewController:之后执行，因为会影响代理方法:willChangePageFromPageIndex的调用次数
- (void)showPage:(NSInteger)pageIndex animated:(BOOL)animated;

/// 应该在屏幕方向即将发生改变时，执行此方法，内部会更新视图
/// @note: 可在控制器的willRotateToInterfaceOrientation:: 中执行此方法，以便更新视图
- (void)willRotateToInterfaceOrientation;

@end

@protocol BBPageScrollViewDelegate <NSObject>

@optional

/// 当前页被更改或添加新页时调用，使用这个回调来更新页面控制（如果不想使用PageControl或SegmentedControl）
/// @param pageScrollView 当前所在BBPageScrollView对象
/// @param currentPageIndex 当前页面索引
/// @param numberOfPages scrollView添加的页面数量
/// @note 当每次执行-addViewController:调用，或currentPageIndex改变时调用
- (void)pageScrollView:(BBPageScrollView *)pageScrollView
         didChangePage:(NSInteger)currentPageIndex
         numberOfPages:(NSInteger)numberOfPages;

/// 即将进入新的页面或首次即将显示页面时调用
/// @param pageScrollView 当前所在BBPageScrollView对象
/// @param previousIndex 上次显示的页面索引
/// @param newPageIndex 即将显示的页面索引
/// @note 只有首次显示或当currentIndex改变时，才会被执行，且只会被执行一次
- (void)pageScrollView:(BBPageScrollView *)pageScrollView
willChangePageFromPageIndex:(NSInteger)previousIndex
          newPageIndex:(NSInteger)newPageIndex;

/// 滚动页面时是否需要动画
- (BOOL)shouldAnimatedInPageScrollView:(BBPageScrollView *)pageScrollView;

/// 是否可以滚动，默认YES
- (BOOL)shouldAllowScrollInPageScrollView:(UIScrollView *)pageScrollView;

@end

@protocol BBPageScrollViewDataSource <NSObject>

@required
/// 必须设置一个UISegmentedControl对象 用来处理切换页面的
/// @note: 获取的UISegmentedControl对象并未添加到任何视图上，且使用weak特性，外界需要添加需要显示的视图，并设置布局
- (UISegmentedControl *)segmentedControlForPageScrollView:(BBPageScrollView *)pageScrollView;
@optional
/// 设置一个UIPageControl对象 用来显示当前页面的指示器，可不设置
/// @note: 获取的UIPageControl对象并未添加到任何视图上，且使用weak特性，外界需要添加需要显示的视图，并设置布局
- (UIPageControl *)pageControlForPageScrollView:(BBPageScrollView *)pageScrollView;

@end
