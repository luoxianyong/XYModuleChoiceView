//
//  XYSubModuleViewController.h
//  IMDemo
//
//  Created by 罗显勇 on 16/7/18.
//  Copyright © 2016年 罗显勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYSubModuleViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,nullable,copy) NSString *titleName;

- (nonnull instancetype)initWithTitle:(NSString * _Nullable)title;
- (void)onCurrentScreen;
- (void)leaveCurrentScreen;


#pragma mark - 可选
/*
 在tableView上创建表脚， 基于tableView
 monitoringStyle: 
    YES,监听contentOffset。立即出现footerButton
    NO, 监听frame。滑动出现footerButton  默认情况。
 必须先设置monitoringStyle，否则使用默认风格
 必须先设置tableViewStyle，否则默认为UITableViewStylePlain
 */
@property (nonatomic,assign,readwrite) BOOL monitoringStyle;
@property (nonatomic,assign,readwrite) UITableViewStyle tableViewStyle;
@property (nonatomic,strong,nullable,readonly) UIButton *footerButton;
@property (nonatomic,strong,nullable,readonly) UITableView *tableView;

@end
