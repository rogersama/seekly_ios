//
//  GroupProfileViewController.h
//  Seekly
//
//  Created by Deepinder singh on 07/07/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import <Social/Social.h>
#import "CalenderViewController.h"
#import <Accounts/Accounts.h>
#import "InviteViewController.h"
#import "chatViewController.h"


@interface GroupProfileViewController : UIViewController
{
    IBOutlet UIImageView *grpProfileImgV;
    IBOutlet UIImageView *grpCoverImg;
    IBOutlet UILabel *grpNamelbl;
    IBOutlet UILabel *grpLocnlbl;
    IBOutlet UILabel *statusLbl;
    IBOutlet UIView *scrollingView;
    InviteViewController *objInvite;
    chatViewController *objchat;
    
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) CGRect originalFrame;
@property (nonatomic) CGRect topOriginalFrame;

- (IBAction)backBtnAction:(id)sender;
- (IBAction)editGrpAction:(id)sender;
- (IBAction)shareGrpAction:(id)sender;
- (IBAction)membersButton:(id)sender;
- (IBAction)chatButton:(id)sender;



@property (nonatomic,retain) NSString *slctdGrpId;
@property (nonatomic,retain) NSString *status;
@property (nonatomic,retain) NSString *grpLat;
@property (nonatomic,retain) NSString *grpLong;
@property (nonatomic,retain) NSString *grpLocn;
@end
