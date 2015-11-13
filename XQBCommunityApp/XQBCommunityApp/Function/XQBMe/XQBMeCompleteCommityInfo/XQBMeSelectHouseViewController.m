//
//  XQBMeSelectHouseViewController.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/6.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "XQBMeSelectHouseViewController.h"
#import "Global.h"
#import "CommunityPeriodModel.h"
#import "XQBCompleteInfoPickerView.h"
#import "XQBSeleteHouseTableViewCell.h"

@interface XQBMeSelectHouseViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) XQBBaseTableView *tableView;


@property (nonatomic, strong) XQBCompleteInfoPickerView *communityPeriodsPicker;
@property (nonatomic, strong) XQBCompleteInfoPickerView *comunityBuildHousePicker;

@property (nonatomic, strong) CommunityPeriodModel *currentPeriodModel;
@property (nonatomic, strong) CommunityBuildModel *currentBuildModel;
@property (nonatomic, strong) CommunityBuildUnitModel *currentUnitModel;
@property (nonatomic, strong) CommunityHouseModel *currentHouseModel;

@property (nonatomic, strong) UISearchBar *houseSearchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;

@end

@implementation XQBMeSelectHouseViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.view.backgroundColor = XQBColorBackground;
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"完善小区资料"];
    
    [self.view setExclusiveTouch:YES];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    [self.view addSubview:self.tableView];
    
    [self requestHouses];
}

#pragma mark ---

