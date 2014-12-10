//
//  QRCodeScannerViewController.m
//  Staff-IOS
//
//  Created by Patrick Lo on 7/12/14.
//  Copyright (c) 2014 ___LoKiFunG___. All rights reserved.
//

#import "QRCodeScannerViewController.h"
#import "Good.h"

@interface QRCodeScannerViewController ()
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) BOOL isReading;

-(BOOL)startReading;
-(void)stopReading;
-(void)setGoodInformation:goodKey;

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
    [_scanButton setTitle:@"Stop" forState:UIControlStateNormal];
    [_scannerState setText:@"Scanning for QR Code..."];
    _isReading = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopReading];
    [_scanButton setTitle:@"Start" forState:UIControlStateNormal];
    [_scannerState setText:@"Standby..."];
    _isReading = NO;
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
            [_scanButton setTitle:@"Stop" forState:UIControlStateNormal];
            [_scannerState setText:@"Scanning for QR Code..."];
            _isReading = YES;
        }
    }
    else{
        [self stopReading];
        [_scanButton setTitle:@"Start" forState:UIControlStateNormal];
        [_scannerState setText:@"Standby..."];
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
    return YES;
}

- (void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
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
            NSString* data = [metadataObj stringValue];
            if ([_goodDictionary objectForKey:data] == nil){
                [_scannerState performSelectorOnMainThread:@selector(setText:) withObject:data waitUntilDone:NO];
                
                //TODO Get Good Datail From Server
                
                Good* good = [[Good alloc] init];
//                good.goodID = 1;
//                good.orderID = 1;
//                good.rfid = @"";
//                good.weigth = 1;
//                good.fragile = NO;
//                good.flammable = NO;
//                good.createdTime = NSDate;
//                good.updatedTime = NSDate;
                [_goodDictionary setObject:good forKey:data];
                [self performSelectorOnMainThread:@selector(setGoodInformation:) withObject:data waitUntilDone:NO];
            }
        }
    }
}

-(void)setGoodInformation:(NSString *)goodKey{
    _idLabel.text = [NSString stringWithFormat:@"%d", ((Good *)[_goodDictionary objectForKey:goodKey]).goodID];
    NSLog(@"%d", ((Good *)[_goodDictionary objectForKey:goodKey]).goodID);
    _orderIDLabel.text = [NSString stringWithFormat:@"%d", ((Good *)[_goodDictionary objectForKey:goodKey]).orderID];
    NSLog(@"%d", ((Good *)[_goodDictionary objectForKey:goodKey]).orderID);
    _rfidLabel.text = ((Good *)[_goodDictionary objectForKey:goodKey]).rfid;
    NSLog(@"%@", ((Good *)[_goodDictionary objectForKey:goodKey]).rfid);
    _weigthLabel.text = [NSString stringWithFormat:@"%f", ((Good *)[_goodDictionary objectForKey:goodKey]).weigth];
    NSLog(@"%f", ((Good *)[_goodDictionary objectForKey:goodKey]).weigth);
    _fragileLabel.text = [NSString stringWithFormat:@"%d", ((Good *)[_goodDictionary objectForKey:goodKey]).fragile];
    NSLog(@"%d", ((Good *)[_goodDictionary objectForKey:goodKey]).fragile);
    _flammableLabel.text = [NSString stringWithFormat:@"%d", ((Good *)[_goodDictionary objectForKey:goodKey]).flammable];
    NSLog(@"%d", ((Good *)[_goodDictionary objectForKey:goodKey]).flammable);
    _createdTimeLabel.text = [NSString stringWithFormat:@"%@", ((Good *)[_goodDictionary objectForKey:goodKey]).createdTime];
    NSLog(@"%@", ((Good *)[_goodDictionary objectForKey:goodKey]).createdTime);
    _updatedTimeLabel.text = [NSString stringWithFormat:@"%@", ((Good *)[_goodDictionary objectForKey:goodKey]).updatedTime];
    NSLog(@"%@", ((Good *)[_goodDictionary objectForKey:goodKey]).updatedTime);
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
