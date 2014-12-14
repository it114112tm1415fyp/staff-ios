//
//  TestTableViewController.h
//  Staff-IOS
//
//  Created by Patrick Lo on 11/12/14.
//  Copyright (c) 2014 1415FYP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseActionTableViewController : UITableViewController

@property (strong, nonatomic) NSString *selectedAction;
@property (strong, nonatomic) NSString *selectedLocation;
@property (nonatomic) int selectedActionType;
@property (nonatomic) int selectedLocationType;

@end
