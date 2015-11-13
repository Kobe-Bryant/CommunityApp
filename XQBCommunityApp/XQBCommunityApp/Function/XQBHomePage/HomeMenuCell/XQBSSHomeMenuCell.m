//
//  XQBSSHomeMenuCell.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/11/25.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBSSHomeMenuCell.h"
#import "XQBUIFormatMacros.h"



@implementation XQBSSHomeMenuCell{
    CGFloat textOffset;
}

@synthesize textLabel = _textLabel;
@synthesize imageView = _imageView;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        textOffset = .0f;
    }
    return self;
}

- (UIImageView *)imageView{
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, 17, 25, 25)];
        [self addSubview:_imageView];
    }
    
    
    return _imageView;
}

- (UIImageView *)accessoryView{
    if (!_accessoryView) {
        _accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(MainWidth-20-XQBMarginHorizontal, (self.bounds.size.height-20)/2, 20, 20)];
        _accessoryView.contentMode = UIViewContentModeRight;
        
        [self addSubview:_accessoryView];
        
    }
    return  _accessoryView;
}

- (void)setAccessoryType:(UICellAccessoryType)accessoryType{
    _accessoryType = accessoryType;
    switch (_accessoryType) {
        case UICellAccessoryNone:
            
            
            break;
        case UICellAccessoryDetailDisclosureButton:
            
            self.accessoryView.image = [UIImage imageNamed:@"right_arrow_whitegray"];
            break;
            
        default:
            break;
    }
}
 
- (UILabel *)textLabel{
    
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor blackColor];
        [self addSubview:_textLabel];
    }
    if (self.imageView.image) {
        textOffset = 40.0f;
         _textLabel.frame = CGRectMake(XQBMarginHorizontal+textOffset, 0, 150, self.bounds.size.height);
    }else{
        textOffset = 0.0f;
        _textLabel.frame = CGRectMake(XQBMarginHorizontal+textOffset, 0, 150, self.bounds.size.height);
    }
   
    
    return _textLabel;
}



@end
