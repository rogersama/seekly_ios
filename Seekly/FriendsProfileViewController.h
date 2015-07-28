//
//  FriendsProfileViewController.h
//  Seekly
//
//  Created by Gursimran on 23/07/15.
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
#import "PostViewController.h"



@interface FriendsProfileViewController : UIViewController<UITextFieldDelegate,UINavigationBarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    IBOutlet UIImageView *profileImage;
    IBOutlet UIImageView *coverImage;
    IBOutlet UILabel *userName;
    CGRect screenSize;
    IBOutlet UIView *scrollingView;
    
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) CGRect originalFrame;
@property (nonatomic) CGRect topOriginalFrame;
@property (nonatomic ,strong) NSString *profileID;


- (IBAction)goTofriendProfile:(id)sender;
- (IBAction)backButton:(id)sender;


@end
