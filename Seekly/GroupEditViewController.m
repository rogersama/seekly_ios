//
//  GroupEditViewController.m
//  Seekly
//
//  Created by OSX on 08/07/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "GroupEditViewController.h"
#import "searchLocationViewController.h"
#import "MBProgressHUD.h"
@interface GroupEditViewController ()
{

    MBProgressHUD *HUD;
    UIAlertView *alert;
}
@end

@implementation GroupEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sub_categ_Id = _subCategId;
    latit = _grp_Lat;
    longit = _grp_Long;

    grpNametxtfld.text=_grpName;
    grpcoverImg.image = _grpCover_Img;
    descTxtView.text = _grp_Descr;
    grpProfImgBtn.layer.cornerRadius=39;
    grpProfImgBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    grpProfImgBtn.layer.borderWidth=2.2;
    grpProfImgBtn.layer.masksToBounds = YES;
    [grpProfImgBtn setImage:_grpProfImg forState:UIControlStateNormal];
    [locnBtn setTitle:_grp_Locn forState:UIControlStateNormal];

    // Do any additional setup after loading the view.
}
-(void) viewWillAppear:(BOOL)animated
{
    //statusVal=0;
    
    
    if (_grpStatus == 0)
    {
        [openEvntBtn setBackgroundImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
        [closedEvntBtn setBackgroundImage:[UIImage imageNamed:@"check_circle"] forState:UIControlStateNormal];
        [secretEvntBtn setBackgroundImage:[UIImage imageNamed:@"check_circle"] forState:UIControlStateNormal];

    }
    else if (_grpStatus ==1)
    {
        [openEvntBtn setBackgroundImage:[UIImage imageNamed:@"check_circle"] forState:UIControlStateNormal];
        [closedEvntBtn setBackgroundImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
        [secretEvntBtn setBackgroundImage:[UIImage imageNamed:@"check_circle"] forState:UIControlStateNormal];

    }
    else
    {
        [openEvntBtn setBackgroundImage:[UIImage imageNamed:@"check_circle"] forState:UIControlStateNormal];
        [closedEvntBtn setBackgroundImage:[UIImage imageNamed:@"check_circle"] forState:UIControlStateNormal];
        [secretEvntBtn setBackgroundImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];

    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    //Or you can get the image url from AssetsLibrary
    //    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    if (isProfilePicBtn==1) {
        
        [picker dismissViewControllerAnimated:YES completion:^{
            
            
            
            [grpProfImgBtn setImage:image forState:UIControlStateNormal];
        }];
    }
    else
    {
        [picker dismissViewControllerAnimated:YES completion:^{
            
            grpcoverImg.image=image;
        }];
    }
}
- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImageJPEGRepresentation(image, 0.5f) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (IBAction)saveBtnAction:(id)sender
{
    strEncodedProfPic = [self encodeToBase64String:grpProfImgBtn.imageView.image];
    strEncodedCoverPic = [self encodeToBase64String:grpcoverImg.image];
    
    NSURL *url = [NSURL URLWithString:@"http://seekly.azurewebsites.net/api/UpdateGroup/Update"];
    
    // Create the request
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];

    if (grpNametxtfld.text.length == 0)
    {
        alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Group name should not be empty." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [grpNametxtfld becomeFirstResponder];
    }
    
    else if  (descTxtView.text.length == 0 )
    {
        alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Enter some description about group." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [descTxtView becomeFirstResponder];
    }
    else if ([latit isEqual:[NSNull null]])
    {
        alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Select location." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    
    
    
    else if (grpNametxtfld.text.length>0 && descTxtView.text.length>0 && ![latit isEqual :[NSNull null] ] && ![longit isEqual:[NSNull null]] )
    {
        //set profile pic and cover pic
        if (strEncodedProfPic.length >0)
        {
            [request setPostValue:strEncodedProfPic forKey:@"group_pic"];
        }
        else
        {
            [request setPostValue:@"" forKey:@"group_pic"];
        }
        if (strEncodedCoverPic.length >0)
        {
            [request setPostValue:strEncodedCoverPic forKey:@"cover_image"];
        }
        else
        {
            [request setPostValue:@"" forKey:@"cover_image"];
        }
        if (sub_categ_Id.length == 0 )
        {
            [request setPostValue:@"" forKey:@"sub_category_id"];
        }
        else
        {
            [request setPostValue:sub_categ_Id forKey:@"sub_category_id"];
        }
        
        [request setPostValue:_grpId forKey:@"id"];
        [request setPostValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"UID"]  forKey:@"user_id"];
        [request setPostValue:grpNametxtfld.text forKey:@"group_name"];
        [request setPostValue:descTxtView.text forKey:@"group_description"];
        [request setPostValue:locnBtn.titleLabel.text forKey:@"location"];
        [request setPostValue:latit forKey:@"latitude"];
        [request setPostValue:longit forKey:@"longitude"];
        [request setPostValue:@"11" forKey:@"total_member"];
        
        [request setPostValue:[NSString stringWithFormat:@"%d",statusVal] forKey:@"status"];
        
        
        [request setDelegate:self];
        [request startSynchronous];
        
        HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSError *error = [request error];
        if (!error)
        {
            NSString *response = [request responseString];
            response=  [response stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            NSLog(@"%@",response);
            
            NSDictionary *responseDict = [response JSONValue];
            NSLog(@"dict is :%@",responseDict);
            if ([[NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"Status"]] isEqual: @"1"])
            {
                [HUD hide:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [HUD hide:YES];
                alert = [[UIAlertView alloc]initWithTitle:@"Exception" message:[NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"Exception"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
    else
    {
        
    }

}
- (IBAction)grpProfImgBtnAction:(id)sender
{
    isProfilePicBtn=1;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];

}
- (IBAction)grpcoverImgAction:(id)sender
{
    isProfilePicBtn=0;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(IBAction)openEvntBtnActn:(id)sender
{
    statusVal=0;
    [openEvntBtn setBackgroundImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
    [closedEvntBtn setBackgroundImage:[UIImage imageNamed:@"check_circle"] forState:UIControlStateNormal];
    [secretEvntBtn setBackgroundImage:[UIImage imageNamed:@"check_circle"] forState:UIControlStateNormal];
}

-(IBAction)closedEvntBtnActn:(id)sender
{
    
    statusVal=1;
    [openEvntBtn setBackgroundImage:[UIImage imageNamed:@"check_circle"] forState:UIControlStateNormal];
    [closedEvntBtn setBackgroundImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
    [secretEvntBtn setBackgroundImage:[UIImage imageNamed:@"check_circle"] forState:UIControlStateNormal];
}
-(IBAction)secretEvntBtnActn:(id)sender
{
    statusVal=2;
    [openEvntBtn setBackgroundImage:[UIImage imageNamed:@"check_circle"] forState:UIControlStateNormal];
    [closedEvntBtn setBackgroundImage:[UIImage imageNamed:@"check_circle"] forState:UIControlStateNormal];
    [secretEvntBtn setBackgroundImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
}
- (IBAction)locnBtnAction:(id)sender
{
    searchLocationViewController *objSignup = [self.storyboard instantiateViewControllerWithIdentifier:@"searchLocationViewControllerID"];
    objSignup.delegate=self;
    objSignup.isComingFrmScreen=@"2";
    objSignup.addrName=_grp_Locn;
    [self presentViewController:objSignup animated:YES completion:nil];
}
- (void)enteredAddress:(searchLocationViewController *)controller didFinishEnteringItem:(NSString *)address :(NSString *)lati :(NSString *)longi
{
    [locnBtn setTitle:address forState:UIControlStateNormal];

    latit=lati;
    longit=longi;
    
}

-(IBAction)interestBtnActn:(id)sender
{
    //createEventSelected = YES;
    InterestCategoryViewController *objintrst = [self.storyboard instantiateViewControllerWithIdentifier:@"InterestCategoryViewControllerID"];
    objintrst.delegate=self;
    objintrst.isComingFrom = @"EditGroup";
    [self.navigationController pushViewController:objintrst animated:YES];
}


- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)enteredSubCatIDToEditGrp:(InterestCategoryViewController *)controller didFinishEnteringItem:(NSString *)categID :(NSString *)subCatIDArr :(NSString *)subcategoryName
{
    
    sub_cat_name=subcategoryName;
    sub_categ_Id=subCatIDArr;
    
    //[interestBtn setTitle:cat_name forState:UIControlStateNormal];
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
