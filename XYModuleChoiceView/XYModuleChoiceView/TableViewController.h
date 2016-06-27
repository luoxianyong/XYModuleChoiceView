//
//  TableViewController.h
//  XYModuleChoiceView
//
//  Created by 罗显勇 on 16/6/26.
//  Copyright © 2016年 JetLuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UIViewController
@property (nonatomic,strong,nonnull,readonly) UITableView *tableView;
@property (nonatomic,nullable,copy) NSString *titleName;
- (nonnull instancetype)initWithTitle:(NSString * _Nullable)title;
@end
