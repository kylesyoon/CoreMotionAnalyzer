//
//  KSYMotionDataSource.m
//  CoreMotionAnalyzer
//
//  Created by Yoon, Kyle on 5/4/17.
//  Copyright © 2017 Kyle Yoon. All rights reserved.
//

#import "KSYMotionDataSource.h"
#import <UIKit/UIKit.h>
#import "KSYMotionData.h"

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

- (KSYMotionData *)dataForIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section < self.allMotionData.count ? self.allMotionData[indexPath.section] : nil;
}

- (NSString *)titleForHeaderForSection:(NSInteger)section {
    NSDate *firstTimestamp = ((KSYMotionData *)self.allMotionData.firstObject).timestamp;
    NSDate *timeStampForSection = ((KSYMotionData *)self.allMotionData[section]).timestamp;
    return [NSString stringWithFormat:@"%f", [timeStampForSection timeIntervalSinceDate:firstTimestamp]];
}

- (NSInteger)numberOfSections {
    return self.allMotionData.count;
}

- (NSInteger)numberOfRowsForSection:(NSInteger)section {
    return 1;
}

@end
