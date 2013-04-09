//
//  AppDelegate.h
//  HERES2U
//
//  Created by Paul Amador on 11/28/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate, NSURLConnectionDelegate>
{
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
  
    
    // Push Notification
    
    //  Reachability internet check
    Reachability *remoteHost;
}
@property (nonatomic, readonly, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic,readonly,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,readonly,strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) UIWindow *window;

// push notification
@property int remoteHostStatus;
@property (nonatomic, strong) NSURL *url; // url to register device

@end
