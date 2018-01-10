//
//  MapDownloadConfiguration.m
//  Boobuz
//
//  Created by xiaoyuan on 06/11/2017.
//  Copyright © 2017 erlinyou.com. All rights reserved.
//

#import "MapDownloadConfiguration.h"

static NSString * const MapDownloadConfigurationAutoDownloadFailure = @"shouldAutoDownloadFailure";
static NSString * const MapDownloadConfigurationAutoDownloadInWifi = @"autoDownloadInWifi";

@implementation MapDownloadConfiguration

+ (void)setShouldAutoDownloadFailure:(NSNumber *)shouldAutoDownloadFailure {
    [[self userDefauls] setObject:shouldAutoDownloadFailure forKey:MapDownloadConfigurationAutoDownloadFailure];
    [[self userDefauls] synchronize];
}

+ (NSNumber *)shouldAutoDownloadFailure {
    NSNumber *shouldAutoDownloadFailure = [[self userDefauls] objectForKey:MapDownloadConfigurationAutoDownloadFailure];
    if (!shouldAutoDownloadFailure) {
        return @(YES);
    }
    return shouldAutoDownloadFailure;
}

+ (void)setShouldAutoDownloadInWifi:(NSNumber *)shouldAutoDownloadInWifi {
    [[self userDefauls] setObject:shouldAutoDownloadInWifi forKey:MapDownloadConfigurationAutoDownloadInWifi];
    [[self userDefauls] synchronize];
}

+ (NSNumber *)shouldAutoDownloadInWifi {
    NSNumber *shouldAutoDownloadInWifi = [[self userDefauls] objectForKey:MapDownloadConfigurationAutoDownloadInWifi];
    if (!shouldAutoDownloadInWifi) {
        return @(YES);
    }
    return shouldAutoDownloadInWifi;
}
+ (NSUserDefaults *)userDefauls {
    return [NSUserDefaults standardUserDefaults];
}

@end
