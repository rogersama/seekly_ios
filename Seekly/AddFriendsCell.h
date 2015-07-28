//
//  AddFriendsCell.h
//  Seekly
//
//  Created by Gursimran on 22/07/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendsCell : UITableViewCell

@property (nonatomic ,strong) IBOutlet UILabel *userName;
@property (nonatomic ,strong) IBOutlet UIImageView *userImage;
@property (nonatomic ,strong) IBOutlet UIButton *addButton;
@property (nonatomic ,strong) IBOutlet UILabel *mutualFriends;
@property (nonatomic ,strong) IBOutlet UIImageView *onlineStatus;
@property (nonatomic ,strong) IBOutlet UIButton *accept;
@property (nonatomic ,strong) IBOutlet UIButton *decline;


@end
