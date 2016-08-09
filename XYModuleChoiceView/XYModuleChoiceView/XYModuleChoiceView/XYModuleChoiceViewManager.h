//
//  XYModuleChoiceViewManager.h
//  XYModuleChoiceView
//
//  Created by 罗显勇 on 16/6/26.
//  Copyright © 2016年 JetLuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYModuleChoiceView.h"

@interface XYModuleChoiceViewManager : UIViewController<XYModuleChoiceViewDataSource>

@property (nonatomic,strong,nonnull,readonly) XYModuleChoiceView *moduleChoiceView;
@property (nonatomic,strong,nullable,readonly) NSMutableArray *mArrayModules;

@end
