//
//  XQBLoadingView.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/23.
//  Copyright (c)2014年 City-Online. All rights reserved.
//

#import "XQBLoadingView.h"
#import "AMTumblrHud.h"
#import "XQBUIFormatMacros.h"


@interface XQBLoadingView ()

@property (nonatomic, strong) AMTumblrHud *amTumblrHud;
@property (nonatomic, assign) UIOffset gmailOffset;
@property (nonatomic, assign) BOOL isWindow;

@end

@implementation XQBLoadingView

+ (instancetype)showLoadingAddedToWindow
{
    return [XQBLoadingView showLoadingAddedToView:[UIApplication sharedApplication].keyWindow];
}

+ (instancetype)showLoadingAddedToView:(UIView *)view
{
    return [XQBLoadingView showLoadingAddedToView:view withOffset:UIOffsetZero andBeginBlock:nil];
}

+ (instancetype)showLoadingAddedToView:(UIView *)view withOffset:(UIOffset)offset
{
    return [XQBLoadingView showLoadingAddedToView:view withOffset:offset andBeginBlock:nil];
}

+ (instancetype)showLoadingAddedToView:(UIView *)view withBeginBlock:(LoadingBlock)beginLoadingBlock
{
    return [XQBLoadingView showLoadingAddedToView:view withOffset:UIOffsetZero andBeginBlock:beginLoadingBlock];
}

+ (instancetype)showLoadingAddedToView:(UIView *)view withOffset:(UIOffset)offset andBeginBlock:(LoadingBlock)beginLoadingBlock
{
    XQBLoadingView *loading = [[self alloc] initWithView:view andOffset:offset];
    loading.hidden = YES;
    [view addSubview:loading];
    [loading showLoadingWithBlock:beginLoadingBlock];
    return loading;
}

+ (BOOL)hideLoadingForWindow
{
    return [XQBLoadingView hideLoadingForView:[UIApplication sharedApplication].keyWindow];
}

+ (BOOL)hideLoadingForView:(UIView *)view
{
    return [XQBLoadingView hideLoadingForView:view withEndBlock:nil];
}

+ (BOOL)hideLoadingForView:(UIView *)view withEndBlock:(LoadingBlock)endLoadingBlock
{
    XQBLoadingView *loading = [self loadingForView:view];
    if (loading != nil){
        [loading hideLoadingWithBlock:endLoadingBlock];
        return YES;
    }
    return NO;
}

+ (instancetype)loadingForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum){
        if ([subview isKindOfClass:self]){
            return (XQBLoadingView *)subview;
        }
    }
    return nil;
}



- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self){
        // Set default values for properties
        self.contentMode = UIViewContentModeCenter;
        self.opaque = NO;
        
//        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
        CGFloat offsetX;
        CGFloat offsetY;
        
        if (-frame.size.width/2+15 < _gmailOffset.horizontal && _gmailOffset.horizontal < frame.size.width/2-15) {
            offsetX = _gmailOffset.horizontal;
        } else {
            if (0 < _gmailOffset.horizontal) {
                offsetX = frame.size.width/2-27.5;
            } else {
                offsetX = -frame.size.width/2+27.5;
            }
        }
        
        if (-frame.size.height/2+15 < _gmailOffset.vertical && _gmailOffset.vertical < frame.size.height/2-15) {
            offsetY = _gmailOffset.vertical;
        } else {
            if (0 < _gmailOffset.vertical) {
                offsetY = frame.size.height/2-15;
            } else {
                offsetY = -frame.size.height/2+15;
            }
        }
        
        _amTumblrHud = [[AMTumblrHud alloc] initWithFrame:CGRectMake(frame.size.width/2-27.5+offsetX, frame.size.height/2-15+offsetY, 55, 30)];
        _amTumblrHud.hudColor = XQBColorGreen;
        [self addSubview:_amTumblrHud];
        
    }
    return self;
}

- (id)initWithView:(UIView *)view
{
    return [self initWithView:view andOffset:UIOffsetZero];
}

- (id)initWithView:(UIView *)view andOffset:(UIOffset)offset
{
    _gmailOffset = offset;
    
    if ([view isKindOfClass:[UIWindow class]]) {
        _isWindow = YES;
    }
    
    return [self initWithFrame:view.bounds];
}

- (void)showLoading
{
    [self showLoadingWithBlock:nil];
}

- (void)showLoadingWithBlock:(LoadingBlock)beginLoadingBlock
{
    self.hidden = NO;
    [_amTumblrHud showAnimated:YES];
    
    if (beginLoadingBlock){
        beginLoadingBlock(self);
    }
}

- (void)hideLoading
{
    [self hideLoadingWithBlock:nil];
}

- (void)hideLoadingWithBlock:(LoadingBlock)endLoadingBlock
{
    [_amTumblrHud hide];
    
    if (endLoadingBlock){
        endLoadingBlock(self);
    }
    
    [self removeFromSuperview];
}

@end
