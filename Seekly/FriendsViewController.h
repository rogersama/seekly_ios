//
//  FriendsViewController.h
//  Seekly
//
//  Created by Deepinder singh on 01/06/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddFriendsCell.h"
#import "MBProgressHUD.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

@interface FriendsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIButton *EditBtn;
    NSMutableArray *searchResults;
    IBOutlet UIButton *friends;
    IBOutlet UIButton *add;
    IBOutlet UIButton *invite;
    IBOutlet UITableView *addTable;
    IBOutlet UITableView *friendsTable;
    NSDictionary *dict;
    NSMutableArray *friendsArr;
    IBOutlet UIView *inviteView;
}
-(IBAction)friendsButton:(id)sender ;
-(IBAction)addButton:(id)sender;
-(IBAction)inviteButton:(id)sender;
@end
