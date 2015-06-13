//
//  NXBeaconManager.m
//  NXBeaconManager
//
//  Created by Nick Sparks on 6/10/15.
//  Copyright (c) 2015 Nick Sparks. All rights reserved.
//

#import "NXBeaconManager.h"
#import <CoreLocation/CoreLocation.h>

@interface NXBeaconManager () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) NSArray* beaconRegions;
@property (strong, nonatomic) CLBeacon* prevNearestBeacon;
@property (nonatomic) BOOL isRanging;

@end

@implementation NXBeaconManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static NXBeaconManager* instance;
    dispatch_once(&onceToken, ^{
        instance = [NXBeaconManager new];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupLocationManager];
        self.prevNearestBeacon = nil;
    }
    return self;
}

- (void)setupLocationManager {
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;

    // request use of the user's location
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

- (void)lookForUUID:(NSUUID*)uuid {
    // add a new beacon region to the list for this uuid
    NSMutableArray* temp = [NSMutableArray arrayWithArray:self.beaconRegions];
    CLBeaconRegion* newRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                   identifier:[uuid UUIDString]];
    [temp addObject:newRegion];
    self.beaconRegions = [temp copy];

    // if we're looking for beacons right now, start looking in this new region
    if (self.isRanging) {
        [self.locationManager startRangingBeaconsInRegion:newRegion];
    }
}

- (void)startLookingForBeacons {
    for (CLBeaconRegion* region in self.beaconRegions) {
        [self.locationManager startRangingBeaconsInRegion:region];
    }
    self.isRanging = YES;
}

- (void) stopLookingForBeacons {
    for (CLBeaconRegion* region in self.beaconRegions) {
        [self.locationManager stopRangingBeaconsInRegion:region];
    }
    self.isRanging = NO;
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {

    // explicitly sort beacons based on distance
    beacons = [beacons sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CLBeacon* A = obj1;
        CLBeacon* B = obj2;

        // give the beacon a value based on its proximity
        NSInteger aValue = [self proximityValueForBeacon:A];
        NSInteger bValue = [self proximityValueForBeacon:B];

        if (aValue > bValue) {
            return NSOrderedAscending;
        } else if (bValue > aValue) {
            return NSOrderedDescending;
        } else {
            // if the beacons are the same proximity, sort by signal strength
            if (A.rssi > B.rssi) {
                return NSOrderedAscending;
            } else if (B.rssi > A.rssi) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }
    }];

    // grab the closest beacon
    CLBeacon* nearestBeacon = nil;
    if ([beacons count] > 0) {
        nearestBeacon = (CLBeacon*)beacons[0];
    } else if (self.prevNearestBeacon != nil) {
        // there are no more beacons
        [self.delegate didStopDetectingBeacons];
    } else {
        // there aren't any beacons to do anything with
        return;
    }

    if (nearestBeacon == nil) {
        // no beacons in range
        [self.delegate didLeaveRangeOfBeacon:self.prevNearestBeacon];
    } else if (self.prevNearestBeacon == nil) {
        // this is the first beacon we've seen recently
        [self.delegate didDetectBeacons:beacons];
        [self.delegate didDetectNewClosestBeacon:nearestBeacon];
    } else if (![self beaconIsSameAsPrevious:nearestBeacon]) {
        // new closest beacon
        [self.delegate didDetectNewClosestBeacon:nearestBeacon];
    } else if ([self beaconIsSameAsPrevious:nearestBeacon] && ![self beaconRangeIsSameAsPrevious:nearestBeacon]) {
        // beacon changed distance
        [self.delegate didChangeDistanceFromBeacon:nearestBeacon];
    }

    // set the new closest beacon
    self.prevNearestBeacon = nearestBeacon;
}


#pragma mark - Private Methods

- (NSInteger)proximityValueForBeacon:(CLBeacon*)beacon {
    // give the beacon a value based on its proximity
    switch (beacon.proximity) {
        case CLProximityImmediate:
            return 3;
        case CLProximityNear:
            return 2;
        case CLProximityFar:
            return 1;
        case CLProximityUnknown:
            return 0;
    }
}

- (BOOL)beaconIsSameAsPrevious:(CLBeacon*)beacon {
    return (beacon.proximityUUID == self.prevNearestBeacon.proximityUUID &&
            beacon.major == self.prevNearestBeacon.major &&
            beacon.minor == self.prevNearestBeacon.minor);
}

- (BOOL)beaconRangeIsSameAsPrevious:(CLBeacon*)beacon {
    return (beacon.proximity == self.prevNearestBeacon.proximity);
}

@end
