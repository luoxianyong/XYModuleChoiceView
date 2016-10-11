//
//  XYModuleChoiceView.m
//  XYModuleChoiceView
//
//  Created by 罗显勇 on 15/5/26.
//  Copyright © 2015年 JetLuo. All rights reserved.
//

#import "XYModuleChoiceView.h"
#import "Masonry.h"

#define XYUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
static NSString * XYMonitorFrame = @"w_headerView";

@interface XYModuleChoiceView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate> {
    CGFloat MCRootView_MinX;
    CGFloat MCRootView_MinY;
    CGFloat MCRootView_MaxX;
    CGFloat MCRootView_MaxY;
    CGFloat MCIvSliderHeight;//活动条的高度
    CGFloat MCHeaderScrollViewHeight;//headerScrollView的高度
    CGFloat MCSpacingOfBetweenTwoScorllViews;//headerScrollView和bottomScrollView之间的间距
    CGFloat MCWidthOfSeparator;//-- headerScrollView中subViews之间的间距
    CGFloat MCWidthOfBottomViews;//-- bottomScrollView中subViews之间的间距，Defautl is 10
    NSInteger MCModulesCount;//-- 有多少个模块
    
    NSInteger contentTag;
    NSInteger oldSelectIndex;
    NSInteger selectedIndex; //从0开始
    NSInteger choosedFontSize;//当sliderStyle为XYMCV_FontColorShade有效
    NSInteger headAndbottomViewStartTag; //Tag不能从0开始，这里给一个初始值800
}
//-- 底部View缓存
@property(nonatomic,strong,nullable) NSMutableArray *mArrayCacheViewsInBottom;
@property(nonatomic,assign) NSInteger cacheViewsCount;
@property(nonatomic,assign) CGFloat w_headerView;
@property(strong,nonatomic,readwrite,nullable) UIView *footerView;
@property(strong,nonatomic,readwrite) UIPanGestureRecognizer *panGestureRecognizer;
@end

@implementation XYModuleChoiceView
@synthesize selectedIndex = selectedIndex;

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self reloadData];
}

