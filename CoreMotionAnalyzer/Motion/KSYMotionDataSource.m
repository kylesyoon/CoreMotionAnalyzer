//
//  KSYMotionDataSource.m
//  CoreMotionAnalyzer
//
//  Created by Yoon, Kyle on 5/4/17.
//  Copyright © 2017 Kyle Yoon. All rights reserved.
//

#import "KSYMotionDataSource.h"
#import <UIKit/UIKit.h>
#import <CoreMotion/CMDeviceMotion.h>

@interface KSYMotionDataSource ()

@property (nonatomic, copy) NSArray <CMDeviceMotion *> *allMotionData;

@end

@implementation KSYMotionDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        _allMotionData = @[];
    }
    return self;
}

- (void)appendMotionData:(CMDeviceMotion *)motionData {
    NSMutableArray *tempMotionData = [self.allMotionData mutableCopy];
    [tempMotionData addObject:motionData];
    self.allMotionData = [tempMotionData copy];
}

- (CMDeviceMotion *)dataForIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section < self.allMotionData.count ? self.allMotionData[indexPath.section] : nil;
}

- (NSString *)titleForHeaderForSection:(NSInteger)section {
    NSTimeInterval timestampForSection = ((CMDeviceMotion *)self.allMotionData[section]).timestamp;
    return [NSString stringWithFormat:@"%lf", timestampForSection];
}

- (NSInteger)numberOfSections {
    return self.allMotionData.count;
}

- (NSInteger)numberOfRowsForSection:(NSInteger)section {
    return 1;
}

@end
