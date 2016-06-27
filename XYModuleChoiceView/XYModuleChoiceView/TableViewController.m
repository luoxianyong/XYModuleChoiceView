//
//  TableViewController.m
//  XYModuleChoiceView
//
//  Created by 罗显勇 on 16/6/26.
//  Copyright © 2016年 JetLuo. All rights reserved.
//

#import "TableViewController.h"
#import "Masonry.h"

@interface TableViewController ()<UITableViewDelegate,UITableViewDataSource>
@end

@implementation TableViewController
- (void)dealloc {
    NSLog(@"确认释放%@",self.titleName);
}
- (instancetype)initWithTitle:(NSString *)title {
    if(self = [super init]) {
        self.titleName = title;
    }
    return self;
}
- (void)loadView {
    [super loadView];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:_tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.equalTo(self.view);
    }];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 22;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@_第%li行",self.titleName,(long)indexPath.row];
    return cell;
}

@end
