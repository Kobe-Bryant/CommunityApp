//
//  XQBSSHomeMenuCell.h
//  XQBCommunityApp
//
//  Created by City-Online on 14/11/25.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UICellAccessoryType) {
    UICellAccessoryNone,                            // don't show any accessory view
    UICellAccessoryDetailDisclosureButton, // info button w/ chevron. tracks
};

@interface XQBSSHomeMenuCell : UIView

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *accessoryView;

@property (nonatomic) UICellAccessoryType accessoryType;

@end
