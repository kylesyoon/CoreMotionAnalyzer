//
//  KSYMotionDataCellTableViewCell.h
//  CoreMotionAnalyzer
//
//  Created by Yoon, Kyle on 5/4/17.
//  Copyright © 2017 Kyle Yoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMDeviceMotion;
@class KSYUserSettings;

@interface KSYMotionDataTableViewCell : UITableViewCell

- (void)configureWithDeviceMotion:(CMDeviceMotion *)deviceMotion andUserSettings:(KSYUserSettings *)userSettings;

@end
