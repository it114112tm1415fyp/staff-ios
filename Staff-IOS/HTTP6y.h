//
//  HTTP6y.h
//  Staff-IOS
//
//  Created by Patrick Lo on 9/12/14.
//  Copyright (c) 2014 it114112tm1415fyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTP6y : NSObject

+ (NSMutableDictionary*)request:(NSString*)postposition;
+ (NSMutableDictionary*)request:(NSString*)postposition parameters:(NSMutableDictionary*)parameters;
+ (NSMutableDictionary*)request:(NSString*)postposition parameters:(NSMutableDictionary*)parameters customParameters:(NSString*)customParameters;

+ (NSMutableDictionary*)staffLoginWithUsername:(NSString*)username password:(NSString*)password;

+ (NSMutableDictionary*)conveyorGetList;
+ (NSMutableDictionary*)conveyorGetControlWithConveyorId:(NSNumber *)conveyor_id;
+ (NSMutableDictionary*)conveyorSendMessageWithConveyorId:(NSNumber *)conveyor_id message:(NSString *)message;

+ (NSMutableDictionary*)locationGetList;

+ (NSMutableDictionary*)goodAction:(NSString*)actionName good_id:(NSNumber*)good_id location_id:(NSNumber*)location_id locationType:(NSString*)locationType;
+ (NSMutableDictionary*)goodInspect:(NSNumber*)good_id store_id:(NSNumber*)store_id;
+ (NSMutableDictionary*)goodWarehouseLeave:(NSString*)actionType good_id:(NSNumber*)good_id location_id:(NSNumber*)location_id location_type:(NSString*)location_type;
+ (NSMutableDictionary*)goodLoadUnload:(NSString*)actionType good_id:(NSNumber*)good_id car_id:(NSNumber*)car_id;
@end
