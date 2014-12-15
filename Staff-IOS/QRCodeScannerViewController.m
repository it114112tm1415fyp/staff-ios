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
    
    listOfID = [NSMutableArray new];
    NSLog(@"%@",_locationID);
    NSLog(@"%@",_locationType);
    NSLog(@"%@",_actionName);
    _goodDictionary = [NSMutableDictionary new];
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
            NSLog(@"%@", qrCodeString);
            if ([qrCodeString rangeOfString:@"^it114112tm1415fyp\\{" options:NSRegularExpressionSearch].location != NSNotFound){
                NSData *qrCodeData = [[qrCodeString substringFromIndex:@"it114112tm1415fyp".length] dataUsingEncoding:NSUTF8StringEncoding];
                NSLog(@"%@", [qrCodeString substringFromIndex:@"it114112tm1415fyp".length]);
                NSMutableDictionary *qrCodeResult = [NSJSONSerialization JSONObjectWithData:qrCodeData options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"%@", qrCodeResult);
                if ([_goodDictionary objectForKey:qrCodeString] == nil){
                    NSNumber *good_id = [qrCodeResult objectForKey:@"good_id"];
                    NSNumber *order_id = [qrCodeResult objectForKey:@"order_id"];
                    NSString *departure = [qrCodeResult objectForKey:@"departure"];
                    NSString *rfid_tag = [qrCodeResult objectForKey:@"rfid_tag"];
                    NSNumber *weight =[qrCodeResult objectForKey:@"weight"];
                    _Bool fragile = [qrCodeResult objectForKey:@"fragile"];
                    _Bool flammable = [qrCodeResult objectForKey:@"flammable"];
                    NSString *created_at = [qrCodeResult objectForKey:@"created_at"];
                    
                    NSDateFormatter *getDateFormat = [[NSDateFormatter alloc] init];
                    [getDateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'000Z'"];
                    NSDate *date = [getDateFormat dateFromString:created_at];
                    
                    good = [Good new];
                    good.goodID = good_id;
                    good.orderID = order_id;
                    good.rfid = rfid_tag;
                    good.weigth = weight;
                    good.fragile = fragile;
                    good.flammable = flammable;
                    good.createdTime = date;
                    [[[NSThread alloc] initWithTarget:self selector:@selector(goodActionThreadMain) object:nil] start];
                    [_goodDictionary setObject:good forKey:qrCodeString];
                    
                    NSString *stringFromScanning = [NSString stringWithFormat:@"Good ID : %@", good.goodID];
                    [_scannerState performSelectorOnMainThread:@selector(setText:) withObject:stringFromScanning waitUntilDone:NO];
                    [self performSelectorOnMainThread:@selector(setGoodInformation:) withObject:qrCodeString waitUntilDone:NO];
                }
                //            else{
                //                NSString *stringFromScanning = [NSString stringWithFormat:@"Good ID : %@", good.goodID];
                //                [_scannerState performSelectorOnMainThread:@selector(setText:) withObject:stringFromScanning waitUntilDone:NO];
                //                [self performSelectorOnMainThread:@selector(setGoodInformation:) withObject:qrCodeString waitUntilDone:NO];
                //            }
            }
        }
    }
}

- (void) goodActionThreadMain {
    NSDictionary *result;
    result = [HTTP6y goodInspect:good.goodID store_id:_locationID];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[result objectForKey:@"success"] isEqual:@(YES)]) {
            NSLog(@"%@", [result objectForKey:@"update_time"]);
            good.updatedTime = [result objectForKey:@"update_time"];
        } else if ([[result objectForKey:@"error_handled"] isEqual:@(NO)]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[result objectForKey:@"error"] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:true completion:nil];
            [self stopReading];
        }
    });
}

-(void)setGoodInformation:(NSString *)goodsKey{
    _idLabel.text = [NSString stringWithFormat:@"%@", good.goodID];
    _orderIDLabel.text = [NSString stringWithFormat:@"%@", good.orderID];
    _rfidLabel.text = [NSString stringWithFormat:@"%@", good.rfid];
    _weigthLabel.text = [NSString stringWithFormat:@"%@", good.weigth];
    _fragileLabel.text = [NSString stringWithFormat:@"%d", good.fragile];
    _flammableLabel.text = [NSString stringWithFormat:@"%d", good.flammable];
    NSDateFormatter *setDateFormat = [[NSDateFormatter alloc] init];
    [setDateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _createdTimeLabel.text = [setDateFormat stringFromDate: good.createdTime];
    _updatedTimeLabel.text = [setDateFormat stringFromDate: good.updatedTime];
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
