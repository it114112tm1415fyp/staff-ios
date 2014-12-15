//
//  BeltControllerTableViewController.m
//  Staff-IOS
//
//  Created by Patrick Lo on 10/12/14.
//  Copyright (c) 2014 it114112tm1415fyp. All rights reserved.
//

#import "ChooseBeltControllerTableViewController.h"
#import "BeltControllerViewController.h"
#import "HTTP6y.h"

@interface ChooseBeltControllerTableViewController (){
    NSMutableArray *listOfBelt;
}

@end

@implementation ChooseBeltControllerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[[NSThread alloc] initWithTarget:self selector:@selector(conveyorGetListThreadMain) object:nil] start];
}

- (void) conveyorGetListThreadMain {
    NSDictionary *result = [HTTP6y conveyorGetList];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[result objectForKey:@"success"] isEqual:@(YES)]) {
            listOfBelt = [[NSMutableArray alloc] initWithArray:[result objectForKey:@"list"]];
        } else if ([[result objectForKey:@"error_handled"] isEqual:@(NO)]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[result objectForKey:@"error"] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:true completion:nil];
        }
        [self.tableView reloadData];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [listOfBelt count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *conveyor = [listOfBelt objectAtIndex:indexPath.row];
    cell.tag = [[conveyor objectForKey:@"id"] integerValue];
    cell.textLabel.text = [conveyor objectForKey:@"name"];
    return cell;
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    UITableViewCell *cell = sender;
    NSMutableDictionary *result = [HTTP6y conveyorGetControlWithConveyorId:[[NSNumber alloc] initWithInteger:cell.tag]];
    if([[result objectForKey:@"success"] isEqual:@(YES)]) {
        return true;
    } else if ([[result objectForKey:@"error_handled"] isEqual:@(NO)]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[result objectForKey:@"error"] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:true completion:nil];
    }
    return false;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BeltControllerViewController* nextViewController = [segue destinationViewController];
    UITableViewCell *cell = sender;
    nextViewController.beltId = [[NSNumber alloc] initWithInteger:cell.tag];
    nextViewController.beltName = cell.textLabel.text;
}

@end
