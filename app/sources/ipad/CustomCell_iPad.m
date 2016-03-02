//
//  CustomCell.m
//  Mobitransit_Helsinki
//
//  Created by Daniel Soro Coicaud on 14/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import "CustomCell_iPad.h"
#import "Utils.h"

@implementation CustomCell_iPad

@synthesize properties;
@synthesize checkButton;
@synthesize routeButton;
@synthesize stopsButton;
@synthesize table;

 /*	
 /	@method: initWithStyle:reuseIdentifier
 /	@description: Design initialization for a cell
 /  @param: style. 
 /  @param: reuseIdentifier.
 /  @return: id - self reference.
 */

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
		self.textLabel.backgroundColor = self.backgroundColor;
		self.textLabel.opaque = NO;
		self.textLabel.textColor = [UIColor blackColor];
		self.textLabel.highlightedTextColor = [UIColor whiteColor];
		self.textLabel.font = [UIFont boldSystemFontOfSize:19.0];
		
		checkButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		checkButton.frame = CGRectZero;
		checkButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		checkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		[checkButton addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchDown];
		checkButton.backgroundColor = self.backgroundColor;
		[self.contentView addSubview:checkButton];
		
		routeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		routeButton.frame = CGRectZero;
		routeButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		routeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
		routeButton.backgroundColor = self.backgroundColor;
		[self.contentView addSubview:routeButton];
		
		stopsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		stopsButton.frame = CGRectZero;
		stopsButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		stopsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
		stopsButton.backgroundColor = self.backgroundColor;
		[self.contentView addSubview:stopsButton];
		
		[self setSelectionStyle:UITableViewCellSelectionStyleGray];
	}
	return self;
}

 /*	
 /	@method: layoutSubviews
 /	@description: Adds style design for the title and the button image.
 */

- (void)layoutSubviews {
	
	[super layoutSubviews];
	CGRect contentRect = [self.contentView bounds];
	
	CGRect frame = CGRectMake(contentRect.origin.x + 60.0, 0.0, contentRect.size.width, 40.0);
	self.textLabel.frame = frame;
	
	UIImage *checkedImage = [Utils getCheckIcon:properties.type];
	frame = CGRectMake(contentRect.origin.x, -8.0, 57, 57);
	checkButton.frame = frame;
	
	UIImage *image = (properties.active) ? checkedImage: [UIImage imageNamed:@"unchecked.png"];
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
	[checkButton setBackgroundImage:newImage forState:UIControlStateNormal];
	
	
	if(self.properties.route != nil){
		UIImage *checkImage = (properties.activeRoute) ? [Utils getRouteIcon:properties.type] : [UIImage imageNamed:@"unselectedRoute.png"];
		routeButton.frame = CGRectMake(contentRect.size.width-50,-8,57,57);
		
		[routeButton setBackgroundImage:checkImage forState:UIControlStateNormal];
		[routeButton addTarget:self action:@selector(checkRoute:) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:routeButton];
	}
	
	if([self.properties.stops count] != 0){
		UIImage *checkImage = (properties.activeStops) ? [Utils getStopIcon:properties.type] : [UIImage imageNamed:@"unselectedStop.png"];
		stopsButton.frame = CGRectMake(contentRect.size.width-90,-8,57,57);
		
		[stopsButton setBackgroundImage:checkImage forState:UIControlStateNormal];
		[stopsButton addTarget:self action:@selector(checkStops:) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:stopsButton];
	}
}

 /*	
 /  @method: title
 /	@description: returns the customized title for the current cell
 /	@return: NSString - cell's title
 */

-(NSString *)title{
	return [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"LINE", @""),properties.name];
}

 /*	
 /  @method: checkAction
 /	@description: Updates the active state and changes the cell image
 /	@param: sender - reference to the cell who sends the action
 */

- (void)checkAction:(id)sender {
	properties.active = !properties.active;
	UIImage *checkImage = (properties.active) ? [Utils getCheckIcon:properties.type] : [UIImage imageNamed:@"unchecked.png"];
	[checkButton setImage:checkImage forState:UIControlStateNormal];
	[table lineSelection];
}

 /*	
 /  @method: checkRoute
 /	@description: Updates the active route state and changes the button image
 /	@param: sender - reference to the cell who sends the action
 */

-(void)checkRoute:(id)sender {
	self.properties.activeRoute = !self.properties.activeRoute;
	UIImage *checkImage = (properties.activeRoute) ? [Utils getRouteIcon:properties.type] : [UIImage imageNamed:@"unselectedRoute.png"];
	[routeButton setImage:checkImage forState: UIControlStateNormal];
	[table routeSelection];
	
}

 /*	
 /  @method: checkStops
 /	@description: Updates the active stops state and changes the button image
 /	@param: sender - reference to the cell who sends the action
 */

-(void)checkStops:(id)sender {
	self.properties.activeStops = !self.properties.activeStops;
	UIImage *checkImage = (properties.activeStops) ? [Utils getStopIcon:properties.type] : [UIImage imageNamed:@"unselectedStop.png"];
	[stopsButton setImage:checkImage forState: UIControlStateNormal];
	[table stopSelection];
}


- (void)dealloc {
	[routeButton release];
	[checkButton release];
	[stopsButton release];
	[properties release];
	[table release];
    [super dealloc];
}


@end
