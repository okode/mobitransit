//
//  MultipleOverlays.m
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 30/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import "MultipleOverlays.h"


@implementation MultipleOverlays

@synthesize polygons = _polygons;

/*	
 /   @method: initWithPolyLines:shapes
 /	 @description: Initializes the multipleOverlays instance.
 /	 @param: shapes - polylines array.
 /	 @return: id - self reference.
 */

- (id)initWithPolyLines:(NSArray *)shapes{
    if ((self = [super init])) {
        _polygons = shapes;
		[_polygons retain];
	
        NSUInteger polyCount = [_polygons count];
        if (polyCount) {
            _boundingMapRect = [[_polygons objectAtIndex:0] boundingMapRect];
            NSUInteger i;
            for (i = 1; i < polyCount; i++) {
                _boundingMapRect = MKMapRectUnion(_boundingMapRect, [[_polygons objectAtIndex:i] boundingMapRect]);
            }
        }
    }
    return self;
}

- (void)dealloc
{
    [_polygons release];
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
