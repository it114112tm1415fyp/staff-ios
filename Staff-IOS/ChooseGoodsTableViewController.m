//
//  ChooseGoodsTableViewController.m
//  Staff-IOS
//
//  Created by Patrick Lo on 15/12/14.
//  Copyright (c) 2014 1415FYP. All rights reserved.
//

#import "ChooseGoodsTableViewController.h"
#import "HTTP6y.h"
#import "Good.h"
#import "GoodDetailViewController.h"

@interface ChooseGoodsTableViewController (){
    NSMutableArray *listOfGoods;
}

@end

@implementation ChooseGoodsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[[NSThread alloc] initWithTarget:self selector:@selector(goodsGetListThreadMain) object:nil] start];
    [self.tableView reloadData];
}

- (void) goodsGetListThreadMain {
    NSDictionary *result = [HTTP6y goodGetList];
    [self performSelectorOnMainThread:@selector(goodsGetListThreadUpdateUI:) withObject:result waitUntilDone:NO];
}

-(void) goodsGetListThreadUpdateUI:(NSDictionary*)result {
    if ([[result objectForKey:@"success"] isEqual:@(YES)]) {
        NSMutableArray *ls = [NSMutableArray new];
        NSMutableArray *list = [[NSMutableArray alloc] initWithArray:[result objectForKey:@"list"]];
        for (int i = 0; i < [list count]; i++) {
            Good *good = [Good new];
            NSDictionary *data = [list objectAtIndex:i];
            good.goodID = [data objectForKey:@"good_id"];
            good.orderID = [data objectForKey:@"order_id"];
            good.rfid = [data objectForKey:@"rfid_tag"];
            good.departure = [data objectForKey:@"departure"];
            good.destination = [data objectForKey:@"destination"];
            good.weigth = [data objectForKey:@"weight"];
            NSString *fragile;
            NSString *flammable;
            if ([[data objectForKey:@"fragile"] intValue] == 0)
                fragile = @"NO";
            else if ([[data objectForKey:@"fragile"] intValue] == 1)
                fragile = @"YES";
            if ([[data objectForKey:@"flammable"] intValue] == 0)
                flammable = @"NO";
            else if ([[data objectForKey:@"flammable"] intValue] == 1)
                flammable = @"YES";
            good.fragile = fragile;
            good.flammable = flammable;
            NSDateFormatter *getDateFormat = [[NSDateFormatter alloc] init];
            [getDateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'000Z'"];
            NSDate *date = [getDateFormat dateFromString:[data objectForKey:@"order_time"]];
            good.createdTime = date;
            good.location = [data objectForKey:@"location"];
            good.locationType = [data objectForKey:@"location_type"];
            good.lastAction = [data objectForKey:@"last_action"];
            NSLog(@"good:%@", data);
            [ls addObject:good];
            listOfGoods = ls;
        }
        [self.tableView reloadData];
    } else if ([[result objectForKey:@"error_handled"] isEqual:@(NO)]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[result objectForKey:@"error"] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:true completion:nil];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [listOfGoods count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.tag = [((Good*)[listOfGoods objectAtIndex:indexPath.row]).goodID integerValue];
    cell.textLabel.text = [@"Good " stringByAppendingString:[((Good*)[listOfGoods objectAtIndex:indexPath.row]).goodID stringValue]];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    GoodDetailViewController* nextViewController = [segue destinationViewController];
    UITableViewCell *cell = sender;
    nextViewController.good = [listOfGoods objectAtIndex:cell.tag - 1];
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
