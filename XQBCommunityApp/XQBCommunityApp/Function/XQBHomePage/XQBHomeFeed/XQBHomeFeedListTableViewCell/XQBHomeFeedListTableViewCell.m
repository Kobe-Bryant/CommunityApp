//
//  XQBHomeFeedListTableViewCell.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/12.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "XQBHomeFeedListTableViewCell.h"
#import "Global.h"
#import "XQBHomeFeedListSectionTopNewsView.h"
#import "XQBHomeFeedListSectionNormalNewsView.h"
#import "XQBHomeFeedDetailModel.h"
#import "XQBHomeFeedListViewController.h"

@interface XQBHomeFeedListTableViewCell ()

@property (nonatomic, strong) UIView *feedsContentView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *feedItems;

@end

@implementation XQBHomeFeedListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.feedsContentView];

    }
    return self;
}

- (void)setSectionModel:(HomeFeedSectionModel *)sectionModel{
    _sectionModel = sectionModel;
    for (UIView *view in self.feedsContentView.subviews) {
        [view removeFromSuperview];
    }
    if ([_sectionModel.homeFeedDetails count]==0) {
        return;
    }
    [_sectionModel.homeFeedDetails enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        XQBHomeFeedDetailModel *model = obj;
        if ([model.setDefault isEqualToString:@"yes"]) {
            CGRect  rect = CGRectMake(0, 0, 290, SECTION_TOP_NEWS_HEIGHT);
            XQBHomeFeedListSectionTopNewsView *topView = [[XQBHomeFeedListSectionTopNewsView alloc] initWithFrame:rect];
            [topView.feedImageView sd_setImageWithURL:[NSURL URLWithString:model.feedIcon] placeholderImage:[UIImage imageNamed:@"default_rect_placeholder_image.png"]];
            topView.textLabel.text = model.title;
            topView.tag = idx;
            [topView addTarget:self action:@selector(newsHandle:) forControlEvents:UIControlEventTouchUpInside];
            [self.feedsContentView addSubview:topView];
        }else{
            CGRect rect = CGRectMake(0, SECTION_TOP_NEWS_HEIGHT + (idx-1)*SECTION_NORMAL_NEWS_HEIGHT, 290, SECTION_NORMAL_NEWS_HEIGHT);
            XQBHomeFeedListSectionNormalNewsView *normalView = [[XQBHomeFeedListSectionNormalNewsView alloc] initWithFrame:rect];
            [normalView.feedImageView sd_setImageWithURL:[NSURL URLWithString:model.feedIcon] placeholderImage:[UIImage imageNamed:@"default_square_placeholder_image.png"]];
            normalView.textLabel.text = model.title;
            normalView.tag = idx;
            [normalView addTarget:self action:@selector(newsHandle:) forControlEvents:UIControlEventTouchUpInside];
            [self.feedsContentView addSubview:normalView];
        }
    }];
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {

        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, WIDTH(self)-15*2, self.bounds.size.height)];
        _backgroundImageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _backgroundImageView.image = XQB_STRETCH_IMAGE([UIImage imageNamed:@"messageTemplateBackgroundImage.png"], UIEdgeInsetsMake(7, 7, 7, 7));
    }
    return _backgroundImageView;
}

- (UIView *)feedsContentView{
    if (!_feedsContentView) {
        _feedsContentView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, WIDTH(self)-15*2, self.bounds.size.height)];
        _feedsContentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    }
    
    return _feedsContentView;
}

#pragma mark ---Action
- (void)newsHandle:(UIButton *)sender{
    XQBLog(@"%ld",sender.tag);
    if (self.feedCellHandleBlock) {
        self.feedCellHandleBlock(self.sectionModel,sender.tag);
    }

}

@end
