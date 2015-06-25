//
//  DetailTableViewController_iPad.m
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 01/10/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import "DetailTableViewController_iPad.h"
#import "CustomCell_iPad.h"


@implementation DetailTableViewController_iPad

@synthesize firstView;
@synthesize tramwayLines, busLines, taxiLines, subwayLines;
@synthesize orderedLines, lineNames, delegate;

#pragma mark -
#pragma mark View lifecycle

 /*	
 /  @method: viewDidLoad
 /	@description: Managed by the UITableViewControllerDelegate. The View Did load, used to initialization
 /	@param: animated. 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
	self.clearsSelectionOnViewWillAppear = YES;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	[[self navigationController] navigationBar].barStyle = UIBarStyleBlackOpaque;
}

 /*	
 /  @method: viewWillAppear
 /	@description: Managed by the UITableViewControllerDelegate. Called when the table view is going to appear. Used initialize navigator properties.
 /	@param: animated. 
 */

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self setTitle:NSLocalizedString(@"LINES",@"")];
	[[self navigationController] navigationBar].barStyle = UIBarStyleBlackOpaque;
}

#pragma mark -
#pragma mark Customized methods

 /*	
 /  @method: lineSelection
 /	@description: Used to delegate the line selection functionality on AppDelegate.
 */

-(void)lineSelection{
	[delegate lineSelection];
}

 /*	
 /  @method: routeSelection
 /	@description: Used to delegate the route selection functionality on AppDelegate.
 */

-(void)routeSelection{
	[delegate routeSelection];
}

/*	
 /  @method: stopSelection
 /	@description: Used to delegate the stop selection functionality on AppDelegate.
 */

-(void)stopSelection{
	[delegate stopSelection];
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
 /  @method: tableView:cellForRowAtIndexPath
 /	@description: Managed by the UITableViewControllerDelegate. Specifies the cells' design
 /  @param: tableView. 
 /  @param: indexPath - has information about the row and section selected 
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *kCustomCellID = @"MyCellID";
	CustomCell_iPad *cell = [[[CustomCell_iPad alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID] autorelease];
	cell.table = self;
	cell.properties = [[orderedLines objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	cell.textLabel.text = [cell title];
    
    return cell;
}

 /*	
 /  @method: tableView:heightForRowAtIndexPath
 /	@description: Managed by the UITableViewControllerDelegate. Specifies the cells' height
 /  @param: tableView. 
 /  @param: indexPath - has information about a row and section
 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {  
    return 40.0;
} 

#pragma mark -
#pragma mark Table view delegate

 /*	
 /  @method: tableView:didSelectRowAtIndexPath
 /	@description: Managed by the UITableViewControllerDelegate. Deselects/selects a indexed line
 /  @param: tableView. 
 /	@param: indexPath - has information about the row and section selected 
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	CustomCell_iPad *targetCustomCell = (CustomCell_iPad *)[tableView cellForRowAtIndexPath:indexPath];
	[targetCustomCell checkAction:nil];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self lineSelection];
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

- (void)viewDidUnload {}


- (void)dealloc {
	[firstView release];
	[busLines release];
	[tramwayLines release];
	[subwayLines release];
	[taxiLines release];
	[orderedLines release];
	[lineNames release];
    [super dealloc];
}


@end