- (void)setDataSource:(id<XYModuleChoiceViewDataSource>)dataSource {
    if(_dataSource != dataSource) {
        _dataSource = dataSource;
        [self reloadData];
    }
}
#pragma mark - 初始化
//实时更新switchSliderView的frame
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if([keyPath isEqualToString:XYMonitorFrame]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self switchSliderView:CGRectGetMinX([[self contentViewInHeader] viewWithTag:selectedIndex+headAndbottomViewStartTag].frame)];
        });
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:XYMonitorFrame];
}
- (instancetype)init {
    if(self = [super init]) {
        contentTag = 3333;
        headAndbottomViewStartTag = 800;
        choosedFontSize = XYMCVTextFontSize+2;
        _heightOfFooter = 40;
        self.useAnimation = YES;
        self.maxButtonsInShowHeader = 5;
        self.choosedFontColor = XYUIColorFromRGB(0xde0103);
        self.unChoosedFontColor = XYUIColorFromRGB(0x333333);
        self.cacheViewsCount = 3;
        self.mArrayCacheViewsInBottom = [[NSMutableArray alloc] initWithCapacity:self.cacheViewsCount];
        [self initBasicView];
        [self addObserver:self forKeyPath:XYMonitorFrame options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}
- (void)initBasicView {
    _rootView = [[UIView alloc] init];
    _rootView.backgroundColor = [UIColor whiteColor];
    _rootView.clipsToBounds = YES;
    [self addSubview:_rootView];
    
    _headerScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.headerScrollView.backgroundColor = [UIColor clearColor];
    self.headerScrollView.pagingEnabled = NO;
    self.headerScrollView.showsHorizontalScrollIndicator = NO;
    self.headerScrollView.showsVerticalScrollIndicator = NO;
    self.headerScrollView.clipsToBounds = NO;
    self.headerScrollView.bounces = NO;
    
    _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.bottomScrollView.backgroundColor = XYUIColorFromRGB(0xAAAAAA);
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
    self.bottomScrollView.showsVerticalScrollIndicator = NO;
    self.bottomScrollView.clipsToBounds = NO;
    self.bottomScrollView.delegate = self;
    self.bottomScrollView.bounces = NO;
    
    
    [self.rootView addSubview:_bottomScrollView];
    [self.rootView addSubview:_headerScrollView];
    
    __weak typeof(self) weakSelf = self;
    
    
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [self.headerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.equalTo(weakSelf.rootView.mas_right);
        make.height.mas_equalTo(40);//Default is 40
    }];
    [self.bottomScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerScrollView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.equalTo(weakSelf.rootView);
        make.bottom.equalTo(weakSelf.rootView);
    }];
}
- (void)setUseFooterNavigation:(BOOL)useFooterNavigation {
    if(_useFooterNavigation != useFooterNavigation) {
        _useFooterNavigation = useFooterNavigation;
        [self layout];
    }
}
- (void)setHeightOfFooter:(CGFloat)heightOfFooter {
    if(_heightOfFooter != heightOfFooter) {
        _heightOfFooter = heightOfFooter;
        [self layout];
    }
}
- (void)layout {
    __weak typeof(self) weakSelf = self;
    if(!_useFooterNavigation) {
        [self.bottomScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.rootView.mas_bottom);
        }];
        [_footerView removeFromSuperview];
        [self setFooterView:nil];
    } else {
        [self.rootView addSubview:self.footerView];
        [self.bottomScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.rootView.mas_bottom).with.offset(-weakSelf.heightOfFooter);
        }];
        [self.footerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(weakSelf.heightOfFooter);
            make.left.mas_equalTo(0);
            make.right.equalTo(weakSelf.rootView.mas_right);
            make.bottom.equalTo(weakSelf.rootView.mas_bottom);
        }];
    }
}
- (UIView *)footerView {
    if(!_footerView) {
        _footerView = [[UIView alloc] init];
        _footerView.userInteractionEnabled = YES;
        _footerView.backgroundColor = [UIColor grayColor];
    }
    return _footerView;
}
- (UIPanGestureRecognizer *)panGestureRecognizer {
    if(!_panGestureRecognizer) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(activateOfFooter:)];
        pan.delegate = self;
        self.panGestureRecognizer = pan;
    }
    return _panGestureRecognizer;
}
- (void)activateOfFooter:(UIPanGestureRecognizer *)pan {
    
}
#pragma mark - 获取ScrollView中的内容View
- (UIView *)contentViewInHeader {
    return [self.headerScrollView viewWithTag:contentTag];
}
- (UIView *)contentViewInBottom {
    return [self.bottomScrollView viewWithTag:contentTag];
}

#pragma mark - 选择模块
- (void)setSelectedIndex:(NSInteger)selectedIndex___ {
    if(selectedIndex != selectedIndex___) {
        selectedIndex = selectedIndex___;
        UIButton *selectedButton = (UIButton *)[[self contentViewInHeader].subviews objectAtIndex:selectedIndex];//请看reloadData是如何工作的
        [self touchDown:selectedButton];
    }
}
- (void)setCloseScrollPageturning:(BOOL)closeScrollPageturning {
    _closeScrollPageturning = closeScrollPageturning;
    self.bottomScrollView.scrollEnabled = !closeScrollPageturning;
}

