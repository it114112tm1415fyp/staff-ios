//
//  UIViewController+BeltControllerViewController.h
//  Staff-IOS
//
//  Created by Patrick Lo on 4/12/14.
//  Copyright (c) 2014 it114112tm1415fyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface BeltControllerViewController : UIViewController{
    AppDelegate *delegate;
}

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *stopperAllButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *ch1AllButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *ch2AllButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *ch3AllButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *ch4AllButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *lcrAllButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *rcrAllButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *mrAllButton;

@property (strong, nonatomic) NSNumber *beltId;

@property (strong, nonatomic) NSString *beltName;

@end
