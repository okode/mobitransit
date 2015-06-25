//
//  LineProperties.m
//  Mobitransit_Helsinki
//
//  Created by Daniel Soro Coicaud on 18/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import "LineProperties.h"

NSString * const kActive		= @"Active";
NSString * const kInactive		= @"Inactive";

NSString * const kBuses			= @"buses";
NSString * const kTramways		= @"tramways";
NSString * const kSubways		= @"subways";
NSString * const kTaxis			= @"taxis";
NSString * const kTypeUnknown	= @"unknow type";

NSString * const kShowingRoute	= @"showing route";
NSString * const kHidingRoute	= @"hiding route";
NSString * const kFixedColor	= @"Fixed color";
NSString * const kWithoutColor	= @"Without color";

@implementation LineProperties

@synthesize active;
@synthesize type;
@synthesize name;
@synthesize image;
@synthesize route;
@synthesize color;
@synthesize activeRoute;
@synthesize stops;
@synthesize activeStops;
@synthesize order;
@synthesize activeChanged;
@synthesize activeRouteChanged;
@synthesize activeStopsChanged;

 /*
 /	@method: description
 /	@description: Returns the String description of the instance.
 /	@return: NSString - Instance description.
 */

-(NSString*) description{
	
	NSString *actL = (active) ? kActive : kInactive;
	NSString *typL;
	switch (type) {
		case BUS:		typL = kBuses;			break;
		case TRAMWAY:	typL = kTramways;		break;
		case SUBWAY:	typL = kSubways;		break;
		case TAXI:		typL = kTaxis;			break;
		default:		typL = kTypeUnknown;	break;
	}
	
	NSString *actR = (activeRoute) ? kShowingRoute : kHidingRoute;
	NSString *colR = (color != nil) ? kFixedColor : kWithoutColor;
	
	if(route != nil){
		NSString *message = [NSString stringWithFormat:@"%@ %@ from %@,Specified route - %@: %@",actL,typL,name,actR,colR];
		return [NSString stringWithFormat:@"%@\nStops: %d",message,[stops count]];
	}else{
		return [NSString stringWithFormat:@"%@ %@ from %@,Unnespecified Route - %@",actL,typL,name,actR];
	}
}

-(void) dealloc{
	[name release];
	[image release];
	[color release];
	[route release];
	[stops release];
    [super dealloc];
}

@end
