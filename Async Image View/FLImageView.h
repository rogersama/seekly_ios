//
//  FLImageView.h
//  FashionLoyal
//
//  Created by Amos Elmaliah on 1/29/14.
//  Copyright (c) 2014 Amos Elmaliah. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FLImageViewNeverAnimate 1

@interface FLImageView : UIImageView

@property (nonatomic) BOOL noAnimation;
@property (strong, nonatomic) NSURL* URL;

- (void)prepareForReuse;

- (void)setImage:(UIImage *)image animated:(BOOL)animated;
- (void)setImageWithURL:(NSURL *)url animated:(BOOL)animated;
- (void)setImageWithURL:(NSURL *)url animated:(BOOL)animated completion:(void(^)(UIImage* image, NSError* error))completion;


@end
