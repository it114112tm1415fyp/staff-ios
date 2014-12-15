//
//  GoodDetailViewController.h
//  Staff-IOS
//
//  Created by Patrick Lo on 15/12/14.
//  Copyright (c) 2014 1415FYP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Good.h"

@interface GoodDetailViewController : UIViewController

@property (strong, nonatomic) Good* good;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *rfidLabel;
@property (weak, nonatomic) IBOutlet UILabel *weigthLabel;
@property (weak, nonatomic) IBOutlet UILabel *fragileLabel;
@property (weak, nonatomic) IBOutlet UILabel *flammableLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastActionLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;

@end
