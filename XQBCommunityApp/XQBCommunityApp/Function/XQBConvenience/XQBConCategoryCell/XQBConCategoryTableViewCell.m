//
//  XQBConCategoryTableViewCell.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/24.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBConCategoryTableViewCell.h"
#import "Global.h"

CGFloat contentOffset = 12.0f;

@interface XQBConCategoryTableViewCell ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIView *imageContntView;
@property (nonatomic, strong) UIView *descriptionView;


@end

@implementation XQBConCategoryTableViewCell

- (void)dealloc{
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [self addSubview:_backgroundImageView];
        [self addSubview:self.imageContntView];
        [self addSubview:self.descriptionView];
        self.categoryCellType = XQBConCategoryTableViewCellTypeValue1;
    }
    return self;
}

- (void)setCategoryCellType:(XQBConCategoryTableViewCellType)categoryCellType{
    _categoryCellType = categoryCellType;
    switch (_categoryCellType) {
        case XQBConCategoryTableViewCellTypeValue1:
        {
            self.backgroundImageView.image = [UIImage imageNamed:@"con_menu_category_background_green.png"];
            self.imageContntView.frame = CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height);
            self.descriptionView.frame = CGRectMake(self.bounds.size.width/2, 0, self.bounds.size.width/2, self.bounds.size.height);
            self.categoryDescriptionLabel.textColor = RGB(55, 170, 135);
            self.categoryTitleLabel.transform = CGAffineTransformMakeTranslation(-10, 0);
            self.categoryDescriptionLabel.transform = CGAffineTransformMakeTranslation(-5.0, 0);
        }
            break;
        case XQBConCategoryTableViewCellTypeValue2:
        {
            self.backgroundImageView.image = [UIImage imageNamed:@"con_menu_category_background_orange.png"];
            self.imageContntView.frame = CGRectMake(self.bounds.size.width/2, 0, self.bounds.size.width/2, self.bounds.size.height);
            self.descriptionView.frame = CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height);
            self.categoryDescriptionLabel.textColor = RGB(250, 100, 100);
            self.categoryTitleLabel.transform = CGAffineTransformMakeTranslation(3, 0);
            self.categoryDescriptionLabel.transform = CGAffineTransformMakeTranslation(3, 0);
        }
            break;
            
        default:
            break;
    }
}

- (UIView *)imageContntView{
    if (!_imageContntView) {
        _imageContntView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height)];
        
        _categoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(contentOffset, 12, 125, 125)];
        _categoryImageView.layer.borderWidth = 2.5f;
        _categoryImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _categoryImageView.layer.cornerRadius = 2.0f;
        [_imageContntView addSubview:_categoryImageView];
    }
    
    return _imageContntView;
}

- (UIView *)descriptionView{
    if (!_descriptionView) {
        _descriptionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height)];
        
        _categoryTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentOffset, 22, self.bounds.size.width/2-contentOffset*2, 24)];
        _categoryTitleLabel.textAlignment = NSTextAlignmentCenter;
        _categoryTitleLabel.textColor = [UIColor whiteColor];
        _categoryTitleLabel.shadowColor = RGBA(0, 0, 0, 0.5);
        _categoryTitleLabel.shadowOffset = CGSizeMake(1, 1);
        [_descriptionView addSubview:_categoryTitleLabel];
        
        _categoryDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentOffset, 50, self.bounds.size.width/2-contentOffset*2, 55)];
        _categoryDescriptionLabel.numberOfLines = 0;
        _categoryDescriptionLabel.textAlignment = NSTextAlignmentCenter;
        _categoryDescriptionLabel.font = [UIFont systemFontOfSize:12.0f];
        [_descriptionView addSubview:_categoryDescriptionLabel];        
    }
    return _descriptionView;
}

@end
