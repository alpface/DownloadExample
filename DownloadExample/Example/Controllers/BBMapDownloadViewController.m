//
//  BBMapDownloadViewController.m
//  Boobuz
//
//  Created by xiaoyuan on 2018/1/3.
//  Copyright © 2018年 erlinyou.com. All rights reserved.
//

#import "BBMapDownloadViewController.h"
#import "BBPageScrollView.h"
#import "BBDownloadManagementViewController.h"
#import "BBAllMapViewController.h"
#import "BBMapDownloadNavigationView.h"
#import "BBMapDownloadConst.h"
#import "NewDownloadModule.h"

@interface BBMapDownloadViewController () <BBPageScrollViewDataSource, BBPageScrollViewDelegate>

@property (nonatomic, strong) BBPageScrollView *scrollView;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) BBMapDownloadNavigationView *customNavView;

@end

@implementation BBMapDownloadViewController

- (void)dealloc {
    [self.scrollView removeFromSuperview];
    self.scrollView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self addChildViewControllers];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


- (void)setupViews {
    self.view.backgroundColor = BBMapDownloadViewBackgroundColor;
    [self setupTopView];
    [self setupSegmentedControl];
    [self setupPageScrollView];
}

- (void)addChildViewControllers {
    BBDownloadManagementViewController *vc1 = [BBDownloadManagementViewController new];
    BBAllMapViewController *vc2 = [BBAllMapViewController new];
    [self.scrollView addViewController:vc1];
    [self.scrollView addViewController:vc2];
}

- (void)setupPageScrollView {
    BBPageScrollView *scrollView = [[BBPageScrollView alloc] init];
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.pageDataSource = self;
    scrollView.pageDelegate = self;
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_customNavView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [NSLayoutConstraint activateConstraints:@[top, left, right, bottom]];
    scrollView.backgroundColor = [UIColor clearColor];
    
}

- (void)setupTopView {
    BBMapDownloadNavigationView *topView = [BBMapDownloadNavigationView new];
    [self.view addSubview:topView];
    _customNavView = topView;
    topView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *topViewTop = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:BBMapDownloadStateBarHeight];
    NSLayoutConstraint *topViewLeft = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
    NSLayoutConstraint *topViewRight = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
    NSLayoutConstraint *topViewHeight = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:BBMapDownloadNavHeight];
    [NSLayoutConstraint activateConstraints:@[topViewTop, topViewLeft, topViewRight, topViewHeight]];
}

- (void)setupSegmentedControl {
    
    _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"下载管理", @"全部地图"]];
    
    self.customNavView.customTitleView = _segmentControl;
    
    __weak typeof(&*self) weakSelf = self;
    self.customNavView.backActionCallBack = ^(UIButton *backButton) {
        __strong typeof(&*weakSelf) self = weakSelf;
        [self navigateBack];
    };
}

- (void)navigateBack {
    [self.navigationController popViewControllerAnimated:YES];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - BBPageScrollViewDataSource
////////////////////////////////////////////////////////////////////////

- (UISegmentedControl *)segmentedControlForPageScrollView:(BBPageScrollView *)pageScrollView {
    return self.segmentControl;
}


////////////////////////////////////////////////////////////////////////
#pragma mark - BBPageScrollViewDelegate
////////////////////////////////////////////////////////////////////////

- (void)pageScrollView:(BBPageScrollView *)pageScrollView
         didChangePage:(NSInteger)currentPageIndex
         numberOfPages:(NSInteger)numberOfPages {
    
}

- (void)pageScrollView:(BBPageScrollView *)pageScrollView
willChangePageFromPageIndex:(NSInteger)previousIndex
          newPageIndex:(NSInteger)newPageIndex {
    
    UIViewController *vc1 = [self.scrollView getControllerOfIndex:newPageIndex];
    UIViewController *vc2 = [self.scrollView getControllerOfIndex:previousIndex];
    [vc1 beginAppearanceTransition:YES animated:YES];
    [vc2 beginAppearanceTransition:NO animated:YES];
    [vc2 endAppearanceTransition];
}

- (BOOL)shouldAnimatedInPageScrollView:(BBPageScrollView *)pageScrollView {
    return YES;
}

- (BOOL)shouldAllowScrollInPageScrollView:(UIScrollView *)pageScrollView {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.scrollView willRotateToInterfaceOrientation];
}


- (void)beginAppearanceTransition:(BOOL)isAppearing animated:(BOOL)animated {
    [super beginAppearanceTransition:isAppearing animated:animated];
    [self.scrollView.displayViewController beginAppearanceTransition:isAppearing animated:animated];
}

- (void)endAppearanceTransition {
    [super endAppearanceTransition];
    [self.scrollView.displayViewController endAppearanceTransition];
}
@end
