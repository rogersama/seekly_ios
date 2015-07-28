//
//  IntroView.m
//  DrawPad
//
//  Created by Adam Cooper on 2/4/15.
//  Copyright (c) 2015 Adam Cooper. All rights reserved.
//

#import "EventScrollView.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

@interface EventScrollView () <UIScrollViewDelegate,EventScrollViewDelegate>
{
    
    NSMutableArray *eventsArray;
    int arrayIndex;
    CGFloat originWidth;
    CGFloat originHeight;
    CGFloat pageFraction;

}

@property (strong, nonatomic)  UIScrollView *scrollView;
@property (strong, nonatomic)  UIPageControl *pageControl;


@property UILabel *eventName;
@property UILabel *eventLocation;
@property UILabel *eventTime;
@property UILabel *members;
@property UIImageView *imageLocation;
@property UIImageView *imageTime;
@property UIImageView *imageMembers;
@property UIImageView *imageEvent;
@property UIImageView *imageLogo;
@property UIView *blackBanner;
@property UIImageView *arrowLeft;
@property UIImageView *arrowRight;;



@end

@implementation EventScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        eventsArray = [[NSMutableArray alloc ]init];
        originWidth = self.frame.size.width;
        originHeight = self.frame.size.height;

        AppDelegate *appDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
        eventsArray = appDel.eventsAvailable;

        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
        backgroundImageView.image = [UIImage imageNamed:@"pic_01"];
        [self addSubview:backgroundImageView];
        
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.scrollView.pagingEnabled = YES;
       // self.scrollView.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.scrollView];

        
        for (int i=0; i<eventsArray.count; i++)
        {
            [self createViewOne:i];

        }
        
        
        self.pageControl.numberOfPages = eventsArray.count;
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width*eventsArray.count, self.scrollView.frame.size.height);
        
        //This is the starting point of the ScrollView
        CGPoint scrollPoint = CGPointMake(0, 0);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
    return self;
}

- (void)onFinishedIntroButtonPressed:(id)sender
{
    [self.delegate onDoneButtonPressed];
}

- (void)onMoveGetStartButtonPressed:(id)sender
{
    [self.delegate onsignUpButtonPressed];
}

- (void)onViewScroll
{
    [self.delegate onViewScroll:[NSString stringWithFormat:@"%d",arrayIndex]];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(self.bounds);
    pageFraction = self.scrollView.contentOffset.x / pageWidth;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
    CGFloat  pageFraction1 = self.scrollView.contentOffset.x / pageWidth;
    self.pageControl.currentPage = roundf(pageFraction1);

    } completion:^(BOOL finished) {
        int i = pageFraction;
        if (arrayIndex != i)
        {
            arrayIndex = pageFraction;
            [self onViewScroll];

        }
    }];
}


