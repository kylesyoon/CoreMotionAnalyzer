//
//  KSYUserSettings.h
//  CoreMotionAnalyzer
//
//  Created by Yoon, Kyle on 5/8/17.
//  Copyright © 2017 Kyle Yoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSYUserSettings : NSObject

@property (nonatomic, assign, getter=isUserAccelerationOn) BOOL userAccelerationOn;
@property (nonatomic, assign, getter=isGravityOn) BOOL gravityOn;
@property (nonatomic, assign, getter=isRotationOn) BOOL rotationOn;

+ (instancetype)userSettingsWithAccelerationOn:(BOOL)isAccelerationOn
                                     gravityOn:(BOOL)isGravityOn
                                    rotationOn:(BOOL)isRotationOn;

@end