#pragma mark - UI布局
- (void)adjustFrameForSubviews {
    UIEdgeInsets insets = [_dataSource respondsToSelector:@selector(edgeInsets)] ? [_dataSource edgeInsets] : UIEdgeInsetsZero;
    MCRootView_MinX = insets.left;
    MCRootView_MaxX = insets.right;
    MCRootView_MinY = insets.top;
    MCRootView_MaxY = insets.bottom;
    MCIvSliderHeight = [_dataSource respondsToSelector:@selector(heightOfSliderView)] ? [_dataSource heightOfSliderView] : 4;
    MCHeaderScrollViewHeight = [_dataSource respondsToSelector:@selector(heightOfHeaderView)] ? [_dataSource heightOfHeaderView] : 40;
    MCSpacingOfBetweenTwoScorllViews = [_dataSource respondsToSelector:@selector(spacingOfBetweenTwoViews)] ? [_dataSource spacingOfBetweenTwoViews] : 0;
    MCWidthOfSeparator = [_dataSource respondsToSelector:@selector(spacingOfBetweenTowHeaderViews)] ? [_dataSource spacingOfBetweenTowHeaderViews] : 0;
    MCWidthOfBottomViews = 10;
    
    [self cleanConstraints];
    [self.rootView mas_remakeConstraints:^(MASConstraintMaker *make) {}];
    
    __weak typeof(self) weakSelf = self;
    [self.rootView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(MCRootView_MinY);
        make.left.mas_equalTo(MCRootView_MinX);
        make.right.equalTo(weakSelf.mas_right).with.offset(-MCRootView_MaxX);
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-MCRootView_MaxY);
    }];
    [self.headerScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(MCHeaderScrollViewHeight);
        make.right.equalTo(weakSelf.rootView.mas_right);
    }];
    [self.bottomScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerScrollView.mas_bottom).with.offset(MCSpacingOfBetweenTwoScorllViews);
        make.left.mas_equalTo(0);//-- 方便计算contentOffset 好好思考
        make.right.equalTo(weakSelf.rootView.mas_right).with.offset(MCWidthOfBottomViews);//-- 好好思考
        if(weakSelf.useFooterNavigation) {
            make.bottom.equalTo(weakSelf.footerView.mas_top);
        } else {
            make.bottom.equalTo(weakSelf.rootView);
        }
    }];
    
    self.w_headerView = CGRectGetWidth(self.headerScrollView.frame);
}
- (void)reloadData {
    MCModulesCount = [_dataSource numberOfModules];
    if(MCModulesCount <= 0) {
        //-- 可添加缺省页
        return;
    } else {
        //-- 删除缺省页面
    }
    [self adjustFrameForSubviews];
    //能显示多少个模块
    NSInteger showModules = MCModulesCount>self.maxButtonsInShowHeader ? self.maxButtonsInShowHeader : MCModulesCount;
    
    //每一个分块的宽度
    CGFloat headerModule_w = ([self scrollHeaderViewWidth]-MCWidthOfSeparator*(showModules-1))/showModules;
    __weak typeof(self) weakself = self;
    UIView *headerContentView = [self contentViewInHeader];
    [headerContentView removeFromSuperview];
    headerContentView = [[UIView alloc] init];
    headerContentView.tag = contentTag;
    
    [self.headerScrollView addSubview:headerContentView];
    [headerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself.headerScrollView);
        make.height.equalTo(weakself.headerScrollView);
    }];

    UIButton *button = nil, *lastButton = nil;
    UIViewController *viewController = [self firstViewController:self];
    viewController.navigationController.navigationBar.translucent = NO;
    viewController.tabBarController.tabBar.translucent = NO;
    viewController.automaticallyAdjustsScrollViewInsets = NO;
    viewController.edgesForExtendedLayout = UIRectEdgeNone;
    
    for(NSInteger i=0; i<MCModulesCount; i++) {
        //-- headerView
        button = (UIButton *)[_dataSource moduleChoice:self headerViewAtIndex:i];
        [button.titleLabel setFont:[UIFont fontWithName:XYMCVTextFontName size:XYMCVTextFontSize]];
        [button setTitleColor:self.unChoosedFontColor forState:UIControlStateNormal];
        [button removeFromSuperview];
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
        [headerContentView addSubview:button];
        if(lastButton) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.bottom.equalTo(headerContentView.mas_bottom);
                make.left.equalTo(lastButton.mas_right).with.offset(MCWidthOfSeparator);
                make.width.mas_equalTo(headerModule_w);
            }];
        } else {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.bottom.equalTo(headerContentView.mas_bottom);
                make.left.mas_equalTo(0);
                make.width.mas_equalTo(headerModule_w);
            }];
        }
        [button setTag:i+headAndbottomViewStartTag];//-- 设置Tag值
        [button addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        lastButton = button;
    }
    [headerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastButton.mas_right);
    }];
    [self removeAndAddViewsToBottom];
    
    
    [_ivSlider removeFromSuperview];
    [_ivSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
    }];
    switch (self.sliderStyle) {
        case XYMCV_Underline: {
            _ivSlider = [_dataSource sliderView];
            [self.headerScrollView addSubview:_ivSlider];
            [self.ivSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(selectedIndex*(headerModule_w+MCWidthOfSeparator));
                make.width.mas_equalTo(headerModule_w);
                make.height.mas_equalTo(MCIvSliderHeight);
                make.bottom.equalTo(weakself.headerScrollView.mas_bottom);
            }];
            break;
        }
        case XYMCV_Slider: {
            _ivSlider = [_dataSource sliderView];
            for(UIView *view in headerContentView.subviews) {
                view.backgroundColor = [UIColor clearColor];
            }
            [headerContentView setBackgroundColor:[UIColor clearColor]];
            [self.headerScrollView insertSubview:_ivSlider atIndex:0];
            [self.ivSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(selectedIndex*(headerModule_w+MCWidthOfSeparator));
                make.width.mas_equalTo(headerModule_w);
                make.bottom.equalTo(weakself.headerScrollView.mas_bottom);
            }];
            break;
        }
        case XYMCV_FontColor: {
            UIButton * currButton = [[self contentViewInHeader].subviews objectAtIndex:selectedIndex];
            [currButton setTitleColor:self.choosedFontColor forState:UIControlStateNormal];
            break;
        }
        case XYMCV_FontColorShade: {
            UIButton * currButton = [[self contentViewInHeader].subviews objectAtIndex:selectedIndex];
            [currButton setTitleColor:self.choosedFontColor forState:UIControlStateNormal];
            [currButton.titleLabel setFont:[UIFont fontWithName:XYMCVTextFontBlodName size:choosedFontSize]];
            break;
        }
        case XYMCV_FontColorShadeAndUnderline: {
            UIButton * currButton = [[self contentViewInHeader].subviews objectAtIndex:selectedIndex];
            [currButton setTitleColor:self.choosedFontColor forState:UIControlStateNormal];
            [currButton.titleLabel setFont:[UIFont fontWithName:XYMCVTextFontBlodName size:choosedFontSize]];
            _ivSlider = [_dataSource sliderView];
            [self.headerScrollView addSubview:_ivSlider];
            [self.ivSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(selectedIndex*(headerModule_w+MCWidthOfSeparator));
                make.width.mas_equalTo(headerModule_w);
                make.height.mas_equalTo(MCIvSliderHeight);
                make.bottom.equalTo(weakself.headerScrollView.mas_bottom);
            }];
            break;
        }
        default:
            break;
    }
}
#pragma mark - 辅助
- (CGFloat)scrollHeaderViewWidth {
    return [[UIScreen mainScreen] bounds].size.width-MCRootView_MinX-MCRootView_MaxX;
}
- (CGFloat)scrollBottomViewWidth {
    return [[UIScreen mainScreen] bounds].size.width-MCRootView_MinX-MCRootView_MaxX;
}
- (UIViewController *)firstViewController:(UIView *)view {
    UIResponder *nextResponder = [view nextResponder];
    while (![nextResponder isKindOfClass:[UIViewController class]]&&nextResponder) {
        nextResponder=[nextResponder nextResponder];
    }
    return (UIViewController *)nextResponder;
}
- (void)cleanConstraints {
    [self.headerScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {}];
    [self.bottomScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {}];
}
- (void)bottomScrollToSelectedIndex:(NSInteger)selectedIndex_ {
    UIView *view = [[self contentViewInBottom] viewWithTag:selectedIndex_+headAndbottomViewStartTag];
    NSInteger index = [[[self contentViewInBottom] subviews] indexOfObject:view];
    [self.bottomScrollView setContentOffset:CGPointMake(index*([self scrollBottomViewWidth]+MCWidthOfBottomViews), 0)];
}
- (void)settingFontColorAtButton {
    UIButton *oldButton = [[[self contentViewInHeader] subviews] objectAtIndex:oldSelectIndex];
    UIButton *xinButton = [[[self contentViewInHeader] subviews] objectAtIndex:selectedIndex];
    [oldButton setTitleColor:self.unChoosedFontColor forState:UIControlStateNormal];
    [xinButton setTitleColor:self.choosedFontColor forState:UIControlStateNormal];
}
- (void)settingFontSizeAtButton {
    UIButton *oldButton = [[[self contentViewInHeader] subviews] objectAtIndex:oldSelectIndex];
    UIButton *xinButton = [[[self contentViewInHeader] subviews] objectAtIndex:selectedIndex];
    [oldButton.titleLabel setFont:[UIFont fontWithName:XYMCVTextFontName size:XYMCVTextFontSize]];
    [xinButton.titleLabel setFont:[UIFont fontWithName:XYMCVTextFontBlodName size:choosedFontSize]];
}

