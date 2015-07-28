//
//  createGroupViewController.m
//  Seekly
//
//  Created by Deepinder singh on 11/06/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "createGroupViewController.h"
#import "inviteFriendsViewController.h"
#import "MBProgressHUD.h"

@interface createGroupViewController ()
{
    MBProgressHUD *HUD,*HUD2;
}
@end

@implementation createGroupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    setProfPicBtn.layer.cornerRadius=35;
    setProfPicBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    setProfPicBtn.layer.borderWidth=2.2;
    setProfPicBtn.layer.masksToBounds = YES;
    statusVal = 0;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (CreategroupPressed == YES) {
        [self.navigationController popViewControllerAnimated:YES];
        CreategroupPressed = NO;
    }
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)inviteFriends:(id)sender
{
    inviteFriendsViewController *objinvite = [self.storyboard instantiateViewControllerWithIdentifier:@"inviteFriendsViewControllerID"];
    [self.navigationController pushViewController:objinvite animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Search Location Delegate

- (void)enteredAddress:(searchLocationViewController *)controller didFinishEnteringItem:(NSString *)address :(NSString *)lati :(NSString *)longi
{
    addrName=address;
    [locBtn setTitle:addrName forState:UIControlStateNormal];
    latit=lati;
    longit=longi;
    
}


#pragma Get SubCatagory ID Delegate


#pragma mark - Button Actions
-(IBAction)locBtnAtcn:(id)sender
{
    searchLocationViewController *objSignup = [self.storyboard instantiateViewControllerWithIdentifier:@"searchLocationViewControllerID"];
    objSignup.delegate=self;
    objSignup.isComingFrmScreen=@"0";
    [self .navigationController pushViewController:objSignup animated:YES];
}


-(IBAction)setCoverPicBtnAtcn:(id)sender
{
    isProfilePicBtn=0;
    [self ShowCameraUI];
}



-(IBAction)setProfPicBtnAtcn:(id)sender
{
    isProfilePicBtn=1;
    [self ShowCameraUI];
}

#pragma ImagePickerController

-(void)ShowCameraUI
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (isProfilePicBtn==1) {
            
            [picker dismissViewControllerAnimated:YES completion:^{
                
                [setProfPicBtn setImage:image forState:UIControlStateNormal];
            }];
        }
        else
        {
            [picker dismissViewControllerAnimated:YES completion:^{
                
                setCoverPicImgV.image=image;
            }];
        }
    }
}

- (UIImage *)getimageWithName: (NSString *)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    UIImage *image = nil;
    image=[UIImage imageWithData:[NSData dataWithContentsOfFile:getImagePath]];
    return image;
}


- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImageJPEGRepresentation(image, 0.5f) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
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
- (IBAction)addEventBtnAction:(id)sender
{

    
        HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSURL *url = [NSURL URLWithString:@"http://seekly.azurewebsites.net/api/Group/AddGroup"];
        
        // Create the request
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"POST"];
        [request setPostValue:grpNameTxtFld.text forKey:@"group_name"];
        [request setPostValue:@"0715314a-73da-4c13-9da0-9a6e4bd112a3" forKey:@"sub_category_id"];
        [request setPostValue:addrName forKey:@"location"];
        [request setPostValue:descTxtView.text forKey:@"group_description"];
        [request setPostValue:@"" forKey:@"group_pic"];
        [request setPostValue:@"" forKey:@"cover_image"];
        [request setPostValue:latit forKey:@"latitude"];
        [request setPostValue:longit forKey:@"longitude"];
        [request setPostValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"UID"]  forKey:@"user_id"];
        [request setDelegate:self];
        [request startSynchronous];
        
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
                //                [HUD hide:YES];
                [self performSelector:@selector(backAction:)];
            } else {
                //                [HUD hide:YES];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Exception" message:[NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"Exception"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }

    

}
-(IBAction)inviteOthrsBtnAtcn:(id)sender
{
    if (grpNameTxtFld.text.length>0 && locBtn.titleLabel.text.length>0 && interestBtn.titleLabel.text.length>0 && descTxtView.text.length>0)
    {
        HUD2=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        UIFont * myFont = [UIFont systemFontOfSize:13];
        HUD2.labelFont=myFont;
        HUD2.labelText=[NSString stringWithFormat:@"Saving group values..."];
        
        strEncodedProfPic = [self encodeToBase64String:setProfPicBtn.imageView.image];
        strEncodedCoverPic = [self encodeToBase64String:setCoverPicImgV.image];
        
        NSString *uid=[[NSUserDefaults standardUserDefaults]valueForKey:@"UID"];
        
        NSURL *url = [NSURL URLWithString:@"http://seekly.azurewebsites.net/api/Group/AddGroup"];
        
        // Create the request
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"POST"];
        
        [request setPostValue:grpNameTxtFld.text forKey:@"group_name"];
        [request setPostValue:cat_Id forKey:@"sub_category_id"];
        [request setPostValue:locBtn.titleLabel.text forKey:@"location"];
        [request setPostValue:descTxtView.text forKey:@"group_description"];
        [request setPostValue:strEncodedProfPic forKey:@"group_pic"];
        [request setPostValue:strEncodedCoverPic forKey:@"cover_image"];
        [request setPostValue:latit forKey:@"latitude"];
        [request setPostValue:longit forKey:@"longitude"];
        [request setPostValue:[NSString stringWithFormat:@"%d",statusVal] forKey:@"status"];
        [request setPostValue:uid forKey:@"user_id"];
        [request setDelegate:self];
        [request startSynchronous];
        
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
                [HUD2 hide:YES];
                NSString *myId = [[responseDict valueForKey:@"GroupInfo"] valueForKey:@"id"];
                inviteFriendsViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"inviteFriendsViewControllerID"];
                obj.group_Id=myId;
                CreategroupPressed = YES;
                [self.navigationController pushViewController:obj animated:YES];
            } else {
                [HUD2 hide:YES];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Exception" message:[NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"Exception"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }

    } else
    {
        [HUD hide:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please make sure all fields are filled" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}


-(IBAction)interestBtnActn:(id)sender
{
    createEventSelected = YES;
    InterestCategoryViewController *objintrst = [self.storyboard instantiateViewControllerWithIdentifier:@"InterestCategoryViewControllerID"];
    objintrst.delegate=self;
    objintrst.isComingFrom = @"group";
    [self.navigationController pushViewController:objintrst animated:YES];
}


- (void)enteredSubCatIDToGrp:(InterestCategoryViewController *)controller didFinishEnteringItem:(NSString *)categID : (NSString *)subCatIDArr :(NSString *)categoryName
{
    
    cat_name=categoryName;
    cat_Id=subCatIDArr;
    
    [interestBtn setTitle:cat_name forState:UIControlStateNormal];
    [self.navigationController popViewControllerAnimated:YES];
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
