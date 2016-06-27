//
//  ModuleViewControllerManager.m
//  XYModuleChoiceView
//
//  Created by 罗显勇 on 16/6/26.
//  Copyright © 2016年 JetLuo. All rights reserved.
//

#import "ModuleViewControllerManager.h"
#import "TableViewController.h"

@interface ModuleViewControllerManager ()
@property (nonatomic,strong,nonnull) NSMutableArray *mArrayModules;
@end

@implementation ModuleViewControllerManager

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.moduleChoiceView setSliderStyle:self.type];
    [self setMArrayModules:[NSMutableArray array]];
    [self.mArrayModules addObject:@"军事"];
    [self.mArrayModules addObject:@"财经"];
    [self.mArrayModules addObject:@"生活"];
    [self.mArrayModules addObject:@"新闻"];
    [self.mArrayModules addObject:@"政治"];
    [self.mArrayModules addObject:@"社会"];
    [self.mArrayModules addObject:@"健康"];
    [self.mArrayModules addObject:@"命运"];
    [self.mArrayModules addObject:@"星座"];
    [self.mArrayModules addObject:@"微头条"];
    [self.mArrayModules addObject:@"时尚界"];
    [self.mArrayModules addObject:@"体育"];
    [self.mArrayModules addObject:@"科技"];
    [self.mArrayModules addObject:@"军事"];
    [self.mArrayModules addObject:@"北京"];
    [self.mArrayModules addObject:@"跑步"];
    [self.mArrayModules addObject:@"旅游"];
    [self.mArrayModules addObject:@"情感"];
    [self.mArrayModules addObject:@"中兴"];
    [self.mArrayModules addObject:@"华为"];
    [self.mArrayModules addObject:@"搜狐"];
    [self.mArrayModules addObject:@"网易"];
    [self.mArrayModules addObject:@"腾讯"];
    [self.mArrayModules addObject:@"百度"];
    [self.mArrayModules addObject:@"奇虎"];
    [self.mArrayModules addObject:@"阿里"];
    [self.mArrayModules addObject:@"小米"];
    [self.mArrayModules addObject:@"京东"];
}

- (NSUInteger)numberOfModules {
    return _mArrayModules.count;
}
- (nonnull UIButton *)moduleChoice:(XYModuleChoiceView * _Nonnull)moduleChoiceView headerViewAtIndex:(NSUInteger)index {
    NSString *title = self.mArrayModules[index];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}
- (nonnull UIViewController *)moduleChoice:(XYModuleChoiceView * _Nonnull)moduleChoiceView bottomViewAtIndex:(NSUInteger)index {
    NSLog(@"加载：%@",self.mArrayModules[index]);
    return [[TableViewController alloc] initWithTitle:self.mArrayModules[index]];
}
- (void)moduleChoice:(XYModuleChoiceView *)mchoiceView didSelectRow:(NSUInteger)index {
    TableViewController *viewController = (TableViewController *)[mchoiceView selectedViewController];
    NSLog(@"选中：%@",viewController.titleName);
}
- (void)moduleChoice:(XYModuleChoiceView *)mchoiceView didDisappearViewController:(UIViewController * _Nonnull)viewController {
    //-- 释放数据
    NSLog(@"释放：%@",[(TableViewController *)viewController titleName]);
}

@end













