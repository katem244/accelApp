//
//  AppDelegate.h
//  accelerometer
//
//  Created by Katerina on 6/23/16.
//  Copyright © 2016 Katerina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;



@end