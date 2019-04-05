/* SPDX-License-Identifier: LGPL-2.1-or-later */
/*
 * Copyright (c) 2019 Collabora Ltd <arnaud.ferraris@collabora.com>
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SERemovableDrive : NSObject

@property DASessionRef session;
@property(nullable) NSString *driveName;
@property(nullable) DADiskRef driveDisk;
@property(nullable) CFDictionaryRef driveProperties;
@property int driveBlockSize;
@property(nullable) NSString *espName;
@property(nullable) DADiskRef espDisk;
@property(nullable) CFDictionaryRef espProperties;

- (id)init;

- (void)listRemovableMedia;

- (bool)useDevice:(NSString *)bsdName;

- (bool)writeImage:(NSString *)imgFile;

- (NSURL *)mountESP;
- (bool)umountESP;

@end

NS_ASSUME_NONNULL_END
