//
//  chatViewController.h
//  Seekly
//
//  Created by Deepinder singh on 29/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chatViewController : UIViewController

{
    IBOutlet UIView *messageBackView;
    IBOutlet UITextField *msgTxtFld;
    IBOutlet UIButton *sendBtn;
    NSMutableArray *msgArray;
    CGRect screenSize;
    IBOutlet UITableView *TableView;
    IBOutlet UILabel *chatLbl;

}


@property(nonatomic) BOOL isFromGroup;
@property(nonatomic ,strong) NSString *groupName;
@property(nonatomic ,strong) NSString *groupID;

-(IBAction)sendAction:(id)sender;


@end
