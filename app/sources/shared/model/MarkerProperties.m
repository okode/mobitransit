//
//  MarkerProperties.m
//  Mobitransit_Helsinki
//
//  Created by Daniel Soro Coicaud on 18/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import "MarkerProperties.h"


@implementation MarkerProperties

@synthesize numberPlate;
@synthesize orientation;
@synthesize coordinate;
@synthesize line;

 /*
 /	@method: parseLatitude:andLongitude:
 /	@description: Sets the latitude and longitude params on the marker's coordinate
 /	@param: lat - Latitude.
 /	@param: lon - Longitude.
 */

-(void) parseLatitude:(float)lat andLongitude:(float)lon{
	coordinate.latitude = lat;
	coordinate.longitude = lon;
}

 /*
 /	@method: description
 /	@description: Returns the String description of the instance.
 /	@return: NSString - Instance description.
 */

-(NSString*) description{
	return [NSString stringWithFormat:@"\n%@ - (%f,%f) Orientation: %d.\n%@",numberPlate,coordinate.latitude,coordinate.longitude,orientation,line];	
}

-(void) dealloc{
	[numberPlate release];
	[line release];
    [super dealloc];
}

@end
