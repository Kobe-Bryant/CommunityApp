//
//  XQBPush.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/9.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "XQBPush.h"
#import "Global.h"

static XQBPush *instance = nil;

@implementation XQBPush

+ (instancetype)shareInstance{
    if (instance == nil) {
        instance = [[XQBPush alloc] init];
    }
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
#ifdef __IPHONE_8_0
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
            self.pushAvailable = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
            if (self.pushAvailable) {
                UIUserNotificationSettings *noticeSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
                NSLog(@"type-->%ld, sets --> %@",noticeSettings.types,noticeSettings.categories);
                UIUserNotificationType types = noticeSettings.types;
                if (types == UIRemoteNotificationTypeNone) {
                    self.pushAvailable = NO;
                }else{
                    self.pushAvailable = YES;
                    self.pushBadge = (types & UIUserNotificationTypeBadge);
                    self.pushSound = (types & UIUserNotificationTypeSound);
                    self.pushAlert = (types & UIUserNotificationTypeAlert);
                }
            }else{
                self.pushSound = NO;
                self.pushBadge = NO;
                self.pushAlert = NO;
            }
            
        }else{
        
            UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
            if (types == UIRemoteNotificationTypeNone) {
                self.pushAvailable = NO;
            }else{
                self.pushAvailable = YES;
                self.pushBadge = (types & UIRemoteNotificationTypeBadge);
                self.pushSound = (types & UIRemoteNotificationTypeSound);
                self.pushAlert = (types & UIRemoteNotificationTypeAlert);
            }
        }
#else
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (types == UIRemoteNotificationTypeNone) {
            self.pushAvailable = NO;
        }else{
            self.pushAvailable = YES;
            self.pushBadge = (types & UIRemoteNotificationTypeBadge);
            self.pushSound = (types & UIRemoteNotificationTypeSound);
            self.pushAlert = (types & UIRemoteNotificationTypeAlert);
        }
        
#endif
        
    }
    return self;
}

- (void)setPushAlert:(BOOL)pushAlert{
    _pushAlert = pushAlert;
}

- (void)setPushBadge:(BOOL)pushBadge{
    _pushBadge = pushBadge;
}

- (void)setPushSound:(BOOL)pushSound{
    _pushSound = pushSound;
}

@end
