//
//  SGPaymentOptionsView.h
//  CommunityAPP
//
//  Created by Oliver on 14-9-13.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "SGCustomMenu.h"

@interface SGPaymentOptionsView : SGCustomMenu

+(instancetype)sharePaymentSheet;

//- (id)initWithItemTitles:(NSArray *)itemTitles;

@property (nonatomic, strong) SGMenuActionHandler payActionHandler;

@end
