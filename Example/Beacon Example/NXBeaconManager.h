//
//  NXBeaconManager.h
//  NXBeaconManager
//
//  Created by Nick Sparks on 6/10/15.
//  Copyright (c) 2015 Nick Sparks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLBeacon;

@protocol NXBeaconManagerDelegate <NSObject>

// Called when there is a new closest beacon.
@optional - (void)didDetectNewClosestBeacon:(CLBeacon*)beacon;

// Called when the device goes out of range of the last beacon.
@optional - (void)didLeaveRangeOfLastBeacon:(CLBeacon*)beacon;

// Called when the device changes distance from the closest beacon.
@optional - (void)didChangeDistanceFromBeacon:(CLBeacon*)beacon;

// Called when beacons are found when none were before. Returns a list sorted by distance.
@optional - (void)didFirstDetectBeacons:(NSArray*)beacons;

// Called when beacons are found. Returns a list sorted by distance.
@optional - (void)didDetectBeacons:(NSArray*)beacons;

// Called when no more beacons are found.
@optional - (void)didStopDetectingBeacons;

@end

@interface NXBeaconManager : NSObject

@property (weak, nonatomic) id<NXBeaconManagerDelegate> delegate;

+ (instancetype)sharedManager;

- (void)startLookingForBeacons;
- (void)stopLookingForBeacons;
- (void)lookForUUID:(NSUUID*)uuid;
- (void)stopLookingForUUID:(NSUUID*)uuid;

@end
