//
//  profileTableViewCell.m
//  Seekly
//
//  Created by Deepinder singh on 16/06/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "profileTableViewCell.h"

@implementation profileTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
