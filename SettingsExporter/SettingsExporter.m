/* SPDX-License-Identifier: LGPL-2.1-or-later */
/*
 * Copyright (c) 2019 Collabora Ltd <arnaud.ferraris@collabora.com>
 */

#import "SettingsExporter.h"

@implementation SESettingsExporter

- (id)init
{
    self.drive = [[SERemovableDrive alloc] init];
    self.settings = [[SESystemSettings alloc] init];
    self.mode = listMedia;
    
    return self;
}

- (bool)readSettings
{
    bool ret;
    
    ret = [self.settings readUserSettings];
    ret = [self.settings readWifiCredentials];
    
    return ret;
}

- (bool)useDevice:(NSString *)device
{
    return [self.drive useDevice:device];
}

- (bool)useImage:(NSString *)image
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:image]) {
        NSLog(@"File %@ not found!", image);
        return false;
    }
    
    self.image = [NSString stringWithString:image];
    
    return true;
}

- (bool)exportSettings
{
    NSMutableString *contents = [[NSMutableString alloc] init];
    NSURL *espMountPoint = [self.drive mountESP];
    NSURL *settingsfile = [espMountPoint URLByAppendingPathComponent:@"settings.conf"];
    NSURL *connections = [espMountPoint URLByAppendingPathComponent:@"network-connections" isDirectory:true];
    bool ret = false;

    if (!espMountPoint) {
        NSLog(@"No ESP partition mounted");
        return false;
    }
    
    // Export user settings
    NSLog(@"Writing settings to %@", [espMountPoint absoluteString]);
    [contents appendFormat:@"LOCALE=%@.UTF-8\n", self.settings.locale];
    [contents appendFormat:@"KEYMAP=%@\n", self.settings.linuxKeymap];
    [contents appendFormat:@"TZ=%@\n", self.settings.timezone];
    ret = [contents writeToURL:settingsfile atomically:true encoding:NSUTF8StringEncoding error:nil];
    if (!ret) {
        NSLog(@"Unable to write user settings to %@", settingsfile);
        goto end;
    }
    
    // Export wifi credentials
    [[NSFileManager defaultManager] createDirectoryAtURL:connections withIntermediateDirectories:true attributes:nil error:nil];
    settingsfile = [connections URLByAppendingPathComponent:[self.settings wifiSSID]];
    [contents setString:@""];
    [contents appendFormat:@"[connection]\nid=%@\nuuid=%@\ntype=wifi\nautoconnect=true\n\n",
                            self.settings.wifiSSID, [[[NSUUID UUID] UUIDString] lowercaseString]];
    [contents appendFormat:@"[wifi]\nmac-address=%@\nmac-address-blacklist=\nmode=infrastructure\nssid=%@\n\n",
                            self.settings.wifiMAC, self.settings.wifiSSID];
    [contents appendFormat:@"[wifi-security]\nkey-mgmt=wpa-psk\npsk=%@\n\n", self.settings.wifiPassword];
    [contents appendString:@"[ipv4]\ndns-search=\nmethod=auto\n\n"];
    [contents appendString:@"[ipv6]\naddr-gen-mode=stable-privacy\ndns-search=\nip6-privacy=0\nmethod=auto\n"];
    ret = [contents writeToURL:settingsfile atomically:true encoding:NSUTF8StringEncoding error:nil];
    if (!ret) {
        NSLog(@"Unable to write Wifi credentials to %@", settingsfile);
    }

end:
    [self.drive umountESP];
    
    return ret;
}

- (bool)execute
{
    switch (self.mode) {
        case listMedia:
            [self.drive listRemovableMedia];
            break;
        case writeImage:
            if (![self.drive writeImage:self.image]) {
                NSLog(@"Unable to write image file to selected drive!");
                return false;
            }
            if (![self readSettings]) {
                NSLog(@"Unable to read settings!");
                return false;
            }
            if (![self exportSettings]) {
                NSLog(@"Unable to export settings!");
                return false;
            }
            break;
        case exportSettings:
            if (![self readSettings]) {
                NSLog(@"Unable to read settings!");
                return false;
            }
            if (![self exportSettings]) {
                NSLog(@"Unable to export settings!");
                return false;
            }
            break;
        default:
            NSLog(@"No operation mode selected, exiting...");
            return false;
    }
    
    return true;
}

@end
