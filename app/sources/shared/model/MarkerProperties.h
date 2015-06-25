//
//  MarkerProperties.h
//  Mobitransit_Helsinki
//
//  Created by Daniel Soro Coicaud on 18/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "LineProperties.h"

@interface MarkerProperties : NSObject {

	NSString *numberPlate;
	int orientation;
	CLLocationCoordinate2D coordinate;
	LineProperties *line;
	
}

#pragma mark MarkerProperties methods

-(void) parseLatitude:(float)latitude andLongitude:(float)longitude;

#pragma mark MarkerProperties properties

@property (nonatomic, retain) NSString *numberPlate;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) int orientation;
@property (nonatomic, retain) LineProperties *line;

@end
