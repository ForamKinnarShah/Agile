//
//  AppDelegate.m
//  HERES2U
//
//  Created by Paul Amador on 11/28/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "LoginViewController.h" 
#import "FeedViewController.h" 
#import "MytabViewController.h" 
#import "CheckinViewController.h" 
#import "Heres2uViewController.h"
#import <AudioToolbox/AudioToolbox.h>

NSString * const logOutNotification = @"logOutNotification";
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
      //LoginViewController *log = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:log];
    
        
//    UITabBarController *tab = [[UITabBarController alloc] init];
//    ProfileViewController *prof = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil]; 
//  
//    MytabViewController *mytab = [[MytabViewController alloc] initWithNibName:@"MytabViewController" bundle:nil];
//    CheckinViewController *check = [[CheckinViewController alloc] initWithNibName:@"CheckinViewController" bundle:nil];
//    FeedViewController *feed = [[FeedViewController alloc] initWithNibName:@"FeedViewController" bundle:nil];
//    Heres2uViewController *h2u = [[Heres2uViewController alloc] initWithNibName:@"Heres2uViewController" bundle:nil];
//    
//    tab.viewControllers = [NSArray arrayWithObjects:feed,check,h2u,mytab,prof,nil];
   // self.window.rootViewController = nav;
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            CGFloat scale = [UIScreen mainScreen].scale;
            result = CGSizeMake(result.width * scale, result.height * scale);
            
            if(result.height == 960) {
                NSLog(@"iPhone 4 Resolution");
                isiPhone5 = NO;
            }
            if(result.height == 1136) {
                isiPhone5 = YES;
                NSLog(@"iPhone 5 Resolution");
            }
        }
        else{
            NSLog(@"Standard Resolution");
        }
    }

    
    
    // push notification
    remoteHost = [Reachability reachabilityWithHostName:@"www.google.co.in"];
	[remoteHost startNotifier];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)];
    
    // ------------------

    NSString *centerImageName = @"logo_small.png";
    tab = [[UITabBarController alloc] init];

    ProfileViewController *prof = [[ProfileViewController alloc] initWithNibName:@"ProfileView" bundle:nil ProfileID:[(NSString *)[NSGlobalConfiguration getConfigurationItem:@"ID"] integerValue]];
    UINavigationController *profNav = [[UINavigationController alloc] initWithRootViewController:prof];
    
    MytabViewController *mytab = [[MytabViewController alloc] initWithNibName:@"MytabViewController" bundle:nil];
    UINavigationController *mytabNav = [[UINavigationController alloc] initWithRootViewController:mytab];
    
    CheckinViewController *check = [[CheckinViewController alloc] initWithNibName:@"CheckinViewController" bundle:nil];
    UINavigationController *checkNav = [[UINavigationController alloc] initWithRootViewController:check];
    
    FeedViewController *feed = [[FeedViewController alloc] initWithNibName:@"Empty" bundle:nil];
    UINavigationController *feedNav = [[UINavigationController alloc] initWithRootViewController:feed];
    
    //Heres2uViewController *h2u = [[Heres2uViewController alloc] initWithNibName:@"Heres2uViewController" bundle:nil];
    Heres2uViewController *h2u = [[Heres2uViewController alloc] initWithNibName:@"Empty" bundle:nil];
    
    
    UINavigationController *h2uNav = [[UINavigationController alloc] initWithRootViewController:h2u];
    profNav.navigationBar.topItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:centerImageName]];
    mytabNav.navigationBar.topItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:centerImageName]];
    feedNav.navigationBar.topItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:centerImageName]];
    checkNav.navigationBar.topItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:centerImageName]];
    h2uNav.navigationBar.topItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:centerImageName]];
    
    
    [prof  setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"dot.png"] tag:5]];
    [mytab  setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"My Tab" image:[UIImage imageNamed:@"dot.png"] tag:4]];
    [check  setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Check-in" image:[UIImage imageNamed:@"dot.png"] tag:2]];
    [feed  setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Feed" image:[UIImage imageNamed:@"dot.png"] tag:1]];
    [h2u  setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"HERES2U" image:[UIImage imageNamed:@"dot.png"] tag:3]];
     tab.viewControllers = [NSArray arrayWithObjects:feedNav,checkNav,h2uNav,mytabNav,profNav,nil];
    
    [self.window setRootViewController:tab];
    [self.window makeKeyAndVisible];
    
#if !TARGET_IPHONE_SIMULATOR
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
#endif

    
    return YES;
}
-(NSURL *) HomeDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
-(NSManagedObjectContext *) managedObjectContext{
    if(managedObjectContext){
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator=[self persistentStoreCoordinator];
    managedObjectContext=[[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator:coordinator];
    return managedObjectContext;
}
-(NSManagedObjectModel *) managedObjectModel{
    if(managedObjectModel){
        return managedObjectModel;
    }
    NSURL *StoreURL=[[NSBundle mainBundle] URLForResource:@"ActivityData" withExtension:@"momd"];
    // NSLog(@"Store front DATA:%@",[StoreURL absoluteString]);
    managedObjectModel=[[NSManagedObjectModel alloc] initWithContentsOfURL:StoreURL];
    //managedObjectModel=[NSManagedObjectModel mergedModelFromBundles:nil];
    return managedObjectModel;
}
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    if(persistentStoreCoordinator){
        return persistentStoreCoordinator;
    }
    NSURL *StoreURL=[[self HomeDirectory] URLByAppendingPathComponent:@"FeedItems.sqlite"];
    // NSLog(@"Store front DATA:%@",[StoreURL absoluteString]);
    NSError *error=nil;
    persistentStoreCoordinator=[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:StoreURL options:nil error:&error]){
        // NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    return persistentStoreCoordinator;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}

#pragma mark -
#pragma mark Remote notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // You can send here, for example, an asynchronous HTTP request to your web-server to store this deviceToken remotely.
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://xxx.com"]];
    [req setHTTPBody:deviceToken];
    [req setHTTPMethod:@"POST"];
    //[req setValue:<#(NSString *)#> forHTTPHeaderField:@"content-length"]; 
    NSLog(@"Did register for remote notifications: %@", deviceToken);
    
    _dataDeviceToken = [[NSData alloc] initWithData:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Fail to register for remote notifications: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    NSString *alertMsg;
    NSString *badge;
    NSString *sound;
    
//    NSDictionary *dic_push=[[NSDictionary alloc]initWithDictionary:userInfo];
    
    if( [[userInfo objectForKey:@"aps"] objectForKey:@"alert"] != NULL)
    {
        alertMsg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    }
    else
    {    alertMsg = @"{no alert message in dictionary}";
    }
    
    if( [[userInfo objectForKey:@"aps"] objectForKey:@"badge"] != NULL)
    {
        badge = [[userInfo objectForKey:@"aps"] objectForKey:@"badge"];
    }
    else
    {    badge = @"{no badge number in dictionary}";
    }
    
    if( [[userInfo objectForKey:@"aps"] objectForKey:@"sound"] != NULL)
    {
        sound = [[userInfo objectForKey:@"aps"] objectForKey:@"sound"];
    }
    else
    {    sound = @"{no sound in dictionary}";
    }
    
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    
  //  NSString* alert_msg = [NSString stringWithFormat:@"APNS message '%@' was just received.", alertMsg];
    
    UIAlertView *alert_push = [[UIAlertView alloc] initWithTitle:@"Here2U"
                                            message:alertMsg
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
    alert_push.tag=1;
    [alert_push show];
        
    //[self.viewController reloadInputViews];
    
    // NSString *badge = [userInfo objectForKey:@"badge"];
    //[alert release];
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    @try {
        [tab setSelectedIndex:3];
    }
    @catch (NSException *exception) {
        
    }
}


#pragma mark
#pragma mark -----------------class shared instance-------------------

static AppDelegate *shared = nil;

+(AppDelegate*)sharedInstance
{
    if (!shared)
        shared = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return shared;
}

#pragma mark -
#pragma mark Facebook

/// FBSample logic
// In the login workflow, the Facebook native application, or Safari will transition back to
// this applicaiton via a url following the scheme fb[app id]://; the call to handleOpenURL
// below captures the token, in the case of success, on behalf of the FBSession object
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBSession.activeSession handleOpenURL:url];
}


@end
