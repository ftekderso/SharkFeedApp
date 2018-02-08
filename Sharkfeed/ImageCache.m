//
//  ImageCache.m
//  Sharkfeed
//
//  Created by Fikirte  Derso on 2/8/18.
//  Copyright © 2018 Fikirte  Derso. All rights reserved.
//

#import "ImageCache.h"

static ImageCache * sharedInstance;

@interface ImageCache ()

@property (nonatomic, strong) NSCache * imageCache;

@end

@implementation ImageCache


+ (ImageCache*)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ImageCache alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageCache = [[NSCache alloc] init];
    }
    return self;
}

- (void)cacheImage:(UIImage*)image forKey:(NSURL*)key {
    [self.imageCache setObject:image forKey:key];
}

- (UIImage*)getCachedImageForKey:(NSURL*)key {
    return [self.imageCache objectForKey:key];
}

@end
