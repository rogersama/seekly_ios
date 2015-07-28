//
//  PostViewController.h
//  Seekly
//
//  Created by Gursimran on 23/07/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextView.h"

@interface PostViewController : UIViewController
{
    IBOutlet SZTextView *textView;
    IBOutlet UIImageView *postImage;
    IBOutlet UIButton *imageButton;
}

-(IBAction)backButton:(id)sender;
-(IBAction)postButton:(id)sender;
-(IBAction)addImageButton:(id)sender;
@end
