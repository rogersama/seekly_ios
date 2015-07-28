//
//  GroupEditViewController.h
//  Seekly
//
//  Created by OSX on 08/07/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "searchLocationViewController.h"
#import "SeeklyAPI.h"
#import "SZTextView.h"
#import "InterestCategoryViewController.h"

@interface GroupEditViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,searchLocationViewControllerDelegate,InterestCategoryViewControllerDelegate>
{
    IBOutlet UIButton *grpProfImgBtn;
    IBOutlet UIButton *grpCoverImgBtn;
    IBOutlet UIImageView *grpcoverImg;
    IBOutlet UIButton*openEvntBtn;
    IBOutlet UIButton*closedEvntBtn;
    IBOutlet UIButton*secretEvntBtn;
    IBOutlet UITextField *grpNametxtfld;
    IBOutlet UIButton *locnBtn;
    int isProfilePicBtn,statusVal;
    IBOutlet SZTextView *descTxtView;
    NSString *strEncodedProfPic,*strEncodedCoverPic,*latit,*longit,*sub_categ_Id,*sub_cat_name,*cat_Id;

}

-(IBAction)openEvntBtnActn:(id)sender;
-(IBAction)closedEvntBtnActn:(id)sender;
-(IBAction)secretEvntBtnActn:(id)sender;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)saveBtnAction:(id)sender;
- (IBAction)grpProfImgBtnAction:(id)sender;
- (IBAction)locnBtnAction:(id)sender;
- (IBAction)grpcoverImgAction:(id)sender;
-(IBAction)interestBtnActn:(id)sender;



@property(nonatomic,retain) NSString *grpId;
@property(nonatomic,retain) NSString *subCategId;
@property(nonatomic,retain) NSString *grpName;
@property(nonatomic,retain) NSString *grpProfImgDataStr;
@property(nonatomic,strong) UIImage *grpProfImg;
@property (nonatomic,retain) NSString *grp_Lat;
@property (nonatomic,retain) NSString *grp_Long;
@property (nonatomic,retain) NSString *grp_Locn;
@property (nonatomic,retain) NSString *status;
@property (nonatomic,retain) NSString *grp_Descr;
@property(nonatomic,strong) UIImage *grpCover_Img;
@property(nonatomic) int grpStatus;


@end
