//
//  StopProperties.h
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 13/10/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Utils.h"

@interface StopProperties : NSObject {
	
	int stopId;
	int secondId;
	TransportType type;
	NSString *name;
	CLLocationCoordinate2D coordinate;
	NSArray *lines;	

}

-(void) parseLatitude:(float)lat andLongitude:(float)lon;

@property (nonatomic, assign) int stopId;
@property (nonatomic, assign) int secondId;
@property (nonatomic, assign) TransportType type;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *lines;

@end
