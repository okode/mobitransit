//
//  CustomCell.m
//  Mobitransit_Helsinki
//
//  Created by Daniel Soro Coicaud on 14/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import "CustomCell.h"
#import "Utils.h"

@implementation CustomCell

@synthesize properties;
@synthesize checkButton;
@synthesize stopsButton;
@synthesize routeButton;

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
		self.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
		
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
	
	CGRect frame = CGRectMake(contentRect.origin.x + 40.0, 8.0, contentRect.size.width, 30.0);
	self.textLabel.frame = frame;
	
	UIImage *checkedImage = [Utils getCheckIcon:properties.type];
	frame = CGRectMake(contentRect.origin.x, 0.0, 45, 45);
	checkButton.frame = frame;
	
	UIImage *image = (properties.active) ? checkedImage: [UIImage imageNamed:@"unchecked.png"];
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
	[checkButton setBackgroundImage:newImage forState:UIControlStateNormal];
	
	
	if(self.properties.route != nil){
		UIImage *checkImage = (properties.activeRoute) ? [Utils getRouteIcon:properties.type] : [UIImage imageNamed:@"unselectedRoute.png"];
		routeButton.frame = CGRectMake(contentRect.size.width-50,0,45,45);
		
		[routeButton setBackgroundImage:checkImage forState:UIControlStateNormal];
		[routeButton addTarget:self action:@selector(checkRoute:) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:routeButton];
	}
	
	if([self.properties.stops count] != 0){
		UIImage *checkImage = (properties.activeStops) ? [Utils getStopIcon:properties.type] : [UIImage imageNamed:@"unselectedStop.png"];
		stopsButton.frame = CGRectMake(contentRect.size.width-80,0,45,45);
		
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
	properties.activeChanged = !properties.activeChanged;
	
	UIImage *checkImage = (properties.active) ? [Utils getCheckIcon:properties.type] : [UIImage imageNamed:@"unchecked.png"];
	[checkButton setImage:checkImage forState:UIControlStateNormal];

}

 /*	
 /  @method: checkRoute
 /	@description: Updates the active route state and changes the button image
 /	@param: sender - reference to the cell who sends the action
 */

-(void)checkRoute:(id)sender {
	self.properties.activeRoute = !self.properties.activeRoute;
	properties.activeRouteChanged = !properties.activeRouteChanged;
	
	UIImage *checkImage = (properties.activeRoute) ? [Utils getRouteIcon:properties.type] : [UIImage imageNamed:@"unselectedRoute.png"];
	[routeButton setImage:checkImage forState: UIControlStateNormal];
	
}


/*	
 /  @method: checkStops
 /	@description: Updates the active stops state and changes the button image
 /	@param: sender - reference to the cell who sends the action
 */

-(void)checkStops:(id)sender {
	self.properties.activeStops = !self.properties.activeStops;
	properties.activeStopsChanged = !properties.activeStopsChanged;
	
	UIImage *checkImage = (properties.activeStops) ? [Utils getStopIcon:properties.type] : [UIImage imageNamed:@"unselectedStop.png"];
	[stopsButton setImage:checkImage forState: UIControlStateNormal];
	
}

- (void)dealloc {
	[routeButton release];
	[checkButton release];
	[stopsButton release];
	[properties release];
    [super dealloc];
}


@end
