//
//  XQBConDPCategoryListTableViewCell.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/30.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQBConDPCategoryListTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *disLabel;

- (void)setStarWithGrade:(NSInteger)grade;

@end
