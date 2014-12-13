//
//  TestTableViewController.m
//  Staff-IOS
//
//  Created by Patrick Lo on 11/12/14.
//  Copyright (c) 2014 1415FYP. All rights reserved.
//

#import "ChooseActionTableViewController.h"
#import "QRCodeScannerViewController.h"
@interface ChooseActionTableViewController (){
    NSMutableArray *listOfAction;
    NSMutableArray *listOfCar;
    NSMutableArray *listOfStore;
    NSMutableArray *listOfFunction;
}

@end

@implementation ChooseActionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    listOfCar = [[NSMutableArray alloc] initWithObjects:@"Car 1",@"Car 2", nil];
    listOfStore = [[NSMutableArray alloc] initWithObjects:@"Store 1",@"Store 2", nil];
    listOfAction = [[NSMutableArray alloc] initWithObjects:@"Download Goods From Car",@"Check In Goods To Store", @"Check Storing Goods", @"Check Out Goods From Store", @"Upload Goods To Car", @"Client Sign", nil];
    listOfFunction = [[NSMutableArray alloc] initWithArray:listOfAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [listOfFunction count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Action" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [listOfFunction objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%@", [listOfFunction objectAtIndex:indexPath.row]);
    if ([[listOfFunction objectAtIndex:indexPath.row] isEqual:@"Download Goods From Car"] || [[listOfFunction objectAtIndex:indexPath.row]  isEqual:@"Upload Goods To Car"]){
        if (![[listOfFunction objectAtIndex:indexPath.row + 1] isEqual:[listOfCar objectAtIndex:0]])
        {
            int newIndex = 0;
            if ([[listOfFunction objectAtIndex:indexPath.row] isEqual:@"Download Goods From Car"])
                newIndex = 0;
            else
                newIndex = 4;
            
            listOfFunction = [[NSMutableArray alloc] initWithArray:listOfAction];
            
            for (int i = [listOfCar count]; i > 0; i--) {
                NSLog(@"Add Row");
                [listOfFunction insertObject:[listOfCar objectAtIndex:i - 1] atIndex:newIndex + 1];
            }
        } else {
            for (int i = [listOfCar count]; i > 0; i--) {
                [listOfFunction removeObjectAtIndex:indexPath.row + 1];
            }
            listOfFunction = [[NSMutableArray alloc] initWithArray:listOfAction];
        }
    }
    else if ([[listOfFunction objectAtIndex:indexPath.row] isEqual:@"Check In Goods To Store"] || [[listOfFunction objectAtIndex:indexPath.row] isEqual:@"Check Storing Goods"] || [[listOfFunction objectAtIndex:indexPath.row] isEqual:@"Check Out Goods From Store"] ){
        if (![[listOfFunction objectAtIndex:indexPath.row + 1] isEqual:[listOfStore objectAtIndex:0]])
        {
            int newIndex = 0;
            if ([[listOfFunction objectAtIndex:indexPath.row] isEqual:@"Check In Goods To Store"])
                newIndex = 1;
            else if ([[listOfFunction objectAtIndex:indexPath.row] isEqual:@"Check Storing Goods"])
                newIndex = 2;
            else
                newIndex = 3;
            
            listOfFunction = [[NSMutableArray alloc] initWithArray:listOfAction];

            for (int i = [listOfStore count]; i > 0; i--) {
                NSLog(@"Add Row");
                [listOfFunction insertObject:[listOfStore objectAtIndex:i - 1] atIndex:newIndex + 1];
            }
        } else {
            for (int i = [listOfStore count]; i > 0; i--) {
                [listOfFunction removeObjectAtIndex:indexPath.row + 1];
            }
            listOfFunction = [[NSMutableArray alloc] initWithArray:listOfAction];
        }
    } else if ([[listOfFunction objectAtIndex:indexPath.row] isEqual:@"Client Sign"]){
        listOfFunction = [[NSMutableArray alloc] initWithArray:listOfAction];
        QRCodeScannerViewController *qrCodeScannerViewController = (QRCodeScannerViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"qrCodeScanner"];
        [self.navigationController pushViewController:qrCodeScannerViewController animated:true];
    }
    [self.tableView reloadData];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