#pragma mark - 设置头部阴影
- (void)setUseBlackShadowHeader:(BOOL)useBlackShadowHeader {
    _useBlackShadowHeader = useBlackShadowHeader;
    self.headerScrollView.backgroundColor = [UIColor whiteColor];
    if (useBlackShadowHeader) {
        self.headerScrollView.layer.shadowColor  = [UIColor blackColor].CGColor;
        self.headerScrollView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
        self.headerScrollView.layer.shadowOpacity= 0.07;
    } else {
        self.headerScrollView.layer.shadowColor  = [UIColor clearColor].CGColor;
        self.headerScrollView.layer.shadowOffset = CGSizeMake(0, 0);
        self.headerScrollView.layer.shadowOpacity= 0;
    }
}
#pragma mark - 获取当前选中的ViewController
- (nullable UIViewController *)selectedViewController {
    UIView *view = [[self contentViewInBottom] viewWithTag:selectedIndex+headAndbottomViewStartTag];
    return [self firstViewController:view];
}
- (nullable NSArray *)unSelectedViewControllers {
    NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:2];
    UIView *currentView = [[self contentViewInBottom] viewWithTag:selectedIndex];
    for(UIView *view in [[self contentViewInBottom] subviews]) {
        if(currentView != view) {
            UIViewController *vc = [self firstViewController:view];
            vc ? [mArray addObject:vc] : 0;
        }
    }
    return mArray;
}

