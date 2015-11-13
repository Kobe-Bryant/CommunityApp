//
//  XQBConvenienceMenu.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/24.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBConvenienceMenu.h"
#import "Global.h"
#import "UIButtonWithImageAndLabel.h"

@interface XQBConvenienceMenu ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, copy) NSArray *menuItems;;

@end

static CGFloat itemWidth = 80;
static CGFloat itemHeight = 88;

@implementation XQBConvenienceMenu

- (instancetype)initWithItmes:(NSArray *)items{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 175)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.menuItems = [items copy];
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:self.scrollView];
        
        NSInteger totalPage = ([self.menuItems count]-1)/8 + 1;
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*totalPage, _scrollView.frame.size.height);
        
        
        [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            XQBConvenienceMenuItem *item = obj;
            NSInteger page = idx/8;
            NSInteger row = (idx%8)/4;
            NSInteger column = (idx%8)%4;
            CGRect rect = CGRectMake(page*_scrollView.frame.size.width+itemWidth*column, itemHeight*row, itemWidth, itemHeight);
            UIButtonWithImageAndLabel *button = [UIButtonWithImageAndLabel buttonWithType:UIButtonTypeCustom];
            button.tag = idx;
            button.frame = rect;
            button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if (item.image) {
                [button setImage:[UIImage imageNamed:item.image] forState:UIControlStateNormal];
            }
            
            if (item.imageUrl.length > 0) {
                [button sd_setImageWithURL:[NSURL URLWithString:item.imageUrl] forState:UIControlStateNormal];
            }
            [button setTitle:item.title forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:button];
        }];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bounds), CGRectGetWidth(self.bounds), 0.5)];
        view.backgroundColor = XQBColorElementSeparationLine;
        [self addSubview:view];
        
    }
    return self;
}

- (void)clickButtonHandle:(UIButton *)sender{
    NSLog(@"sender:%ld",sender.tag);
    if(self.menuItemHandleBlock){
        self.menuItemHandleBlock(sender.tag, sender.titleLabel.text);
    }
}

@end
