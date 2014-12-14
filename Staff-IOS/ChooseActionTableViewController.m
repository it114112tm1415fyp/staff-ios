//
//  TestTableViewController.m
//  Staff-IOS
//
//  Created by Patrick Lo on 11/12/14.
//  Copyright (c) 2014 1415FYP. All rights reserved.
//

#import "ChooseActionTableViewController.h"
#import "QRCodeScannerViewController.h"
#import "HTTP6y.h"

@interface ChooseActionTableViewController (){
    NSArray *action;
    NSArray *menu;
    NSInteger selectionIndex;
    NSArray *car;
    NSArray *storeAddress;
    NSArray *shopAddress;
}

@end

@implementation ChooseActionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[[NSThread alloc] initWithTarget:self selector:@selector(conveyorGetListThreadMain) object:nil] start];
    action = @[@"inspect", @"warehouse", @"leave", @"load", @"unload", @"receive", @"issue"];
    NSArray *location = [storeAddress arrayByAddingObjectsFromArray:shopAddress];
    menu = @[storeAddress, location, location, car, car, @[], @[]];
}

- (void) conveyorGetListThreadMain {
    NSDictionary *result = [HTTP6y addressGetList];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[result objectForKey:@"success"] isEqual:@(YES)]) {
            car = [[NSMutableArray alloc] initWithArray:[result objectForKey:@"car"]];
            storeAddress = [[NSMutableArray alloc] initWithArray:[result objectForKey:@"storeAddress"]];
            shopAddress = [[NSMutableArray alloc] initWithArray:[result objectForKey:@"shopAddress"]];
        } else if ([[result objectForKey:@"error_handled"] isEqual:@(NO)]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[result objectForKey:@"error"] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:true completion:nil];
        }
        [self.tableView reloadData];
    });
}

- (void)viewWillAppear:(BOOL)animated{
    selectionIndex = NSIntegerMax;
    [self.tableView reloadData];
}

- (NSArray*)submenu {
    if (selectionIndex == NSIntegerMax)
        return @[];
    else
        return [menu objectAtIndex:selectionIndex];
}

- (NSArray*)submenu:(NSInteger) index {
    return [menu objectAtIndex:index];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return action.count + [self submenu].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row > selectionIndex && indexPath.row <= selectionIndex + [self submenu].count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Submenu" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"\t%@", [((NSDictionary*)[[self submenu] objectAtIndex:indexPath.row - selectionIndex - 1]) objectForKey:@""]];
        return cell;
    } else {
        NSInteger actionIndex = indexPath.row - ( indexPath.row > selectionIndex ? [self submenu].count : 0 );
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self submenu:actionIndex].count == 0 ? @"Submenu" : @"Action" forIndexPath:indexPath];
        cell.textLabel.text = [action objectAtIndex:actionIndex];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectionIndex = selectionIndex == indexPath.row ? NSIntegerMax : indexPath.row - ( indexPath.row > selectionIndex ? [self submenu].count : 0 );
    _selectedAction = selectionIndex == NSIntegerMax ? nil : [action objectAtIndex:selectionIndex];
    _selectedActionType = selectionIndex;
    _selectedLocationType = indexPath.row - ( indexPath.row > selectionIndex ? [self submenu].count : 0 );
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    QRCodeScannerViewController* controller = [segue destinationViewController];
    UITableViewCell *cell = sender;
    controller.chooseActionController = self;
    _selectedLocation = cell.textLabel.text;
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