#pragma mark - 加载BottomViews
- (void)removeAndAddViewsToBottom {
    [self.mArrayCacheViewsInBottom removeAllObjects];
    NSInteger first = -1, count = 1;
    
    if (self.noReleaseAnyController) {
        first = 0;
        self.cacheViewsCount = 100;
    } else {
        self.cacheViewsCount = 3;
        if(selectedIndex == MCModulesCount-1) { //最后一个
            NSInteger last = MCModulesCount;
            while (last > 0 && count <= self.cacheViewsCount) {
                last--;
                count++;
            }
            first = last;
        } else if(selectedIndex == 0) { //第一个
            first = 0;
        } else {
            first = selectedIndex-1;
        }
    }
    
    for(int i=0; i<MIN(self.cacheViewsCount, MCModulesCount); i++) {
        [self.mArrayCacheViewsInBottom addObject:[NSNumber numberWithInteger:i+first+headAndbottomViewStartTag]];
    }
    
    __weak typeof(self) weakself = self;
    UIView *bottomContentView = [self contentViewInBottom];
    for(UIView *view in bottomContentView.subviews) {
        //-- 释放不需要的子ViewController
        if(![self.mArrayCacheViewsInBottom containsObject:[NSNumber numberWithInteger:view.tag]]) {
            UIViewController *viewController = [self firstViewController:view];
            [view removeFromSuperview];
            [viewController removeFromParentViewController];
            if([self.dataSource respondsToSelector:@selector(moduleChoice:didDisappearViewController:)]) {
                [self.dataSource moduleChoice:self didDisappearViewController:viewController];
            }
        }
    }
    if(bottomContentView == nil) {
        bottomContentView = [[UIView alloc] init];
        bottomContentView.tag = contentTag;
        [self.bottomScrollView addSubview:bottomContentView];
    }
    [bottomContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself.bottomScrollView);
        make.height.equalTo(weakself.bottomScrollView);
    }];
    UIViewController *viewController = [self firstViewController:self];
    UIViewController *subViewController = nil;
    UIView *lastView = nil;
    CGFloat bottomModule_w = [self scrollBottomViewWidth];
    for(NSInteger i=first; i<MIN(self.cacheViewsCount, MCModulesCount)+first; i++) {
        UIView *hasView = [bottomContentView viewWithTag:i+headAndbottomViewStartTag];
        if(hasView) {
            subViewController = [self firstViewController:hasView];
        } else {
            subViewController = [_dataSource moduleChoice:self bottomViewAtIndex:i];
            subViewController.view.layer.shadowColor  = [UIColor blackColor].CGColor;
            subViewController.view.layer.shadowOffset = CGSizeMake(2.5, 2.5);
            subViewController.view.layer.shadowOpacity= 0.9;
            [viewController addChildViewController:subViewController];
            [bottomContentView insertSubview:subViewController.view atIndex:i-first];
        }
        subViewController.view.tag = i+headAndbottomViewStartTag;//设置Tag
        [subViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
        
        [subViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            if(lastView) {
                make.left.equalTo(lastView.mas_right).with.offset(MCWidthOfBottomViews);
            } else { make.left.mas_equalTo(0); }
            make.width.mas_equalTo(bottomModule_w);
            make.bottom.equalTo(bottomContentView.mas_bottom);
        }];
        lastView = subViewController.view;
    }
    [bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView.mas_right).with.offset(MCWidthOfBottomViews);
    }];
    [self bottomScrollToSelectedIndex:selectedIndex];
    [self switchSliderView:CGRectGetMinX([[self contentViewInHeader] viewWithTag:selectedIndex+headAndbottomViewStartTag].frame)];
    [self switchBeforeViewIndex:oldSelectIndex afterViewIndex:selectedIndex];
}

