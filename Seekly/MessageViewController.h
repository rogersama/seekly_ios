//
//  MessageViewController.h
//  Seekly
//
//  Created by Deepinder singh on 21/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessagesTableViewCell.h"
#import "SWTableViewCell.h"
#import "FriendsProfileViewController.h"

@interface MessageViewController : UIViewController<SWTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    IBOutlet UITextField *serachUser;
    IBOutlet UIView *searchView;
    IBOutlet UITableView *Table;
    BOOL isVisible;
    FriendsProfileViewController *obj;
    NSMutableArray *filteredArray;
    IBOutlet UITextField *searchTF;
    NSString *searchTextString;
    NSMutableArray *globalArray;
    NSMutableArray *mainArr;
    IBOutlet UIButton *searchButton;

}
- (IBAction)writeNewMsg:(id)sender;
- (IBAction)searchButton:(id)sender;

@end
