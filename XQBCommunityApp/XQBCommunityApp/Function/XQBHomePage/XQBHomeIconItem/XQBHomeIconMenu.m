//
//  XQBHomeIconMenu.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/31.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBHomeIconMenu.h"

#import "Global.h"
#import "UIButtonWithImageAndLabel.h"
#import "XQBHomeIconImageWithLable.h"

@interface XQBHomeIconMenu ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;


@end


static CGFloat itemWidth = 80;
static CGFloat itemHeight = 88;
//static CGFloat itemTopSpace = 10;
//static CGFloat itemLeftSpace = 10;

@implementation XQBHomeIconMenu

- (instancetype)initWithItmes:(NSArray *)items{
    self = [self initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    if (self) {
        [self setup];
        if (items.count > 0) {
            [self setMenuItems:items];
        }
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.backgroundColor = [UIColor whiteColor];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self addSubview:self.scrollView];
    _scrollView.delegate = self;
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 170, self.frame.size.width, 5)];
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = XQBColorGreen;
    [self addSubview:_pageControl];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bounds), CGRectGetWidth(self.bounds), 0.5)];
    view.backgroundColor = XQBColorElementSeparationLine;
    [self addSubview:view];
}

- (void)setMenuItems:(NSArray *)menuItems{
    _menuItems = [menuItems copy];

    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    if (self.menuItems.count < 9) {
        _pageControl.hidden = YES;
    }else{
        _pageControl.hidden = NO;
    }
    
    if ([self.menuItems count] == 0) {
        return;
    }
    
    NSInteger totalPage = ([self.menuItems count]-1)/8 + 1;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*totalPage, _scrollView.frame.size.height);
    _pageControl.numberOfPages = totalPage;
    _pageControl.currentPage = 0;
    
    
    [_menuItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        XQBHomeIconItem *item = obj;
        NSInteger page = idx/8;
        NSInteger row = (idx%8)/4;
        NSInteger column = (idx%8)%4;
        CGRect rect = CGRectMake(page*_scrollView.frame.size.width+itemWidth*column, itemHeight*row, itemWidth, itemHeight);
        XQBHomeIconImageWithLable *button = [[XQBHomeIconImageWithLable  alloc] initWithFrame:rect];
        button.tag = idx;
        button.frame = rect;
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.kImageView.frame = CGRectMake(20, 10, 40,40);
        button.kLabel.frame = CGRectMake(0, CGRectGetMaxY(button.kImageView.frame)+8, itemWidth,20);
        if (item.imageUrl.length > 0) {
            [button.kImageView sd_setImageWithURL:[NSURL URLWithString:item.imageUrl]];
        }
        [button.kLabel setText:item.title];
        [button addTarget:self action:@selector(clickButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
    }];
    

}

- (void)clickButtonHandle:(UIButton *)sender{
    NSLog(@"sender:%ld",sender.tag);
    if(self.menuItemHandleBlock){
        XQBHomeIconItem *item = [self.menuItems objectAtIndex:sender.tag];
        self.menuItemHandleBlock(sender.tag,item);
    }
}


#pragma mark ---
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
    _pageControl.currentPage = currentPage;
}

@end
