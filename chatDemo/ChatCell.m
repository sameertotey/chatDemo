//
//  chatCell.m
//  chatDemo
//
//  Created by Sameer Totey on 10/30/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "ChatCell.h"

@interface ChatCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelHeightConstraint;

@end

@implementation ChatCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    NSLog(@"Will move to super view");
    
}

- (void) layoutSubviews {
    [super layoutSubviews];
//    NSLog(@"inside layout subviews for chatcell");
    // Before layout, calculate the intrinsic size of the labels (the size they "want" to be), and add 2 to the height
    CGSize maxsize = CGSizeMake(CGRectGetWidth(self.contentView.bounds) * 0.25, MAXFLOAT);
    CGSize usernameLabelSize = [self.userLabel sizeThatFits:maxsize];
    CGSize timeLabelSize = [self.timeLabel sizeThatFits:maxsize];
    
    self.userLabelHeightConstraint.constant = usernameLabelSize.height + 2;
    self.timeLabelHeightConstraint.constant = timeLabelSize.height + 2;
    
    CGSize textStringConstraintSize = CGSizeMake(CGRectGetWidth(self.contentView.bounds) * 0.75, MAXFLOAT);
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    UIFont *font = [UIFont systemFontOfSize:14];

    self.textString.frame = [self.textString.text boundingRectWithSize:textStringConstraintSize options:options attributes:@{NSFontAttributeName : font} context:nil];

    [self.userLabel sizeToFit];
    [self.timeLabel sizeToFit];
    [self.textString sizeToFit];
    [self.contentView sizeToFit];
}

@end
