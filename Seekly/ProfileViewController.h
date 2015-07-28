//
//  ProfileViewController.h
//  Seekly
//
//  Created by Deepinder singh on 21/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "profileTableViewCell.h"
#import "CalenderViewController.h"
#import "SeeklyAPI.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "EditProfileViewController.h"
#import "MyInterestViewController.h"



@interface ProfileViewController : UIViewController<UITextFieldDelegate,UINavigationBarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    IBOutlet UIButton *profileBtn;
    IBOutlet UIImageView *profileImage;
    IBOutlet UIButton *coverBtn;
    IBOutlet UIImageView *coverImage;
    IBOutlet UILabel *userName;
    CGRect screenSize;
    IBOutlet UIButton *calenderBtn;
    IBOutlet UIView *scrollingView;

}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) CGRect originalFrame;
@property (nonatomic) CGRect topOriginalFrame;


- (IBAction)goTofriendProfile:(id)sender;
- (IBAction)uploadPhotoBtnAction:(id)sender;
- (IBAction)uploadCoverImage:(id)sender;
- (IBAction)calenderAction:(id)sender;


@end
