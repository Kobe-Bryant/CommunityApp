//
//  PhotoDisplayView.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/11/27.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoDisplayView;

@protocol PhotoDisplayViewDelegate <NSObject>

- (void)photoDisplayView:(PhotoDisplayView *)photoView tappedAtIndex:(NSInteger)index;

@end


@interface PhotoDisplayView : UIView

@property (nonatomic, strong) NSArray *photoUrls;

@property (nonatomic, weak) id<PhotoDisplayViewDelegate> delegate;


- (id)initWithDefualtFrame;

- (id)initWithPhotosUrl:(NSArray *)photosUrlArray;

- (id)initWithFrame:(CGRect)frame andPhotosUrl:(NSArray *)photosUrlArray;

@end
