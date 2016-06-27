//
//  XYModuleChoiceViewManager.m
//  XYModuleChoiceView
//
//  Created by 罗显勇 on 16/6/26.
//  Copyright © 2016年 JetLuo. All rights reserved.
//

#import "XYModuleChoiceViewManager.h"
#import "Masonry.h"

@interface XYModuleChoiceViewManager ()

@end

@implementation XYModuleChoiceViewManager

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _moduleChoiceView = [[XYModuleChoiceView alloc] init];
    [self.moduleChoiceView blackShadowHeader];
    [self.view addSubview:self.moduleChoiceView];
    [self.moduleChoiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.moduleChoiceView setDataSource:self];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.moduleChoiceView reloadData];
}

#pragma mark - XYModuleChoiceViewDataSource
- (NSUInteger)numberOfModules {
    return 0;
}
- (nonnull UIButton *)moduleChoice:(XYModuleChoiceView * _Nonnull)moduleChoiceView headerViewAtIndex:(NSUInteger)index; {
    return nil;
}
- (nonnull UIViewController *)moduleChoice:(XYModuleChoiceView * _Nonnull)moduleChoiceView bottomViewAtIndex:(NSUInteger)index {
    return nil;
}
- (UIView *)sliderView {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Resource.bundle/MC_Slider.png"]];
}



@end
