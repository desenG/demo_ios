//
//  AppDelegate.h
//  ObjectiveC_Demo
//
//  Created by DesenGuo on 2016-03-17.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Connectivity.h"
#import "AccountInfoCache.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

