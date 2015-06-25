//
//  StopAnnotation.h
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 13/10/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "StopProperties.h"


@interface StopAnnotation : NSObject <MKAnnotation> {
	StopProperties *properties;
	CLLocationCoordinate2D coordinate;
}

-(void)setCoordinate:(CLLocationCoordinate2D)newLocation;

@property (nonatomic, retain) StopProperties *properties;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
