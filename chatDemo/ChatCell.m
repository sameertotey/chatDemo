//
//  chatCell.m
//  chatDemo
//
//  Created by Sameer Totey on 10/30/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "ChatCell.h"

@interface ChatCell()

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
//    NSLog(@"Will move to super view");
    
}

- (void) layoutSubviews {
    [super layoutSubviews];
    // Before layout, calculate the intrinsic size of the labels (the size they "want" to be), and set the appropriate constraints
    
    NSStringDrawingContext *ctx = [[NSStringDrawingContext alloc] init];
    CGSize maxLabelSize = CGSizeMake(CGRectGetWidth(self.contentView.bounds) * 0.30, MAXFLOAT);
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    UIFont *font = [UIFont systemFontOfSize:17];
    CGRect usernameBounds = [self.userLabel.text boundingRectWithSize:maxLabelSize options:options attributes:@{NSFontAttributeName : font} context:ctx];
    [self.userLabel.text drawInRect:usernameBounds withAttributes:@{NSFontAttributeName : font}];
    self.userLabelWidthConstraint.constant = usernameBounds.size.width;
    self.userLabelHeightConstraint.constant = usernameBounds.size.height;
    
    CGSize maxTextSize = CGSizeMake(CGRectGetWidth(self.contentView.bounds) * 0.60, MAXFLOAT);
    
    font = [UIFont systemFontOfSize:16];

    CGRect textBounds = [self.textString.text boundingRectWithSize:maxTextSize options:options attributes:@{NSFontAttributeName : font} context:ctx];
    
    self.textStringHeightConstraint.constant = textBounds.size.height;
    self.textStringWidthConstraint.constant = textBounds.size.width;
    
}


@end
