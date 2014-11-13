//
//  ChatRoomViewController.m
//  chatDemo
//
//  Created by Sameer Totey on 11/1/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "ChatRoomViewController.h"

#define TABBAR_HEIGHT 49.0f
#define TEXTFIELD_HEIGHT 70.0f

@interface ChatRoomViewController ()

@end

@implementation ChatRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.chatData = [[NSMutableArray alloc] init];
    self.className = @"ChatData";
    self.userName = @"John Appleseed";

    [self reloadTableViewDatasource];
//    _tfEntry.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self registerForKeyboardNotifications];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self freeKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Chat TextField

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"The text content: %@", self.tfEntry.text);

    [textField resignFirstResponder];
    
    if (self.tfEntry.text.length > 0) {
        // updating the table immediately
        NSArray *keys = [NSArray arrayWithObjects:@"text", @"userName", @"date", nil];
        NSArray *objects = [NSArray arrayWithObjects:self.tfEntry.text, self.userName, [NSDate date], nil];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        [self.chatData addObject:dictionary];
        
        NSMutableArray *insertIndexPaths = [NSMutableArray array];
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [insertIndexPaths addObject:newPath];
        [self.chatTable beginUpdates];
        [self.chatTable insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
        [self.chatTable endUpdates];
        [self.chatTable reloadData];
        
        // going for the parsing
        PFObject *newMessage = [PFObject objectWithClassName:self.className];
        [newMessage setObject:self.tfEntry.text forKey:@"text"];
        [newMessage setObject:self.userName forKey:@"userName"];
        [newMessage setObject:[NSDate date] forKey:@"date"];
        [newMessage saveInBackground];
        self.tfEntry.text = @"";
    }
    [self loadLocalChat];
    return NO;
}

- (IBAction)textFieldDoneEditing:(UITextField *)sender {
    NSLog(@"The text content: %@", self.tfEntry.text);
    [self.tfEntry resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.tfEntry resignFirstResponder];
}

#pragma KeyBoard Notifications

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)freeKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *)aNotification {
    NSLog(@"Keyboard was shown");
    
    NSDictionary *info = [aNotification userInfo];
    
    NSNumber *durationNumber = info[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curveNumber = info[UIKeyboardAnimationCurveUserInfoKey];
    NSTimeInterval animationDuration = durationNumber.doubleValue;
    UIViewAnimationCurve animationCurve = curveNumber.unsignedIntegerValue;
    NSValue *keyboardFrameValue = info[UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameInScreenCoordiantes = keyboardFrameValue.CGRectValue;
    CGRect keyboardFrameInViewCooradinates = [self.view convertRect:keyboardFrameInScreenCoordiantes fromView:nil];
    
    UIViewAnimationOptions options = animationCurve << 16;
    
    [UIView animateWithDuration:animationDuration delay:0 options:options animations:^{
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - keyboardFrameInViewCooradinates.size.height+TABBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
    } completion:nil];
    
    
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    NSLog(@"Keyboard will hide");
    NSDictionary *info = [aNotification userInfo];
    
    NSNumber *durationNumber = info[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curveNumber = info[UIKeyboardAnimationCurveUserInfoKey];
    NSTimeInterval animationDuration = durationNumber.doubleValue;
    UIViewAnimationCurve animationCurve = curveNumber.unsignedIntegerValue;
    NSValue *keyboardFrameValue = info[UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameInScreenCoordiantes = keyboardFrameValue.CGRectValue;
    CGRect keyboardFrameInViewCooradinates = [self.view convertRect:keyboardFrameInScreenCoordiantes fromView:nil];
    
    UIViewAnimationOptions options = animationCurve << 16;
    
    [UIView animateWithDuration:animationDuration delay:0 options:options animations:^{
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + keyboardFrameInViewCooradinates.size.height - TABBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
    } completion:nil];
    
}

#pragma mark - Text Field delegate

#pragma mark - Data Source Loading / Reloading methods

- (void)reloadTableViewDatasource {
    // should be calling your tableviews data source model to reload put here just for demo
    self.reloading = YES;
    [self loadLocalChat];
    [self.chatTable reloadData];
}

- (void)doneLoadingTableViewData {
    // model should call this when its done loading
    self.reloading = NO;
    
}

#pragma mark - Table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.chatData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = (ChatCell *)[tableView dequeueReusableCellWithIdentifier:@"chatCellIdentifier"];
    
    NSUInteger row = [self.chatData count] - indexPath.row - 1;
    NSString *chatText = [[self.chatData objectAtIndex:row] objectForKey:@"text"];
    cell.textString.text = chatText;
    
    NSDate *theDate = [[self.chatData objectAtIndex:row] objectForKey:@"date"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm a"];
    NSString *timeString = [formatter stringFromDate:theDate];
    cell.timeLabel.text = timeString;
    
    cell.userLabel.text = [[self.chatData objectAtIndex:row] objectForKey:@"userName"];


    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor grayColor];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView setEditing:YES animated:YES];
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSUInteger index = [self.chatData count] - indexPath.row - 1;
        NSLog(@"inside the swipe to delete %lu and %lu", (unsigned long)indexPath.row, (unsigned long)index);
        PFObject *objectToDelete = [self.chatData objectAtIndex:index];
        NSLog(@"The object is %@", objectToDelete);
        [objectToDelete deleteInBackground];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellText = [[self.chatData objectAtIndex:self.chatData.count - indexPath.row - 1] objectForKey:@"text"];
    UIFont *font = [UIFont systemFontOfSize:17];
    CGSize constraintSize = CGSizeMake(CGRectGetWidth(self.view.frame) * 0.60, CGRectGetHeight(self.view.frame));
    
    NSStringDrawingContext *ctx = [[NSStringDrawingContext alloc] init];

    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect labelRect = [cellText boundingRectWithSize:constraintSize options:options attributes:@{NSFontAttributeName : font} context:ctx];
    CGFloat textHeight = labelRect.size.height + 10;
    
    // atleast return 100
    return textHeight > 100 ? textHeight : 100;
}

#pragma mark - Parse

#define MAX_ENTRIES_LOADED 25

- (void)loadLocalChat {
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    // If no objects are loaded in memory, we look to the cache first to fill the table and then subsequently do a query against the network
    if ([self.chatData count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query orderByAscending:@"createdAt"];
        NSLog(@"Trying to retrieve from cache");
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded
                NSLog(@"Successfully retrieved %lu chats from cache.", (unsigned long)objects.count);
                [self.chatData removeAllObjects];
                [self.chatData addObjectsFromArray:objects];
                [self.chatTable reloadData];
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    __block int totalNumberOfEntries = 0;
    PFQuery *query1 = [PFQuery queryWithClassName:self.className];
    [query1 orderByAscending:@"createdAt"];
    [query1 countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            // The count request succeeded. Log the count
            NSLog(@"There are currently %d entries", number);
            totalNumberOfEntries = number;
            if (totalNumberOfEntries > [self.chatData count]) {
                NSLog(@"Retrieving data");
                int theLimit;
                if (totalNumberOfEntries - [self.chatData count] > MAX_ENTRIES_LOADED) {
                    theLimit = MAX_ENTRIES_LOADED;
                } else {
                    theLimit = totalNumberOfEntries - (int)[self.chatData count];
                }
                query1.limit = theLimit;
                [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        // The find succeeded.
                        NSLog(@"Successfully retrieved %lu chats.", (unsigned long)objects.count);
                        [self.chatData addObjectsFromArray:objects];
                    } else {
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
        } else {
            // The request failed, we'll keep the chatData count?
            number = (int)[self.chatData count];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
