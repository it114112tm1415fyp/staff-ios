//
//  ViewController.m
//  Staff-IOS
//
//  Created by Patrick Lo on 4/12/14.
//  Copyright (c) 2014 it114112tm1415fyp. All rights reserved.
//

#import "LoginViewController.h"
#import "MenuViewController.h"
#import "HTTP6y.h"
#import "StaffData.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButton:(UIButton *)sender {
    if ([_usernameTextField.text  isEqual: @""] || [_passwordTextField.text  isEqual: @""]){
        [[[UIAlertView alloc] initWithTitle:@"Warming" message:@"Please enter your username and password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    else
    [[[NSThread alloc] initWithTarget:self selector:@selector(loginThreadMain) object:nil] start];
}

- (void) loginThreadMain {
    NSDictionary *result = [HTTP6y staffLoginWithUsername:_usernameTextField.text password:_passwordTextField.text];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[result objectForKey:@"success"] isEqual:@(YES)]) {
            [StaffData setStaffId:[[result objectForKey:@"id"] intValue]];
            [StaffData setStaffName:[result objectForKey:@"name"]];
            [StaffData setRegisterDate:[result objectForKey:@"register_time"]];
            [StaffData setLastModifyTime:[result objectForKey:@"last_modify_time"]];
            [StaffData setUsername:_usernameTextField.text];
            [StaffData setPassword:_passwordTextField.text];
            MenuViewController *menuView = (MenuViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"MenuView"];
            [self presentViewController:menuView animated:true completion:nil];
        } else if ([[result objectForKey:@"error_handled"] isEqual:@(NO)]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[result objectForKey:@"error"] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:true completion:nil];
        }
    });
}

@end
