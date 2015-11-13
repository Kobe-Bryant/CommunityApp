//
//  DateSelectPopUpView.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/25.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "DateSelectPopUpView.h"
#import "XQBUIFormatMacros.h"

static const CGFloat kMaxTableViewHeight = 200.0f;
static const CGFloat kTableViewCellHeight = 40.0f;

@interface DateSelectPopUpView ()  <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIButton *backGroundButton;
@property (nonatomic, strong) UITableView *yearTableView;
@property (nonatomic, strong) UITableView *monthTableView;

@property (nonatomic, strong) NSMutableArray *yearsArray;
@property (nonatomic, strong) NSMutableArray *monthsArray;
@property (nonatomic, assign) NSInteger yearIndex;

@end


@implementation DateSelectPopUpView

- (instancetype)initWithYearItems:(NSArray *)yearItems andMonthItems:(NSArray *)monthItems
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _yearsArray = [[NSMutableArray alloc] initWithArray:yearItems];
        _monthsArray = [[NSMutableArray alloc] initWithArray:monthItems];
        _yearIndex = 0;
    }
    
    return self;
}

- (void)showInWindow
{
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)showInView:(UIView *)view
{
    [self showInView:view withOffset:UIOffsetZero];
}

- (void)showInView:(UIView *)view withOffset:(UIOffset)offset
{
    if (!_backGroundButton) {
        _backGroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backGroundButton.frame = CGRectMake(offset.horizontal, offset.vertical, view.frame.size.width, view.frame.size.height);
        _backGroundButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [_backGroundButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        [_backGroundButton addSubview:self];
        
        [self addSubview:self.yearTableView];
        [_yearTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self addSubview:self.monthTableView];
        self.frame = CGRectMake(0, 0, MainWidth, kMaxTableViewHeight);
        
        [view addSubview:_backGroundButton];
        
        _backGroundButton.alpha = 0.0f;
        [UIView animateWithDuration:0.3f animations:^{
            _backGroundButton.alpha = 1.0f;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)dismiss
{
    [self dismissWithAnimated:YES];
}

- (void)dismissWithAnimated:(BOOL)animated
{
    if (!animated) {
        [_backGroundButton removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        _backGroundButton.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_backGroundButton removeFromSuperview];
    }];
}

#pragma mark --- UI
- (UITableView *)yearTableView
{
    if (!_yearTableView) {
        _yearTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainWidth/2, kMaxTableViewHeight) style:UITableViewStylePlain];
        _yearTableView.tag = 0;
        _yearTableView.dataSource = self;
        _yearTableView.delegate = self;
        _yearTableView.showsHorizontalScrollIndicator = NO;
        _yearTableView.showsVerticalScrollIndicator = NO;
        _yearTableView.backgroundColor = [UIColor whiteColor];
        _yearTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        _yearTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _yearTableView.separatorColor = XQBColorInternalSeparationLine;
    }
    
    return _yearTableView;
}

- (UITableView *)monthTableView
{
    if (!_monthTableView) {
        _monthTableView = [[UITableView alloc] initWithFrame:CGRectMake(MainWidth/2, 0, MainWidth/2, kMaxTableViewHeight) style:UITableViewStylePlain];
        _monthTableView.tag = 1;
        _monthTableView.dataSource = self;
        _monthTableView.delegate = self;
        _monthTableView.showsHorizontalScrollIndicator = NO;
        _monthTableView.showsVerticalScrollIndicator = NO;
        _monthTableView.backgroundColor = XQBColorBackground;
        _monthTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        _monthTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _monthTableView.separatorColor = XQBColorInternalSeparationLine;
    }
    
    return _monthTableView;
}

#pragma mark --- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0) {
        return _yearsArray.count;
    } else {
        return _monthsArray.count>0 ? [[_monthsArray objectAtIndex:_yearIndex] count] : 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
        if (tableView.tag == 0) {
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = XQBColorBackground;
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
#ifdef __IPHONE_8_0
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
#endif
    }
    
    if (tableView.tag == 0) {
        cell.textLabel.text = _yearsArray.count > indexPath.row ? [[_yearsArray objectAtIndex:indexPath.row] stringValue]: @"";
        if (indexPath.row == 0) {
            cell.selected = YES;
        }
        
    } else {
        cell.backgroundColor = XQBColorBackground;
        cell.textLabel.text = [[_monthsArray objectAtIndex:_yearIndex] count] > indexPath.row ? [[[_monthsArray objectAtIndex:_yearIndex] objectAtIndex:indexPath.row] stringValue]: @"";
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = XQBFontContent;
    cell.textLabel.textColor = XQBColorContent;
    
    return cell;
}

#pragma mark --- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        _yearIndex = indexPath.row;
        [_monthTableView reloadData];
    } else {
        if (self.dateDidSelectedBlock) {
            self.dateDidSelectedBlock([[_yearsArray objectAtIndex:_yearIndex] integerValue], [[[_monthsArray objectAtIndex:_yearIndex] objectAtIndex:indexPath.row] integerValue]);
        }
    }
}
@end
