//
//  StopProperties.m
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 13/10/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import "StopProperties.h"


@implementation StopProperties

@synthesize stopId, secondId, name, coordinate, lines, type;

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
	return [NSString stringWithFormat:@"\n%@ - (%f,%f) Id: %d, 2id: %d.\nUsed by %d lines.",name,coordinate.latitude,coordinate.longitude,stopId,secondId,[lines count]];	
}


-(void)dealloc{
	[name release];
	[lines release];
	[super dealloc];
}

@end
