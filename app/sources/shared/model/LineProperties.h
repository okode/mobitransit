//
//  LineProperties.h
//  Mobitransit_Helsinki
//
//  Created by Daniel Soro Coicaud on 18/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKPolyline.h>
#import "Utils.h"

@interface LineProperties : NSObject {
	
	BOOL active;
	TransportType type;
	NSString *name;
	UIImage *image;
	
	MKPolyline *route;
	UIColor *color;
	BOOL activeRoute;
	
	NSArray *stops;
	BOOL activeStops;
	
	int order;
	BOOL activeChanged;
	BOOL activeRouteChanged;
	BOOL activeStopsChanged;

}

#pragma mark LineProperties properties

@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) TransportType type;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) UIImage *image;

@property (nonatomic, retain) MKPolyline *route;
@property (nonatomic, retain) UIColor *color;
@property (nonatomic, assign) BOOL activeRoute;
@property (nonatomic, retain) NSArray *stops;
@property (nonatomic, assign) BOOL activeStops;
@property (nonatomic, assign) int order;
@property (nonatomic, assign) BOOL activeChanged;
@property (nonatomic, assign) BOOL activeRouteChanged;
@property (nonatomic, assign) BOOL activeStopsChanged;

@end
