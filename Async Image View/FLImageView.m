//
//  FLImageView.m
//  FashionLoyal
//
//  Created by Amos Elmaliah on 1/29/14.
//  Copyright (c) 2014 Amos Elmaliah. All rights reserved.
//

#import "FLImageView.h"
#import "UIImageView+AFNetworking.h"

static NSString * const animationKey = @"imageFade";

@implementation FLImageView

static NSMutableDictionary* __URLs;
static dispatch_queue_t __queue;
+(void)load {
	__URLs = [[NSMutableDictionary alloc] init];
	__queue = dispatch_queue_create("FLImageView__URL", DISPATCH_QUEUE_CONCURRENT);
}

+(UIImage*)imageForURL:(NSURL *)URL {
	__block UIImage* image = nil;
	dispatch_sync(__queue, ^{
		image = [__URLs objectForKey:URL];
	});
	return image;
}

+(void)addImage:(UIImage*)image ForURL:(NSURL *)URL {
	dispatch_barrier_async(__queue, ^{
		if (![[__URLs allKeys] containsObject:URL]) {
			[__URLs setObject:image forKey:URL];
		};
	});
}


- (void)setImageWithURL:(NSURL *)url animated:(BOOL)animated {

	[self setImageWithURL:url animated:animated completion:NULL];

}


- (void)setImageWithURL:(NSURL *)url animated:(BOOL)animated completion:(void(^)(UIImage* image, NSError* error))completion {
	
	NSParameterAssert(url);
#ifdef USE_AFNETWORKING_UIIMAGEVIEW
	if([url isEqual:_URL]) return;
	
	if(animated) {
		[self setImage:nil];
	}
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
	PUSH_WEAK_SELF
	[self setImageWithURLRequest:request
							placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
								POP_STRONG_SELF(self)
								[self setImage:image animated:FLImageViewNeverAnimate ?  NO : animated];
								self->_URL = url;
								if(completion) {
									completion(image, nil);
								}
							} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
								POP_STRONG_SELF(self)
								if(completion) {
									completion(nil, error);
								}
							}];
#else
	
	UIImage* image = [self.class imageForURL:url];
	if(image) {
		[self setImage:image];
	}
   
    else {
//		[super setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//			if (error) {
//				NSLog(@"error loading image for url:%@", url);
//			} else {
//				if (!image) {
//					NSLog(@"missing image:");
//				} else {
//					//POP_STRONG_SELF(self)
//					[self setImage:image];
//					[self.class addImage:image ForURL:url];
//				}
//			}
//		}];
	}
#endif
}

- (void) setImage:(UIImage *)image animated:(BOOL)animated {
	
	if (animated) {
		[super setImage:nil];
		dispatch_async(dispatch_get_main_queue(), ^{
			[super setImage:image];
			[[self layer] addAnimation:[CATransition animation] forKey:kCATransition];
		});
	} else {
		[super setImage:image];
	}
}

-(void)prepareForReuse {
	[[self layer] removeAnimationForKey:kCATransition];
	[self setURL:nil];
	[self cancelImageRequestOperation];
}


@end