-(void)createViewOne :(int)index
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((originWidth*index), 0, originWidth, originHeight)];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0 ,0, originWidth, originHeight)];
    //    imageview.contentMode = UIViewContentModeScaleAspectFill;
    
    NSLog(@"%@",[[eventsArray valueForKey:@"category_image"] objectAtIndex:index]);
    
    NSString *path = [NSString stringWithFormat:@"%@",[[eventsArray valueForKey:[NSString stringWithFormat:@"sub_category_image%i",index+1]] objectAtIndex:index]];
    
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:path];

    
    __block UIActivityIndicatorView *activityIndicator;
    __weak UIImageView *weakImageView = imageview;
    [imageview sd_setImageWithURL:url
               placeholderImage:nil
                        options:SDWebImageProgressiveDownload
                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                           if (!activityIndicator) {
                               [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
                               activityIndicator.center = weakImageView.center;
                               [activityIndicator startAnimating];
                           }
                       }
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                          [activityIndicator removeFromSuperview];
                          activityIndicator = nil;
                          if (!image)
                          {
                              imageview.image = [UIImage imageNamed:@"eventBack"];
                          }
                      }];

    
    [view addSubview:imageview];
    
    
    //blackBanner
    self.blackBanner = [[UIImageView alloc] initWithFrame:CGRectMake(0, originHeight - 95, originWidth , 95 )];
    [self.blackBanner setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] ];
    [view addSubview:self.blackBanner];
    
    //            self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height*.90, self.frame.size.width, 10)];
    //            self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:143 green:186 blue:96 alpha:1.000];
    //            [self addSubview:self.pageControl];
    
    //LeftArrow
    self.arrowLeft = [[UIImageView alloc] initWithFrame:CGRectMake(10, 80, 30, 10)];
    self.arrowLeft.image = [UIImage imageNamed:@"location"];
    [view addSubview:self.arrowLeft];
    //RightArrow
    self.arrowRight = [[UIImageView alloc] initWithFrame:CGRectMake(originWidth-40, 80, 30, 10)];
    self.arrowRight.image = [UIImage imageNamed:@"location"];
    [view addSubview:self.arrowRight];
    
    //eventName
    self.eventName = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 150, 16)];
    self.eventName.text = [NSString stringWithFormat:@"%@",[[eventsArray valueForKey:@"event_name"] objectAtIndex:index]];
    self.eventName.textColor = [UIColor whiteColor];
    [self.eventName setFont:[UIFont fontWithName:@"Lato-Bold" size:14.0]];
    [self.blackBanner addSubview:self.eventName];
    
    
    
    //eventLocation
    self.eventLocation = [[UILabel alloc] initWithFrame:CGRectMake(30, 25, 150, 15)];
    self.eventLocation.text = [NSString stringWithFormat:@"%@",[[eventsArray valueForKey:@"event_location"] objectAtIndex:index]];
    self.eventLocation.textColor = [UIColor whiteColor];
    [self.eventLocation setFont:[UIFont fontWithName:@"Lato-Regular" size:12.0]];
    [self.blackBanner addSubview:self.eventLocation];
    //imageLocation
    self.imageLocation = [[UIImageView alloc] initWithFrame:CGRectMake(10, 27, 15, 15)];
    self.imageLocation.image = [UIImage imageNamed:@"location"];
    [self.blackBanner addSubview:self.imageLocation];
    
    
    //eventTime
    self.eventTime = [[UILabel alloc] initWithFrame:CGRectMake(30, 45, 150, 15)];
    self.eventTime.text = [NSString stringWithFormat:@"%@",[[eventsArray valueForKey:@"event_time"] objectAtIndex:index]];
    self.eventTime.textColor = [UIColor whiteColor];
    [self.eventTime setFont:[UIFont fontWithName:@"Lato-Regular" size:12.0]];
    [self.blackBanner addSubview:self.eventTime];
    //imageTime
    self.imageTime = [[UIImageView alloc] initWithFrame:CGRectMake(10, 46, 15, 15)];
    self.imageTime.image = [UIImage imageNamed:@"time"];
    [self.blackBanner addSubview:self.imageTime];
    
    
    //eventMembers
    self.members = [[UILabel alloc] initWithFrame:CGRectMake(30, 65, 150, 15)];
    self.members.text = [NSString stringWithFormat:@"%@ out of %@",[[eventsArray valueForKey:@"total_user_Joined"] objectAtIndex:index],[[eventsArray valueForKey:@"total_user_Invited"] objectAtIndex:index]];
    self.members.textColor = [UIColor whiteColor];
    [self.members setFont:[UIFont fontWithName:@"Lato-Regular" size:12.0]];
    [self.blackBanner addSubview:self.members];
    //imagePlayer
    self.imageMembers = [[UIImageView alloc] initWithFrame:CGRectMake(10, 66, 15, 15)];
    self.imageMembers.image = [UIImage imageNamed:@"player"];
    [self.blackBanner addSubview:self.imageMembers];
    
    
    //imageLogo
    self.imageLogo = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 120, 25, 105, 45)];
    self.imageLogo.image = [UIImage imageNamed:@"logo_01"];
    [self.blackBanner addSubview:self.imageLogo];
    
    
    
    self.scrollView.delegate = self;
    [self.scrollView addSubview:view];
    
}



@end