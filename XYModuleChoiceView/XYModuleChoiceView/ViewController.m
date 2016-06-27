//
//  ViewController.m
//  XYModuleChoiceView
//
//  Created by 罗显勇 on 16/6/26.
//  Copyright © 2016年 JetLuo. All rights reserved.
//

#import "ViewController.h"
#import "ModuleViewControllerManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"XYModuleChoiceView", nil);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellReuseIdentifier = @"identifierOfCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    NSString *titleName = nil;
    switch (indexPath.row) {
        case 0:
            titleName = @"下划线显示";
            break;
        case 1:
            titleName = @"滑块显示";
            break;
        case 2:
            titleName = @"字体颜色显示";
            break;
        case 3:
            titleName = @"渐变";
            break;
        default:
            break;
    }
    cell.textLabel.text = titleName;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ModuleViewControllerManager *manager = [[ModuleViewControllerManager alloc] init];
    manager.type = (int)indexPath.row;
    manager.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [self.navigationController pushViewController:manager animated:YES];
}

@end
