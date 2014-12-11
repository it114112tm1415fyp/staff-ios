//
//  StaffViewController.h
//  Staff-IOS
//
//  Created by Patrick Lo on 10/12/14.
//  Copyright (c) 2014 1415FYP. All rights reserved.
//

#import "LoginViewController.h"

@interface StaffDetailViewController : LoginViewController
@property (weak, nonatomic) IBOutlet UILabel *staffIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *staffNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *entryTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastActivityTimeLabel;

@end
