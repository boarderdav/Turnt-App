//
//  FriendsModel.h
//  Turnt_1
//
//  Created by Jake Spracher on 1/5/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface FriendsModel : NSObject

@property (nonatomic, retain) NSMutableArray* Friends;
@property (nonatomic, retain) NSMutableArray* FriendFullNames;
@property (nonatomic, retain) NSMutableArray* ContactMatches;
@property (nonatomic, retain) NSMutableArray* ContactMatchFullNames;
@property (nonatomic, retain) NSMutableArray* TempCliqueMembers;
@property (nonatomic, strong) dispatch_queue_t ReadWriteQueue;


// open the shared model in any file
+(FriendsModel*)GetSharedInstance;

// initialize memory
-(void)initialize;
-(void)clear;

// Get the current user's stored name for a contact associated with a number from the address book (full names arent stored on the server, preference given to contact names which differ by user)
+(NSString *)FindNameByNumber:(NSString*) Number;
-(void)FollowUser:(NSString*)username;
-(void)FollowUserBack:(NSString*)username;
-(void)UnfollowUser:(PFUser*)user;

@end