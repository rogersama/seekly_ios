//
//  MessagesTableViewCell.h
//  Seekly
//
//  Created by Gursimran on 23/07/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface MessagesTableViewCell : SWTableViewCell


@property(nonatomic ,strong) IBOutlet UIImageView *userImage;
@property(nonatomic ,strong) IBOutlet UILabel *userName;
@property(nonatomic ,strong) IBOutlet UILabel *msgText;
@property(nonatomic ,strong) IBOutlet UILabel *time;
@property(nonatomic ,strong) IBOutlet UIButton *userProfileButton;
@end
