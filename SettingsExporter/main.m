/* SPDX-License-Identifier: LGPL-2.1-or-later */
/*
 * Copyright (c) 2019 Collabora Ltd <arnaud.ferraris@collabora.com>
 */

#import <Foundation/Foundation.h>

#import "SettingsExporter.h"

static void usage(const char *cmd)
{
    printf("SettingsExporter - export system settings and wifi credentials to a Linux system\n\n");
    printf("USAGE:\t%s <COMMAND> [OPTIONS]\n\n", cmd);
    printf("COMMANDS:\n");
    printf("\tlist\t\t\tList all attached removable drives\n");
    printf("\twrite <FILE> <DEVICE>\tWrite image <FILE> to <DEVICE>\n");
    printf("\t\t\t\tand export settings to the newly written system\n");
    printf("\texport <DEVICE>\t\tExport settings to the system on <DEVICE>\n");
}

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        NSArray *opts = [[NSProcessInfo processInfo] arguments];
        SESettingsExporter *exporter = [[SESettingsExporter alloc] init];
        
        // Skip the first argument as it is the executable name
        if ([opts count] < 2) {
            usage(argv[0]);
            return EXIT_FAILURE;
        }
            
        if ([opts[1] isEqualToString:@"list"]) {
            [exporter setMode:listMedia];
        } else if ([opts[1] isEqualToString:@"write"]) {
            if ([opts count] < 4) {
                usage(argv[0]);
                return EXIT_FAILURE;
            }
            [exporter setMode:writeImage];
            if (![exporter useImage:opts[2]])
                return EXIT_FAILURE;
            if (![exporter useDevice:opts[3]])
                return EXIT_FAILURE;
        } else if ([opts[1] isEqualToString:@"export"]) {
            if ([opts count] < 3) {
                usage(argv[0]);
                return EXIT_FAILURE;
            }
            [exporter setMode:exportSettings];
            if (![exporter useDevice:opts[2]])
                return EXIT_FAILURE;
        }
        
        if (![exporter execute])
            return EXIT_FAILURE;
    }
    
    return EXIT_SUCCESS;
}
