//
//  ViewController.m
//  CoreMotionAnalyzer
//
//  Created by Kyle Yoon on 4/2/15.
//  Copyright (c) 2015 Kyle Yoon. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "GraphViewController.h"
#import "SettingsViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, SettingsDelegate>

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataToGraph;
@property (nonatomic) CGFloat timeFrame;
@property (nonatomic) BOOL selectedAll;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    self.dataToGraph = [NSMutableArray array];
    self.motionManager = [[CMMotionManager alloc] init];
    
    self.tableView.allowsMultipleSelection = YES;
    self.selectedAll = NO;
    self.isUserAccelerationOn = YES;
    self.isGravityOn = YES;
    self.isRotationRateOn = YES;

}

- (CMDeviceMotionHandler)analyzeMotionData
{
    typeof(self) __weak weakSelf = self;
    return ^(CMDeviceMotion *motion, NSError *error) {
        // Parsing motion data.
        NSMutableDictionary *motionData = [NSMutableDictionary dictionary];
        
        if (self.isUserAccelerationOn) {
            NSDictionary *acceleration = @{@"x":[NSNumber numberWithDouble:motion.userAcceleration.x],
                                           @"y":[NSNumber numberWithDouble:motion.userAcceleration.y],
                                           @"z":[NSNumber numberWithDouble:motion.userAcceleration.z]};
            [motionData setObject:acceleration forKey:@"acceleration"];
        }
        if (self.isGravityOn) {
            NSDictionary *gravity = @{@"x":[NSNumber numberWithDouble:motion.gravity.x],
                                      @"y":[NSNumber numberWithDouble:motion.gravity.y],
                                      @"z":[NSNumber numberWithDouble:motion.gravity.z]};
            [motionData setObject:gravity forKey:@"gravity"];
        }
        if (self.isRotationRateOn) {
            NSDictionary *rotation = @{@"x":[NSNumber numberWithDouble:motion.rotationRate.x],
                                       @"y":[NSNumber numberWithDouble:motion.rotationRate.y],
                                       @"z":[NSNumber numberWithDouble:motion.rotationRate.z]};
            [motionData setObject:rotation forKey:@"rotation"];
        }
        [motionData setObject:[NSNumber numberWithFloat:weakSelf.timeFrame] forKey:@"time"];
        
        [weakSelf.dataArray addObject:motionData];
        [weakSelf.tableView reloadData];
        
        weakSelf.timeFrame += 0.05;
    };
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *motionData = [self.dataArray objectAtIndex:indexPath.row];
    
    NSString *dataString = @"";
    if (self.isUserAccelerationOn) {
        NSDictionary *acc = motionData[@"acceleration"];
        dataString = [dataString stringByAppendingFormat:@"ACC (%.3f, %.3f, %.3f)\r", [acc[@"x"] floatValue], [acc[@"y"] floatValue], [acc[@"z"]floatValue]];
    }
    if (self.isGravityOn) {
        NSDictionary *grav = motionData[@"gravity"];
        dataString = [dataString stringByAppendingFormat:@"GRAV (%.3f, %.3f, %.3f)\r", [grav[@"x"] floatValue], [grav[@"y"] floatValue], [grav[@"z"] floatValue]];
        
    }
    if (self.isRotationRateOn) {
        NSDictionary *rot = motionData[@"rotation"];
        dataString = [dataString stringByAppendingFormat:@"ROTR (%.3f, %.3f, %.3f)", [rot[@"x"] floatValue], [rot[@"y"] floatValue], [rot[@"z"] floatValue]];
        
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = dataString;
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", [motionData[@"time"] floatValue]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataToGraph addObject:[self.dataArray objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataToGraph containsObject:[self.dataArray objectAtIndex:indexPath.row]]) {
        [self.dataToGraph removeObject:[self.dataArray objectAtIndex:indexPath.row]];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"plotSegue"]) {
        GraphViewController *graphVC = segue.destinationViewController;
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
        self.dataToGraph = [[[NSArray arrayWithArray:self.dataToGraph] sortedArrayUsingDescriptors:@[descriptor]] mutableCopy];
        graphVC.data = [self.dataToGraph copy];
    } else {
        SettingsViewController *settingsVC = segue.destinationViewController;
        settingsVC.isUserAccelerationOn = self.isUserAccelerationOn;
        settingsVC.isRotationRateOn = self.isRotationRateOn;
        settingsVC.isGravityOn = self.isGravityOn;
        settingsVC.delegate = self;
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma Settings Delegate

- (void)updateDataSettingsForUserAcceleration:(BOOL)isAcceleration gravity:(BOOL)isGravity rotationRate:(BOOL)isRotationRate
{
    self.isUserAccelerationOn = isAcceleration;
    self.isGravityOn = isGravity;
    self.isRotationRateOn = isRotationRate;
}

#pragma mark - IBActions

- (IBAction)pressedStartStopButton:(UIButton *)button
{
    if (self.motionManager.isDeviceMotionActive) {
        [self.motionManager stopDeviceMotionUpdates];
        [button setTitle:@"Start" forState:UIControlStateNormal];
    } else {
        if (self.motionManager.deviceMotionAvailable) {
            self.motionManager.deviceMotionUpdateInterval = 0.05;
            self.timeFrame = 0.0;
            [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:[self analyzeMotionData]];
            [button setTitle:@"Stop" forState:UIControlStateNormal];
        } else {
            // Error handling
        }
    }
    
}

- (IBAction)pressedSelectAll:(UIButton *)button
{
    if (self.selectedAll) {
        for (int i = 0; i < self.dataArray.count; i++) {
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES];
            [self.dataToGraph removeObject:[self.dataArray objectAtIndex:i]];
        }
        self.selectedAll = NO;
        [button setTitle:@"Select All" forState:UIControlStateNormal];
    } else {
        for (int i = 0; i < self.dataArray.count; i++) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self.dataToGraph addObject:[self.dataArray objectAtIndex:i]];
        }
        self.selectedAll = YES;
        [button setTitle:@"Deselect All" forState:UIControlStateNormal];
    }
}

- (IBAction)pressedClear:(id)sender
{
    [self.dataArray removeAllObjects];
    [self.dataToGraph removeAllObjects];
    [self.tableView reloadData];
}

@end
