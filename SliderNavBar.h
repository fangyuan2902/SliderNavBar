//
//  SliderNavBar.h
//  JJJF
//
//  Created by 远方 on 2017/5/10.
//  Copyright © 2017年 远方. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SliderNavBarTapBlock)(NSInteger index, UIPageViewControllerNavigationDirection direction);

/* 滑动按钮导航栏 */
@interface SliderNavBar : UIView

DEFINE_PROPERTY_COPY(SliderNavBarTapBlock, navBarTapBlock);//控制器主动调用的Block
DEFINE_PROPERTY_ASSIGN(NSInteger, currentIndex);//当前选中按钮次序

/**
 初始化Nav按钮
 
 @param frame 尺寸
 @param array 按钮名称数组
 @param fontSize 按钮字体大小
 @param selectedColor 选中颜色
 @param unselectedolor 未选中颜色
 @param isFull 底部标记横线是否满尺寸(满尺寸 = 按钮宽度，非满尺寸 = 文字宽度)
 @param canScrollOrTap 是否可滑动或点击
 @return return value description
 */
- (instancetype)initWithFrame:(CGRect)frame buttonTitleArray:(NSArray *)array andTitleFontSize:(CGFloat)fontSize andSelectedColor:(UIColor *)selectedColor andUnselectedColor:(UIColor *)unselectedolor andBottomLineisFull:(BOOL)isFull canScrollOrTap:(BOOL)canScrollOrTap;

/**
 往哪个按钮Index滑动
 
 @param index 按钮次序
 */
-(void)moveToIndex:(NSInteger)index;

@end