#pragma mark - 手势处理
- (void)touchDown:(UIButton *)sender {
    if(sender.tag-headAndbottomViewStartTag != selectedIndex) {
        [self switchSliderView:CGRectGetMinX(sender.frame)]; //看手势添加在哪个对象上的
        oldSelectIndex = selectedIndex;
        selectedIndex  = sender.tag-headAndbottomViewStartTag;
        [self removeAndAddViewsToBottom];
    }
}

- (void)switchSliderView:(CGFloat)slider_x {
    UIButton *button = [[self contentViewInHeader] viewWithTag:selectedIndex+headAndbottomViewStartTag];
    CGFloat button_midx = CGRectGetMidX(button.frame);
    CGFloat offset_x = button_midx-CGRectGetWidth(self.headerScrollView.frame)/2.0;
    if(offset_x < 0) {
        offset_x = 0;
    } else if (offset_x > MCModulesCount*(CGRectGetWidth(button.frame)+MCWidthOfSeparator)-CGRectGetWidth(self.headerScrollView.frame)) {
        offset_x = MCModulesCount*(CGRectGetWidth(button.frame)+MCWidthOfSeparator)-CGRectGetWidth(self.headerScrollView.frame);
    }
    [self.headerScrollView setContentOffset:CGPointMake(offset_x, 0) animated:_useAnimation];
    [self.ivSlider mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(slider_x);
    }];
}

