//
//  AppDelegate.m
//  StretchGasStation
//
//  Created by Douglas Voss on 6/1/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

/*have the function gasStation:(NSArray *)pathArray
The array will consist of the following elements: strings g:c where g is the amount of gas in gallons at that gas station and c will be the amount of gallons of gas needed to get to the following gas station.
* For example pathArray may be: ["3:1","2:2","1:2","0:1"].
Your goal is to return the index of the starting gas station that will allow you to travel around the whole route once, otherwise return -1.
* For the example above, there are 4 gas stations, and your program should return 1 because starting at station 1 you receive 3 gallons of gas and spend 1 getting to the next station. Then you have 2 gallons + 2 more at the next station and you spend 2 so you have 2 gallons when you get to the 3rd station. You then have 3 but you spend 2 getting to the final station, and at the final station you receive 0 gallons and you spend your final gallon getting to your starting point. Starting at any other gas station would make getting around the route impossible, so the answer is 1.
If there are multiple gas stations that are possible to start at, return the smallest index (of the gas station).
[pathArray count] >= 2.
*/

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (NSNumber *)gasStation:(NSArray *)pathArray
{
    int numStations = [pathArray count];
    for (int startStation=0; startStation<numStations; startStation++)
    {
        int currentGallons = 0;

        BOOL startStationFailed = NO;
        int i=startStation;
        NSLog(@"startStation=%d", i);
        // iterate through all stations, but start at different stations each time
        for (int count=0; count<numStations; count++)
        {
            NSString *str = pathArray[i%numStations];
            NSArray *strArr = [str componentsSeparatedByString:@":"];
            NSLog(@"Station[%d]: gallons=%@, costToNextStation=%@", i, strArr[0], strArr[1]);
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *gallonsInc = [f numberFromString:strArr[0]];
            NSNumber *costToNextStation = [f numberFromString:strArr[1]];
            NSLog(@"arrive: currentGallons=%d", currentGallons, [gallonsInc integerValue], [costToNextStation integerValue]);
            currentGallons += [gallonsInc integerValue];
            NSLog(@"postFillup: currentGallons=%d", currentGallons, [gallonsInc integerValue], [costToNextStation integerValue]);
            currentGallons -= [costToNextStation integerValue];
            NSLog(@"postdrivetonext: currentGallons=%d", currentGallons, [gallonsInc integerValue], [costToNextStation integerValue]);
            i++;
            if (currentGallons < 0) {
                startStationFailed = YES;
            }
        }
        if (!startStationFailed) {
            return [NSNumber numberWithInt:startStation];
        }
    }
    
    return @-1;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSArray *pathArray = @[@"3:1", @"2:2", @"1:2", @"0:1"];
    NSLog(@"gasStation result for pathArray=%@ is %@", pathArray, [self gasStation:pathArray]);
    
    pathArray = @[@"0:1", @"3:1", @"2:2", @"1:2"];
    NSLog(@"gasStation result for pathArray=%@ is %@", pathArray, [self gasStation:pathArray]);
    
    pathArray = @[@"1:2", @"0:1", @"3:1", @"2:2"];
    NSLog(@"gasStation result for pathArray=%@ is %@", pathArray, [self gasStation:pathArray]);
    
    pathArray = @[@"2:2", @"1:2", @"0:1", @"3:1"];
    NSLog(@"gasStation result for pathArray=%@ is %@", pathArray, [self gasStation:pathArray]);
    
    pathArray = @[@"2:2", @"1:2", @"0:1", @"3:2"];
    NSLog(@"gasStation result for pathArray=%@ is %@", pathArray, [self gasStation:pathArray]);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.dougsapps.StretchGasStation" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"StretchGasStation" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"StretchGasStation.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
