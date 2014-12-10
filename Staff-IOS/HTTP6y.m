//
//  HTTP6y.m
//  Staff-IOS
//
//  Created by Patrick Lo on 9/12/14.
//  Copyright (c) 2014 ___LoKiFunG___. All rights reserved.
//

#import "HTTP6y.h"

static NSDictionary* cookie;
static NSString* ServerUrl = @"http://it114112tm1415fyp1.redirectme.net:8000/";

@implementation HTTP6y

+ (NSDictionary*)request:(NSString*)postposition {
    return [self request:postposition parameters:[NSDictionary new] arrayParameters:[NSDictionary new]];
}

+ (NSDictionary*)request:(NSString*)postposition parameters:(NSDictionary*)parameters {
    return [self request:postposition parameters:parameters arrayParameters:[NSDictionary new]];
}

+ (NSDictionary*)request:(NSString*)postposition arrayParameters:(NSDictionary*)arrayParameters {
    return [self request:postposition parameters:[NSDictionary new] arrayParameters:arrayParameters];
}

+ (NSDictionary*)request:(NSString*)postposition parameters:(NSMutableDictionary*)parameters arrayParameters:(NSDictionary*)arrayParameters {
    NSError* error = nil;
    NSString* formatedParameters = @"";
    if(parameters != nil && parameters.count != 0) {
        for(NSString* x in parameters) {
            formatedParameters = [formatedParameters stringByAppendingString:x];
            NSLog(@"%@",x);
            formatedParameters = [formatedParameters stringByAppendingString:@"="];
            NSLog(@"%@",(NSString*) [parameters objectForKey:x]);
            formatedParameters = [formatedParameters stringByAppendingString:(NSString*) [parameters objectForKey:x]];
            NSLog(@"3");
            formatedParameters = [formatedParameters stringByAppendingString:@"&"];
            NSLog(@"4");
        }
        formatedParameters = [formatedParameters substringToIndex:[formatedParameters length] - 1];
    }
    NSURL* url = [NSURL URLWithString:[ServerUrl stringByAppendingString:postposition]];
    NSLog(@"URL: %@", url);
    NSLog(@"Parameters: %@", formatedParameters);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:6];
    [request setHTTPMethod:@"POST"];
    NSURLResponse* response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if([data length] > 0 && error == nil) {
        NSMutableDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if(error == nil) {
            return jsonObject;
        }
    }
    NSLog(@"URL: %@", url);
    NSLog(@"Parameters: %@", formatedParameters);
    NSLog(@"Error:\n%@", error);
    return nil;
}

@end
