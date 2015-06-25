//
//  MultipleOverlays.h
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 30/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MultipleOverlays : NSObject <MKOverlay>{
	NSArray *_polygons;
	MKMapRect _boundingMapRect;
}

- (id)initWithPolyLines:(NSArray *)shapes;

@property (nonatomic, retain) NSArray *polygons;

@end
