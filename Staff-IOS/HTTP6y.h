//
//  HTTP6y.h
//  Staff-IOS
//
//  Created by Patrick Lo on 9/12/14.
//  Copyright (c) 2014 ___LoKiFunG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTP6y : NSObject

+ (NSDictionary*)request:(NSString*)postposition;
+ (NSDictionary*)request:(NSString*)postposition parameters:(NSDictionary*)parameters;
+ (NSDictionary*)request:(NSString*)postposition arrayParameters:(NSDictionary*)arrayParameters;
+ (NSDictionary*)request:(NSString*)postposition parameters:(NSDictionary*)parameters arrayParameters:(NSDictionary*)arrayParameters;

@end
