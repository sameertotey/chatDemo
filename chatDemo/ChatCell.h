//
//  chatCell.h
//  chatDemo
//
//  Created by Sameer Totey on 10/30/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *userLabel;
@property (nonatomic, strong) IBOutlet UITextView *textString;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textStringHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textStringWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userLabelWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userLabelHeightConstraint;

@end
