//
//  XQBHomeInformationPublishViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 15/1/4.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "XQBHomeInformationPublishViewController.h"
#import "Global.h"
#import "PhotoAddView.h"

static const CGFloat kTitleLabelWidth   = 45.0f;
static const CGFloat kDescViewHeight    = 100.0f;
static const CGFloat kWordLimiteWidth   = 40.0f;
static const CGFloat kWordLimiteHeight  = 18.0f;

@interface XQBHomeInformationPublishViewController () <UITextViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *backgroundButton;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UITextField *titleField;
@property (nonatomic, strong) UIView *descView;
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) UITextView *descTextView;
@property (nonatomic, strong) UILabel *wordLimitedLabel;
@property (nonatomic, strong) PhotoAddView *kPhotoAddView;

@property (nonatomic, strong) NSString *feedId;
@property (nonatomic, assign) BOOL isFirstInto;

@end

@implementation XQBHomeInformationPublishViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.feedId = @"";
        self.isFirstInto = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:[NSString stringWithFormat:@"发布%@", _homeFeedName]];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //发布按钮
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:XQBColorGreen forState:UIControlStateNormal];
    [_rightBtn setTitleColor:XQBColorExplain forState:UIControlStateSelected];
    [_rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [_rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.frame = CGRectMake(280,0,70,44);
    [self setRightBarButtonItem:_rightBtn];

    self.view.backgroundColor = XQBColorBackground;
    
    [self.view addSubview:self.backgroundButton];
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.descView];
    [self.view addSubview:self.wordLimitedLabel];
    [self.view addSubview:self.kPhotoAddView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_isFirstInto) {
        [_titleField becomeFirstResponder];
        self.isFirstInto = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- UI
- (UIButton *)backgroundButton
{
    if (!_backgroundButton) {
        self.backgroundButton = [[UIButton alloc] initWithFrame:self.view.bounds];
        [_backgroundButton addTarget:self action:@selector(backgroundButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundButton;
}

- (UIView *)titleView
{
    if (!_titleView) {
        self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, XQBHeightElement)];
        _titleView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, 0, kTitleLabelWidth, XQBHeightElement)];
        titleLabel.font = XQBFontContent;
        titleLabel.text = @"标题";
        titleLabel.textColor = XQBColorContent;
        [_titleView addSubview:titleLabel];
        
        _titleField = [[UITextField alloc] initWithFrame:CGRectMake(XQBMarginHorizontal+WIDTH(titleLabel), 0, MainWidth-XQBMarginHorizontal*2-kTitleLabelWidth, XQBHeightElement)];
        _titleField.font = XQBFontContent;
        _titleField.placeholder = @"不少于3个字";
        _titleField.textColor = XQBColorContent;
        _titleField.delegate = self;
        [_titleView addSubview:_titleField];
    }
    return _titleView;
}

- (UIView *)descView
{
    if (!_descView) {
        self.descView = [[UIView alloc] initWithFrame:CGRectMake(0, XQBHeightElement+XQBSpaceVerticalElement, MainWidth, kDescViewHeight)];
        _descView.backgroundColor = [UIColor whiteColor];
        
        _descTextView = [[UITextView alloc] initWithFrame:CGRectMake(XQBMarginHorizontal-5, (XQBSpaceVerticalItem-5), MainWidth-(XQBMarginHorizontal-5)*2, kDescViewHeight-(XQBSpaceVerticalItem-5)*2)];
        _descTextView.font = XQBFontContent;
        _descTextView.delegate = self;
        _descTextView.returnKeyType = UIReturnKeyDone;
        [_descView addSubview:_descTextView];
        
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 9, WIDTH(_descTextView)-5*2, 14)];
        if (_descTextView.text.length > 0) {
            _placeHolderLabel.text = nil;
        }else{
            _placeHolderLabel.text = @"请输入详细信息";
        }
        
        _placeHolderLabel.font = XQBFontContent;
        _placeHolderLabel.textColor = XQBColorExplain;
        _placeHolderLabel.enabled = NO;//lable必须设置为不可用
        _placeHolderLabel.backgroundColor = [UIColor clearColor];
        [_descTextView addSubview:_placeHolderLabel];
    }
    return _descView;
}

- (UILabel *)wordLimitedLabel{
    if (!_wordLimitedLabel) {
        _wordLimitedLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth-kWordLimiteWidth-XQBMarginHorizontal, XQBHeightElement+XQBSpaceVerticalElement+kDescViewHeight, kWordLimiteWidth, kWordLimiteHeight)];
        _wordLimitedLabel.font = XQBFontTabbarItem;
        _wordLimitedLabel.text = @"200字";
        _wordLimitedLabel.textColor = XQBColorContent;
        _wordLimitedLabel.textAlignment = NSTextAlignmentRight;
    }
    return _wordLimitedLabel;
}

