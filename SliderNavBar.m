//
//  SliderNavBar.m
//  JJJF
//
//  Created by 远方 on 2017/5/10.
//  Copyright © 2017年 远方. All rights reserved.
//

#import "SliderNavBar.h"

@interface SliderNavBar ()
{
    CGFloat _buttonW;//按钮宽度
    CGFloat _fontSize;//按钮字体大小
    UIColor *_selectedColor;//选中颜色
    UIColor *_unSelectedColor;//未选中颜色
    BOOL _isFull;//按钮底部标记线是否满尺寸
    CGFloat _lineWidth;//底部按钮宽度
    CGFloat _lineX;//底部按钮的x
    BOOL _canScrollOrTap;//是否可滑动或点击
}
DEFINE_PROPERTY_STRONG(UIScrollView, *buttonScorllView);//放置按钮的ScrollView
DEFINE_PROPERTY_STRONG(NSArray, *buttonArr);//装button的数组
DEFINE_PROPERTY_STRONG(UIView, *bottomLine);//按钮下方的标记横线

@end

@implementation SliderNavBar

/**
 初始化Nav按钮
 注：
 4 inch 按钮数为5、6时对应的buttonW为64 53
 4.7 inch 按钮数为5、6时对应的buttonW为75 62
 5.5 inch 按钮数为5、6、7时对应的buttonW为83 69 59
 根据上面计算的数据得出结论：在buttonW不能低于60，在buttonW将要低于60时，buttonScorllView设置为可滑动的，并将buttonW设为64
 */
- (instancetype)initWithFrame:(CGRect)frame buttonTitleArray:(NSArray *)array andTitleFontSize:(CGFloat)fontSize andSelectedColor:(UIColor *)selectedColor andUnselectedColor:(UIColor *)unselectedolor andBottomLineisFull:(BOOL)isFull canScrollOrTap:(BOOL)canScrollOrTap {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.buttonArr = [NSArray arrayWithArray:array];
        _fontSize = fontSize;
        _selectedColor = [[UIColor alloc] init];
        _selectedColor = selectedColor;
        _unSelectedColor = [[UIColor alloc] init];
        _unSelectedColor = unselectedolor;
        _isFull = isFull;
        _canScrollOrTap = canScrollOrTap;
        [self setUIViewWith:self.buttonArr];
    }
    return self;
}

/**
 设置显示哪个类型的产品
 注：
 4 inch 按钮数为5、6时对应的buttonW为64 53
 4.7 inch 按钮数为5、6时对应的buttonW为75 62
 5.5 inch 按钮数为5、6、7时对应的buttonW为83 69 59
 根据上面计算的数据得出结论：在buttonW不能低于60，在buttonW将要低于60时，buttonScorllView设置为可滑动的，并将buttonW设为64
 */
- (void)setUIViewWith:(NSArray *)buttonArray {
    self.buttonScorllView = [[UIScrollView alloc] initWithFrame:self.frame];
    self.buttonScorllView.backgroundColor = [UIColor clearColor];
    self.buttonScorllView.showsHorizontalScrollIndicator = NO;
    self.buttonScorllView.showsVerticalScrollIndicator = NO;
    self.buttonScorllView.scrollsToTop = NO;
    self.buttonScorllView.scrollEnabled = _canScrollOrTap;
    [self addSubview:self.buttonScorllView];
    _buttonW = self.frame.size.width/buttonArray.count;//按钮宽度
    if (_buttonW < 60.f) {
        _buttonW = 64.f;
        self.buttonScorllView.contentSize = CGSizeMake(_buttonW * buttonArray.count, self.frame.size.height);
    } else {
        self.buttonScorllView.scrollEnabled = NO;
        self.buttonScorllView.contentSize = self.frame.size;
        self.buttonScorllView.pagingEnabled = YES;
    }
    for (int i = 0; i < buttonArray.count; i++) {
        CGFloat x = _buttonW * i;//每一个按钮的x坐标
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, 0, _buttonW, self.frame.size.height);
        [button setTitle:buttonArray[i] forState:UIControlStateNormal];
        [button setTitleColor:_unSelectedColor forState:UIControlStateNormal];
        button.titleLabel.font = FONT_SIZE(_fontSize);
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(buttonSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 20170301 + i;
        button.userInteractionEnabled = _canScrollOrTap;
        [self.buttonScorllView addSubview:button];
        
        if (i == 0) {
            _currentIndex = 0;
            [button setTitleColor:_selectedColor forState:UIControlStateNormal];
            button.titleLabel.font = FONT_SIZE(_fontSize + 1);
        }
    }
    
    UIButton *btn = (UIButton *)[self viewWithTag:20170301 + _currentIndex];
    if (_isFull) {
        _lineWidth = self.frame.size.width/self.buttonArr.count;
        _lineX = 0.f;
    } else {
        
        _lineWidth = [StringUtil boundingRectWithText:btn.titleLabel.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:btn.titleLabel.font].width;
        _lineX = self.buttonScorllView.contentSize.width / (2*self.buttonArr.count) - _lineWidth / 2.0;
    }
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(_lineX, self.frame.size.height - 2, _lineWidth, 2)];
    _bottomLine.backgroundColor = _selectedColor;
    [self.buttonScorllView addSubview:_bottomLine];
    
}

