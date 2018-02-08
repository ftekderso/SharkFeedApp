//
//  SharkPhoto.h
//  Sharkfeed
//
//  Created by Fikirte  Derso on 2/6/18.
//  Copyright © 2018 Fikirte  Derso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharkPhoto : NSObject


/** The title for the photo if ther is one. */
@property (nonatomic, strong) NSString * title;

/** Photo Id */
@property (nonatomic, strong) NSString * photoId;

/** Photo Location thumbnail, 100 on longest side */
@property (nonatomic, strong) NSString * url_t;

/** Photo Location Image, large */
@property (nonatomic, strong) NSString * url_l;

-(void)setTitle:(NSString *)title;
-(void)setPhotoId:(NSString *)photoId;
-(void)setUrl_t:(NSString *)url_t;


@end
