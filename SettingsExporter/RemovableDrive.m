/* SPDX-License-Identifier: LGPL-2.1-or-later */
/*
 * Copyright (c) 2019 Collabora Ltd <arnaud.ferraris@collabora.com>
 */

#import "RemovableDrive.h"

@implementation SERemovableDrive

- (id)init
{
    self = [super init];
    self.session = DASessionCreate(kCFAllocatorDefault);
    
    return self;
}

- (void)listRemovableMedia
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *removableMedia = [[NSMutableArray alloc] init];
    NSMutableDictionary<NSString *, NSString *> *removableMediaDict = [[NSMutableDictionary alloc] init];
    NSString *file;
    
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:@"/dev"];
    [enumerator skipDescendents];
    
    // Enumerate disk* device files
    while (file = [enumerator nextObject]) {
        if ([file hasPrefix:@"disk"] && ![[file substringFromIndex:4] containsString:@"s"]) {
            [removableMedia addObject:file];
        }
    }
    
    // Check device properties (removable & name)
    for (NSString *bsdName in removableMedia) {
        DADiskRef disk;
        CFDictionaryRef properties;
        CFBooleanRef isRemovable;
        
        disk = DADiskCreateFromBSDName(nil, self.session, [bsdName UTF8String]);
        if (!disk)
            continue;
        
        properties = DADiskCopyDescription(disk);
        if (!properties) {
            CFRelease(disk);
            continue;
        }
        
        isRemovable = CFDictionaryGetValue(properties, kDADiskDescriptionMediaRemovableKey);
        if (isRemovable && CFBooleanGetValue(isRemovable)) {
            CFStringRef prop = CFDictionaryGetValue(properties, kDADiskDescriptionDeviceModelKey);
            NSString *deviceName = [NSString stringWithString:(__bridge NSString *)prop];
            [removableMediaDict setValue:deviceName forKey:bsdName];
        }
        
        CFRelease(properties);
        CFRelease(disk);
    }
    
    // Print removable media list
    for (NSString *key in removableMediaDict) {
        printf("%s\t%s\n", [key UTF8String], [removableMediaDict[key] UTF8String]);
    }
}

- (bool)useDevice:(NSString *)bsdName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullPath = [@"/dev/" stringByAppendingString:bsdName];
    bool ret = false;

    if ([fileManager fileExistsAtPath:fullPath]) {
        CFBooleanRef isRemovable;
        
        self.driveDisk = DADiskCreateFromBSDName(kCFAllocatorDefault, self.session, [bsdName UTF8String]);
        if (!self.driveDisk)
            goto error;
        
        self.driveProperties = DADiskCopyDescription(self.driveDisk);
        if (!self.driveProperties)
            goto error;
        
        isRemovable = CFDictionaryGetValue(self.driveProperties, kDADiskDescriptionMediaRemovableKey);
        if (!isRemovable || CFBooleanGetValue(isRemovable) == false)
            goto error;
        
        self.driveName = [NSString stringWithString:bsdName];
        
        CFNumberRef blocksize = CFDictionaryGetValue(self.driveProperties, kDADiskDescriptionMediaBlockSizeKey);
        if (!blocksize || !CFNumberGetValue(blocksize, kCFNumberIntType, &_driveBlockSize)) {
            NSLog(@"Block size not found, using default");
            self.driveBlockSize = 512;
        }
        ret = true;
    }
    
    return ret;
    
error:
    if (self.driveName) {
        self.driveName = nil;
    }
    if (self.driveProperties) {
        CFRelease(self.driveProperties);
        self.driveProperties = nil;
    }
    if (self.driveDisk) {
        CFRelease(self.driveDisk);
        self.driveDisk = nil;
    }
    
    return ret;
}

