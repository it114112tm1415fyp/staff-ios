//
//  HTTP6y.m
//  Staff-IOS
//
//  Created by tlsv6y on 9/12/14.
//  Copyright (c) 2014 it114112tm1415fyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"
#import "StaffData.h"
#import "HTTP6y.h"

static NSDictionary* cookie;
static NSString* ServerUrl = @"http://it114112tm1415fyp1.redirectme.net:8000/";

@implementation HTTP6y

+ (NSMutableDictionary*)request:(NSString*)postposition {
    return [self request:postposition parameters:[NSMutableDictionary new] customParameters:@""];
}

+ (NSMutableDictionary*)request:(NSString*)postposition parameters:(NSMutableDictionary*)parameters {
    return [self request:postposition parameters:parameters customParameters:@""];
}

+ (NSMutableDictionary*)request:(NSString*)postposition parameters:(NSMutableDictionary*)parameters customParameters:(NSString*)customParameters {
    NSError* error = nil;
    NSString* formatedParameters = @"";
    if(parameters != nil && parameters.count != 0) {
        for(NSString* x in parameters) {
            formatedParameters = [formatedParameters stringByAppendingString:x];
            formatedParameters = [formatedParameters stringByAppendingString:@"="];
            formatedParameters = [formatedParameters stringByAppendingString:(NSString*) [parameters objectForKey:x]];
            formatedParameters = [formatedParameters stringByAppendingString:@"&"];
        }
        formatedParameters = [customParameters  isEqual: @""] ? [formatedParameters substringToIndex:[formatedParameters length] - 1] : [formatedParameters stringByAppendingString:customParameters] ;
    } else {
        formatedParameters = customParameters;
    }
    NSData* data = [formatedParameters dataUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:[ServerUrl stringByAppendingString:postposition]];
    NSLog(@"URL: %@", url);
    NSLog(@"Parameters: %@", formatedParameters);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:6];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    NSURLResponse* response = nil;
    NSData* body = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if([body length] > 0 && error == nil) {
        NSMutableDictionary* jsonObject = [[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingAllowFragments error:&error]];
        if(error == nil) {
            if (![self checkResult:jsonObject]) {
                return [self request:postposition parameters:parameters customParameters:customParameters];
            }
            return jsonObject;
        }
    }
    NSLog(@"URL: %@", url);
    NSLog(@"Parameters: %@", formatedParameters);
    NSLog(@"Error:\n%@", error);
    return nil;
}

+ (BOOL)checkResult:(NSMutableDictionary*)result {
    if([[result objectForKey:@"success"] isEqual: @(NO)]) {
        [result setObject:@(NO) forKey:@"error_handled"];
        NSString* error = [result objectForKey:@"error"];
        if ([error isEqual:@"Connection expired"]) {
            [result setObject:@(YES) forKey:@"error_handled"];
            [self staffLoginWithUsername:[StaffData getUsername] password:[StaffData getPassword]];
            return false;
        } else if ([error isEqual:@"Need login"] || [error isEqual:@"Unknown"]) {
            [result setObject:@(YES) forKey:@"error_handled"];
            NSLog(@"Error: %@",error);
        }
    }
    return true;
}

+ (NSString*)md5:(NSString*)s {
    const char *cStr = [s UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

+ (NSMutableDictionary*)staffLoginWithUsername:(NSString*)username password:(NSString*)password {
    NSMutableDictionary* parameters = [NSMutableDictionary new];
    [parameters setObject:username forKey:@"username"];
    [parameters setObject:[self md5:[self md5:password]] forKey:@"password"];
    return [self request:@"account/staff_login" parameters:parameters];
}

+ (NSMutableDictionary*)conveyorGetList {
    return [self request:@"conveyor/get_list"];
}


+ (NSMutableDictionary*)conveyorGetControlWithConveyorId:(NSNumber*)conveyor_id {
    NSMutableDictionary* parameters = [NSMutableDictionary new];
    [parameters setObject:[conveyor_id stringValue] forKey:@"conveyor_id"];
    return [self request:@"conveyor/get_control" parameters:parameters];
}

+ (NSMutableDictionary*)conveyorSendMessageWithConveyorId:(NSNumber*)conveyor_id message:(NSString*)message {
    NSMutableDictionary* parameters = [NSMutableDictionary new];
    [parameters setObject:[conveyor_id stringValue] forKey:@"conveyor_id"];
    [parameters setObject:message forKey:@"message"];
    return [self request:@"conveyor/send_message" parameters:parameters];

}

+ (NSMutableDictionary*)goodInspect:(NSNumber*)good_id store_id:(NSNumber*)store_id {
    NSMutableDictionary* parameters = [NSMutableDictionary new];
    [parameters setObject:[good_id stringValue] forKey:@"good_id"];
    [parameters setObject:[store_id stringValue] forKey:@"store_id"];
    return [self request:@"good/inspect" parameters:parameters];
}

+ (NSMutableDictionary*)goodWarehouse:(NSNumber*)good_id location_id:(NSNumber*)location_id location_type:(NSString*)location_type{
    NSMutableDictionary* parameters = [NSMutableDictionary new];
    [parameters setObject:good_id forKey:@"good_id"];
    [parameters setObject:location_id forKey:@"location_id"];
    [parameters setObject:location_type forKey:@"location_type"];
    return [self request:@"good/warehouse" parameters:parameters];
}

+ (NSMutableDictionary*)goodLeave:(NSNumber*)good_id location_id:(NSNumber*)location_id location_type:(NSString*)location_type{
    NSMutableDictionary* parameters = [NSMutableDictionary new];
    [parameters setObject:good_id forKey:@"good_id"];
    [parameters setObject:location_id forKey:@"location_id"];
    [parameters setObject:location_type forKey:@"location_type"];
    return [self request:@"good/leave" parameters:parameters];
}

+ (NSMutableDictionary*)goodLoad:(NSNumber*)good_id car_id:(NSNumber*)car_id {
    NSMutableDictionary* parameters = [NSMutableDictionary new];
    [parameters setObject:good_id forKey:@"good_id"];
    [parameters setObject:car_id forKey:@"car_id"];
    return [self request:@"good/load" parameters:parameters];
}

+ (NSMutableDictionary*)goodUnload:(NSNumber*)good_id password:(NSNumber*)car_id {
    NSMutableDictionary* parameters = [NSMutableDictionary new];
    [parameters setObject:good_id forKey:@"good_id"];
    [parameters setObject:car_id forKey:@"car_id"];
    return [self request:@"good/unload" parameters:parameters];
}

@end
