//
//  HTTP6y.h
//  Staff-IOS
//
//  Created by Patrick Lo on 9/12/14.
//  Copyright (c) 2014 it114112tm1415fyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTP6y : NSObject

+ (NSDictionary*)request:(NSString*)postposition;
+ (NSDictionary*)request:(NSString*)postposition parameters:(NSMutableDictionary*)parameters;
+ (NSDictionary*)request:(NSString*)postposition parameters:(NSMutableDictionary*)parameters customParameters:(NSString*)customParameters;
+ (NSDictionary*)staffLoginWithUsername:(NSString*)username password:(NSString*)password;
+ (NSDictionary*)conveyorGetList;
+ (NSDictionary *)sendMessageWithConvoyerName:(NSString *)convoyer_name message:(NSString *)message;
+ (NSDictionary *)getControlWithBelt:(NSString *)convoyer_name;

@end
