//
//  GoodDetailViewController.m
//  Staff-IOS
//
//  Created by Patrick Lo on 15/12/14.
//  Copyright (c) 2014 1415FYP. All rights reserved.
//

#import "GoodDetailViewController.h"

@interface GoodDetailViewController ()

@end

@implementation GoodDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _idLabel.text = [NSString stringWithFormat:@"%@", _good.goodID];
    _orderIdLabel.text = [NSString stringWithFormat:@"%@", _good.orderID];
    _rfidLabel.text = _good.rfid;
    _weigthLabel.text = [NSString stringWithFormat:@"%@", _good.weigth];
    _fragileLabel.text = [NSString stringWithFormat:@"%@", _good.fragile];
    _flammableLabel.text = [NSString stringWithFormat:@"%@", _good.flammable];
    _departureLabel.text = [NSString stringWithFormat:@"%@", _good.departure];
    _destinationLabel.text = [NSString stringWithFormat:@"%@", _good.destination];
    _locationLabel.text = _good.location;
    _lastActionLabel.text = _good.lastAction;
    NSDateFormatter *setDateFormat = [[NSDateFormatter alloc] init];
    [setDateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [setDateFormat stringFromDate:_good.createdTime];
    _orderTimeLabel.text = dateString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.}
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
