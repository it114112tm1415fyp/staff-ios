//
//  SatffData.m
//  Staff-IOS
//
//  Created by Patrick Lo on 10/12/14.
//  Copyright (c) 2014 it114112tm1415fyp. All rights reserved.
//

#import "StaffData.h"

static int staffId;
static NSString* staffName;
static NSString* registerDate;
static NSString* lastModifyTime;
static NSString* staffUsername;
static NSString* staffPassword;

@implementation StaffData

+ (int) getStaffId { return staffId; }
+ (void) setStaffId:(int)staffDataId { staffId = staffDataId; }
+ (NSString*) getStaffName {return staffName; }
+ (void) setStaffName:(NSString*)staffDataName { staffName = staffDataName; }
+ (NSString*) getRegisterDate { return registerDate;}
+ (void) setRegisterDate:(NSString*)staffDataRegisterDate { registerDate = staffDataRegisterDate; }
+ (NSString*) getLastModifyTime { return lastModifyTime; }
+ (void) setLastModifyTime:(NSString*)staffDataLastModifyTime { lastModifyTime = staffDataLastModifyTime; }
+ (NSString*) getUsername { return staffUsername;}
+ (void) setUsername:(NSString*)staffDataUsername { staffUsername = staffDataUsername; }
+ (NSString*) getPassword { return staffPassword; }
+ (void) setPassword:(NSString*)staffDataPassword { staffPassword = staffDataPassword; }

@end
