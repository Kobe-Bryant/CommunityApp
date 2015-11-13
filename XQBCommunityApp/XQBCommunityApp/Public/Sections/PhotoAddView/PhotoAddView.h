//
//  PhotoAddView.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 15/1/4.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PresentVCBlock)(UIImagePickerController *imagePickerContr, BOOL animated);

@interface PhotoAddView : UIScrollView

@property (nonatomic, strong) PresentVCBlock presentPhotoVCBlock;
@property (nonatomic, strong) NSMutableArray *photosArray;

- (instancetype)initWithDefualtFrame;
- (instancetype)initWithDefualtFrameAndOffset:(UIOffset)offset;

@end
