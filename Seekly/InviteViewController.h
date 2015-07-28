//
//  InviteViewController.h
//  Seekly
//
//  Created by Gursimran on 24/07/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddFriendsCell.h"
#import "MBProgressHUD.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

@interface InviteViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *invitableFriends;
    IBOutlet UIButton *members;
    IBOutlet UIButton *invite;
    IBOutlet UITableView *addTable;
    IBOutlet UITableView *friendsTable;
    NSDictionary *dict;
    NSMutableArray *friendsArr;
    IBOutlet UIView *inviteView;
    MBProgressHUD *HUD;
    IBOutlet UITextField *searchTF;
    NSString *searchTextString;
    NSMutableArray *globalArray;
    NSMutableArray *filteredArray;

}
-(IBAction)membersButton:(id)sender ;
-(IBAction)inviteButton:(id)sender;
@end
