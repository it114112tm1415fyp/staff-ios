//
//  ViewController.m
//  Staff-IOS
//
//  Created by Patrick Lo on 4/12/14.
//  Copyright (c) 2014 ___LoKiFunG___. All rights reserved.
//

#import "ViewController.h"
#import "MenuViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "HTTP6y.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)viewSession:(UIButton *)sender {
    NSDictionary* object = [HTTP6y request:@"mobile_application/view_session"];
    NSDictionary* object2 = [object objectForKey:@"session"];
    NSLog(@"%@", [object2 objectForKey:@"session_id"]);
    NSLog(@"%@", [object2 objectForKey:@"expiry_time"]);
    NSLog(@"%@", [object2 objectForKey:@"user_id"]);
}
- (IBAction)testLogin:(id)sender {
    NSDictionary* object = [HTTP6y request:@"account/staff_login" parameters:@{@"username":@"staff0",@"password":@"57530c60783b37f20e80262d5156f37f"}];
    NSLog(@"%@", object);
    NSLog(@"%@", [object objectForKey:@"id"]);
    NSLog(@"%@", [object objectForKey:@"name"]);
}
- (IBAction)loginButton:(UIButton *)sender {
    if ([_usernameTextField.text  isEqual: @""] || [_passwordTextField.text  isEqual: @""]){
        [[[UIAlertView alloc] initWithTitle:@"Warming" message:@"Please enter your username and password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    else
    {
        NSError *error = nil;
        NSURLResponse *urlResponse = nil;
        
        // Create and instantiate a NSURL object with the URL string created
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://it114112tm1415fyp1.redirectme.net:8000/account/staff_login?username=%@&password=%@",
                       _usernameTextField.text, [self md5:[self md5:_passwordTextField.text]]]];
        NSLog(@"%@",url);
        
        // Create and instantiate a NSMutableURLRequest object
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        
        [urlRequest setTimeoutInterval:10.0f];
        
        [urlRequest setHTTPMethod:@"POST"];
        
        // Create and instantiate a NSURLConnection object to load the connection based on the created request and other parameters
        NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
        
        if ([data length] > 0 && error == nil)
        {
            // Deserialize JSON
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if (jsonObject != nil && error == nil)
            {
                MenuViewController *menuView = (MenuViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"MenuView"];
                [self presentViewController:menuView animated:true completion:nil];
            }
        }
        // If response data length is zero, then print error message
        else if ([data length] == 0 && error == nil)
        {
            NSLog(@"Nothing was downloaded !");
        }
        // If error occur, then print error message
        else if (error != nil)
        {
            NSLog(@"Error is:\n%@", error);
        }
    }
}

- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

@end
