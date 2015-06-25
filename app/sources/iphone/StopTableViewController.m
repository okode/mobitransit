//
//  StopTableViewController.m
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 14/10/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import "StopTableViewController.h"
#import "StopCell.h"
#import "MobitransitDelegate.h"

@implementation StopTableViewController

@synthesize stopInfo, type, utils, firstStops, currentStopId;

-(void)viewDidLoad{
	[super viewDidLoad];
	double elapsedTime = [utils elapsedTrackTime];
	if(currentStopId == nil){currentStopId = @"Not Identified";}
	NSString *description = [NSString stringWithFormat:@"Checking schedule from stop: %@",currentStopId];
	[Utils trackEvent:kStopCategory forAction:kScheduleAction withDescription:description withValue:(int)elapsedTime];
}

#pragma mark -
#pragma mark Table view data source

 /*	
 /  @method: numberOfSectionsInTableView
 /	@description: Managed by the UITableViewControllerDelegate. Indicates the number of sections
 /	@param: tableView. 
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

 /*	
 /	@method: tableView:numberOfRowsInSection
 /	@description: Managed by the UITableViewControllerDelegate. Indicates the number of rows for each section
 /  @param: tableView. 
 /  @param: section. 
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [stopInfo count]-1;
}

 /*	
 /  @method: tableView:cellForRowAtIndexPath
 /	@description: Managed by the UITableViewControllerDelegate. Specifies the cells' design and attributes
 /  @param: tableView. 
 /  @param: indexPath - has information about the row and section selected 
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    StopCell *cell = (StopCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[StopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	cell.hour.text = [[stopInfo objectAtIndex:indexPath.row +1] objectForKey: @"hour"];
	cell.line.text = [[stopInfo objectAtIndex:indexPath.row +1] objectForKey: @"line"];
	cell.destination.text = [[stopInfo objectAtIndex:indexPath.row +1] objectForKey: @"destination"];
	cell.imgDecor.image = [utils getLineImage:type];
    
    return cell;
}

 /*	
 /  @method: tableView:titleForHeaderInSection
 /	@description: Managed by the UITableViewControllerDelegate. Indicates the title fo a section
 /	@param: tableView. 
 /  @param: section.
 */

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return [stopInfo objectAtIndex:0];
}

#pragma mark -
#pragma mark Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { }

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
	[currentStopId release];
	[stopInfo release];
    [super dealloc];
}


@end

