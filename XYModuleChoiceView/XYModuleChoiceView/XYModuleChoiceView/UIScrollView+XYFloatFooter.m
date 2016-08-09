//
//  UIScrollView+XYFloatFooter.m
//  XYModuleChoiceView
//
//  Created by 罗显勇 on 15/5/12.
//  Copyright © 2015年 JetLuo. All rights reserved.
//

#import "UIScrollView+XYFloatFooter.h"

NSString *const XYRefreshKeyPathContentOffset = @"contentOffset";
NSString *const XYRefreshKeyPathFrame = @"frame";
#define XYFloatFooter_Height 44
#define XYFloatFooter_Tag 120

@implementation UIScrollView (XYFloatFooter)

#pragma mark - 方式一：如果其他地方有对contentOffset进行监听会导致冲突
- (void)removeObserverOffsetInFloatFooterView {
    [self removeObserver:self forKeyPath:XYRefreshKeyPathContentOffset context:NULL];
    [self removeFloatFooterView];
}
- (void)addObserverOffsetInFloatFooterView:(UIView *)footerView {
    if(![self viewWithTag:XYFloatFooter_Tag]) {
        [self addTagOnFloatFooterView:footerView];
        [self addObserver:self forKeyPath:XYRefreshKeyPathContentOffset options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:NULL];
    } else {
        [self updateFrameOfFloatFooterView];
    }
}

#pragma mark - 方式二：如果其他地方有对frame进行监听会导致冲突
- (void)removeObserverFrameInFloatFooterView {
    [self removeObserver:self forKeyPath:XYRefreshKeyPathFrame context:NULL];
    [self removeFloatFooterView];
}
- (void)addObserverFrameInFloatFooterView:(nonnull UIView *)footerView {
    if(![self viewWithTag:XYFloatFooter_Tag]) {
        [self addTagOnFloatFooterView:footerView];
        [self addObserver:self forKeyPath:XYRefreshKeyPathFrame options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:NULL];
    } else {
        [self updateFrameOfFloatFooterView];
    }
}
- (void)scrollViewDidScroll {
    [self updateFrameOfFloatFooterView];
}

#pragma mark - Public Methods
- (void)removeFloatFooterView {
    [[self viewWithTag:XYFloatFooter_Tag] removeFromSuperview];
}
- (void)addTagOnFloatFooterView:(UIView *)footerView {
    [footerView setTag:XYFloatFooter_Tag];
    [footerView removeFromSuperview];
    [self addSubview:footerView];
    CGFloat height = CGRectGetHeight(footerView.frame) > 0 ? CGRectGetHeight(footerView.frame) : XYFloatFooter_Height;
    [footerView setFrame:CGRectMake(0, CGRectGetHeight(self.frame)-CGRectGetHeight(footerView.frame), CGRectGetWidth(footerView.frame), height)];
    [footerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
}
- (void)updateFrameOfFloatFooterView {
    UIView *footerView = [self viewWithTag:XYFloatFooter_Tag];
    if(!footerView) return;
    CGFloat height   = CGRectGetHeight(self.frame);
    CGFloat offset_y = self.contentOffset.y;
    CGFloat content_h= self.contentSize.height;
    CGFloat insets_h = self.contentInset.bottom;
    CGFloat now_y = 0;
    if(content_h > height) {
        if(offset_y + height >= content_h + insets_h) {
            now_y = content_h + insets_h - XYFloatFooter_Height;
        } else {
            now_y = offset_y + height - XYFloatFooter_Height;
        }
    } else {
        now_y = height - XYFloatFooter_Height;
    }
    [footerView setFrame:CGRectMake(0, now_y, CGRectGetWidth(self.frame), CGRectGetHeight(footerView.frame))];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if([keyPath isEqualToString:XYRefreshKeyPathContentOffset]) {
        [self updateFrameOfFloatFooterView];
    } else if([keyPath isEqualToString:XYRefreshKeyPathFrame]) {
        [self updateFrameOfFloatFooterView];
    }
}

@end





