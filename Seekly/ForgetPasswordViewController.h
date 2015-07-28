//
//  ForgetPasswordViewController.h
//  Seekly
//
//  Created by Deepinder singh on 14/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordViewController : UIViewController<UITextFieldDelegate,UINavigationBarDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIView *mainView;
    IBOutlet UITextField *emailNameTxtFld;
}
- (IBAction)backAction:(id)sender;
- (IBAction)signInBtnAction:(id)sender;


@end
