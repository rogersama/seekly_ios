//
//  PostViewController.m
//  Seekly
//
//  Created by Gursimran on 23/07/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "PostViewController.h"

@interface PostViewController ()

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void) viewDidDisappear:(BOOL)animated
{
    //  [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_FEEDS" object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{

    NSDictionary* dic = [notification userInfo];
    CGRect keyboardEndFrame = [dic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardEndFrame = [self.view convertRect:keyboardEndFrame fromView:nil];
    
    
    [imageButton setFrame:CGRectMake(0, keyboardEndFrame.origin.y-108,self.view.frame.size.width, imageButton.frame.size.height)];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    [imageButton setFrame:CGRectMake(0, self.view.frame.size.height-108, self.view.frame.size.width,imageButton.frame.size.height)];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


#pragma Mark Image Picker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    //Or you can get the image url from AssetsLibrary
    //    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
            
            postImage.image = image;
        }];
    
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImageJPEGRepresentation(image, 0.5f) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}



#pragma  mark Action Methods

-(IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)postButton:(id)sender
{
    NSString* strEncodedPostPic = [self encodeToBase64String:postImage.image];
    
    if ([textView.text isEqualToString:@""] && (strEncodedPostPic.length < 10) )
    {
        NSLog(@"enter some text");
    }
    else
    {
        NSLog(@"%@",strEncodedPostPic);
        NSLog(@"%@",textView.text);
        // postImage.image = nil;

    }

}
-(IBAction)addImageButton:(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];

}

@end
