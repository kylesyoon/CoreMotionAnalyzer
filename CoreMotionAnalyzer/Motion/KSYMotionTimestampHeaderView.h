//
//  KSYMotionTimestampHeaderView.h
//  CoreMotionAnalyzer
//
//  Created by Yoon, Kyle on 5/4/17.
//  Copyright © 2017 Kyle Yoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSYMotionTimestampHeaderView : UITableViewHeaderFooterView

@property (strong, nonatomic) IBOutlet UILabel *timestampLabel;

+ (CGFloat)headerViewHeight;

@end
