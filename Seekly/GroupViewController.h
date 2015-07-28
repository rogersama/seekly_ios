//
//  GroupViewController.h
//  Seekly
//
//  Created by Deepinder singh on 21/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface GroupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,UITextFieldDelegate>
{
    IBOutlet UITableView *groupsTblV;
    IBOutlet UIView *searchView;
    IBOutlet UITableView *Table;
    BOOL isVisible;
    IBOutlet UIButton *searchButton;
    NSMutableArray *filteredArray;
    IBOutlet UITextField *searchTF;
    NSString *searchTextString;
    NSMutableArray *globalArray;
}
@property (nonatomic, strong) UIImageView *deleteButton;

-(IBAction)searchButton:(id)sender;

@end
