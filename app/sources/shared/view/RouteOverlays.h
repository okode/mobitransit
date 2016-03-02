//
//  RouteOverlay.h
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 29/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKOverlay.h>


@interface RouteOverlays : NSObject <MKOverlay>{
	NSArray *routes;
	NSArray *colors;
	
	MKMapRect _boundingMapRect;
}

- (id)initWithPolyLines:(NSArray *)polylines withColors:(NSArray *)routeColors;

@property (nonatomic, retain) NSArray *routes;
@property (nonatomic, retain) NSArray *colors;

@end
