//
//  NewMsgViewController.h
//  Seekly
//
//  Created by Deepinder singh on 28/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMsgViewController : UIViewController
{
    IBOutlet UIView *messageBackView;
    IBOutlet UITextField *msgTxtFld;
    IBOutlet UIButton *sendBtn;
}

-(IBAction)sendAction:(id)sender;

@end
