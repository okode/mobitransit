//
//  DetailTableViewController.m
//  Mobitransit_Helsinki
//
//  Created by Daniel Soro Coicaud on 14/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import "DetailTableViewController.h"
#import "CustomCell.h"


@implementation DetailTableViewController

@synthesize tramwayLines, busLines, taxiLines, subwayLines;
@synthesize orderedLines, lineNames, delegate;

#pragma mark -
#pragma mark View lifecycle

 /*	
 /  @method: viewWillDisappear
 /	@description: Managed by the UITableViewControllerDelegate. Warns the AppDelegate to create a new stomp filtering
 /	@param: animated. 
 */

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	[delegate finishListProperties];
}


#pragma mark -
#pragma mark Table view data source

 /*	
 /  @method: numberOfSectionsInTableView
 /	@description: Managed by the UITableViewControllerDelegate. Indicates the number of sections
 /	@param: tableView. 
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [orderedLines count];
}

 /*	
 /	@method: tableView:numberOfRowsInSection
 /	@description: Managed by the UITableViewControllerDelegate. Indicates the number of rows for each section
 /  @param: tableView. 
 /  @param: section. 
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[orderedLines objectAtIndex:section] count];
}

 /*	
 /  @method: tableView:didSelectRowAtIndexPath
 /	@description: Managed by the UITableViewControllerDelegate. Deselects/selects a indexed line
 /  @param: tableView. 
 /	@param: indexPath - has information about the row and section selected 
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	CustomCell *targetCustomCell = (CustomCell *)[tableView cellForRowAtIndexPath:indexPath];
	[targetCustomCell checkAction:nil];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

 /*	
 /  @method: tableView:cellForRowAtIndexPath
 /	@description: Managed by the UITableViewControllerDelegate. Specifies the cells' design
 /  @param: tableView. 
 /  @param: indexPath - has information about the row and section selected 
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *kCustomCellID = @"MyCellID";
	CustomCell *cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID] autorelease];
	cell.properties = [[orderedLines objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	cell.textLabel.text = [cell title];
    	
	return cell;
}

 /*	
 /  @method: tableView:titleForHeaderInSection
 /	@description: Managed by the UITableViewControllerDelegate. Indicates the title fo a section
 /	@param: tableView. 
 /  @param: section.
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return [lineNames objectAtIndex:section];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload { }


- (void)dealloc {
	[busLines release];
	[tramwayLines release];
	[subwayLines release];
	[taxiLines release];
	[orderedLines release];
	[lineNames release];
    [super dealloc];
}


@end

