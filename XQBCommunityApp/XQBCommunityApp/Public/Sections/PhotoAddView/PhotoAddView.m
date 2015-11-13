//
//  PhotoAddView.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 15/1/4.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "PhotoAddView.h"
#import "XQBUIFormatMacros.h"
#import "UIImage+extra.h"
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSObject_extra.h"


static const CGFloat kPhotoWidth        = 61.0f;
static const CGFloat kPhotoHeight       = 61.0f;
static const CGFloat kSpaceHorizontal   = 15.0f;

@interface PhotoAddView() <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIButton *addPhotoButton;

@end

@implementation PhotoAddView

- (instancetype)initWithDefualtFrame
{
    return [self initWithDefualtFrameAndOffset:UIOffsetZero];
}

- (instancetype)initWithDefualtFrameAndOffset:(UIOffset)offset
{
    return [self initWithFrame:CGRectMake(offset.horizontal, offset.vertical, MainWidth, kPhotoHeight)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.photosArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        [self addSubview:self.addPhotoButton];
    }
    return self;
}

#pragma mark --- UI
- (UIButton *)addPhotoButton
{
    if (!_addPhotoButton) {
        self.addPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addPhotoButton.frame = CGRectMake(kSpaceHorizontal, 0, kPhotoWidth, kPhotoHeight);
        _addPhotoButton.backgroundColor = XQBColorDefaultImage;
        [_addPhotoButton setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
        [_addPhotoButton addTarget:self action:@selector(addPhotoButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addPhotoButton];
    }
    
    return _addPhotoButton;
}

- (void)refreshPickedAssets
{
    for (NSInteger i = 0; i<_photosArray.count; i++) {
        UIImageView  *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kSpaceHorizontal+kPhotoWidth)*i+kSpaceHorizontal, 0, kPhotoWidth, kPhotoHeight)];
        imageView.image = [_photosArray objectAtIndex:i];
        [self addSubview:imageView];
    }
    if (_photosArray.count>= 4) {
        _addPhotoButton.hidden = YES;
        self.contentSize = CGSizeMake([_photosArray count]*(kSpaceHorizontal+kPhotoWidth)+kSpaceHorizontal,kPhotoHeight);
    }else{
        _addPhotoButton.frame = CGRectMake([_photosArray count]*(kSpaceHorizontal+kPhotoWidth)+kSpaceHorizontal, 0, kPhotoWidth, kPhotoHeight);
        self.contentSize = CGSizeMake(([_photosArray count]+1)*(kSpaceHorizontal+kPhotoWidth)+kSpaceHorizontal,kPhotoHeight);
    }
}

#pragma mark --- action
- (void)addPhotoButtonHandle:(UIButton *)sender
{
    UIActionSheet* mySheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [mySheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        BOOL iscamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if (!iscamera) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有相机" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
        UIImagePickerController *pick = [[UIImagePickerController alloc] init];
        pick.delegate = self;
        pick.sourceType = UIImagePickerControllerSourceTypeCamera;
        pick.allowsEditing = YES;
        if (self.presentPhotoVCBlock) {
            self.presentPhotoVCBlock(pick, YES);
        }
    }
    if (buttonIndex == 1) {
        UIImagePickerController *pick = [[UIImagePickerController alloc]init];
        pick.delegate = self;
        pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pick.allowsEditing = YES;
        if (self.presentPhotoVCBlock) {
            self.presentPhotoVCBlock(pick, YES);
        }
    }
}

#pragma mark ---image picker controller delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        NSString *str = (NSString*)kCGImagePropertyTIFFDictionary;
        NSDictionary *dic = [[info objectForKey:UIImagePickerControllerMediaMetadata] objectForKey:str];
        image.fileName = [[dic objectForKey:@"DateTime"] stringByAppendingPathExtension:@"jpg"];
        
        UIImage *newImage = [UIImage writeImageToSandBox:image name:image.fileName];
        image = nil;
        [self.photosArray addObject:newImage];
        [self refreshPickedAssets];
    }else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *asset)
        {
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            NSString *fileName = [representation filename];
            NSLog(@"fileName : %@",fileName);
            
            image.fileName = fileName;
            UIImage *newImage = [UIImage writeImageToSandBox:image name:image.fileName];
            [self.photosArray addObject:newImage];
            [self refreshPickedAssets];
        };
        
        ALAssetsLibrary* assetslibrary =[[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imageURL
                       resultBlock:resultblock
                      failureBlock:nil];
        
    }
}
@end
