//
//  InterestSubCategoryViewController.h
//  Seekly
//
//  Created by Deepinder singh on 05/06/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeeklyAPI.h"
#import "slideViewController.h"

@class InterestSubCategoryViewController;

@protocol InterestSubCategoryViewControllerDelegate <NSObject>

- (void)enteredCatIDs:(InterestSubCategoryViewController *)controller didFinishEnteringItem:(NSString *)categID : (NSString *)subCatIDArr ;


- (void)enteredCatIDsToGrp:(InterestSubCategoryViewController *)controller didFinishEnteringItem:(NSString *)categID : (NSString *)subCatIDArr : (NSString *)subCatName ;

- (void)enteredCatIDsAtSignup:(InterestSubCategoryViewController *)controller didFinishEnteringItem:(NSString *)subCatIDArr;


@end


@interface InterestSubCategoryViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    IBOutlet UILabel *categoryLbl;
    NSUInteger prevIndex;
}
@property (nonatomic,retain) NSString *isComingFromScreen;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong,nonatomic) NSString *categoryId;
@property (strong,nonatomic) NSString *categoryName;


@property (nonatomic, weak) id <InterestSubCategoryViewControllerDelegate> delegate;
@end
