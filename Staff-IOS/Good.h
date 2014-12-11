//
//  Good.h
//  Staff-IOS
//
//  Created by Patrick Lo on 8/12/14.
//  Copyright (c) 2014 it114112tm1415fyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Good : NSObject

@property (nonatomic) int goodID;
@property (nonatomic) int orderID;
@property (nonatomic) NSString* rfid;
@property (nonatomic) double weigth;
@property (nonatomic) bool fragile;
@property (nonatomic) bool flammable;
@property (nonatomic) NSString* location;
@property (nonatomic) NSDate* createdTime;
@property (nonatomic) NSDate* updatedTime;

@end
