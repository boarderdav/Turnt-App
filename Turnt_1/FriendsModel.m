//
//  FriendsModel.m
//  Turnt_1
//
//  Created by Jake Spracher on 1/5/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "FriendsModel.h"
#import <AddressBook/AddressBook.h>
#import <Parse/Parse.h>

@interface FriendsModel ()

@end

@implementation FriendsModel
@synthesize Friends;
@synthesize FriendFullNames;
@synthesize ContactMatches;
@synthesize ContactMatchFullNames;
@synthesize ReadWriteQueue;
@synthesize TempCliqueMembers;

static FriendsModel* instance;

// open the shared model in any file
+(FriendsModel *)GetSharedInstance {
    @synchronized(self) {
        if(instance == nil) {
            instance= [FriendsModel new];
        }
    }
    return instance;
}

// Allocate memory/Initialize custom queue
-(void)initialize {
    Friends = [[NSMutableArray alloc] init];
    FriendFullNames = [[NSMutableArray alloc] init];
    ContactMatches = [[NSMutableArray alloc] init];
    ContactMatchFullNames = [[NSMutableArray alloc] init];
    TempCliqueMembers = [[NSMutableArray alloc] init];
    ReadWriteQueue = dispatch_queue_create("readwriteQueue",0);
}

// Remove all stored information (For logout or something)
-(void)clear {
    [Friends removeAllObjects];
    [FriendFullNames removeAllObjects];
    [ContactMatches removeAllObjects];
    [ContactMatchFullNames removeAllObjects];
    [TempCliqueMembers removeAllObjects];
}

#pragma mark - Friend Management Utilites

// Get the name associated with a number from the address book (full names arent stored on the server, preference given to contact names which differ by user)
+ (NSString *)FindNameByNumber:(NSString*)Number {
    
    // clean the number of extra characters
    NSString *toFind = [[Number componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    
    // open the address book
    CFErrorRef *error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    
    // iterate all of the contacts
    for(int i = 0; i < numberOfPeople; i++) {
        
        // get this contact
        ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
        
        // Get all of the phone numbers for this contact
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        // Iterate all of the numbers
        for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
            
            // Get this number
            NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            // clean the contact number of extra characters
            NSString *cleaned = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];

            // If its the one were looking for
            if ([cleaned isEqualToString:toFind]) {
                
                // get the contact's name
                NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
                NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
                NSString *fullName = [NSString stringWithFormat:@"%@ %@",firstName,lastName];

                // return the user's name
                return fullName;
            }
        }
    }
    return @"";
}

-(void)FollowUser:(NSString*)username {
    //Protect from simulaneous reading and writing to model
    dispatch_barrier_async(ReadWriteQueue, ^{
        // query for the user to follow
        PFQuery *UserQuery = [PFUser query];
        [UserQuery whereKey:@"username" equalTo:username];
        PFUser *ToFollow = [UserQuery findObjects][0];

        // create an entry in the Follow table
        PFObject *follow = [PFObject objectWithClassName:@"Follow"];
        [follow setObject:[PFUser currentUser]  forKey:@"From"];
        [follow setObject:ToFollow forKey:@"To"];
        [follow setValue:@NO forKey:@"Accepted"];
        [follow setValue:@NO forKey:@"Read"];
        [follow saveEventually];
        
        PFQuery *PushQuery = [PFInstallation query];
        
        // only return Installations that belong to a User that
        // matches the innerQuery
        [PushQuery whereKey:@"user" equalTo:ToFollow];
        
        PFPush *push = [[PFPush alloc] init];
        [push setQuery:PushQuery];
        NSString *Message = [NSString stringWithFormat:@"%@ just followed you on Turnt. Accept?", [PFUser currentUser].username];
        [push setMessage:Message];
        [push sendPushInBackground];
        
    });
    
}

-(void)FollowUserBack:(NSString*)username {
    //Protect from simulaneous reading and writing to model
    dispatch_barrier_async(ReadWriteQueue, ^{
        // query for the user to follow
        PFQuery *UserQuery = [PFUser query];
        [UserQuery whereKey:@"username" equalTo:username];
        PFUser *ToFollow = [UserQuery findObjects][0];
        
        // Add the user to the friends model in the background
        
        [Friends addObject:ToFollow];
        [FriendFullNames addObject:[ FriendsModel FindNameByNumber:ToFollow[@"phone"]]];
        
        // create an entry in the Follow table
        PFObject *follow = [PFObject objectWithClassName:@"Follow"];
        [follow setObject:[PFUser currentUser]  forKey:@"From"];
        [follow setObject:ToFollow forKey:@"To"];
        [follow setValue:@YES forKey:@"Accepted"];
        [follow setValue:@YES forKey:@"Read"];
        [follow saveEventually];
        
        PFQuery *newFollowQuery = [PFQuery queryWithClassName:@"Follow"];
        [newFollowQuery whereKey:@"To" equalTo:[PFUser currentUser]];
        [newFollowQuery whereKey:@"From" equalTo:ToFollow];
        [newFollowQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for(PFObject *o in objects) {
                o[@"Accepted"] = @YES;
                [o saveEventually];
            }
        }];
        
    });
    
}

-(void)UnfollowUser:(PFUser *)user{
    //Protect from simulaneous reading and writing to model
    dispatch_barrier_async(ReadWriteQueue, ^{
        // query for follow
        PFQuery *FollowQuery = [PFQuery queryWithClassName:@"Follow"];
        [FollowQuery whereKey:@"From" equalTo:[PFUser currentUser]];
        [FollowQuery whereKey:@"To" equalTo:user];
        
        // remove from server
        [FollowQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            // remove the follow in the background
            for (PFObject *o in objects) {
                [o deleteEventually];
            }
        }];
        
        // query for complementary follow
        PFQuery *FollowQuery2 = [PFQuery queryWithClassName:@"Follow"];
        [FollowQuery2 whereKey:@"To" equalTo:[PFUser currentUser]];
        [FollowQuery2 whereKey:@"From" equalTo:user];
        
        // remove from server
        [FollowQuery2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            // remove the follow in the background
            for (PFObject *o in objects) {
                [o deleteEventually];
            }
        }];
   
        // remove the object from the friend model (Consider revising implementation to make use of dictionary to reduce time complexity here)
        for (int i = 0; i < Friends.count; i++) {
            if ([Friends[i][@"username"] isEqualToString:[user objectForKey:@"username"]]) {
                [Friends removeObjectAtIndex:i];
                [FriendFullNames removeObjectAtIndex:i];
            }
        }
    });
}

@end
