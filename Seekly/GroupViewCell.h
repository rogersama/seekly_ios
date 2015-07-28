//
//  GroupViewCell.h
//  LeftSwipeDemo
//
//  Created by Deepinder singh on 15/06/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface GroupViewCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *patternImageView;
@property (weak, nonatomic) IBOutlet UILabel *patternLabel;
@property (weak, nonatomic) IBOutlet UILabel *noOfMembrsLabel;
@property (weak, nonatomic) IBOutlet UILabel *grpTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *grpStatus;
@property (weak, nonatomic) IBOutlet UIImageView *dotImage;


@end
