//
//  KSYMotionDataCellTableViewCell.m
//  CoreMotionAnalyzer
//
//  Created by Yoon, Kyle on 5/4/17.
//  Copyright © 2017 Kyle Yoon. All rights reserved.
//

#import "KSYMotionDataTableViewCell.h"
#import <CoreMotion/CoreMotion.h>
#import "KSYUserSettings.h"

static NSString * const kXYZFormat = @"X: %.3lf  Y: %.3lf  Z: %.3lf";

@interface KSYMotionDataTableViewCell ()

@property (strong, nonatomic) IBOutlet UIStackView *accelerationStackView;
@property (strong, nonatomic) IBOutlet UILabel *accelerationLabel;
@property (strong, nonatomic) IBOutlet UIStackView *gravityStackView;
@property (strong, nonatomic) IBOutlet UILabel *gravityLabel;
@property (strong, nonatomic) IBOutlet UIStackView *rotationRateStackView;
@property (strong, nonatomic) IBOutlet UILabel *rotationRateLabel;

@end

@implementation KSYMotionDataTableViewCell

- (void)configureWithDeviceMotion:(CMDeviceMotion *)deviceMotion andUserSettings:(KSYUserSettings *)userSettings {
    if (userSettings.isUserAccelerationOn) {
        NSString *accString = [NSString stringWithFormat:kXYZFormat,
                               deviceMotion.userAcceleration.x,
                               deviceMotion.userAcceleration.y,
                               deviceMotion.userAcceleration.z];
        self.accelerationLabel.text = accString;
        self.accelerationStackView.hidden = NO;
    }
    else {
        self.accelerationStackView.hidden = YES;
    }
    
    NSString *gravString = [NSString stringWithFormat:kXYZFormat,
                            deviceMotion.gravity.x,
                            deviceMotion.gravity.y,
                            deviceMotion.gravity.z];
    self.gravityLabel.text = gravString;
    NSString *rotationString = [NSString stringWithFormat:kXYZFormat,
                                deviceMotion.rotationRate.x,
                                deviceMotion.rotationRate.y,
                                deviceMotion.rotationRate.z];
    self.rotationRateLabel.text = rotationString;
}

@end
