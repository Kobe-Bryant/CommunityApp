 //
//  XQBConDPCategoryDetailViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/30.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBConDPCategoryDetailViewController.h"
#import "Global.h"
#import "XQBBaseTableView.h"
#import "NSObject_extra.h"
#import "MakePhoneCall.h"
#import <MAMapKit/MAMapKit.h>
#import "XQBCoreLBS.h"
#import "CustomAnnotationView.h"

@interface XQBConDPCategoryDetailViewController ()<UITableViewDataSource,UITableViewDelegate,MAMapViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MAMapView *maMapView;
@property (nonatomic, strong) MAPointAnnotation *userAnnotation;
@property (nonatomic, strong) MAPointAnnotation *businessAnnotation;

@end

@implementation XQBConDPCategoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:self.listItemModel.nameString];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    self.view.backgroundColor = XQBColorBackground;
    
    [self initMapView];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self markMapView];
}

#pragma makr --- ui
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[XQBBaseTableView alloc] initWithFrame:CGRectMake(0, 300-STATUS_NAV_BAR_HEIGHT, self.view.bounds.size.width, MainHeight-XQBHeightElement) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor redColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (void)initMapView
{
    NSInteger zoomLevel = 15-([self.listItemModel.distanceString floatValue]/1000);
    _maMapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    _maMapView.delegate = self;
    [_maMapView setMapType:MAMapTypeStandard];
    [_maMapView setZoomLevel:zoomLevel];
    //self.maMapView.showsUserLocation = YES;
    [self.view addSubview:_maMapView];
}

- (void)markMapView{

    XQBCoreLBS *coreLBS = [XQBCoreLBS shareInstance];
    _userAnnotation = [[MAPointAnnotation alloc] init];
    _userAnnotation.coordinate = CLLocationCoordinate2DMake(coreLBS.coordinate.latitude, coreLBS.coordinate.longitude);
    [_maMapView addAnnotation:_userAnnotation];
    
    _businessAnnotation = [[MAPointAnnotation alloc] init];
    _businessAnnotation.coordinate = CLLocationCoordinate2DMake([self.listItemModel.latitudeString doubleValue], [self.listItemModel.longitudeString doubleValue]);
    _businessAnnotation.title      = self.listItemModel.nameString;
    _businessAnnotation.subtitle   = self.listItemModel.addressString;
    [_maMapView addAnnotation:_businessAnnotation];
    [_maMapView setCenterCoordinate:_businessAnnotation.coordinate animated:YES];
    
    
}

#pragma mark --- action
- (void)backHandle:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        if (annotation == _userAnnotation) {
            annotationView.image = [UIImage imageNamed:@"bg_convenience_location_usericon.png"];
        }else if (annotation == _businessAnnotation){
            annotationView.image = [UIImage imageNamed:@"bg_convenience_location_business.png"];
        }
    
        return annotationView;
    }
    
    return nil;
    
}


#pragma mark ---tableView data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"identify";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:
                 UITableViewCellStyleSubtitle reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = RGB(51, 51, 51);
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    NSInteger row = [indexPath row];
    switch (row) {
        case 0:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.imageView.image = [UIImage imageNamed:@"dp_con_detail_location.png"];
            cell.textLabel.text = [NSString stringWithFormat:@"地址：%@",self.listItemModel.addressString];
            cell.textLabel.numberOfLines = 2;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            break;
        case 1:
        {
            if ([self.listItemModel.telephoneString length]==0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = [NSString stringWithFormat:@"电话：%@",@"暂无"];
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"电话：%@",self.listItemModel.telephoneString];
            }
            cell.imageView.image = [UIImage imageNamed:@"dp_con_detail_phone.png"];
        }
            break;
        case 2:
        {
            int grade = [self.listItemModel.avg_ratingString intValue];
            UIImage *starImage = [UIImage imageNamed:@"dp_con_detail_normalstar.png"];
            for (int i=0; i<5; i++) {
                UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(22*i+30, (cell.frame.size.height-starImage.size.height)/2, starImage.size.width, starImage.size.height)];
                if (i<=(grade-1)) {
                    [starImageView setImage:[UIImage imageNamed:@"dp_con_detail_highstar.png"]];
                }else{
                    [starImageView setImage:[UIImage imageNamed:@"dp_con_detail_normalstar.png"]];
                }
                [cell addSubview:starImageView];
            }
        }
            break;
        default:
            break;
    }
    return cell;

    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

#pragma mark --- tableView delegate


@end
