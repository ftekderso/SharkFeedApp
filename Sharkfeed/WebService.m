//
//  WebService.m
//  Sharkfeed
//
//  Created by Fikirte  Derso on 2/6/18.
//  Copyright © 2018 Fikirte  Derso. All rights reserved.
//

#import "WebService.h"

const int SUCCESS = 200;

@implementation WebService

-(void)makeGetRequestWithURL:(NSString*)urlString withCallback:(WebServiceManagerCallback)callback;{
    
    NSURLSessionConfiguration * defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * defaultSession = [NSURLSession sessionWithConfiguration:defaultConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            NSHTTPURLResponse * httpURLResponse = (NSHTTPURLResponse*)response;
            NSInteger responseStatus = [httpURLResponse statusCode];
            
            if (responseStatus == SUCCESS) {
                
               NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                
                callback(jsonDict, nil);
                
            }
            else{
                
                callback(nil,error);
            }
        }
        else {
            callback(nil, error);
            NSLog(@"Connection Error: %@", error.description);
        }

    }];
    
    [dataTask resume];
    
}


@end
