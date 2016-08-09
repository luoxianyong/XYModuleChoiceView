//
//  XYSubModuleViewController.m
//  IMDemo
//
//  Created by 罗显勇 on 16/7/18.
//  Copyright © 2016年 罗显勇. All rights reserved.
//

#import "XYSubModuleViewController.h"
#import "UIScrollView+XYFloatFooter.h"
#import "Masonry.h"
#import "XYMacroDefinition.h"

@interface XYSubModuleViewController () {
    UITableView *_tableView;
    UIButton *_footerButton;
}

@end

@implementation XYSubModuleViewController

@synthesize tableView = _tableView, footerButton = _footerButton;

- (void)dealloc {
    if(_footerButton) {
        self.monitoringStyle
        ? [self.tableView removeObserverOffsetInFloatFooterView]
        : [self.tableView removeObserverFrameInFloatFooterView];
    }
}

- (instancetype)initWithTitle:(NSString *)title {
    if(self = [super init]) {
        self.titleName = title;
        self.tableViewStyle = UITableViewStylePlain;
    }
    return self;
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - getter methods
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.tableViewStyle];
        _tableView.backgroundColor = XYUIColorFromRGBVlaue(241, 241, 241);
        self.tableView.rowHeight = 48;
        [self.view addSubview:_tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [self.tableView setDelegate:self];
        [self.tableView setDataSource:self];
    }
    return _tableView;
}
- (UIButton *)footerButton {
    if(!_footerButton) {
        _footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _footerButton.backgroundColor = XYUIColorFromRGB(0xf6f6f6f);
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 44, 0)];
         self.monitoringStyle ? [self.tableView addObserverOffsetInFloatFooterView:_footerButton] : [self.tableView addObserverFrameInFloatFooterView:_footerButton];
    }
    return _footerButton;
}

#pragma mark - 加载 / 释放
- (void)onCurrentScreen {
    //-- 在这里加载数据是最佳位置
}
- (void)leaveCurrentScreen {
    /*
     可以在这里释放数据数据,也可以在viewWillDisappear中释放数据。
     不同之处在于只要当前页离开了屏幕，就会调用leaveCurrentScreen释放。而此时未必会执行viewWillDisappear方法
     */
}

@end
