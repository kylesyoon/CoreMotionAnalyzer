//
//  KSYMotionData.h
//  CoreMotionAnalyzer
//
//  Created by Yoon, Kyle on 5/4/17.
//  Copyright © 2017 Kyle Yoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMDeviceMotion;

@interface KSYMotionData : NSObject

@property (nonatomic, strong) CMDeviceMotion *deviceMotion;
@property (nonatomic, strong) NSDate *timestamp;

+ (instancetype)motionDataWithDeviceMotion:(CMDeviceMotion *)deviceMotion andTimestamp:(NSDate *)timestamp;

@end
