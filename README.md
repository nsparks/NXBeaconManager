# NXBeaconManager
NXBeaconManager is a simple class that makes it easy to use iBeacons in your application. It's built on top of CoreLocation and handles all the messy parts of dealing with iBeacons for you. You can add NXBeaconManager to your project either as plain files or as a library.

## Installation
1. Download NXBeaconManager from Github
2. Add NXBeaconManager to your project
3. Link to CoreLocation in your build settings

## Project Setup
NXBeaconManager uses a singleton with delegate methods to pass data to the rest of the application. Before doing anything else with NXBeaconManager, assign the singleton a delegate.

`[NXBeaconManager sharedManager].delegate = self;`

## Looking for iBeacons
NXBeaconManager searches for UUIDs that you specify. To add a uuid to the list, use `lookForUUID`

`[[NXBeaconManager sharedManager] lookForUUID:@"SOME_UUID_1234_567_890"];`

To start looking for beacons, simply do the following:

`[[NXBeaconManager sharedManager] startLookingForBeacons];`

Similarly, to stop looking, call the following method:

`[[NXBeaconManager sharedManager] stopLookingForBeacons];`

When looking for beacons, NXBeaconManager will invoke delegate methods whenever something significant happens. The manager has been written to avoid invoking the delegate needlessly. All delegate methods are optional, so your project only has to implement the exact functionality it needs without having to handle other cases. The available delegate methods are as follows:

`-(void)didDetectNewClosestBeacon:(CLBeacon*)beacon;`
`-(void)didLeaveRangeOfBeacon:(CLBeacon*)beacon;`
`-(void)didChangeDistanceFromBeacon:(CLBeacon*)beacon;`
`-(void)didDetectBeacons:(NSArray*)beacons;`
`- (void)didStopDetectingBeacons;`
