//
//  ChooseLocationTableViewController.m
//  Staff-IOS
//
//  Created by Patrick Lo on 14/12/14.
//  Copyright (c) 2014 1415FYP. All rights reserved.
//

#import "ChooseLocationTableViewController.h"
#import "HTTP6y.h"
#import "QRCodeScannerViewController.h"

@interface ChooseLocationTableViewController (){
    NSArray *car;
    NSArray *storeAddress;
    NSArray *shopAddress;
}

@end

@implementation ChooseLocationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _actionName;
    [[[NSThread alloc] initWithTarget:self selector:@selector(locationGetListThreadMain) object:nil] start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) locationGetListThreadMain {
    NSDictionary *result = [HTTP6y locationGetList];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[result objectForKey:@"success"] isEqual:@(YES)]) {
            car = [[NSMutableArray alloc] initWithArray:[result objectForKey:@"Car"]];
            storeAddress = [[NSMutableArray alloc] initWithArray:[result objectForKey:@"StoreAddress"]];
            shopAddress = [[NSMutableArray alloc] initWithArray:[result objectForKey:@"ShopAddress"]];
        } else if ([[result objectForKey:@"error_handled"] isEqual:@(NO)]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[result objectForKey:@"error"] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:true completion:nil];
        }
        [self.tableView reloadData];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_sectionHeader count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[_sectionHeader objectAtIndex:section] isEqualToString:@"Car"]) {
        return car.count;
    }
    if ([[_sectionHeader objectAtIndex:section] isEqualToString:@"StoreAddress"]) {
        return storeAddress.count;
    }
    if ([[_sectionHeader objectAtIndex:section] isEqualToString:@"ShopAddress"]) {
        return shopAddress.count;
    }
    return 0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_sectionHeader objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    if ([[_sectionHeader objectAtIndex:indexPath.section] isEqualToString:@"Car"]) {
        cell.tag = [[[car objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
        cell.textLabel.text = [[car objectAtIndex:indexPath.row] objectForKey:@"vehicle_registration_mark"];
    }
    if ([[_sectionHeader objectAtIndex:indexPath.section] isEqualToString:@"StoreAddress"]) {
        cell.tag = [[[storeAddress objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
        cell.textLabel.text = [[storeAddress objectAtIndex:indexPath.row] objectForKey:@"address"];
    }
    if ([[_sectionHeader objectAtIndex:indexPath.section] isEqualToString:@"ShopAddress"]) {
        cell.tag = [[[shopAddress objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
        cell.textLabel.text = [[shopAddress objectAtIndex:indexPath.row] objectForKey:@"address"];
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = sender;
    QRCodeScannerViewController* controller = [segue destinationViewController];
    controller.actionName = _actionName;
    controller.locationID = [NSNumber numberWithInt:cell.tag];
    controller.locationType = [_sectionHeader objectAtIndex:[self.tableView indexPathForCell:cell].section];
}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
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
