//
//  KSYMotionDataCellTableViewCell.m
//  CoreMotionAnalyzer
//
//  Created by Yoon, Kyle on 5/4/17.
//  Copyright © 2017 Kyle Yoon. All rights reserved.
//

#import "KSYMotionDataTableViewCell.h"
#import <CoreMotion/CoreMotion.h>
#import "KSYMotionData.h"

@interface KSYMotionDataTableViewCell ()

@property (strong, nonatomic) IBOutlet UIStackView *accelerationStackView;
@property (strong, nonatomic) IBOutlet UILabel *accelerationLabel;
@property (strong, nonatomic) IBOutlet UIStackView *gravityStackView;
@property (strong, nonatomic) IBOutlet UILabel *gravityLabel;
@property (strong, nonatomic) IBOutlet UIStackView *rotationRateStackView;
@property (strong, nonatomic) IBOutlet UILabel *rotationRateLabel;

@end

@implementation KSYMotionDataTableViewCell

- (void)configureWithMotionData:(KSYMotionData *)motionData {
    CMDeviceMotion *deviceMotion = motionData.deviceMotion;
    NSString *accString = [NSString stringWithFormat:@"X: %.3f, Y: %.3f, Z: %.3f",
                           deviceMotion.userAcceleration.x,
                           deviceMotion.userAcceleration.y,
                           deviceMotion.userAcceleration.z];
    self.accelerationLabel.text = accString;
    NSString *gravString = [NSString stringWithFormat:@"X: %.3f, Y: %.3f, Z: %.3f",
                            deviceMotion.gravity.x,
                            deviceMotion.gravity.y,
                            deviceMotion.gravity.z];
    self.gravityLabel.text = gravString;
    NSString *rotationString = [NSString stringWithFormat:@"X: %.3f, Y: %.3f, Z: %.3f",
                                deviceMotion.rotationRate.x,
                                deviceMotion.rotationRate.y,
                                deviceMotion.rotationRate.z];
    self.rotationRateLabel.text = rotationString;
}

@end
