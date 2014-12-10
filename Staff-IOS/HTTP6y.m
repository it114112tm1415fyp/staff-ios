//
//  HTTP6y.m
//  Staff-IOS
//
//  Created by Patrick Lo on 9/12/14.
//  Copyright (c) 2014 ___LoKiFunG___. All rights reserved.
//

#import "HTTP6y.h"

/*Cache-Control → max-age=0, private, must-revalidate
 Connection → Keep-Alive
 Content-Length → 274
 Content-Type → application/json; charset=utf-8
 Date → Tue, 09 Dec 2014 08:11:38 GMT
 Etag → "94379f78a6f23890017ff27255839665"
 Server → WEBrick/1.3.1 (Ruby/2.1.3/2014-09-19)
 X-Content-Type-Options → nosniff
 X-Frame-Options → SAMEORIGIN
 X-Request-Id → cd1e85e9-b40a-4e60-8290-2a8e68d19f82
 X-Runtime → 0.208000
 X-Xss-Protection → 1; mode=block*/

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

+ (NSDictionary*)request:(NSString*)postposition parameters:(NSDictionary*)parameters arrayParameters:(NSDictionary*)arrayParameters {
    NSError* error = nil;
    NSString* formatedParameters = @"";
    if(parameters != nil && parameters.count != 0) {
        for(NSString* x in parameters) {
            formatedParameters = [formatedParameters stringByAppendingString:x];
            formatedParameters = [formatedParameters stringByAppendingString:@"="];
            formatedParameters = [formatedParameters stringByAppendingString:(NSString*) [parameters objectForKey:x]];
            formatedParameters = [formatedParameters stringByAppendingString:@"&"];
        }
        formatedParameters = [formatedParameters substringToIndex:[formatedParameters length] - 1];
    }
    NSData* data = [formatedParameters dataUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:[ServerUrl stringByAppendingString:postposition]];
    NSLog(@"URL: %@", url);
    NSLog(@"Parameters: %@", formatedParameters);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:6];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[formatedParameters length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:data];
    NSURLResponse* response = nil;
    NSData* body = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if([body length] > 0 && error == nil) {
        NSMutableDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingAllowFragments error:&error];
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
