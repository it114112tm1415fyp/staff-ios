//
//  QRCodeScannerViewController.h
//  Staff-IOS
//
//  Created by Patrick Lo on 7/12/14.
//  Copyright (c) 2014 it114112tm1415fyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ChooseActionTableViewController.h"

@interface QRCodeScannerViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UILabel *scannerState;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIView *videoPreviewView;

@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *rfidLabel;
@property (weak, nonatomic) IBOutlet UILabel *weigthLabel;
@property (weak, nonatomic) IBOutlet UILabel *fragileLabel;
@property (weak, nonatomic) IBOutlet UILabel *flammableLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (nonatomic, strong) NSMutableArray *listOfID;

@property (nonatomic, strong) NSString *actionName;
@property (nonatomic, strong) NSNumber *locationID;
@property (nonatomic, strong) NSString *locationType;

@end
