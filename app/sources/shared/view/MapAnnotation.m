//
//  MapAnnotation.m
//  Mobitransit_Helsinki
//
//  Created by Daniel Soro Coicaud on 15/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

@synthesize properties;
@synthesize image;
@synthesize orientImage;
@synthesize coordinate;
@synthesize lineName;

 /*	
 /	@method: initWithCoordinate
 /	@description: Annotation's coordinate initialization
 /	@param: c - coordinate to set
 /	@return: id - self reference
 */
-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	properties.coordinate = c;
	return self;
}

 /*	
 /	@method: setCoordinate
 /	@description: the current coordinate to set on the annotation. Updates the model's coordinate
 /	@param: newCoordinate - coordinate to set
 */
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
	coordinate = newCoordinate;
	properties.coordinate = newCoordinate;
}

 /*	
 /  @method: title
 /  @description: returns the annotation title (showed at the pop-up)
 /	@return: NSString - marker customized title.
 */
-(NSString *)title{
	return [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"LINE", @""),properties.line.name];
	//return properties.line.name;
}

 /*	
 /	@method: subtitle
 /  @description: returns the annotation subtitle (showed at the pop-up)
 /  @return: NSString - marker's plate number
 */
-(NSString *)subtitle{
	return properties.numberPlate;
}


- (void)dealloc{
	[properties release];
    [image release];
	[orientImage release];
	[lineName release];
    [super dealloc];
}

@end
