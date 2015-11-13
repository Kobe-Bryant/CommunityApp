//
//  MallPopListViewController.m
//  CommunityAPP
//
//  Created by City-Online on 14-10-14.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "MallPopListViewController.h"
#import "MallPopListTableViewCell.h"
#import "Global.h"
#import "ECPopMenuItem.h"

#define POPMENU_WIDTH   165
#define TOP_OFFSET      22
#define CELL_HEIGHT     44

@interface MallPopListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *contentView;

@property (nonatomic, strong) NSMutableArray *menus;

@end

@implementation MallPopListViewController

- (void)dealloc{
    _popMenuDidDismissCompled = nil;
    _popMenuDidSlectedCompled = nil;
}

- (instancetype)initWithMenuItems:(NSArray *)items{
    self = [super init];
    if (self) {
        self.menus = [[NSMutableArray alloc] init];
        [self.menus addObjectsFromArray:items];
    }
    return self;
}

- (instancetype)initWithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION {
    self = [super init];
    if (self) {
        NSMutableArray *menuItems = [[NSMutableArray alloc] init];
        ECPopMenuItem *eachItem;
        va_list argumentList;
        if (firstObj) {
            [menuItems addObject:firstObj];
            va_start(argumentList, firstObj);
            while((eachItem = va_arg(argumentList, ECPopMenuItem *))) {
                [menuItems addObject:eachItem];
            }
            va_end(argumentList);
        }
        self.menus = menuItems;
        //[self setup];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor redColor];
    self.view.frame = CGRectMake(0, 0, POPMENU_WIDTH, TOP_OFFSET + [self.menus count]*CELL_HEIGHT);
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentView];
    
    if ([self respondsToSelector:@selector(setPreferredContentSize:)]) {
        self.preferredContentSize = CGSizeMake(POPMENU_WIDTH, TOP_OFFSET + [self.menus count]*CELL_HEIGHT);
    } else {
        self.contentSizeForViewInPopover=CGSizeMake(POPMENU_WIDTH, 110);
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 12, POPMENU_WIDTH-10, [self.menus count]*CELL_HEIGHT-2) style:UITableViewStylePlain];
    _tableView.layer.masksToBounds = YES;
    _tableView.layer.cornerRadius = 5.0f;
    _tableView.backgroundColor = RGBA(153, 153, 153, 0.6);
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    //_tableView.backgroundView = RGB(190,204,184);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor whiteColor];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
}

- (UIImageView *)contentView{
    if (_contentView == nil) {
        //UIImage *orginImage = [UIImage imageNamed:@"shoppingmall_pop_background.png"];
        //UIImage *image = [orginImage resizableImageWithCapInsets:UIEdgeInsetsMake(20, 10, 20, 10) resizingMode:UIImageResizingModeTile];
        _contentView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        //_contentView.image = image;
        _contentView.backgroundColor = [UIColor clearColor];//RGBA(153, 153, 153, 0.8);
    }
    
    return _contentView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark ---tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.menus count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"identify";
    MallPopListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[MallPopListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.backgroundColor = [UIColor clearColor];//RGBA(153, 153, 153, 0.6);
    }
    ECPopMenuItem *item = [self.menus objectAtIndex:indexPath.row];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.titleLabel.text = item.title;
        }else if (indexPath.row == 1) {
            cell.titleLabel.text = item.title;
        }else if (indexPath.row == 2){
            cell.titleLabel.text = item.title;
        }
    }
    cell.imageView.image = item.image;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.popMenuDidSlectedCompled) {
        self.popMenuDidSlectedCompled(indexPath.row);
    }
    
}

@end
