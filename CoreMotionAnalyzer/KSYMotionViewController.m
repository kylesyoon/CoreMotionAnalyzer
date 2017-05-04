//
//  ViewController.m
//  CoreMotionAnalyzer
//
//  Created by Kyle Yoon on 4/2/15.
//  Copyright (c) 2015 Kyle Yoon. All rights reserved.
//

#import "KSYMotionViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "GraphViewController.h"
#import "SettingsViewController.h"
#import "KSYMotionDataSource.h"
#import "KSYMotionData.h"
#import "KSYMotionDataTableViewCell.h"

static NSString * const kGraphViewControllerSegueIdentifier = @"graphViewControllerSegueIdentifier";
static CGFloat const kMotionUpdateInterval = 0.05;
static CGFloat const kEstimatedRowHeight = 180.0;

@interface KSYMotionViewController () <UITableViewDataSource, UITableViewDelegate, SettingsDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, copy) NSArray <KSYMotionData *> *motionData;
@property (strong, nonatomic) KSYMotionDataSource *motionDataSource;

@property (strong, nonatomic) NSMutableArray *dataArray;


@property (strong, nonatomic) NSMutableArray *dataToGraph;

@end

@implementation KSYMotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = kMotionUpdateInterval;
    
    self.motionData = @[];
    self.motionDataSource = [KSYMotionDataSource new];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KSYMotionDataTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([KSYMotionDataTableViewCell class])];
    self.tableView.estimatedRowHeight = kEstimatedRowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.isUserAccelerationOn = YES;
    self.isGravityOn = YES;
    self.isRotationRateOn = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kGraphViewControllerSegueIdentifier]) {
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

- (CMDeviceMotionHandler)handleDeviceMotionUpdates {
    typeof(self) __weak weakSelf = self;
    return ^(CMDeviceMotion *motion, NSError *error) {
        KSYMotionData *motionData = [KSYMotionData motionDataWithDeviceMotion:motion andTimestamp:[NSDate date]];
        NSMutableArray *tempMotionData = [self.motionData mutableCopy];
        [tempMotionData addObject:motionData];
        weakSelf.motionData = [tempMotionData copy];
        [weakSelf.motionDataSource appendMotionData:motionData];
        [weakSelf.tableView reloadData];
    };
}

- (IBAction)didTapStartStopButton:(UIBarButtonItem *)button {
    if (self.motionManager.isDeviceMotionActive) {
        [self.motionManager stopDeviceMotionUpdates];
        button.title = NSLocalizedString(@"Start", @"Stop title");
    }
    else {
        if (self.motionManager.deviceMotionAvailable) {
            button.title = NSLocalizedString(@"Stop", @"Stop title");
            [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                                    withHandler:[self handleDeviceMotionUpdates]];
        }
        else {
            // TODO: Show alert
        }
    }
}
- (IBAction)didTapSelectButton:(UIBarButtonItem *)sender {
    // TODO: Go to selection mode
}

- (IBAction)didTapClearButton:(id)sender {
    self.motionData = @[];
    [self.tableView reloadData];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KSYMotionDataTableViewCell *cell = [tableView
                                        dequeueReusableCellWithIdentifier:NSStringFromClass([KSYMotionDataTableViewCell class])
                                        forIndexPath:indexPath];
    KSYMotionData *motionData = [self.motionDataSource dataForCellAtIndexPath:indexPath];
    [cell configureWithMotionData:motionData];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.motionDataSource numberOfRowsForSection:section];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    [self.dataToGraph addObject:[self.dataArray objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if ([self.dataToGraph containsObject:[self.dataArray objectAtIndex:indexPath.row]]) {
    //        [self.dataToGraph removeObject:[self.dataArray objectAtIndex:indexPath.row]];
    //    }
}

#pragma Settings Delegate

- (void)updateDataSettingsForUserAcceleration:(BOOL)isAcceleration gravity:(BOOL)isGravity rotationRate:(BOOL)isRotationRate
{
    self.isUserAccelerationOn = isAcceleration;
    self.isGravityOn = isGravity;
    self.isRotationRateOn = isRotationRate;
}


@end