#pragma mark --- ui
- (void)initalizeSearchBar{
    
    _houseSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , 40)];
    _houseSearchBar.delegate = self;
    [_houseSearchBar setPlaceholder:@"请输入房间号"];
    float version = [[[ UIDevice currentDevice ] systemVersion ] floatValue ];
    if ([ _houseSearchBar respondsToSelector : @selector (barTintColor)]) {
        float  iosversion7_1 = 7.1 ;
        if (version >= iosversion7_1)
        {
            //iOS7.1
            [[[[_houseSearchBar.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
            [_houseSearchBar setBackgroundColor :RGB(240, 240, 240)];
        }
        else
        {
            //iOS7.0
            [_houseSearchBar setBarTintColor :[ UIColor clearColor ]];
            [_houseSearchBar setBackgroundColor :RGB(240, 240, 240)];
        }
    }
    else
    {
        //iOS7.0 以下
        [[_houseSearchBar.subviews objectAtIndex : 0 ] removeFromSuperview ];
        [_houseSearchBar setBackgroundColor :RGB(240, 240, 240)];
    }
    [self.view addSubview:_houseSearchBar];
    
    _searchController = [[UISearchDisplayController alloc] initWithSearchBar:_houseSearchBar contentsController:self];
    _searchController.active = NO;
    _searchController.searchResultsDataSource = self;
    _searchController.searchResultsDelegate = self;
}


- (XQBBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[XQBBaseTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-STATUS_NAV_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (XQBCompleteInfoPickerView *)communityPeriodsPicker{
    if (!_communityPeriodsPicker) {
        _communityPeriodsPicker = [XQBCompleteInfoPickerView initalize];
        _communityPeriodsPicker.pickerView.delegate = self;
        _communityPeriodsPicker.pickerView.dataSource = self;
        
        [_communityPeriodsPicker setPickComplete:^(NSString *result) {
            
        }];
        [_communityPeriodsPicker setPickCancel:^(NSString *result) {
            
        }];
        
    }
    return _communityPeriodsPicker;
}

- (XQBCompleteInfoPickerView *)comunityBuildHousePicker{
    if (!_comunityBuildHousePicker) {
        _comunityBuildHousePicker = [XQBCompleteInfoPickerView initalize];
        _comunityBuildHousePicker.pickerView.delegate = self;
        _comunityBuildHousePicker.pickerView.dataSource = self;
        [_comunityBuildHousePicker setPickComplete:^(NSString *result) {
            
        }];
        [_comunityBuildHousePicker setPickCancel:^(NSString *result) {
            
        }];
    }
    return _comunityBuildHousePicker;
}

#pragma mark --- network
- (void)requestHouses{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    if (self.communityId) {
        [parameters setObject:self.communityId forKey:@"communityId"];
    }
    
    [parameters addSignatureKey];
    [XQBLoadingView showLoadingAddedToView:self.view withOffset:UIOffsetMake(0, -150)];
    [manager GET:API_HOUSE_URL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [XQBLoadingView hideLoadingForView:self.view];
             [self.dataSource removeAllObjects];
             if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]){
                 
                 NSArray *periods = [responseObject objectForKey:@"data"];
                 
                 for (NSDictionary *periodDic in periods) {
                     CommunityPeriodModel *model = [[CommunityPeriodModel alloc] init];
                     model.periodName = [periodDic objectForKey:@"period"];
                     
                     NSArray *builds = [periodDic objectForKey:@"builds"];
                     for (NSDictionary *buildDic in builds) {
                         CommunityBuildModel *buildModel = [[CommunityBuildModel alloc] init];
                         buildModel.buildName = [buildDic objectForKey:@"build"];
                         [model.builds addObject:buildModel];
                         
                         NSArray *units = [buildDic objectForKey:@"units"];
                         for (NSDictionary *unitDic in units) {
                             CommunityBuildUnitModel *unitModel = [[CommunityBuildUnitModel alloc] init];
                             unitModel.unitName = DealWithJSONValue([unitDic objectForKey:@"unit"]);
                             [buildModel.unitsArray addObject:unitModel];
                             NSArray *houses = [unitDic objectForKey:@"houseNumbers"];
                             for (NSDictionary *houseDic in houses) {
                                 CommunityHouseModel *houseModel = [[CommunityHouseModel alloc] init];
                                 houseModel.houseId = [[houseDic objectForKey:@"id"] stringValue];
                                 houseModel.houseNumber = [houseDic objectForKey:@"houseNumber"];
                                 [unitModel.houseNumbers addObject:houseModel];
                             }
                         }
                     }
                     
                     [self.dataSource addObject:model];
                     
                 }
                 [self.communityPeriodsPicker.pickerView reloadAllComponents];
             }else{
                 //加载服务器异常界面
                 [self.view makeCustomToast:@"服务器异常"];
             }
             
             [self.tableView reloadData];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [XQBLoadingView hideLoadingForView:self.view];
             NSLog(@"网络异常error-->%@",error);
         }];
}

- (void)requestCompleteCommunityInfo{
    if (!self.currentHouseModel) {
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    if (self.currentHouseModel) {
        [parameters setObject:self.currentHouseModel.houseId forKey:@"houseNumberId"];
    }
    
    [parameters addSignatureKey];
    
    [manager POST:API_USER_PERFECT_COMMUNITY_INFORMATION
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]){
                 
                 NSDictionary *dic = [responseObject objectForKey:@"data"];
                 [UserModel shareUser].provinceId = [[dic objectForKey:@"provinceId"] stringValue];
                 [UserModel shareUser].provinceName = DealWithJSONValue([dic objectForKey:@"provinceName"]);
                 [UserModel shareUser].cityId = [[dic objectForKey:@"cityId"] stringValue];
                 [UserModel shareUser].cityName = DealWithJSONValue([dic objectForKey:@"cityName"]);
                 [UserModel shareUser].communityId = [[dic objectForKey:@"communityId"] stringValue];
                 [UserModel shareUser].communityName = DealWithJSONValue([dic objectForKey:@"communityName"]);
                 [UserModel shareUser].userType = DealWithJSONValue([dic objectForKey:@"userType"]);
                 [UserModel shareUser].residentDesc = DealWithJSONValue([dic objectForKey:@"residentDesc"]);
                 
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:kXQBUserCertificationSucceedNotification object:nil];
                 
                 [self popCompleteInfoViewControllers];
                
             }else{
                 //加载服务器异常界面
             }
             
             
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"网络异常error-->%@",error);
         }];

}

#pragma mark --- action
- (void)backHandle:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popCompleteInfoViewControllers{
    
    
    if (self.hiddenNavigationBarWhenPoped) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    NSArray *viewControllers = self.navigationController.viewControllers;
    if ([viewControllers count] <= 3) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        NSInteger index = [viewControllers indexOfObject:self];
        UIViewController *viewController = [viewControllers objectAtIndex:(index-3)];
        [self.navigationController popToViewController:viewController animated:YES];
    }
}

