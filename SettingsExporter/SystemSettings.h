/* SPDX-License-Identifier: LGPL-2.1-or-later */
/*
 * Copyright (c) 2019 Collabora Ltd <arnaud.ferraris@collabora.com>
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SESystemSettings : NSObject

typedef enum {
    none = 0,
    wep,
    wpa
} WifiSecurity;

@property NSString *macKeymap;
@property NSString *linuxKeymap;
@property NSString *locale;
@property NSString *timezone;
@property NSString *wifiSSID;
@property NSString *wifiMAC;
@property WifiSecurity wifiSecurity;
@property NSString *wifiPassword;

- (bool)readUserSettings;
- (bool)readWifiCredentials;

@end

NS_ASSUME_NONNULL_END
