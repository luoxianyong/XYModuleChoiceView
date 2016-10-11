//
//  XYModuleChoiceView.h
//  XYModuleChoiceView
//
//  Created by 罗显勇 on 15/5/26.
//  Copyright © 2015年 JetLuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYModuleChoiceView;

@protocol XYModuleChoiceViewDataSource <NSObject>

@optional
- (UIEdgeInsets)edgeInsets;
- (CGFloat)heightOfSliderView;//滑动条的高度,默认4
- (CGFloat)heightOfHeaderView;//头部高度，默认40
- (CGFloat)spacingOfBetweenTwoViews;//bottomScrollView和headerScrollView之间的间距，默认0
- (CGFloat)spacingOfBetweenTowHeaderViews;//headerViews之间的间距@optional，默认0
- (void)moduleChoice:(XYModuleChoiceView * _Nonnull)mchoiceView didSelectRow:(NSInteger)index; //index从0开始
- (void)moduleChoice:(XYModuleChoiceView * _Nonnull)mchoiceView didDisappearViewController:(UIViewController * _Nonnull)viewController;

@required
- (NSInteger)numberOfModules;//有多少个分块
- (nonnull UIView *)sliderView;//滑块
- (nonnull UIButton *)moduleChoice:(XYModuleChoiceView * _Nonnull)moduleChoiceView headerViewAtIndex:(NSInteger)index;//标题
- (nonnull UIViewController *)moduleChoice:(XYModuleChoiceView * _Nonnull)moduleChoiceView bottomViewAtIndex:(NSInteger)index;//内容

@end

typedef enum {
    XYMCV_Underline,    //下划线
    XYMCV_Slider,       //滑块
    XYMCV_FontColor,    //颜色
    XYMCV_FontColorShade,//颜色字体变化
    XYMCV_FontColorShadeAndUnderline, //下划线和颜色
}XYMCV_SliderStyle;

#define XYMCVTextFontName         @"Verdana"
#define XYMCVTextFontBlodName     @"Verdana-Bold"
#define XYMCVTextFontSize         14

/*
 使用[[XYModuleChoiceView alloc] init]创建
 */
@interface XYModuleChoiceView : UIView

//-- Views
@property(nonnull,nonatomic,strong,readonly) UIView *rootView;
@property(nonnull,nonatomic,strong,readonly) UIScrollView *headerScrollView;
@property(nonnull,nonatomic,strong,readonly) UIScrollView *bottomScrollView;
//-- 当前选中模块在栈中的序次
@property(nonatomic,assign,readwrite) NSInteger selectedIndex;
//-- 滑块
@property(nullable,nonatomic,strong,readonly) UIView * ivSlider;
//-- 滑动显示方式
@property(nonatomic,assign) XYMCV_SliderStyle sliderStyle;
//-- 是否使用动画
@property(nonatomic,assign) BOOL useAnimation;
//-- 代理和数据源
@property(nonatomic,weak,nullable,readwrite) id<XYModuleChoiceViewDataSource > dataSource;
//-- 为XYMCV_FontColor时，choosedFontColor有效
@property(nullable,nonatomic,strong,readwrite) UIColor *choosedFontColor; //选中字体颜色
@property(nullable,nonatomic,strong,readwrite) UIColor *unChoosedFontColor; //未选中字体颜色
//-- headerScrollView最多显示模块数,默认为5
@property(assign,nonatomic,readwrite) NSInteger maxButtonsInShowHeader;
//-- 禁止滚动翻页
@property(assign,nonatomic,readwrite) BOOL closeScrollPageturning;
//-- 禁止释放任何Controller
@property(assign,nonatomic,readwrite) BOOL noReleaseAnyController;
//-- 设置头部阴影
@property(assign,nonatomic,readwrite) BOOL useBlackShadowHeader;
//-- 使用页脚导航,Default is NO, 默认高度40
@property(assign,nonatomic,readwrite) CGFloat heightOfFooter;
@property(assign,nonatomic,readwrite) BOOL useFooterNavigation;
@property(strong,nonatomic,readonly,nullable) UIView *footerView;

//刷新数据
- (void)reloadData;
//获取当前选中的ViewController
- (nullable UIViewController *)selectedViewController;
//使用缓存时不会超过2个未选择的控制器
- (nullable NSArray *)unSelectedViewControllers;

@end