//按钮点击事件
- (void)buttonSelectedAction:(UIButton *)button {
    [self changeSelectedButton:button.tag - 20170301];
    [self changeScrollOfSet:button.tag - 20170301];
    
    //设置_pageViewController的滑动方向
    UIPageViewControllerNavigationDirection direction = UIPageViewControllerNavigationDirectionForward;
    if (_currentIndex - button.tag + 20170301 > 0) {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    _currentIndex = button.tag - 20170301;
    if (self.navBarTapBlock){
        _navBarTapBlock(_currentIndex, direction);
    }
}

//改变底部横线的位置
- (void)moveTheLineViewWithIndex:(NSInteger)index {
    [UIView animateWithDuration:0.35f animations:^{
        UIButton *btn = (UIButton *)[self viewWithTag:20170301 + index];
        if (_isFull) {
            _lineX = index * _lineWidth;
        } else {
            _lineWidth = [StringUtil boundingRectWithText:btn.titleLabel.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:btn.titleLabel.font].width;
            _lineX = self.buttonScorllView.contentSize.width*(1 + 2*index) / (2*self.buttonArr.count) - _lineWidth / 2.0;
        }
        CGRect frame = _bottomLine.frame;
        frame.origin.x = _lineX;
        frame.size.width = _lineWidth;
        _bottomLine.frame = frame;
    }];
}

#pragma mark - Methods

/**
 改变选中的按钮
 
 @param index 按钮的次序
 */
- (void)changeSelectedButton:(NSInteger)index {
    for (int i = 0; i < _buttonArr.count; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:20170301 + i];
        [btn setTitleColor:_unSelectedColor forState:UIControlStateNormal];
        btn.titleLabel.font = FONT_SIZE(_fontSize);
        if (btn.tag == 20170301 + index) {
            [btn setTitleColor:_selectedColor forState:UIControlStateNormal];
            btn.titleLabel.font = FONT_SIZE(_fontSize + 1);
            [self moveTheLineViewWithIndex:index];
        }
    }
}

/**
 往哪个按钮Index滑动
 */
-(void)moveToIndex:(NSInteger)index {
    if (index >= 0 && index < _buttonArr.count) {
        if (index != _currentIndex) {//保证在一个item内滑动，只执行一次
            [self changeSelectedButton:index];
            [self changeScrollOfSet:index];
        }
        _currentIndex = index;
    }
}

//移动ScrollView
-(void)changeScrollOfSet:(NSInteger)index {
    float halfWidth = CGRectGetWidth(self.frame)/2.0;
    float scrollWidth = self.buttonScorllView.contentSize.width;
    float leftSpace = _buttonW * index - halfWidth + _buttonW/2.0;
    
    if(leftSpace < 0) {
        leftSpace = 0;
    }
    if(leftSpace > scrollWidth - 2*halfWidth) {
        leftSpace = scrollWidth - 2*halfWidth;
    }
    [self.buttonScorllView setContentOffset:CGPointMake(leftSpace, 0) animated:YES];
}

@end
