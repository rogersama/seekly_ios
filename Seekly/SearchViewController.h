//
//  SearchViewController.h
//  Seekly
//
//  Created by Deepinder singh on 28/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeeklyAPI.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"


@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    CGRect screenSize;
    UIImage *eventImg,*logoImg;

    IBOutlet UITextField *searchTxtFld;
    IBOutlet UILabel *displayMsgTxt;
    IBOutlet UITableView *searchTblV;
    IBOutlet UIButton *searchBtn;
    NSDictionary *dict;

}
-(IBAction)searchBtnAct:(id)sender;
@property(nonatomic,retain) NSString *msgText;
@property(nonatomic,assign) int isComingFrm;

@property (nonatomic, assign) bool isFiltered;
@property (strong, nonatomic) NSMutableArray* allTableData;
@property (strong, nonatomic) NSMutableArray* filteredTableData;



@end
