//
//  AppDelegate.m
//  Seekly
//
//  Created by Deepinder singh on 14/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "AppDelegate.h"
#import "SignInViewController.h"
#import "signUpViewController.h"
#import "LaunchScreenViewController.h"
#import "MessageViewController.h"
#import "TabBarExampleViewController.h"
#import "QSTodoService.h"
#import <GoogleMaps/GoogleMaps.h>



@interface AppDelegate ()


@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize window = _window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    /// For StoryBoard....
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

//    SeeklyAPI *obj =[[SeeklyAPI alloc]init];
//    [obj checkInternetConnection];
    
    [GMSServices provideAPIKey:@"AIzaSyBSe7lXp_OyUb0DRZswg6v2cORyWHpORRs"];

    
    [FBSession.activeSession closeAndClearTokenInformation];
    FBSession.activeSession=nil;
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
#ifdef __IPHONE_8_0
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        [application registerForRemoteNotifications];
#endif
    } else
    {
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    UIStoryboard *objStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ///SignInViewController *obj=[objStoryBoard instantiateViewControllerWithIdentifier:@"SignInViewControllerID"];
    NSString *uid=[[NSUserDefaults standardUserDefaults]valueForKey:@"UID"];
//    if (uid.length>0 && ![uid isEqual:[NSNull null]])
//    {
//        _viewController = [[JASidePanelController alloc] init];
//        _viewController.shouldDelegateAutorotateToVisiblePanel = NO;
//        _viewController.leftPanel = [objStoryBoard instantiateViewControllerWithIdentifier:@"slideMenuVC"];
//        _viewController.centerPanel = [[UINavigationController alloc]
//                                       initWithRootViewController:[objStoryBoard instantiateViewControllerWithIdentifier:@"TabVCID"]];
//        
//        self.window.rootViewController = _viewController;
//        [self.window makeKeyAndVisible];
//        homeSelected = YES;
//        
//    }
//    else
//    {
        LaunchScreenViewController *obj=[objStoryBoard instantiateViewControllerWithIdentifier:@"LaunchScreenViewControllerID"];
        UINavigationController *mObjNavigation=[[UINavigationController alloc]initWithRootViewController:obj];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = mObjNavigation;
        [self.window makeKeyAndVisible];
    NSString* radius;
    

    radiusStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"radiusStr"]];
    if (![radiusStr isEqualToString:@"(null)"]) {
        radiusStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"radiusStr"]];
    }
    else
    {
        radiusStr = @"50";
        [[NSUserDefaults standardUserDefaults]setObject:radiusStr forKey:@"radiusStr"];
    }
    
    return YES;
}



#pragma mark - Getting Device Token

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"error here : %@", error);//not called
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    
    //    _dvcToknData= deviceToken;
    NSString * deviceTokenStr = [NSString stringWithFormat:@"%@",deviceToken];
    
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"My token is: %@", deviceTokenStr);
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenStr forKey:@"device_token"];
    
    NSLog(@"did register notif");//not called
}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
    
//    NSString *itemName = [notif.userInfo objectForKey:ToDoItemKey];
//    
//    [viewController displayItem:itemName];  // custom method
//    
//    app.applicationIconBadgeNumber = notification.applicationIconBadgeNumber - 1;
    
}

#pragma mark - FaceBook implementation


-(void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI{
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:allowLoginUI
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                      
                                      // Create a NSDictionary object and set the parameter values.
                                      NSDictionary *sessionStateInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                        session, @"session",
                                                                        [NSNumber numberWithInteger:status], @"state",
                                                                        error, @"error",
                                                                        nil];
                                      
                                      // Create a new notification, add the sessionStateInfo dictionary to it and post it.
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"SessionStateChangeNotification"
                                                                                          object:nil
                                                                                        userInfo:sessionStateInfo];
                                      
                                  }];
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

#pragma mark- Azure DataBase Implementation



//- (NSManagedObjectContext *)managedObjectContext
//{
//    if (_managedObjectContext != nil) {
//        return _managedObjectContext;
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (coordinator != nil) {
//        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
//        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
//    }
//    return _managedObjectContext;
//}
//
//// Returns the managed object model for the application.
//// If the model doesn't already exist, it is created from the application's model.
//- (NSManagedObjectModel *)managedObjectModel
//{
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
//    
//    //
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"QSTodoDataModel" withExtension:@"momd"];
//    
////    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"QSTodoDataModel" withExtension:@"xcdatamodel"];
//
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    return _managedObjectModel;
//}
//
//// Returns the persistent store coordinator for the application.
//// If the coordinator doesn't already exist, it is created and the application's store added to it.
//
//
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
//{
//    if (_persistentStoreCoordinator != nil)
//    {
//        return _persistentStoreCoordinator;
//    }
//    
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"qstodoitem.sqlite"];
//    
//    NSError *error = nil;
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//  /*   if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//         Replace this implementation with code to handle the error appropriately.
//         
//         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//         
//         Typical reasons for an error here include:
//         * The persistent store is not accessible;
//         * The schema for the persistent store is incompatible with current managed object model.
//         Check the error message to determine what the actual problem was.
//         
//         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
//         
//         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
//         * Simply deleting the existing store:
//         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
//         
//         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
//         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
//         
//         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
//         
//   
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//   */
//
//    return _persistentStoreCoordinator;
//}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
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
}

@end
