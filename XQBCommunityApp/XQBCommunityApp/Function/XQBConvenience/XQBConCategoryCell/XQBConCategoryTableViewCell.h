//
//  XQBConCategoryTableViewCell.h
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/24.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XQBConCategoryTableViewCellType) {
    XQBConCategoryTableViewCellTypeValue1,      // Left image on left and right aligned description label on right
    XQBConCategoryTableViewCellTypeValue2,		// Right aligned description label on right and left image on left
};

@interface XQBConCategoryTableViewCell : UITableViewCell



@property (nonatomic, assign) XQBConCategoryTableViewCellType categoryCellType;

@property (nonatomic, strong) UIImageView *categoryImageView;
@property (nonatomic, strong) UILabel *categoryTitleLabel;
@property (nonatomic, strong) UILabel *categoryDescriptionLabel;

@end