#pragma mark ---tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }else if (section == 2){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"identify";
    XQBSeleteHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[XQBSeleteHouseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = [self cellConfigWithIndexPath:indexPath];
    cell.contentLabel.text = [self cellConfigHouseWithIndexPath:indexPath];
    if (indexPath.section == 2 && indexPath.row == 0) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = XQBColorGreen;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }else{
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}

- (NSString *)cellConfigWithIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                return @"期/区";
            }
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                return @"楼栋";
            }
                break;
            case 1:
            {
                return @"单元";
                break;
            }
            case 2:
            {
                return @"房号";
            }
                
            default:
                break;
        }
    }else if (indexPath.section == 2){
        switch (indexPath.row) {
            case 0:
                return @"确定";
                break;
                
            default:
                break;
        }
    }
    return nil;
}

- (NSString *)cellConfigHouseWithIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                return self.currentPeriodModel.periodName;
            }
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                return self.currentBuildModel.buildName;
            }
                break;
            case 1:
            {
                return self.currentUnitModel.unitName;
            }
                break;
            case 2:
            {
                return self.currentHouseModel.houseNumber;
            }
                
            default:
                break;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0){
        [self.communityPeriodsPicker showPickerView];
        [self.communityPeriodsPicker.pickerView reloadAllComponents];
    }else if (indexPath.section == 1){
        if (self.currentPeriodModel == nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请选择期/区" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        [self.comunityBuildHousePicker showPickerView];
        [self.comunityBuildHousePicker.pickerView reloadAllComponents];
    }else if (indexPath.section == 2){
        if (self.currentPeriodModel.periodName.length == 0) {
            [self.view makeCustomToast:@"请选择期/区" duration:1.0 position:CSToastPositionTop];
        } else if (self.currentBuildModel.buildName.length == 0) {
            [self.view makeCustomToast:@"请选择楼栋" duration:1.0 position:CSToastPositionTop];
        } else if (self.currentUnitModel.unitName.length == 0) {
            [self.view makeCustomToast:@"请选择单元" duration:1.0 position:CSToastPositionTop];
        } else if (self.currentHouseModel.houseNumber.length == 0) {
            [self.view makeCustomToast:@"请选择房号" duration:1.0 position:CSToastPositionTop];
        } else {
            [self requestCompleteCommunityInfo];
        }
    }
}

#pragma mark --- tableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return XQBSpaceVerticalElement;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, XQBSpaceVerticalElement)];
    backgroundView.backgroundColor = XQBColorBackground;
    
    return backgroundView;
}


#pragma mark --- pickerView datasource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.communityPeriodsPicker.pickerView == pickerView) {
        return 1;
    }else if (self.comunityBuildHousePicker.pickerView == pickerView){
        return 3;
    }
    return 0;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (self.communityPeriodsPicker.pickerView == pickerView) {
        return [self.dataSource count];
    }else if (self.comunityBuildHousePicker.pickerView == pickerView){
        if (component == 0) {
           return [self.currentPeriodModel.builds count];
        }else if (component == 1){
            return [self.currentBuildModel.unitsArray count];
        }else if (component == 2){
            return [self.currentUnitModel.houseNumbers count];
        }
        
    }
    return 0;
}

