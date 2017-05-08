//
//  SettingsViewController.m
//  CoreMotionAnalyzer
//
//  Created by Kyle Yoon on 4/3/15.
//  Copyright (c) 2015 Kyle Yoon. All rights reserved.
//

#import "KSYSettingsViewController.h"
#import "KSYMotionViewController.h"
#import "KSYUserSettings.h"

@interface KSYSettingsViewController ()

@property (strong, nonatomic) IBOutlet UISegmentedControl *userAccelerationSegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *gravitySegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *rotationSegmentedControl;

@property (nonatomic, strong) KSYUserSettings *userSettings;

@end

@implementation KSYSettingsViewController

+ (instancetype)settingsViewControllerWithUserSettings:(KSYUserSettings *)userSettings {
    KSYSettingsViewController *settingsViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                                         instantiateViewControllerWithIdentifier:NSStringFromClass([KSYSettingsViewController class])];
    settingsViewController.userSettings = userSettings;
    return settingsViewController;
}

- (IBAction)didToggleSegmentedControl:(UISegmentedControl *)segmentedControl {
    if (segmentedControl == self.userAccelerationSegmentedControl) {
        self.userSettings.userAccelerationOn = segmentedControl.selectedSegmentIndex == 0;
    }
    else if (segmentedControl == self.gravitySegmentedControl) {
        self.userSettings.userAccelerationOn = segmentedControl.selectedSegmentIndex == 0;
    }
    else if (segmentedControl == self.rotationSegmentedControl) {
        self.userSettings.rotationOn = segmentedControl.selectedSegmentIndex == 0;
    }
    else {
        NSAssert(NO, @"Unexpected segmented control toggle");
    }
}

- (IBAction)didTapDone:(id)sender {
    [self.delegate settingsViewController:self userDidTapDoneWithSettings:self.userSettings];
}

@end
