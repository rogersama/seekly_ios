//
//  InterestCategoryViewController.h
//  Seekly
//
//  Created by Deepinder singh on 14/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInViewController.h"
#import "JASidePanelController.h"
#import "slideViewController.h"
#import "AsyncImageView.h"
#import "InterestSubCategoryViewController.h"

@class InterestCategoryViewController;

@protocol InterestCategoryViewControllerDelegate <NSObject>
- (void)enteredCatIDs:(InterestCategoryViewController *)controller didFinishEnteringItem:(NSString *)categID : (NSString *)subCatIDArr ;

- (void)enteredSubCatIDToGrp:(InterestCategoryViewController *)controller didFinishEnteringItem:(NSString *)categID : (NSString *)subCatIDArr :(NSString *)categoryName ;

-(void)enteredCatIDSubCatIds:(InterestCategoryViewController *)controller didFinishEnteringItem:(NSString *)categID :(NSString *)subCatIDArr;

- (void)enteredSubCatIDToEditGrp:(InterestCategoryViewController *)controller didFinishEnteringItem:(NSString *)categID : (NSString *)subCatIDArr :(NSString *)subcategoryName ;


@end
@interface InterestCategoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,InterestSubCategoryViewControllerDelegate>
{
    NSArray * array,*Arr;
    NSMutableArray *subCatArr;
    NSString *subCatStr;
    
    IBOutlet UIView *searchView;
    IBOutlet UITableView *Table;
    BOOL isVisible;
    IBOutlet UIButton *searchButton;
    NSMutableArray *filteredArray;
    IBOutlet UITextField *searchTF;
    NSString *searchTextString;
    NSMutableArray *globalArray;

}

@property (strong, nonatomic)UIRefreshControl *refreshControl;
@property (nonatomic,retain) NSString *isComingFrom;
@property (strong, nonatomic) JASidePanelController *viewController;
@property (nonatomic, weak) id <InterestCategoryViewControllerDelegate> delegate;



- (IBAction)doneAction:(id)sender;

@end