#pragma mark --- pickerView Delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (self.communityPeriodsPicker.pickerView == pickerView) {
        CommunityPeriodModel *periodModel = ([self.dataSource count]>row)?[self.dataSource objectAtIndex:row]:nil;
        if (periodModel && (row == 0) && self.currentPeriodModel == nil) {
            self.currentPeriodModel = periodModel;
            [pickerView selectRow:0 inComponent:component animated:YES];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        return periodModel.periodName;
    }else if (self.comunityBuildHousePicker.pickerView == pickerView){
        
        if (component == 0) {
            CommunityBuildModel *buildModel = ([self.currentPeriodModel.builds count]>row)?[self.currentPeriodModel.builds objectAtIndex:row]:nil;
            if (buildModel && (row == 0) && self.currentBuildModel == nil) {
                self.currentBuildModel = buildModel;
                [pickerView selectRow:0 inComponent:component animated:YES];
                [pickerView reloadComponent:1];
            }
            return buildModel.buildName;
        }else if (component == 1){
            NSInteger index = [pickerView selectedRowInComponent:0];
            if (index >= 0) {
                CommunityBuildModel *buildModel = ([self.currentPeriodModel.builds count]>index)?[self.currentPeriodModel.builds objectAtIndex:index]:nil;
                if (buildModel) {
                    CommunityBuildUnitModel *unitModel = ([buildModel.unitsArray count]>row)?[buildModel.unitsArray objectAtIndex:row]:nil;
                    if (unitModel && (row == 0) && self.currentUnitModel == nil) {
                        self.currentUnitModel = unitModel;
                        [pickerView selectRow:0 inComponent:component animated:YES];
                        [pickerView reloadComponent:2];
                    }
                    return unitModel.unitName;
                }
            }
        }else if (component == 2){
            NSInteger index = [pickerView selectedRowInComponent:1];
            CommunityBuildUnitModel *unitModel = ([self.currentBuildModel.unitsArray count]>index)?[self.currentBuildModel.unitsArray objectAtIndex:index]:nil;
            if (unitModel) {
                CommunityHouseModel *houseModel = ([unitModel.houseNumbers count]>row)?[unitModel.houseNumbers objectAtIndex:row]:nil;
                if (houseModel && (row == 0) && self.currentHouseModel == nil) {
                    self.currentHouseModel = houseModel;
                    [pickerView selectRow:0 inComponent:component animated:YES];
                     [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                return houseModel.houseNumber;
            }
        }
        
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.communityPeriodsPicker.pickerView == pickerView) {
        CommunityPeriodModel *periodModel = ([self.dataSource count]>row)?[self.dataSource objectAtIndex:row]:nil;
        if (periodModel != self.currentPeriodModel) {
            self.currentBuildModel = nil;
            self.currentUnitModel = nil;
            self.currentHouseModel = nil;
        }
        self.currentPeriodModel = periodModel;
        [self.comunityBuildHousePicker.pickerView reloadAllComponents];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else if (self.comunityBuildHousePicker.pickerView == pickerView){
        
        if (component == 0) {
            CommunityBuildModel *buildModel = ([self.currentPeriodModel.builds count]>row)?[self.currentPeriodModel.builds objectAtIndex:row]:nil;
            if (buildModel != self.currentBuildModel) {
                self.currentUnitModel = nil;
                self.currentHouseModel = nil;
            }
            self.currentBuildModel = buildModel;
            [self.comunityBuildHousePicker.pickerView reloadComponent:1];
        }else if (component == 1){
            
            NSInteger index = [pickerView selectedRowInComponent:0];
            if (index >= 0) {
                CommunityBuildModel *buildModel = ([self.currentPeriodModel.builds count]>index)?[self.currentPeriodModel.builds objectAtIndex:index]:nil;
                if (buildModel) {
                    CommunityBuildUnitModel *unitModel = ([buildModel.unitsArray count]>row)?[buildModel.unitsArray objectAtIndex:row]:nil;
                    if (self.currentUnitModel != unitModel) {
                        self.currentHouseModel = nil;
                    }
                    self.currentUnitModel = unitModel;
                }
                [self.comunityBuildHousePicker.pickerView reloadComponent:2];
            }
        }else if (component == 2){
            NSInteger index = [pickerView selectedRowInComponent:1];
            if (index >= 0) {
                CommunityBuildUnitModel *unitModel = ([self.currentBuildModel.unitsArray count]>index)?[self.currentBuildModel.unitsArray objectAtIndex:index]:nil;
                if (unitModel) {
                    CommunityHouseModel *houseModel = ([unitModel.houseNumbers count]>row)?[unitModel.houseNumbers objectAtIndex:row]:nil;
                    self.currentHouseModel = houseModel;
                }
            }
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


#pragma mark ---AlertView


@end
