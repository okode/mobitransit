//
//  RouteOverlay.m
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 29/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import "RouteOverlays.h"


@implementation RouteOverlays

@synthesize routes;
@synthesize colors;

 /*	
 /   @method: initWithPolyLines:withColors
 /	 @description: Initializes the routeOverlays instance.
 /	 @param: polylines - route lines array.
 /	 @param: routeColors - colors array.
 /	 @return: id - self reference.
 */

- (id)initWithPolyLines:(NSArray *)polylines withColors:(NSArray *)routeColors{
	if((self = [super init])) {
		routes = polylines;
		colors = routeColors;
        
        [routes retain];
        [colors retain];
		
		NSUInteger polyCount = [routes count];
        if (polyCount) {
            _boundingMapRect = [[routes objectAtIndex:0] boundingMapRect];
            NSUInteger i;
            for (i = 1; i < polyCount; i++) {
                _boundingMapRect = MKMapRectUnion(_boundingMapRect, [[routes objectAtIndex:i] boundingMapRect]);
            }
        }		
		
	}
	return self;
}

-(void)dealloc{
	[routes release];
	[colors release];
	[super dealloc];
}

- (MKMapRect)boundingMapRect
{
    return _boundingMapRect;
}

- (CLLocationCoordinate2D)coordinate
{
    return MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMidX(_boundingMapRect), MKMapRectGetMidY(_boundingMapRect)));
}


@end
