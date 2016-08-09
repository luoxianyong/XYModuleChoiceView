//
//  UIScrollView+XYFloatFooter.h
//  XYModuleChoiceView
//
//  Created by 罗显勇 on 15/5/12.
//  Copyright © 2015年 JetLuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (XYFloatFooter)

#pragma mark - 方式一：如果其他地方有对contentOffset进行监听会导致冲突
//在dealloc中必须删除
- (void)removeObserverOffsetInFloatFooterView;
- (void)addObserverOffsetInFloatFooterView:(nonnull UIView *)footerView;

#pragma mark - 方式二：如果其他地方有对frame进行监听会导致冲突
//在dealloc中必须删除
- (void)removeObserverFrameInFloatFooterView;
- (void)addObserverFrameInFloatFooterView:(nonnull UIView *)footerView;
//在scrollViewDidScroll代理方法中调用
- (void)scrollViewDidScroll;

@end


