//
//  SettingsViewController.h
//  CoreMotionAnalyzer
//
//  Created by Kyle Yoon on 4/3/15.
//  Copyright (c) 2015 Kyle Yoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsDelegate

- (void)updateDataSettingsForUserAcceleration:(BOOL)isAcceleration gravity:(BOOL)isGravity rotationRate:(BOOL)isRotationRate;

@end

@interface SettingsViewController : UIViewController

@property (nonatomic) BOOL isUserAccelerationOn;
@property (nonatomic) BOOL isGravityOn;
@property (nonatomic) BOOL isRotationRateOn;
@property id<SettingsDelegate> delegate;

@end
