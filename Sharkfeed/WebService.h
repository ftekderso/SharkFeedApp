//
//  WebService.h
//  Sharkfeed
//
//  Created by Fikirte  Derso on 2/6/18.
//  Copyright © 2018 Fikirte  Derso. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WebServiceManagerCallback)(id responseData, NSError * error);

@interface WebService : NSObject

-(void)makeGetRequestWithURL:(NSString*)urlString withCallback:(WebServiceManagerCallback)callback;


@end
