//
//  ProfileDetailViewController.m
//  Seekly
//
//  Created by Deepinder singh on 14/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "ProfileDetailViewController.h"
#import "InterestCategoryViewController.h"
#import "SeeklyAPI.h"


@interface ProfileDetailViewController ()
{
    MBProgressHUD *HUD;
}


@property (strong, nonatomic) QSTodoService *todoService;


@end

@implementation ProfileDetailViewController
@synthesize items;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.todoService = [QSTodoService defaultService];

    profileBtn.layer.cornerRadius = profileBtn.frame.size.width / 2;
    profileBtn.clipsToBounds = YES;

    UIColor *color = [UIColor whiteColor];
    fNameTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First name " attributes:@{NSForegroundColorAttributeName: color}];
    sNameTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last name " attributes:@{NSForegroundColorAttributeName: color}];
    cityNameTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"City" attributes:@{NSForegroundColorAttributeName: color}];
    dobNameTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Date of Birth" attributes:@{NSForegroundColorAttributeName: color}];
    
    checkImage = [UIImage imageNamed:@"icon.png"];
    UncheckImage = [UIImage imageNamed:@"check_circle.png"];
    
    if (toolBar == nil) {
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        [toolBar setBarStyle:UIBarStyleBlackTranslucent];
        
        UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(switchToNextField:)];
        
        [toolBar setItems:[[NSArray alloc] initWithObjects: extraSpace, next, nil]];
    }
    
    dobNameTxtFld.inputAccessoryView = toolBar;
    
    
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDate * currentDate = [NSDate date];
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    [comps setYear: -13];
    NSDate * maxDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
    [comps setYear: -100];
    NSDate * minDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.minimumDate = minDate;
    datePicker.maximumDate = maxDate;
    datePicker.date = minDate;

    [datePicker setDate:[NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    [dobNameTxtFld setInputView:datePicker];

    // Do any additional setup after loading the view from its nib.
}

-(void) dateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)dobNameTxtFld.inputView;
    [picker setMaximumDate:[NSDate date]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    dobNameTxtFld.text = [NSString stringWithFormat:@"%@",dateString];
}

- (IBAction)switchToNextField:(id)sender
{
    [dobNameTxtFld resignFirstResponder];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (textField == dobNameTxtFld) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = containerView.frame;
            frame.origin.y = -105;
            containerView.frame = frame;
            
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = containerView.frame;
        frame.origin.y = 0;
        containerView.frame = frame;
    }];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        profileBtn.clipsToBounds = YES;
        profileBtn.contentMode = UIViewContentModeScaleAspectFill;
        NSString *imageName = [NSString stringWithFormat:@"ProfilePic.png"];
        
        [self removeImage:imageName];
        [self saveImage:image withName:imageName];
        image = [self getimageWithName:imageName];
        [profileBtn setImage:image forState:UIControlStateNormal];
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
}

- (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size
{
    // not equivalent to image.size (which depends on the imageOrientation)!
    double refWidth = CGImageGetWidth(image.CGImage);
    double refHeight = CGImageGetHeight(image.CGImage);
    
    double x = (refWidth - size.width) / 2.0;
    double y = (refHeight - size.height) / 2.0;
    
    CGRect cropRect = CGRectMake(x, y, size.height, size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    
    return cropped;
}

- (void)saveImage:(UIImage *)image withName:(NSString *)Name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:Name];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:savedImagePath atomically:YES];
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

- (void)removeImage:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
         NSLog(@"Successfully removed");
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

