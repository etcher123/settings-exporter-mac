/* SPDX-License-Identifier: LGPL-2.1-or-later */
/*
 * Copyright (c) 2019 Collabora Ltd <arnaud.ferraris@collabora.com>
 */

#import <Foundation/Foundation.h>

#import "RemovableDrive.h"
#import "SystemSettings.h"

NS_ASSUME_NONNULL_BEGIN

@interface SESettingsExporter : NSObject

typedef enum {
    listMedia = 0,
    writeImage,
    exportSettings
} AppMode;

@property AppMode mode;
@property NSString *image;
@property SESystemSettings *settings;
@property SERemovableDrive *drive;

- (id)init;

- (bool)execute;

- (bool)readSettings;

- (bool)useDevice:(NSString *)device;
- (bool)useImage:(NSString *)image;

- (bool)exportSettings;

@end

NS_ASSUME_NONNULL_END
