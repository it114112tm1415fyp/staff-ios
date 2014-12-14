//
//  UIViewController+BeltControllerViewController.m
//  Staff-IOS
//
//  Created by Patrick Lo on 4/12/14.
//  Copyright (c) 2014 it114112tm1415fyp. All rights reserved.
//

#import "BeltControllerViewController.h"
#import "HTTP6y.h"
@interface BeltControllerViewController ()
{
    NSTimer* timer;
    
    NSArray* mrImageArray;
    NSArray* crImageArray;
    NSArray* mrDisImageArray;
    NSArray* crDisImageArray;
    NSArray* stImageArray;
    
    NSArray* chAllButton;
    NSArray* crAllButton;
}
@end
@implementation BeltControllerViewController
@synthesize stopperAllButton, ch1AllButton, ch2AllButton, ch3AllButton, ch4AllButton, lcrAllButton, rcrAllButton, mrAllButton;
- (void)viewDidLoad {
    [super viewDidLoad];

    chAllButton = [[NSMutableArray alloc] initWithArray:@[ch1AllButton, ch2AllButton, ch3AllButton, ch4AllButton]];
    
    crAllButton = [[NSMutableArray alloc] initWithArray:@[lcrAllButton, rcrAllButton]];

    mrImageArray = [[NSMutableArray alloc] initWithArray:@[@"stop_icon",@"cycle_forward", @"cycle_backward"]];
    mrDisImageArray = [[NSMutableArray alloc] initWithArray:@[@"stop_icon_dis",@"cycle_forward_dis", @"cycle_backward_dis"]];

    crImageArray = [[NSMutableArray alloc] initWithArray:@[@"stop_icon",@"forward_icon",@"backward_icon", @"up_icon"]];
    crDisImageArray = [[NSMutableArray alloc] initWithArray:@[@"stop_icon_dis",@"forward_icon_dis",@"backward_icon_dis", @"up_icon_dis"]];
    
    stImageArray = [[NSMutableArray alloc] initWithArray:@[@"up_icon_dis", @"up_icon"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)upButtonOnClick:(UIButton *)sender {
    [self sendMessage:sender];
}

- (IBAction)rollerButtonOnClick:(UIButton *)sender {
    [self sendMessage:sender];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getControl];
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getControl) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [timer invalidate];
}

-(void) sendMessage:(UIButton *)sender
{
    NSDictionary* result = [HTTP6y sendMessageWithConvoyerName:@"Conveyor for test" message:[sender restorationIdentifier]];
    [self updateImage:result];
}

- (void) getControl {
    NSDictionary *result = [HTTP6y getControlWithBelt:@"Conveyor for test"];
    [self updateImage:result];
}

-(void) updateImage:(NSDictionary *)result
{
    if ([[result objectForKey:@"success"] isEqual:@(YES)]) {
        NSDictionary *message = [result objectForKey:@"message"];
        NSArray *ch = [message objectForKey:@"ch"];
        for (int i = 0; i < [ch count]; i++){
            [self setCHButtonState:i state:(int)[[ch objectAtIndex:i]integerValue]];
        }
        NSArray *cr = [message objectForKey:@"cr"];
        for (int i = 0; i < [cr count]; i++){
            [self setCRButtonState:i state:(int)[[cr objectAtIndex:i] integerValue]];
        }
        [self setMRButtonState:[[message objectForKey:@"mr"] intValue]];
        NSArray *st = [message objectForKey:@"st"];
        for (int i = 0; i < [st count]; i++){
            [self setStopperState:i state:(int)[[st objectAtIndex:i] integerValue]];
        }
    }
}

- (void) setMRButtonState:(int)state
{
    for (int i = 0; i < [mrAllButton count]; i++) {
        [[mrAllButton objectAtIndex:i] setImage:[UIImage imageNamed:[mrDisImageArray objectAtIndex:i]] forState:UIControlStateNormal];
    }
    [[mrAllButton objectAtIndex:state] setImage:[UIImage imageNamed:[mrImageArray objectAtIndex:state]] forState:UIControlStateNormal];
}
- (void) setCHButtonState:(int)changeover state:(int)state
{
    for (int i = 0; i < [[chAllButton objectAtIndex:changeover] count]; i++) {
        [[[chAllButton objectAtIndex:changeover] objectAtIndex:i] setImage:[UIImage imageNamed:[crDisImageArray objectAtIndex:i]] forState:UIControlStateNormal];
    }
    [[[chAllButton objectAtIndex:changeover] objectAtIndex:state / 2] setImage:[UIImage imageNamed:[crImageArray objectAtIndex:state / 2]] forState:UIControlStateNormal];
    
    [[[chAllButton objectAtIndex:changeover] objectAtIndex:3] setImage:[UIImage imageNamed:[stImageArray objectAtIndex:state % 2]] forState:UIControlStateNormal];
}

-(void) setCRButtonState:(int)crossover state:(int)state
{
    for (int i = 0; i < [[crAllButton objectAtIndex:crossover] count]; i++)
    {
        [[[crAllButton objectAtIndex:crossover] objectAtIndex:i] setImage:[UIImage imageNamed:[crDisImageArray objectAtIndex:i]] forState:UIControlStateNormal];
    }
    [[[crAllButton objectAtIndex:crossover] objectAtIndex:state] setImage:[UIImage imageNamed:[crImageArray objectAtIndex:state]] forState:UIControlStateNormal];
}

- (void) setStopperState:(int)stopper state:(int)state
{
    [[stopperAllButton objectAtIndex:stopper] setImage:[UIImage imageNamed:[stImageArray objectAtIndex:state]] forState:UIControlStateNormal];
}
@end
