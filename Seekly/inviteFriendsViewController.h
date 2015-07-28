//
//  inviteFriendsViewController.h
//  Seekly
//
//  Created by Deepinder singh on 11/06/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeeklyAPI.h"
@class inviteFriendsViewController;

@protocol inviteFriendsViewControllerDelegate <NSObject>
- (void)enteredCatIDs:(inviteFriendsViewController *)controller didFinishEnteringItem:(NSString *)categID : (NSMutableArray *)subCatIDArr ;
@end
@interface inviteFriendsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *frndsListtblV;
    NSMutableArray *mainArr,*rquestdUsrsIDArr;
    CGRect screenSize;
    NSMutableArray *SelectedCategoryArray;
}
@property (nonatomic,retain) NSString *group_Id;
@property (nonatomic, weak) id <inviteFriendsViewControllerDelegate> delegate;
-(IBAction)sendInviteBtnActn:(id)sender;
@end
