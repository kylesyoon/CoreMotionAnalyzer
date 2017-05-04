//
//  KSYMotionDataCellTableViewCell.h
//  CoreMotionAnalyzer
//
//  Created by Yoon, Kyle on 5/4/17.
//  Copyright © 2017 Kyle Yoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSYMotionData;

@interface KSYMotionDataTableViewCell : UITableViewCell

- (void)configureWithMotionData:(KSYMotionData *)motionData;

@end
