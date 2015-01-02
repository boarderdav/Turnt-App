//
//  AppDelegate.h
//  Project_Turnt
//
//  Created by Jake Spracher on 11/30/14.
//  Copyright (c) 2014 Turnt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

/*
 General valuable info to read first:
 
 how function declarations and calls work:
 http://jojitsoriano.wordpress.com/2010/08/06/declaring-objective-c-methods/
 
 note that functions can ONLY exist as part of classes, which are explained here:
 https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/DefiningClasses/DefiningClasses.html
 
 ^That one explains 99.9% of the difference between obj C and C++
 
 ... dat shit is pretty cruche
 
 "WTF is a protocol? Why does it have a function whats the difference??" I got you: https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/WorkingwithProtocols/WorkingwithProtocols.html#//apple_ref/doc/uid/TP40011210-CH11-SW1
 
 "now what is a delegate??" Delegates handle events from generic other shit, see https://developer.apple.com/library/ios/documentation/General/Conceptual/CocoaEncyclopedia/DelegatesandDataSources/DelegatesandDataSources.html
 
 */


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property (nonatomic, strong) UINavigationController *navigationController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

