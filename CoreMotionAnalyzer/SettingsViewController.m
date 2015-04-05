//
//  SettingsViewController.m
//  CoreMotionAnalyzer
//
//  Created by Kyle Yoon on 4/3/15.
//  Copyright (c) 2015 Kyle Yoon. All rights reserved.
//

#import "SettingsViewController.h"
#import <DNSCastroSegmentedControl.h>
#import "ViewController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet DNSCastroSegmentedControl *userAccelerationControl;
@property (weak, nonatomic) IBOutlet DNSCastroSegmentedControl *gravityControl;
@property (weak, nonatomic) IBOutlet DNSCastroSegmentedControl *rotationRateControl;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *onOffArray = @[@"On", @"Off"];
    
    self.userAccelerationControl.choices = onOffArray;
    self.userAccelerationControl.selectedSegmentIndex = 0;
    self.userAccelerationControl.backgroundColor = [UIColor clearColor];
    self.gravityControl.choices = onOffArray;
    self.gravityControl.selectedSegmentIndex = 0;
    self.gravityControl.backgroundColor = [UIColor clearColor];
    self.rotationRateControl.choices = onOffArray;
    self.rotationRateControl.selectedSegmentIndex = 0;
    self.rotationRateControl.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.isUserAccelerationOn) {
        self.userAccelerationControl.selectedSegmentIndex = 1;
    }
    if (!self.isGravityOn) {
        self.gravityControl.selectedSegmentIndex = 1;
    }
    if (!self.isRotationRateOn) {
        self.rotationRateControl.selectedSegmentIndex = 1;
    }
}

- (IBAction)movedSegmentedControl:(DNSCastroSegmentedControl *)control
{
    if (control == self.userAccelerationControl) {
        if (control.selectedSegmentIndex == 0) {
            self.isUserAccelerationOn = YES;
        } else {
            self.isUserAccelerationOn = NO;
        }
    } else if (control == self.gravityControl) {
        if (control.selectedSegmentIndex == 0) {
            self.isGravityOn = YES;
        } else {
            self.isGravityOn = NO;
        }
    } else if (control == self.rotationRateControl) {
        if (control.selectedSegmentIndex == 0) {
            self.isRotationRateOn = YES;
        } else {
            self.isRotationRateOn = NO;
        }
    }
}

- (IBAction)pressedClose:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate updateDataSettingsForUserAcceleration:self.isUserAccelerationOn gravity:self.isGravityOn rotationRate:self.isRotationRateOn];
    }];
}

@end
