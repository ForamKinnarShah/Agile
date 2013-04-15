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
    
    // push notification
    remoteHost = [Reachability reachabilityWithHostName:@"www.google.co.in"];
	[remoteHost startNotifier];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)];
    
    // ------------------

    NSString *centerImageName = @"logo_small.png";
    UITabBarController *tab = [[UITabBarController alloc] init];

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
    
    
    // -----------------------------Push Notification
    
    
    NSLog(@"deviceToken: %@", deviceToken);
    //	//    [self sendProviderDeviceToken:devTokenBytes]; // custom method
	
	
	// Get Bundle Info for Remote Registration (handy if you have more than one app)
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];

	// Check what Notifications the user has turned on.  We registered for all three, but they may have manually disabled some or all of them.
    NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
	
    
//	// Set the defaults to disabled unless we find otherwise...
//    NSString *pushBadge = @"disabled";
//    NSString *pushAlert = @"disabled";
//    NSString *pushSound = @"disabled";

    // Set the defaults to disabled unless we find otherwise...
    NSString *pushBadge;
    NSString *pushAlert;
    NSString *pushSound;

    
    // Check what Registered Types are turned on. This is a bit tricky since if two are enabled, and one is off, it will return a number 2... not telling you which
    // one is actually disabled. So we are literally checking to see if rnTypes matches what is turned on, instead of by number. The "tricky" part is that the
    // single notification types will only match if they are the ONLY one enabled.  Likewise, when we are checking for a pair of notifications, it will only be
    // true if those two notifications are on.  This is why the code is written this way
    if(rntypes == UIRemoteNotificationTypeBadge){
        pushBadge = @"enabled";
    }
    else if(rntypes == UIRemoteNotificationTypeAlert){
        pushAlert = @"enabled";
    }
    else if(rntypes == UIRemoteNotificationTypeSound){
        pushSound = @"enabled";
    }
    else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)){
        pushBadge = @"enabled";
        pushAlert = @"enabled";
    }
    else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)){
        pushBadge = @"enabled";
        pushSound = @"enabled";
    }
    else if(rntypes == ( UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)){
        pushAlert = @"enabled";
        pushSound = @"enabled";
    }
    else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)){
        pushBadge = @"enabled";
        pushAlert = @"enabled";
        pushSound = @"enabled";
    }
	
	// Get the users Device Model, Display Name, Unique ID, Token & Version Number
    UIDevice *dev = [UIDevice currentDevice];
    NSString *deviceUuid = dev.uniqueIdentifier;
    NSString *deviceName = dev.name;
    NSString *deviceModel = dev.model;
    NSString *deviceSystemVersion = dev.systemVersion;
	
	// Prepare the Device Token for Registration (remove spaces and < >)
    NSString *deviceToken_Push = [[[[deviceToken description]
                                    stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                   stringByReplacingOccurrencesOfString:@">" withString:@""]
                                  stringByReplacingOccurrencesOfString: @" " withString: @""];
	
	// !!! CHANGE "/apns.php?" TO THE PATH TO WHERE apns.php IS INSTALLED
    // !!! ( MUST START WITH / AND END WITH ? ).
    // !!! SAMPLE: "/path/to/apns.php?"
    NSString *urlString = [@"/APNS.php?"stringByAppendingString:@"task=register"];
	urlString = [urlString stringByAppendingString:@"&appname="];
    urlString = [urlString stringByAppendingString:appName];
    urlString = [urlString stringByAppendingString:@"&appversion="];
    urlString = [urlString stringByAppendingString:appVersion];
    urlString = [urlString stringByAppendingString:@"&deviceuid="];
    urlString = [urlString stringByAppendingString:deviceUuid];
    urlString = [urlString stringByAppendingString:@"&devicetoken="];
    urlString = [urlString stringByAppendingString:deviceToken_Push];
    urlString = [urlString stringByAppendingString:@"&devicename="];
    urlString = [urlString stringByAppendingString:deviceName];
    urlString = [urlString stringByAppendingString:@"&devicemodel="];
    urlString = [urlString stringByAppendingString:deviceModel];
    urlString = [urlString stringByAppendingString:@"&deviceversion="];
    urlString = [urlString stringByAppendingString:deviceSystemVersion];
    urlString = [urlString stringByAppendingString:@"&pushbadge="];
    urlString = [urlString stringByAppendingString:pushBadge];
    urlString = [urlString stringByAppendingString:@"&pushalert="];
    urlString = [urlString stringByAppendingString:pushAlert];
    urlString = [urlString stringByAppendingString:@"&pushsound="];
    urlString = [urlString stringByAppendingString:pushSound];
    urlString = [urlString stringByAppendingString:@"&uid="];
    int i=7;
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
    
//    urlString = [urlString stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    
   // NSString *hostUrl = @"heres2u.calarg.net";
    
   // NSString *hostUrl = @"74.208.77.106/rts/heres2u/api/";
    
    NSString *hostUrl = @"http://50.62.148.155:8080/heres2u";
    
     _url= [[NSURL alloc] initWithScheme:@"http" host:hostUrl path:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
   
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:_url];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"Register URL: %@", _url);
    NSLog(@"Return Data: %@", returnData);
    
    NSString *s=[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Response String ==-========================================================================================================================================================== %@",s);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Fail to register for remote notifications: %@", error);
}

@end
