//
//  StaffViewController.m
//  Staff-IOS
//
//  Created by Patrick Lo on 10/12/14.
//  Copyright (c) 2014 it114112tm1415fyp. All rights reserved.
//

#import "StaffDetailViewController.h"
#import "StaffData.h"
@interface StaffDetailViewController ()

@end

@implementation StaffDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _staffIdLabel.text = [NSString stringWithFormat:@"%d", [StaffData getStaffId]];
    _staffNameLabel.text = [StaffData getStaffName];
    NSDateFormatter *getDateFormat = [[NSDateFormatter alloc] init];
    [getDateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'000Z'"];
    NSDateFormatter *setDateFormat = [[NSDateFormatter alloc] init];
    [setDateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [setDateFormat stringFromDate:[getDateFormat dateFromString:[StaffData getRegisterDate]]];
    _entryTimeLabel.text = date;
    date = [setDateFormat stringFromDate:[getDateFormat dateFromString:[StaffData getLastModifyTime]]];
    _lastActivityTimeLabel.text = date;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
