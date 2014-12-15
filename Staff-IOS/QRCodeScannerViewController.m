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

@interface QRCodeScannerViewController (){
    Good* good;
    NSMutableDictionary *goodDictionary;
}
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) BOOL isReading;

-(BOOL)startReading;
-(void)stopReading;
-(void)setGoodInformation:goodsKey;

@end

@implementation QRCodeScannerViewController
@synthesize listOfID;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = _actionName;
    goodDictionary = [NSMutableDictionary new];
    listOfID = [NSMutableArray new];
    NSLog(@"%@",_locationID);
    NSLog(@"%@",_locationType);
    NSLog(@"%@",_actionName);
    _captureSession = nil;
    _isReading = NO;
    [_scannerState setText:@"Standby..."];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self willRotateToInterfaceOrientation:self.interfaceOrientation duration:0];
    [self startReading];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopReading];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        _videoPreviewView.transform = CGAffineTransformMakeRotation(M_PI_2);
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
            NSString *qrCodeString = [metadataObj stringValue];
            if ([qrCodeString rangeOfString:@"^it114112tm1415fyp\\{" options:NSRegularExpressionSearch].location != NSNotFound){
                NSData *qrCodeData = [[qrCodeString substringFromIndex:@"it114112tm1415fyp".length] dataUsingEncoding:NSUTF8StringEncoding];
                NSMutableDictionary *qrCodeResult = [NSJSONSerialization JSONObjectWithData:qrCodeData options:NSJSONReadingAllowFragments error:nil];
                NSNumber *good_id = [qrCodeResult objectForKey:@"good_id"];
                if ([goodDictionary objectForKey:good_id] == nil){
                    NSLog(@"%@", qrCodeResult);
                    NSNumber *good_id = [qrCodeResult objectForKey:@"good_id"];
                    NSNumber *order_id = [qrCodeResult objectForKey:@"order_id"];
                    NSString *destination = [qrCodeResult objectForKey:@"destination"];
                    NSString *departure = [qrCodeResult objectForKey:@"departure"];
                    NSString *rfid_tag = [qrCodeResult objectForKey:@"rfid_tag"];
                    NSNumber *weight =[qrCodeResult objectForKey:@"weight"];
                    NSString *fragile;
                    NSString *flammable;
                    if ([[qrCodeResult objectForKey:@"fragile"] intValue] == 0)
                        fragile = @"NO";
                    else if ([[qrCodeResult objectForKey:@"fragile"] intValue] == 1)
                        fragile = @"YES";
                    if ([[qrCodeResult objectForKey:@"flammable"] intValue] == 0)
                        flammable = @"NO";
                    else if ([[qrCodeResult objectForKey:@"flammable"] intValue] == 1)
                        flammable = @"YES";
                    NSString *created_at = [qrCodeResult objectForKey:@"order_time"];
                    NSDateFormatter *getDateFormat = [[NSDateFormatter alloc] init];
                    [getDateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
                    NSDate *date = [getDateFormat dateFromString:created_at];
                    
                    good = [Good new];
                    good.goodID = good_id;
                    good.orderID = order_id;
                    good.rfid = rfid_tag;
                    good.weigth = weight;
                    good.fragile = fragile;
                    good.destination = destination;
                    good.departure = departure;
                    good.flammable = flammable;
                    good.createdTime = date;
                    
                    NSDictionary *result = [HTTP6y goodAction:_actionName good_id:good.goodID location_id:_locationID locationType:_locationType];
                    [self performSelectorOnMainThread:@selector(goodActionThreadUpdateUI:) withObject:result waitUntilDone:NO];
                    
                    NSString *stringFromScanning = [NSString stringWithFormat:@"Good ID : %@", good.goodID];
                    [goodDictionary setObject:good forKey:good_id];
                    [_scannerState performSelectorOnMainThread:@selector(setText:) withObject:stringFromScanning waitUntilDone:NO];
                    [_stateLabel performSelectorOnMainThread:@selector(setText:) withObject:@"OK" waitUntilDone:NO];
                    [self performSelectorOnMainThread:@selector(setGoodInformation:) withObject:good waitUntilDone:NO];
                } else {
                    NSString *stringFromScanning = [NSString stringWithFormat:@"Good ID : %@", good_id];
                    [_scannerState performSelectorOnMainThread:@selector(setText:) withObject:stringFromScanning waitUntilDone:NO];
                    Good *selfGood = [goodDictionary objectForKey:good_id];
                    [self performSelectorOnMainThread:@selector(setGoodInformation:) withObject:selfGood waitUntilDone:NO];
                }
            } else {
                [_scannerState performSelectorOnMainThread:@selector(setText:) withObject:@"Not Registered QR Code" waitUntilDone:NO];
            }
        }
    }
}

- (void) goodActionThreadUpdateUI:(NSDictionary*)result {
    if ([[result objectForKey:@"success"] isEqual:@(YES)]) {
        NSDateFormatter *getDateFormat = [[NSDateFormatter alloc] init];
        [getDateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'000Z'"];
        NSDate *date = [getDateFormat dateFromString:[result objectForKey:@"update_time"]];
        good.updatedTime = date;
    } else if ([[result objectForKey:@"error_handled"] isEqual:@(NO)]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[result objectForKey:@"error"] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:true completion:nil];
        [self stopReading];
    }
}

-(void)setGoodInformation:(Good *)goodkey{
    _idLabel.text = [NSString stringWithFormat:@"%@", goodkey.goodID];
    _orderIDLabel.text = [NSString stringWithFormat:@"%@", goodkey.orderID];
    _rfidLabel.text = goodkey.rfid;
    _weigthLabel.text = [NSString stringWithFormat:@"%@", goodkey.weigth];
    _fragileLabel.text = [NSString stringWithFormat:@"%@", goodkey.fragile];
    _flammableLabel.text = [NSString stringWithFormat:@"%@", goodkey.flammable];
    _destinationLabel.text = goodkey.destination;
    _departureLabel.text = goodkey.departure;
    NSDateFormatter *setDateFormat = [[NSDateFormatter alloc] init];
    [setDateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _createdTimeLabel.text = [setDateFormat stringFromDate: goodkey.createdTime];
    _updatedTimeLabel.text = [setDateFormat stringFromDate: goodkey.updatedTime];
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
