//
//  WebServiceManager.h
//  Sharkfeed
//
//  Created by Fikirte  Derso on 2/6/18.
//  Copyright © 2018 Fikirte  Derso. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ViewControllerCallback)(NSDictionary * data, NSError * error);

@interface WebServiceManager : NSObject

-(void)downlaodPhotoFromUrl:(NSString *)urlString withCallback:(ViewControllerCallback)callback;


@end
