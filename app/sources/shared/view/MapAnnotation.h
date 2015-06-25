//
//  MapAnnotation.h
//  Mobitransit_Helsinki
//
//  Created by Daniel Soro Coicaud on 15/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MarkerProperties.h"

@class MarkerProperties;

@interface MapAnnotation : NSObject <MKAnnotation> {
	
	MarkerProperties *properties;
	
	CLLocationCoordinate2D coordinate;
	
	UIImage *image;
	UIImageView *orientImage;
	UILabel *lineName;

}


-(void)setCoordinate:(CLLocationCoordinate2D)newLocation;
-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) MarkerProperties *properties;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImageView *orientImage;
@property (nonatomic, retain) UILabel *lineName;

@end
