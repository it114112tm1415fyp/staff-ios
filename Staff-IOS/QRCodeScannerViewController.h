//
//  QRCodeScannerViewController.h
//  Staff-IOS
//
//  Created by Patrick Lo on 7/12/14.
//  Copyright (c) 2014 it114112tm1415fyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

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
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatedTimeLabel;

@property (nonatomic, strong) NSMutableArray *listOfID;
@property (nonatomic, strong) NSMutableDictionary *goodDictionary;

@end
