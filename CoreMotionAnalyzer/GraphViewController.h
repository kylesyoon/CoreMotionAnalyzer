//
//  GraphViewController.h
//  CoreMotionAnalyzer
//
//  Created by Kyle Yoon on 4/2/15.
//  Copyright (c) 2015 Kyle Yoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CorePlot-CocoaTouch.h>

@interface GraphViewController : UIViewController <CPTPlotDataSource>

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) CPTGraphHostingView *hostView;

@end
