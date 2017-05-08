//
//  KSYMotionDataSource.h
//  CoreMotionAnalyzer
//
//  Created by Yoon, Kyle on 5/4/17.
//  Copyright © 2017 Kyle Yoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMDeviceMotion;

@interface KSYMotionDataSource : NSObject

- (void)appendMotionData:(CMDeviceMotion *)motionData;

- (CMDeviceMotion *)dataForIndexPath:(NSIndexPath *)indexPath;

- (NSString *)titleForHeaderForSection:(NSInteger)section;

- (NSInteger)numberOfSections;

- (NSInteger)numberOfRowsForSection:(NSInteger)section;

@end
