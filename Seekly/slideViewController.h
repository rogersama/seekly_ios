

#import <UIKit/UIKit.h>
//#import "AsyncImageView.h"
//#import "NVSlideMenuController.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"


BOOL homeSelected,UpcomingSelected,AwaitingSelected,pastSelected,groupSelected,createEventSelected;

NSInteger indexVal;
@interface slideViewController : UIViewController
{

    IBOutlet UITableView *sideMenuTbl;
    UIView *dropDownView;
    BOOL showDropDown;
    CGRect screenSize;
    IBOutlet UIButton *UserName;
    IBOutlet UIImageView *profielPic;
}
- (IBAction)homeBtnAction:(id)sender;


@end
