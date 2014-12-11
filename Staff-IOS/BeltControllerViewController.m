//
//  UIViewController+BeltControllerViewController.m
//  Staff-IOS
//
//  Created by Patrick Lo on 4/12/14.
//  Copyright (c) 2014 it114112tm1415fyp. All rights reserved.
//

#import "BeltControllerViewController.h"

@interface BeltControllerViewController (){
    NSMutableArray* Array;
    NSMutableArray* mrImageArray;
    NSMutableArray* rImageArray;
    int stopperState[8];
    int rollerState[7][4];
}
@end

@implementation BeltControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Array =[[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc]initWithObjects:_mrStopButton,_mrForwardButton,_mrBackwardButton, nil],[[NSMutableArray alloc]initWithObjects:_lcrStopButton,_lcrForwardButton,_lcrBackwardButton, nil],[[NSMutableArray alloc]initWithObjects:_rcrStopButton,_rcrForwardButton,_rcrBackwardButton, nil],[[NSMutableArray alloc]initWithObjects:_cd1StopButton,_cd1ForwardButton,_cd1BackwardButton, nil],[[NSMutableArray alloc]initWithObjects:_cd2StopButton,_cd2ForwardButton,_cd2BackwardButton, nil],[[NSMutableArray alloc]initWithObjects:_cd3StopButton,_cd3ForwardButton,_cd3BackwardButton, nil],[[NSMutableArray alloc]initWithObjects:_cd4StopButton,_cd4ForwardButton,_cd4BackwardButton, nil], nil];

    mrImageArray = [[NSMutableArray alloc] initWithObjects:@"stop_icon_dis",@"cycle_forward_dis",@"cycle_backward_dis",@"stop_icon",@"cycle_forward",@"cycle_backward", nil];
    rImageArray = [[NSMutableArray alloc] initWithObjects:@"stop_icon_dis",@"forward_icon_dis",@"backward_icon_dis",@"stop_icon",@"forward_icon",@"backward_icon", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)upButtonOnClick:(UIButton *)sender {
    int rollerType = (int) sender.tag / 10 - 1;
    int buttonType = (int) sender.tag % 10 - 4;
    
    NSLog(@"Roller Type = %D Button Type = %d", rollerType, buttonType);
    if (rollerType > 2){
        switch (rollerState[rollerType][buttonType]) {
            case 0:
                NSLog(@"Roller Type = %d UP%d is ON", rollerType, buttonType);
                rollerState[rollerType][buttonType] = 1;
                [sender setImage:[UIImage imageNamed:@"up_icon"] forState:UIControlStateNormal];
                break;
            case 1:
                NSLog(@"Roller Type = %d UP%d is OFF", rollerType, buttonType);
                rollerState[rollerType][buttonType] = 0;
                [sender setImage:[UIImage imageNamed:@"up_icon_dis"] forState:UIControlStateNormal];
                break;
            default:
                break;
            }
        }else{
            switch (stopperState[sender.tag - 1]) {
                case 0:
                    NSLog(@"Stopper %lD is ON", (long)sender.tag);
                    stopperState[sender.tag - 1] = 1;
                    [sender setImage:[UIImage imageNamed:@"up_icon"] forState:UIControlStateNormal];
                    break;
                case 1:
                    NSLog(@"Stopper %lD is OFF", (long)sender.tag);
                    stopperState[sender.tag - 1] = 0;
                    [sender setImage:[UIImage imageNamed:@"up_icon_dis"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
        }
    }
}

- (IBAction)rollerButtonOnClick:(UIButton *)sender {
    int rollerType = (int) sender.tag / 10 - 1;
    int buttonType = (int) sender.tag % 10 - 1;
    
    NSMutableArray *ImageArray;
    if (rollerType == 0)
        ImageArray = mrImageArray;
    else
        ImageArray = rImageArray;
    
    for (int i = 0; i < 3; i++) {
        rollerState[rollerType][i] = 0;
        [Array[rollerType][i] setImage:[UIImage imageNamed:ImageArray[i]] forState:UIControlStateNormal];
    }
    
    rollerState[rollerType][buttonType] = 1;
    for (int i = 0; i < 3; i++)
    {
        if (rollerState[rollerType][i] == 1) {
            [Array[rollerType][buttonType] setImage:[UIImage imageNamed:ImageArray[i + 3]] forState:UIControlStateNormal];
            NSLog(@"Roller Type = %D Button Type = %d is ON", rollerType, buttonType);
            break;
        }
    }
}
@end