/*
 
 
 
 -(void)removeImage:(NSString *)fileName
 {
 fileManager = [NSFileManager defaultManager];
 paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 documentsPath = [paths objectAtIndex:0];
 filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]];
 [fileManager removeItemAtPath:filePath error:NULL];
 UIAlertView *removeSuccessFulAlert=[[UIAlertView alloc]initWithTitle:@"Congratulation:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
 [removeSuccessFulAlert show];
 }
 
 #pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)uploadPhotoBtnAction:(id)sender
{
    [self ShowCameraUI];
}

-(void) SignInSucces
{
    InterestCategoryViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"InterestCategoryViewControllerID"];
    obj.isComingFrom = @"signup";
    [self.navigationController pushViewController:obj animated:YES];
}

-(void) startSpinner
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


- (IBAction)moveToNext:(id)sender
{
    [self performSelector:@selector(callWebService)];
}

-(void)callWebService
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (fNameTxtFld.text.length != 0 || sNameTxtFld.text.length != 0 || cityNameTxtFld.text.length != 0 || dobNameTxtFld.text.length != 0)
    {
        NSString *strEncoded,*gender;
        self.items = [[NSUserDefaults standardUserDefaults] objectForKey:@"DicVal"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"DicVal"];
        if (profileBtn.imageView.image) {
            UIImage *newImg = profileBtn.imageView.image;
            strEncoded = [self encodeToBase64String:newImg];
        }
        else
        {
            strEncoded = @"null";
        }
        
        if ([[maleBtn backgroundImageForState:UIControlStateNormal] isEqual:checkImage])
        {
            gender = @"1";
        }else
        {
            gender = @"0";
        }
#if TARGET_IPHONE_SIMULATOR
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"30.7245916,76.6921956"] forKey:@"latLong"];
        //Apps+Maven/@ 30.7245916 , 76.6921956
        
#else
        
#endif
        NSString *latlongStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"latLong"];
        NSArray *array = [ latlongStr componentsSeparatedByString:@","];
        
        NSURL *url = [NSURL URLWithString:@"http://seekly.azurewebsites.net/api/SignUp/SignUp"];
        
        // Create the request
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"POST"];
        [request setPostValue:fNameTxtFld.text forKey:@"first_name"];
        [request setPostValue:sNameTxtFld.text forKey:@"last_name"];
        [request setPostValue:cityNameTxtFld.text forKey:@"city"];
        [request setPostValue:dobNameTxtFld.text forKey:@"date_of_birth"];
        [request setPostValue:[items valueForKey:@"emailid"] forKey:@"email"];
        [request setPostValue:[items valueForKey:@"password"] forKey:@"password"];
        [request setPostValue:gender forKey:@"gender"];
        [request setPostValue:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"device_token"]] forKey:@"device_token"];
        //        [request setPostValue:@"0" forKey:@"devicetype"];
        
        [request setPostValue:[NSString stringWithFormat:@"%@",array [0]] forKey:@"latitude"];
        [request setPostValue:[NSString stringWithFormat:@"%@",array [1]]  forKey:@"longitude"];
        
        
        //        [request setPostValue:@"10.6231364" forKey:@"latitude"];
        //        [request setPostValue:@"30.5515012" forKey:@"longitude"];
        [request setPostValue:strEncoded  forKey:@"profile_pic"];
        [request setPostValue:@"0" forKey:@"register_type"];
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
                
                NSString*imgStr =[responseDict  objectForKey:@"ImageUrl"];
                
                if (![imgStr isKindOfClass:[NSNull class]])
                {
                    [[NSUserDefaults standardUserDefaults]setValue:imgStr forKey:@"UImageUrl"];
                }
                
                [[NSUserDefaults standardUserDefaults]setValue:[responseDict  objectForKey:@"UserId"] forKey:@"UID"];
                
                NSString *fName = [NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"FirstName"]];
                NSString *lName = [NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"LastName"]];
                
                [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@ %@",fName,lName] forKey:@"UName"];
                
                [self SignInSucces];
                [HUD hide:YES];
            } else {
                [HUD hide:YES];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Exception" message:[NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"Exception"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
    else
    {
        [HUD hide:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please make sure that all fields entered" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImageJPEGRepresentation(image, 0.5f) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}


- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

- (IBAction)maleBtnAction:(id)sender {
    if ([[maleBtn backgroundImageForState:UIControlStateNormal] isEqual:checkImage])
    {
        [maleBtn setBackgroundImage:UncheckImage forState:UIControlStateNormal];
        [femaleBtn setBackgroundImage:checkImage forState:UIControlStateNormal];
    }
    else
    {
        [maleBtn setBackgroundImage:checkImage forState:UIControlStateNormal];
        [femaleBtn setBackgroundImage:UncheckImage forState:UIControlStateNormal];
    }
}

- (IBAction)femaleBtnAction:(id)sender {
    if ([[femaleBtn backgroundImageForState:UIControlStateNormal] isEqual:checkImage])
    {
        [femaleBtn setBackgroundImage:UncheckImage forState:UIControlStateNormal];
        [maleBtn setBackgroundImage:checkImage forState:UIControlStateNormal];
    }
    else
    {
        [femaleBtn setBackgroundImage:checkImage forState:UIControlStateNormal];
        [maleBtn setBackgroundImage:UncheckImage forState:UIControlStateNormal];
    }
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
