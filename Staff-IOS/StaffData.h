//
//  SatffData.h
//  Staff-IOS
//
//  Created by Patrick Lo on 10/12/14.
//  Copyright (c) 2014 it114112tm1415fyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaffData : NSObject

+ (int) getStaffId;
+ (void) setStaffId:(int)staffDataId;
+ (NSString*) getStaffName;
+ (void) setStaffName:(NSString*)staffDataName;
+ (NSString*) getRegisterDate;
+ (void) setRegisterDate:(NSString*)staffDataRegisterDate;
+ (NSString*) getLastModifyTime;
+ (void) setLastModifyTime:(NSString*)staffDataLastModifyTime;
+ (NSString*) getUsername;
+ (void) setUsername:(NSString*)staffDataUsername;
+ (NSString*) getPassword;
+ (void) setPassword:(NSString*)staffDataPassword;

@end
