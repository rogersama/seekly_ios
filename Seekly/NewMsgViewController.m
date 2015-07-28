//
//  NewMsgViewController.m
//  Seekly
//
//  Created by Deepinder singh on 28/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "NewMsgViewController.h"

@interface NewMsgViewController ()

@end

@implementation NewMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];

//    self.view.backgroundColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:1];
    // Do any additional setup after loading the view.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    NSLog(@"keyboardFrame: %@", NSStringFromCGRect(keyboardFrame));
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];  
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (textField == msgTxtFld) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = messageBackView.frame;
            frame.origin.y = 308;
            messageBackView.frame = frame;
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = messageBackView.frame;
        frame.origin.y = 524;
        messageBackView.frame = frame;
    }];
    return YES;
}

-(IBAction)sendAction:(id)sender
{
     [msgTxtFld resignFirstResponder];
    msgTxtFld.text = @"";
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = messageBackView.frame;
        frame.origin.y = 524;
        messageBackView.frame = frame;
    }];
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