- (bool)writeImage:(NSString *)imgFile
{
    NSString *devFile = [@"/dev/" stringByAppendingString:self.driveName];
    NSFileHandle *inFile = [NSFileHandle fileHandleForReadingAtPath:devFile];
    NSFileHandle *outFile = [NSFileHandle fileHandleForReadingAtPath:imgFile];
    NSData *buffer;
    unsigned long long percentSize, nextReport;
    int chunkSize = 1024 * self.driveBlockSize;
    int currentPercent;
    
    inFile = [NSFileHandle fileHandleForReadingAtPath:imgFile];
    if (!inFile) {
        NSLog(@"Unable to open %@ for reading!", imgFile);
        return false;
    }
    
    outFile = [NSFileHandle fileHandleForWritingAtPath:devFile];
    if (!outFile) {
        NSLog(@"Unable to open %@ for writing!", devFile);
        return false;
    }
    
    currentPercent = 0;
    printf("%d%%", currentPercent);
    fflush(stdout);
    nextReport = percentSize = [inFile seekToEndOfFile] / 100ULL;
    [inFile seekToFileOffset:0ULL];
    do {
        buffer = [inFile readDataOfLength:chunkSize];
        if ([buffer length] > 0) {
            [outFile writeData:buffer];
            
            if ([inFile offsetInFile] >= nextReport) {
                currentPercent++;
                if (currentPercent % 10)
                    printf(".");
                else
                    printf("%d%%%s", currentPercent, currentPercent == 100 ? "\n" : "");
                fflush(stdout);
                nextReport += percentSize;
            }
        }
    } while ([buffer length] > 0);
    
    [inFile closeFile];
    [outFile closeFile];
    
    return true;
}

- (NSURL *)mountESP
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *partitions = [[NSMutableArray alloc] init];
    NSString *cmd;
    NSString *file;
    NSURL *mountPoint = nil;
    int ret;

    // Enumerate device partitions
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:@"/dev"];
    [enumerator skipDescendents];
    while (file = [enumerator nextObject]) {
        if ([file hasPrefix:self.driveName] && [[file substringFromIndex:[self.driveName length]] containsString:@"s"]) {
            [partitions addObject:file];
        }
    }
    
    // Search for ESP partition
    for (file in partitions) {
        NSString *prop;
        
        self.espDisk = DADiskCreateFromBSDName(nil, self.session, [file UTF8String]);
        if (!self.espDisk)
            continue;
        
        self.espProperties = DADiskCopyDescription(self.espDisk);
        if (!self.espProperties) {
            CFRelease(self.espDisk);
            self.espDisk = nil;
        }
        
        prop = (__bridge NSString *)CFDictionaryGetValue(self.espProperties, kDADiskDescriptionVolumeKindKey);
        if (prop && [prop isEqualToString:@"msdos"]) {
            if (!CFDictionaryGetValue(self.espProperties, kDADiskDescriptionVolumePathKey)) {
                // Volume is not automatically mounted, it should be the ESP
                NSLog(@"Using %@ as it is not mounted\n", file);
                self.espName = [NSString stringWithString:file];
                break;
            }
            prop = (__bridge NSString *)CFDictionaryGetValue(self.espProperties, kDADiskDescriptionVolumeNameKey);
            if (prop) {
                if([[prop uppercaseString] hasPrefix:@"EFI"]) {
                    NSLog(@"Using %@ as its name starts with 'EFI'\n", file);
                    self.espName = [NSString stringWithString:file];
                    break;
                }
            }
        }
        
        CFRelease(self.espProperties);
        self.espProperties = nil;
        CFRelease(self.espDisk);
        self.espDisk = nil;
    }

    if (self.espDisk) {
        cmd = [NSString stringWithFormat:@"diskutil mount %@", self.espName];
        ret = system([cmd UTF8String]);
        if (ret != 0) {
            NSLog(@"Unable to mount %@", self.espName);
        } else {
            mountPoint = (__bridge NSURL *)CFDictionaryGetValue(self.espProperties, kDADiskDescriptionVolumePathKey);
            NSLog(@"%@ mounted at %@", self.espName, mountPoint);
        }
    } else {
        NSLog(@"Unable to find ESP partition on %@", self.driveName);
    }
    
    return mountPoint;
}

- (bool)umountESP
{
    NSString *cmd = [NSString stringWithFormat:@"diskutil umount %@", self.espName];
    int ret = system([cmd UTF8String]);
    
    if (ret != 0)
        return false;
    
    return true;
}

@end
