//
//  IntroView.m
//  DrawPad
//
//  Created by Adam Cooper on 2/4/15.
//  Copyright (c) 2015 Adam Cooper. All rights reserved.
//

#import "ABCIntroView.h"

@interface ABCIntroView () <UIScrollViewDelegate>
@property (strong, nonatomic)  UIScrollView *scrollView;
@property (strong, nonatomic)  UIPageControl *pageControl;
@property UIView *holeView;
@property UIView *circleView;
@property UIImageView *logoImgView;
@property UIButton *doneButton;

@property UIButton *loginButton;

@end

@implementation ABCIntroView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
        backgroundImageView.image = [UIImage imageNamed:@"Intro_Screen_Background"];
        [self addSubview:backgroundImageView];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        self.scrollView.pagingEnabled = YES;
        [self addSubview:self.scrollView];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height*.79, self.frame.size.width, 10)];
        self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:143 green:186 blue:96 alpha:1.000];
        [self addSubview:self.pageControl];
    
        [self createViewOne];
        [self createViewTwo];
        [self createViewThree];
        
        //logo Button
        self.logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(30, self.frame.size.height*.08, self.frame.size.width*.81, self.frame.size.height*.15)];
        self.logoImgView.image = [UIImage imageNamed:@"logo_full"];
        [self addSubview:self.logoImgView];
        
        //Done Button
        self.doneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width*.07, self.frame.size.height*.82, self.frame.size.width*.867, self.frame.size.height * .081)];
        [self.doneButton setTitle:@"Get started" forState:UIControlStateNormal];
        [self.doneButton.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:18.0]];
        [self.doneButton setBackgroundImage:[UIImage imageNamed:@"signin1"] forState:UIControlStateNormal];
        [self.doneButton addTarget:self action:@selector(onMoveGetStartButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.doneButton];
        
        //login Button
        self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height*.91, self.frame.size.width, 30)];
        self.loginButton.titleLabel.textColor = [UIColor whiteColor];
        [self.loginButton.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14.0]];

        NSMutableAttributedString *attString =
        [[NSMutableAttributedString alloc]
         initWithString: @"Already have an account? Sign in."];
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"LATO-LIGHT" size:14]
                          range: NSMakeRange(0,24)];
        
        [self.loginButton setAttributedTitle:attString forState:UIControlStateNormal];
        [self.loginButton addTarget:self action:@selector(onFinishedIntroButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.loginButton];
        

        self.pageControl.numberOfPages = 3;
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width*3, self.scrollView.frame.size.height);
        
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(self.bounds);
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
       CGFloat pageFraction = self.scrollView.contentOffset.x / pageWidth;
    self.pageControl.currentPage = roundf(pageFraction);

    } completion:^(BOOL finished) {
    }];
}


-(void)createViewOne{
    
    UIView *view = [[UIView alloc] initWithFrame:self.frame];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0 ,0, self.frame.size.width, self.frame.size.height)];
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    imageview.image = [UIImage imageNamed:@"Intro_Screen_One"];
    [view addSubview:imageview];
    
//    CGPoint labelCenter = CGPointMake(self.center.x, self.frame.size.height*.7);
//    descriptionLabel.center = labelCenter;
    
    self.scrollView.delegate = self;
    [self.scrollView addSubview:view];
    
}


-(void)createViewTwo{
    
    CGFloat originWidth = self.frame.size.width;
    CGFloat originHeight = self.frame.size.height;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(originWidth, 0, originWidth, originHeight)];
    
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0 ,0, self.frame.size.width, self.frame.size.height)];
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    imageview.image = [UIImage imageNamed:@"Intro_Screen_Two"];
    [view addSubview:imageview];
    
    
    
    self.scrollView.delegate = self;
    [self.scrollView addSubview:view];
    
}

-(void)createViewThree{
    
    CGFloat originWidth = self.frame.size.width;
    CGFloat originHeight = self.frame.size.height;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(originWidth*2, 0, originWidth, originHeight)];
    
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0 ,0, self.frame.size.width, self.frame.size.height)];
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    imageview.image = [UIImage imageNamed:@"Intro_Screen_Three"];
    [view addSubview:imageview];
    
    
    self.scrollView.delegate = self;
    [self.scrollView addSubview:view];
    
}



@end// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net