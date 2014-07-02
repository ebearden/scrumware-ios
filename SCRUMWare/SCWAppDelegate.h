//
//  SCWAppDelegate.h
//  SCRUMWare
//
//  Created by Elvin Bearden.
//  Copyright (c) 2014 scrumware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCWMainMenuViewController.h"

@interface SCWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) SCWMainMenuViewController *mainMenuViewController;

// Core Data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
