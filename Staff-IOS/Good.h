//
//  Good.h
//  Staff-IOS
//
//  Created by Patrick Lo on 8/12/14.
//  Copyright (c) 2014 it114112tm1415fyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Good : NSObject

@property (nonatomic) NSNumber* goodID;
@property (nonatomic) NSNumber* orderID;
@property (nonatomic) NSString* rfid;
@property (nonatomic) NSNumber* weigth;
@property (nonatomic) NSString* fragile;
@property (nonatomic) NSString* flammable;
@property (nonatomic) NSString* destination;
@property (nonatomic) NSString* departure;
@property (nonatomic) NSDate* createdTime;
@property (nonatomic) NSDate* updatedTime;
@property (nonatomic) NSString* location;
@property (nonatomic) NSString* locationType;
@property (nonatomic) NSString*lastAction;

@end
