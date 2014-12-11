//
//  QRCodeScannerViewController.m
//  Staff-IOS
//
//  Created by Patrick Lo on 7/12/14.
//  Copyright (c) 2014 it114112tm1415fyp. All rights reserved.
//

#import "QRCodeScannerViewController.h"
#import "Good.h"
#import "HTTP6y.h"

@interface QRCodeScannerViewController ()
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) BOOL isReading;

-(BOOL)startReading;
-(void)stopReading;
-(void)setGoodInformation:goodsKey;

@end

@implementation QRCodeScannerViewController

@synthesize listOfID;
Good* good;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    listOfID = [NSMutableArray new];
    _goodDictionary = [NSMutableDictionary new];
    _captureSession = nil;
    _isReading = NO;
    [_scannerState setText:@"Standby..."];
}

- (void)viewDidAppear:(BOOL)animated{
    [self willRotateToInterfaceOrientation:self.interfaceOrientation duration:0];
    [self startReading];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopReading];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        _videoPreviewView.transform = CGAffineTransformMakeRotation( M_PI_2);
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
        _videoPreviewView.transform = CGAffineTransformMakeRotation(M_PI +M_PI_2);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ScanButtonOnClick:(UIButton *)sender {
    if (!_isReading) {
        if ([self startReading]) {
            _isReading = YES;
        }
    }
    else{
        [self stopReading];
        _isReading = NO;
    }
}

- (BOOL)startReading {
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_videoPreviewView.layer.bounds];
    [_videoPreviewView.layer addSublayer:_videoPreviewLayer];

    [_captureSession startRunning];
    
    _isReading = YES;
    [_scanButton setTitle:@"Stop" forState:UIControlStateNormal];
    [_scannerState setText:@"Scanning for QR Code..."];
    return YES;
}

- (void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
    
    _isReading = NO;
    [_scanButton setTitle:@"Start" forState:UIControlStateNormal];
    [_scannerState setText:@"Standby..."];

}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            // If the found metadata is equal to the QR code metadata then update the status label's text,
            // stop reading and change the bar button item's title and the flag's value.
            // Everything is done on the main thread.
            NSString* qrCodeString = [metadataObj stringValue];
            if ([_goodDictionary objectForKey:qrCodeString] == nil){
                NSString *stringFromScanning = [NSString stringWithFormat:@"Item Counting : %lu QRCode : %@", (unsigned long)[_goodDictionary count], qrCodeString];
                [_scannerState performSelectorOnMainThread:@selector(setText:) withObject:stringFromScanning waitUntilDone:NO];
                
//                //TODO Get Good Datail From Server
//                NSDictionary* result = [HTTP6y request:@"" parameters:@{@"username":qrCodeString}];
//                if (result != nil) {
//                    NSLog(@"%@",[result objectForKey:@"success"]);
//                    if ([result objectForKey:@"success"]) {
//                        Good* good = [[Good alloc] init];
//                        good.goodID = 1;
//                        good.orderID = 1;
//                        good.rfid = @"";
//                        good.weigth = 1;
//                        good.fragile = NO;
//                        good.flammable = NO;
//                        good.createdTime = NSDate;
//                        good.updatedTime = NSDate;
//                        [_goodDictionary setObject:good forKey:qrCodeString];
//                        [self performSelectorOnMainThread:@selector(setGoodInformation:) withObject:qrCodeString waitUntilDone:NO];
//                    } else {
//                        [[[UIAlertView alloc] initWithTitle:@"Error!"
//                                                    message:@"Fail to connect server.\n Please try again later."
//                                                   delegate:self
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil, nil] show];
//                        [self stopReading];
//                    }
//                } else {
//                    [[[UIAlertView alloc] initWithTitle:@"Error!"
//                                                message:@"Fail to connect server.\n Please try again later."
//                                               delegate:self
//                                      cancelButtonTitle:@"OK"
//                                      otherButtonTitles:nil, nil] show];
//                    [self stopReading];
//                }
                
                Good* good = [[Good alloc] init];
                good.goodID = 1;
                good.orderID = 1;
                good.rfid = @"";
                good.weigth = 1;
                good.fragile = NO;
                good.flammable = NO;
                //good.createdTime = @"";
                //good.updatedTime = @"";
                [_goodDictionary setObject:good forKey:qrCodeString];
                [self performSelectorOnMainThread:@selector(setGoodInformation:) withObject:qrCodeString waitUntilDone:NO];
            }
            
        }
    }
}

-(void)setGoodInformation:(NSString *)goodsKey{
    _idLabel.text = [NSString stringWithFormat:@"%d", ((Good *)[_goodDictionary objectForKey:goodsKey]).goodID];
    NSLog(@"%d", ((Good *)[_goodDictionary objectForKey:goodsKey]).goodID);
    
    _orderIDLabel.text = [NSString stringWithFormat:@"%d", ((Good *)[_goodDictionary objectForKey:goodsKey]).orderID];
    NSLog(@"%d", ((Good *)[_goodDictionary objectForKey:goodsKey]).orderID);
    
    _rfidLabel.text = ((Good *)[_goodDictionary objectForKey:goodsKey]).rfid;
    NSLog(@"%@", ((Good *)[_goodDictionary objectForKey:goodsKey]).rfid);
    
    _weigthLabel.text = [NSString stringWithFormat:@"%f", ((Good *)[_goodDictionary objectForKey:goodsKey]).weigth];
    NSLog(@"%f", ((Good *)[_goodDictionary objectForKey:goodsKey]).weigth);
    
    _fragileLabel.text = [NSString stringWithFormat:@"%d", ((Good *)[_goodDictionary objectForKey:goodsKey]).fragile];
    NSLog(@"%d", ((Good *)[_goodDictionary objectForKey:goodsKey]).fragile);
    
    _flammableLabel.text = [NSString stringWithFormat:@"%d", ((Good *)[_goodDictionary objectForKey:goodsKey]).flammable];
    NSLog(@"%d", ((Good *)[_goodDictionary objectForKey:goodsKey]).flammable);
    
    _createdTimeLabel.text = [NSString stringWithFormat:@"%@", ((Good *)[_goodDictionary objectForKey:goodsKey]).createdTime];
    NSLog(@"%@", ((Good *)[_goodDictionary objectForKey:goodsKey]).createdTime);
    
    _updatedTimeLabel.text = [NSString stringWithFormat:@"%@", ((Good *)[_goodDictionary objectForKey:goodsKey]).updatedTime];
    NSLog(@"%@", ((Good *)[_goodDictionary objectForKey:goodsKey]).updatedTime);
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
