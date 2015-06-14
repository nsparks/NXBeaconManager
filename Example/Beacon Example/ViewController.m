//
//  ViewController.m
//  Beacon Test
//
//  Created by Nick Sparks on 6/13/15.
//  Copyright (c) 2015 Nick Sparks. All rights reserved.
//

#import "ViewController.h"
#import "NXBeaconManager.h"

@interface ViewController () <NXBeaconManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NXBeaconManager sharedManager] setDelegate:self];
    [[NXBeaconManager sharedManager] lookForUUID:[[NSUUID alloc] initWithUUIDString:@"SOME_UUID_1234_567_890"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startLooking:(id)sender {
    [[NXBeaconManager sharedManager] startLookingForBeacons];
}

- (IBAction)stopLooking:(id)sender {
    [[NXBeaconManager sharedManager] stopLookingForBeacons];
}

#pragma mark - NXBeaconManagerDelegate Methods

- (void)didDetectBeacons:(NSArray *)beacons {
    NSLog(@"detected beacons");
    for (CLBeacon* beacon in beacons) {
        NSLog(@"%@", beacon);
    }
}

- (void)didDetectNewClosestBeacon:(CLBeacon *)beacon {
    NSLog(@"detected new closest beacon: %@", beacon);
}

- (void)didFirstDetectBeacons:(NSArray *)beacons {
    NSLog(@"first detected beacons");
    for (CLBeacon* beacon in beacons) {
        NSLog(@"%@", beacon);
    }
}

- (void)didLeaveRangeOfLastBeacon:(CLBeacon *)beacon {
    NSLog(@"left range of last beacon: %@", beacon);
}

- (void)didStopDetectingBeacons {
    NSLog(@"stopped detecting beacons");
}


@end
