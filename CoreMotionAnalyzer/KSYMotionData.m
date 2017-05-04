//
//  KSYMotionData.m
//  CoreMotionAnalyzer
//
//  Created by Yoon, Kyle on 5/4/17.
//  Copyright © 2017 Kyle Yoon. All rights reserved.
//

#import "KSYMotionData.h"
#import <CoreMotion/CoreMotion.h>

@implementation KSYMotionData

+ (instancetype)motionDataWithDeviceMotion:(CMDeviceMotion *)deviceMotion andTimestamp:(NSDate *)timestamp {
    KSYMotionData *data = [KSYMotionData new];
    data.deviceMotion = deviceMotion;
    data.timestamp = timestamp;
    return data;
}

@end