- (PhotoAddView *)kPhotoAddView
{
    if (!_kPhotoAddView) {
        self.kPhotoAddView = [[PhotoAddView alloc] initWithDefualtFrameAndOffset:UIOffsetMake(0, XQBHeightElement+XQBSpaceVerticalElement+kDescViewHeight+kWordLimiteHeight)];
        __weak typeof(self) weakSelf = self;
        _kPhotoAddView.presentPhotoVCBlock = ^(UIImagePickerController *imagePickerContr, BOOL animated){
            [weakSelf presentViewController:imagePickerContr animated:YES completion:NULL];
        };
    }
    return _kPhotoAddView;
}

#pragma mark --- action
- (void)backHandle:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnAction:(UIButton *)sender
{
    [self backgroundButtonHandle:nil];
    
    if (_titleField.text.length < 3) {
        [self.view.window makeCustomToast:@"标题不能少于3个字"];
    } else if (16 < _titleField.text.length) {
        [self.view.window makeCustomToast:@"标题不能超过15个字"];
    } else if (0 == _descTextView.text.length) {
        [self.view.window makeCustomToast:@"描述不能为空"];
    } else if (201 < _descTextView.text.length) {
        [self.view.window makeCustomToast:@"正文不能超过200个字"];
    } else {
        if (!sender.selected) {
            [self requestAddNeighbourFeed];
            sender.selected = YES;
        }
    }
}

- (void)backgroundButtonHandle:(UIButton *)sender
{
    [_titleField resignFirstResponder];
    [_descTextView resignFirstResponder];
}

#pragma mark --- AFNetworking
- (void)requestAddNeighbourFeed
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters setObject:_titleField.text forKey:@"title"];
    [parameters setObject:_descTextView.text forKey:@"descp"];
    [parameters setObject:_homeFeedType forKey:@"feedType"];
    
    [parameters addSignatureKey];
    
    [manager POST:API_FEED_ADD_NEITHBOURFEED_URL parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            _feedId = [[responseObject objectForKey:@"data"] stringValue];
            if (_kPhotoAddView.photosArray.count == 0) {
                _rightBtn.selected = NO;
                [self.view.window makeCustomToast:@"发布成功"];
                [self backHandle:nil];
            } else {
                [self requestAddNeighbourFeedImgs];
            }
        } else {
            //加载服务器异常界面
            XQBLog(@"服务器异常");
            _rightBtn.selected = NO;
            [self.view.window makeCustomToast:[responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
        _rightBtn.selected = NO;
        [self.view.window makeCustomToast:TOAST_NO_NETWORK];
    }];
}

- (void)requestAddNeighbourFeedImgs
{
    [XQBLoadingView showLoadingAddedToView:self.view withOffset:UIOffsetMake(0, -HEIGHT(self.view)/2+30)];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters setObject:_feedId forKey:@"feedId"];
    
    [parameters addSignatureKey];
    
    [manager POST:API_FEED_ADD_NEITHBOURFEED_IMGS_URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (UIImage *image in _kPhotoAddView.photosArray) {
        UIImage *fileImage = [UIImage imageWithContentsOfFile:image.filePath];
        NSData * data= UIImagePNGRepresentation(fileImage);
        [formData appendPartWithFileData:data name:@"imgs" fileName:image.fileName mimeType:@"image/png"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        [XQBLoadingView hideLoadingForView:self.view];
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            _rightBtn.selected = NO;
            [self.view.window makeCustomToast:@"发布成功"];
            [self backHandle:nil];
        } else {
            //加载服务器异常界面
            XQBLog(@"服务器异常");
            _rightBtn.selected = NO;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"图片发送失败,是否重新发送图片" delegate:self cancelButtonTitle:@"重新发送" otherButtonTitles:@"不发送图片", nil];
            [alertView show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        [XQBLoadingView hideLoadingForView:self.view];
        _rightBtn.selected = NO;
        XQBLog(@"网络异常Error:%@", error);
        [self.view.window makeCustomToast:TOAST_NO_NETWORK];
    }];
}
#pragma mark --- textFilde delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //限制字符在16个以内
    if ([string isEqualToString:@"\n"]){
        [textField resignFirstResponder];
        return NO;
    }
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([aString length] > 16) {
        if (range.length>0) {
            return YES;
        }
        [self.view.window makeCustomToast:@"标题不能超过15个字"];
        return NO;
    }
    return YES;
}

#pragma mark --- text view delegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _placeHolderLabel.text = @"请输入详细信息";
    }else{
        _placeHolderLabel.text = nil;
    }
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //限制字符在200个以内
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    NSString * aString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([aString length] > 200) {
        if (range.length>0) {
            return YES;
        }
        [self.view.window makeCustomToast:@"正文不能超过200个字"];
        return NO;
    } else if ([aString length] == 0) {
        _wordLimitedLabel.text = [NSString stringWithFormat:@"200字"];
    }else {
        _wordLimitedLabel.text = [NSString stringWithFormat:@"%lu字", 200-[aString length]];
    }
    return YES;
}

#pragma mark --- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self requestAddNeighbourFeedImgs];
    } else {
        [self.view.window makeCustomToast:@"发布文字成功"];
        [self backHandle:nil];
    }
}
@end
