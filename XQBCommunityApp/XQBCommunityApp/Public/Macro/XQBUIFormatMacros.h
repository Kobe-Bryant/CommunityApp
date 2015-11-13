//
//  XQBUIFormatMacros.h
//  XQBCommunityApp
//
//  Created by City-Online on 14/11/19.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#ifndef XQBCommunityApp_XQBUIFormatMacros_h
#define XQBCommunityApp_XQBUIFormatMacros_h


///////////////////////////////////////////
// Screen
///////////////////////////////////////////
#define SCREEN_WIDTH                [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT               [[UIScreen mainScreen] bounds].size.height
#define STATUS_BAR_HEIGHT           20
#define NAVIGATIONBAR_HEIGHT        44
#define STATUS_NAV_BAR_HEIGHT       64
#define TABBAR_HEIGHT               49
#define MainHeight                  (SCREEN_HEIGHT - STATUS_NAV_BAR_HEIGHT)
#define MainWidth                   SCREEN_WIDTH

///////////////////////////////////////////
// Views
///////////////////////////////////////////
#define WIDTH(view) view.frame.size.width
#define HEIGHT(view) view.frame.size.height
#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y
#define LEFT(view) view.frame.origin.x
#define TOP(view) view.frame.origin.y
#define BOTTOM(view) (view.frame.origin.y + view.frame.size.height)
#define RIGHT(view) (view.frame.origin.x + view.frame.size.width)



//================= color ================
//16进制的时候用
#define UIColorFromRGB(rgbValue) [UIColor \
            colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
            green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
            blue: ((float)(rgbValue & 0xFF))/255.0 \
            alpha:1.0]
//设置RGB值
#define RGB(r,g,b)          [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r,g,b,a)       [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define XQBColorContent     RGB( 80,  80,  80)                  //content表示正文
#define XQBColorExplain     RGB(150, 150, 150)                  //explain表示正文的说明解释
#define XQBColorInternalSeparationLine RGB(220, 220, 220)       //internal:内部分隔线
#define XQBColorElementSeparationLine  RGB(200, 200, 200)       //element:元素分隔线（页面中竖直每一项每一项之间）
#define XQBColorBackground  RGB(240, 240, 240)
#define XQBColorGreen       RGB( 75, 200, 160)
#define XQBColorOrange      RGB(240, 130,  20)
#define XQBColorDefaultImage    RGB(220,220,220)


//================= font =================
#define XQBFontHeadline     [UIFont systemFontOfSize:17.0f]     //大标题
#define XQBFontContent      [UIFont systemFontOfSize:14.0f]
#define XQBFontExplain      [UIFont systemFontOfSize:12.0f]
#define XQBFontTabbarItem   [UIFont systemFontOfSize:10.0f]



//================= space and margin =====
#define XQBMarginHorizontal     15.0f                           //水平边缘间距
#define XQBSpaceHorizontalItem  10.0f                           //小项水平间隔

#define XQBSpaceVerticalElement 15.0f                           //元素竖直间隔
#define XQBSpaceVerticalItem    10.0f                           //小项竖直间隔



//================= height ===============
#define XQBHeightElement        50.0f
#define XQBHeightLabelContent   20.0f
#define XQBHeightLabelExplain   18.0f


#endif
