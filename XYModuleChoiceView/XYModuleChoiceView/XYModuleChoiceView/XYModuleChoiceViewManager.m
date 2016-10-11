//
//  XYModuleChoiceViewManager.m
//  XYModuleChoiceView
//
//  Created by 罗显勇 on 16/6/26.
//  Copyright © 2016年 JetLuo. All rights reserved.
//

#import "XYModuleChoiceViewManager.h"
#import "Masonry.h"

@interface XYModuleChoiceViewManager () {
    NSMutableArray *_mArrayModules;
}

@end

@implementation XYModuleChoiceViewManager

@synthesize mArrayModules = _mArrayModules;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _moduleChoiceView = [[XYModuleChoiceView alloc] init];
    self.moduleChoiceView.rootView.backgroundColor = [UIColor whiteColor];
    [self.moduleChoiceView setSliderStyle:XYMCV_FontColorShade];
    [self.moduleChoiceView setUseBlackShadowHeader:YES];
    [self.view addSubview:self.moduleChoiceView];
    [self.moduleChoiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.size.equalTo(self.view);
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
- (NSInteger)numberOfModules {
    return 0;
}
- (nonnull UIButton *)moduleChoice:(XYModuleChoiceView * _Nonnull)moduleChoiceView headerViewAtIndex:(NSInteger)index; {
    return nil;
}
- (nonnull UIViewController *)moduleChoice:(XYModuleChoiceView * _Nonnull)moduleChoiceView bottomViewAtIndex:(NSInteger)index {
    return nil;
}
- (UIView *)sliderView {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Resource.bundle/MC_Slider.png"]];
}
- (CGFloat)heightOfHeaderView {
    return 44;
}
#pragma mark - getter
- (NSMutableArray *)mArrayModules {
    if(!_mArrayModules) {
        _mArrayModules = [[NSMutableArray alloc] init];
    }
    return _mArrayModules;
}

@end
