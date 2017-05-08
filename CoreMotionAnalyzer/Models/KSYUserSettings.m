//
//  KSYUserSettings.m
//  CoreMotionAnalyzer
//
//  Created by Yoon, Kyle on 5/8/17.
//  Copyright © 2017 Kyle Yoon. All rights reserved.
//

#import "KSYUserSettings.h"

@implementation KSYUserSettings

+ (instancetype)userSettingsWithAccelerationOn:(BOOL)isAccelerationOn
                                     gravityOn:(BOOL)isGravityOn
                                    rotationOn:(BOOL)isRotationOn {
    KSYUserSettings *settings = [KSYUserSettings new];
    settings.userAccelerationOn = isAccelerationOn;
    settings.gravityOn = isGravityOn;
    settings.rotationOn = isRotationOn;
    return settings;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _userAccelerationOn = YES;
        _gravityOn = YES;
        _rotationOn = YES;
    }
    
    return self;
}

@end
