//
//  ImageCache.h
//  Sharkfeed
//
//  Created by Fikirte  Derso on 2/8/18.
//  Copyright © 2018 Fikirte  Derso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageCache : NSObject

+(ImageCache*)sharedInstance;

- (void)cacheImage:(UIImage*)image forKey:(NSString*)key;
- (UIImage*)getCachedImageForKey:(NSString*)key;

@end
