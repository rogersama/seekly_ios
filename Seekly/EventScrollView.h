//
//  IntroView.h
//  ABCIntroView
//
//  Created by Adam Cooper on 2/4/15.
//  Copyright (c) 2015 Adam Cooper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class EventsScroll;

@protocol EventScrollViewDelegate <NSObject>

-(void)onDoneButtonPressed;
-(void)onsignUpButtonPressed;
-(void)onViewScroll:(NSString*)indexString;

@end

@interface EventScrollView : UIView
@property id<EventScrollViewDelegate> delegate;


@end


// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net