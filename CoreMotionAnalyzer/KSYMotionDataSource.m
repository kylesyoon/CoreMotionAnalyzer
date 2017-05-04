//
//  KSYMotionDataSource.m
//  CoreMotionAnalyzer
//
//  Created by Yoon, Kyle on 5/4/17.
//  Copyright © 2017 Kyle Yoon. All rights reserved.
//

#import "KSYMotionDataSource.h"
#import <UIKit/UIKit.h>

@interface KSYMotionDataSource ()

@property (nonatomic, copy) NSArray <KSYMotionData *> *allMotionData;

@end

@implementation KSYMotionDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        _allMotionData = @[];
    }
    return self;
}

- (void)appendMotionData:(KSYMotionData *)motionData {
    NSMutableArray *tempMotionData = [self.allMotionData mutableCopy];
    [tempMotionData addObject:motionData];
    self.allMotionData = [tempMotionData copy];
}

- (KSYMotionData *)dataForCellAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row < self.allMotionData.count ? self.allMotionData[indexPath.row] : nil;
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfRowsForSection:(NSInteger)section {
    return self.allMotionData.count;
}

//- (void)blockToUpdateMotionData {
//    typeof(self) __weak weakSelf = self;
//    return ^(CMDeviceMotion *motion, NSError *error) {
//        // Parsing motion data.
//        NSMutableDictionary *motionData = [NSMutableDictionary dictionary];
//        
//        if (self.isUserAccelerationOn) {
//            NSDictionary *acceleration = @{@"x":[NSNumber numberWithDouble:motion.userAcceleration.x],
//                                           @"y":[NSNumber numberWithDouble:motion.userAcceleration.y],
//                                           @"z":[NSNumber numberWithDouble:motion.userAcceleration.z]};
//            [motionData setObject:acceleration forKey:@"acceleration"];
//        }
//        if (self.isGravityOn) {
//            NSDictionary *gravity = @{@"x":[NSNumber numberWithDouble:motion.gravity.x],
//                                      @"y":[NSNumber numberWithDouble:motion.gravity.y],
//                                      @"z":[NSNumber numberWithDouble:motion.gravity.z]};
//            [motionData setObject:gravity forKey:@"gravity"];
//        }
//        if (self.isRotationRateOn) {
//            NSDictionary *rotation = @{@"x":[NSNumber numberWithDouble:motion.rotationRate.x],
//                                       @"y":[NSNumber numberWithDouble:motion.rotationRate.y],
//                                       @"z":[NSNumber numberWithDouble:motion.rotationRate.z]};
//            [motionData setObject:rotation forKey:@"rotation"];
//        }
//        [motionData setObject:[NSNumber numberWithFloat:weakSelf.timeFrame] forKey:@"time"];
//        
//        [weakSelf.dataArray addObject:motionData];
//        [weakSelf.tableView reloadData];
//        
//        weakSelf.timeFrame += 0.05;
//    };
//}

@end
