//
//  ChatRoomViewController.h
//  chatDemo
//
//  Created by Sameer Totey on 11/1/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatCell.h"
#import <Parse/Parse.h>

@interface ChatRoomViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *tfEntry;
@property (weak, nonatomic) IBOutlet UITableView *chatTable;

@property (nonatomic, strong) NSMutableArray *chatData;
@property (assign) BOOL reloading;

@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *userName;

- (void) registerForKeyboardNotifications;
- (void) freeKeyboardNotifications;
- (void) keyboardWasShown:(NSNotification *)aNotification;
- (void) keyboardWillHide:(NSNotification *)aNotification;

- (void) loadLocalChat;

@end
