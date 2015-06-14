# NXBeaconManager
NXBeaconManager is a simple class that makes it easy to use iBeacons in your application. It's built on top of CoreLocation and handles all the messy parts of dealing with iBeacons for you. You can add NXBeaconManager to your project either as plain files or as a library.

## Installation
1. Download NXBeaconManager from Github
2. Add NXBeaconManager to your project
3. Link to CoreLocation in your build settings

## Project Setup
NXBeaconManager uses a singleton with delegate methods to pass data to the rest of the application. Before doing anything else with NXBeaconManager, assign the singleton a delegate.

`[[NXBeaconManager sharedManager] setDelegate:self];`

## Looking for iBeacons
NXBeaconManager searches for UUIDs that you specify. The UUID of an iBeacon is often tied to who purchased it, so many iBeacons could potentially have the same UUID. This reduces the number of UUIDs that have to be specified. To add a uuid to the list, use `lookForUUID`

`[[NXBeaconManager sharedManager] lookForUUID:myUUID];`

To start looking for beacons, simply use the following:

`[[NXBeaconManager sharedManager] startLookingForBeacons];`

Similarly, to stop looking:

`[[NXBeaconManager sharedManager] stopLookingForBeacons];`

When looking for beacons, NXBeaconManager will invoke delegate methods whenever something significant happens. The manager has been written to avoid invoking the delegate needlessly. All delegate methods are optional, so your project only has to implement the exact functionality it needs without having to handle other cases. Commonly used delegate methods include:

`-(void)didDetectNewClosestBeacon:(CLBeacon*)beacon`

`-(void)didDetectBeacons:(NSArray*)beacons`

`-(void)didStopDetectingBeacons`

The usage for each of these methods and all the others is described in NXBeaconManager.h.
