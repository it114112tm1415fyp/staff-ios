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

+ (NSDictionary*)goodInspect:(NSNumber*)good_id store_id:(NSNumber*)store_id ;
+ (NSDictionary*)goodWarehouse:(NSNumber*)good_id location_id:(NSNumber*)location_id location_type:(NSString*)location_type;
+ (NSDictionary*)goodLeave:(NSNumber*)good_id location_id:(NSNumber*)location_id location_type:(NSString*)location_type;
+ (NSDictionary*)goodLoad:(NSNumber*)good_id car_id:(NSNumber*)car_id;
+ (NSDictionary*)goodUnload:(NSNumber*)good_id password:(NSNumber*)car_id;
@end
