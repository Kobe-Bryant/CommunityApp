//
//  SGPaymentOptionsView.m
//  CommunityAPP
//
//  Created by Oliver on 14-9-13.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "SGPaymentOptionsView.h"
#import "Global.h"

#define CMSSPayMentTopViewHeight        3.0
#define CMSSUnionPayTitle                   @"银联支付"
#define CMSSAlipayTitle                     @"支付宝"
#define CMSSTencetpayTitle                  @"微支付"

@interface CMSSPaymentSheetTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *payOrganizerIcon;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CMSSPaymentSheetTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{

    _payOrganizerIcon = [[UIImageView alloc] initWithFrame:CGRectMake(90, 10, 25, 25)];
    [self addSubview:_payOrganizerIcon];
    
    _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _titleLabel.clipsToBounds = YES;
    _titleLabel.textColor = XQBColorContent;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
}

@end

@interface SGPaymentOptionsView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) UIImageView *backgroundView;

@property (nonatomic, assign) NSInteger backgroundViewHeight;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic, strong) NSArray *imageDatasource;

@end

@implementation SGPaymentOptionsView

- (void)dealloc{

}

+(instancetype)sharePaymentSheet{
    
    return [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setup];
    }
    return self;
}

- (void)setup{
    self.roundedCorner = 0.0f;
    
    _datasource = [[NSArray alloc] initWithObjects:CMSSUnionPayTitle,CMSSAlipayTitle,/*CMSSTencetpayTitle,*/@"取消",nil];
    _imageDatasource = [[NSArray alloc] initWithObjects:@"",@"", nil];
    _backgroundViewHeight = CMSSPayMentTopViewHeight + [self.datasource count] * 44;
    [self initalize];
}

- (void)initalize{
    _backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, CMSSPayMentTopViewHeight)];
    //_backgroundView.image = stretchImage;
    _backgroundView.backgroundColor = RGB(87, 182, 16);
    [self addSubview:_backgroundView];
    
    CGRect rect = CGRectMake(0, CMSSPayMentTopViewHeight, self.bounds.size.height, 0);
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
}

- (id)initWithItemTitles:(NSArray *)itemTitles{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (self) {
        self.datasource = itemTitles;

    }
    return self;
}

- (void)layoutContentScrollView
{
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bounds = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, _backgroundViewHeight)};
    _backgroundView.frame = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, CMSSPayMentTopViewHeight)};
    _tableView.frame = (CGRect){CGPointMake(0, CMSSPayMentTopViewHeight),CGSizeMake(self.bounds.size.width, self.bounds.size.height-CMSSPayMentTopViewHeight)};
}

- (void)payActionClicked:(UIButton *)sender{
    if (self.payActionHandler) {
        self.payActionHandler(sender.tag);
    }
    [[SGActionView sharedActionView] dismissMenu:self Animated:YES];
}

#pragma mark --- tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"identify";
    CMSSPaymentSheetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[CMSSPaymentSheetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    if (indexPath.row == 3) {
        cell.titleLabel.textColor = RGB(153, 153, 153);
    }else{
        cell.titleLabel.textColor = XQBColorContent;
    }
    
    NSString *title = [self.datasource objectAtIndex:indexPath.row];
    cell.titleLabel.text = title;
    NSString *imageName = [self conifgCellImageWith:indexPath];
    if (imageName.length > 0) {
        cell.payOrganizerIcon.image = [UIImage imageNamed:imageName];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (NSString *)conifgCellImageWith:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                return @"xqb_unionpay_icon";
            }else if (indexPath.row == 1){
            
                return @"xqb_alipay_icon";
            }else if (indexPath.row == 2){
                
            }
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            if (self.payActionHandler) {
                self.payActionHandler(indexPath.row);
            }
        }
            break;
        case 1:
        {
            if (self.payActionHandler) {
                self.payActionHandler(indexPath.row);
            }
        }
            break;
        case 2:
        {
            NSLog(@"微支付");
        }
        default:
            break;
    }
     [[SGActionView sharedActionView] dismissMenu:self Animated:YES];
}

@end
