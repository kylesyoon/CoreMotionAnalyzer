//
//  KSYMotionDataSource.h
//  CoreMotionAnalyzer
//
//  Created by Yoon, Kyle on 5/4/17.
//  Copyright © 2017 Kyle Yoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KSYMotionData;

@interface KSYMotionDataSource : NSObject

- (void)appendMotionData:(KSYMotionData *)motionData;

- (KSYMotionData *)dataForCellAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfSections;

- (NSInteger)numberOfRowsForSection:(NSInteger)section;

@end
