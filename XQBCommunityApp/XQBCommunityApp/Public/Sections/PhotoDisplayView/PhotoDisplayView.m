//
//  PhotoDisplayView.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/11/27.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "PhotoDisplayView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+extra.h"
#import "XQBUIFormatMacros.h"

static const CGFloat kPhotoWidth = 61.0f;
static const CGFloat kPhotoHeight = 61.0f;
static const CGFloat kSpaceHorizontal = 15.0f;

@implementation PhotoDisplayView

- (id)initWithDefualtFrame
{
    return [self initWithPhotosUrl:nil];
}

- (id)initWithPhotosUrl:(NSArray *)photosUrlArray
{
    return [self initWithFrame:CGRectMake(0, 0, kPhotoWidth*3+kSpaceHorizontal*2, kPhotoHeight) andPhotosUrl:photosUrlArray];
}

- (id)initWithFrame:(CGRect)frame andPhotosUrl:(NSArray *)photosUrlArray
{
    self = [self initWithFrame:frame];
    if (self) {
        [self setPhotoUrls:photosUrlArray];
    }
    return self;
}

- (void)setPhotoUrls:(NSArray *)photoUrls
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    _photoUrls = photoUrls;
    for (int i = 0; i<MIN(photoUrls.count, 4); i++) {

        UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake(((self.frame.size.width-kSpaceHorizontal*2)/3 + kSpaceHorizontal)*i, 0, (self.frame.size.width-kSpaceHorizontal*2)/3, self.frame.size.height)];
        photo.userInteractionEnabled = YES;
        photo.tag = i;
        [photo sd_setImageWithURL:[photoUrls objectAtIndex:i] placeholderImage:[UIImage imageWithColor:XQBColorDefaultImage size:photo.frame.size]];
        [self addSubview:photo];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [photo addGestureRecognizer:tapGesture];

    }
}

- (void)tapImage:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(photoDisplayView:tappedAtIndex:)]){
        NSInteger index = sender.view.tag;
        [self.delegate photoDisplayView:self tappedAtIndex:index];
    }
}

@end