- (void)switchBeforeViewIndex:(NSInteger)beforeIndex afterViewIndex:(NSInteger)afterIndex {
    if(self.sliderStyle == XYMCV_FontColor) {
        [self settingFontColorAtButton];
    } else if(self.sliderStyle == XYMCV_FontColorShade || self.sliderStyle == XYMCV_FontColorShadeAndUnderline) {
        [self settingFontColorAtButton];
        UIButton *oldButton = [[[self contentViewInHeader] subviews] objectAtIndex:oldSelectIndex];
        UIButton *xinButton = [[[self contentViewInHeader] subviews] objectAtIndex:selectedIndex];
        [oldButton.titleLabel setFont:[UIFont fontWithName:XYMCVTextFontName size:XYMCVTextFontSize]];
        [xinButton.titleLabel setFont:[UIFont fontWithName:XYMCVTextFontBlodName size:choosedFontSize]];
    }
    if([_dataSource respondsToSelector:@selector(moduleChoice:didSelectRow:)]) {
        if(_useAnimation) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.35*NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                [_dataSource moduleChoice:self didSelectRow:selectedIndex];
            });
        } else {
            [_dataSource moduleChoice:self didSelectRow:selectedIndex];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sView {
    if(sView == self.bottomScrollView) {
        NSInteger offset_x = sView.contentOffset.x;
        NSInteger s_w = sView.frame.size.width;
        CGFloat remainder = offset_x%s_w;
        UIView * currentView = [[self contentViewInBottom] viewWithTag:selectedIndex+headAndbottomViewStartTag];
        if(remainder == 0) {
            
        } else {
            CGFloat scrollPercentage = remainder/s_w; //单页滚动比例
            scrollPercentage = offset_x > [[self contentViewInBottom].subviews indexOfObject:currentView]*s_w ? scrollPercentage : scrollPercentage-1;
            
            if(self.sliderStyle == XYMCV_FontColorShade || self.sliderStyle == XYMCV_FontColorShadeAndUnderline) {
                NSInteger changeValue = fabs(scrollPercentage)/0.33;
                UIButton *willShowButton = [[self contentViewInHeader] viewWithTag:selectedIndex+headAndbottomViewStartTag+(scrollPercentage>0?1:-1)];
                UIButton *currentButton = [[self contentViewInHeader] viewWithTag:selectedIndex+headAndbottomViewStartTag];
                [willShowButton.titleLabel setFont:[UIFont fontWithName:XYMCVTextFontName size:XYMCVTextFontSize+changeValue]];
                [currentButton.titleLabel setFont:[UIFont fontWithName:XYMCVTextFontName size:XYMCVTextFontSize-changeValue]];
            }
            [self switchSliderView:(self.selectedIndex+scrollPercentage)*(CGRectGetWidth(self.ivSlider.frame)+MCWidthOfSeparator)];
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewStopDragging:scrollView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        [self scrollViewStopDragging:scrollView];
    }
}
- (void)scrollViewStopDragging:(UIScrollView *)scrollView {
    if(scrollView == self.bottomScrollView) {
        CGFloat s_w = scrollView.frame.size.width; //UIScrolView的宽度
        CGFloat offset_x = scrollView.contentOffset.x;//取得当前显示内容的坐标x
        NSInteger page = floor(offset_x/s_w);//当前在第几页,从0开始
        UIView *currentView = [[[self contentViewInBottom] subviews] objectAtIndex:page];
        if(selectedIndex == currentView.tag-headAndbottomViewStartTag) {
            if(self.sliderStyle == XYMCV_FontColor) {
                [self settingFontColorAtButton];
            } else if(self.sliderStyle == XYMCV_FontColorShade || self.sliderStyle == XYMCV_FontColorShadeAndUnderline) {
                [self settingFontColorAtButton];
                [self settingFontSizeAtButton];
            }
            return;
        }
        oldSelectIndex = selectedIndex;
        selectedIndex = currentView.tag-headAndbottomViewStartTag;
        if(oldSelectIndex != selectedIndex) {
            [self removeAndAddViewsToBottom];
        }
    }
}
@end
