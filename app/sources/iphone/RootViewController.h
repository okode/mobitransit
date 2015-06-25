//
//  RootViewController.h
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 24/09/10.
//  Copyright Okode S.L. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MobitransitDelegate.h"
#import "RouteOverlays.h"
#import "Utils.h"
#import "ShareMessageController.h"
#import "ActivityIndicator.h"

@interface RootViewController : UIViewController <MKMapViewDelegate,MKReverseGeocoderDelegate> {
	
	MKMapView *mapView;
	
	NSDictionary *mapAnnotations;
	NSDictionary *stopAnnotations;
	
	id <MobitransitDelegate> delegate;
	Utils *utils;
	
	BOOL adjustView;
	RouteOverlays* overlays;
	UIInterfaceOrientation orientation;
	
	BOOL locationRequested;
	
	ShareMessageController *shareView;
	
    MKPlacemark *placemark;
	
}

-(void)loadInfo;
-(void)initLocation;
-(void)setLatitude:(float)latitude andLongitude:(float)longitude;
-(void)updateAnnotations;
-(void)updateMarker:(NSString*)nPlate;
-(void)updateOverlays;
-(void)deselectMarker:(NSString*)nPlate;
-(void)removeOverlays;
-(void)disableUserLocation;
-(void)showStopInformation:(id)sender;
-(void)delayStopInfo:(NSTimer*)theTimer;
-(void)changeUserLocationTo:(BOOL)enable;

-(void)mapTypeNormal;
-(void)mapTypeSatellite;
-(void)mapTypeHybrid;

-(void)loadShareMessageView;
-(void)loadSharePositionView;

-(NSString*)currentCityName;
-(NSString*)currentStreetName;
-(NSString*)currentNumber;

-(void)reverseGeocoderCurrentLocation;


@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSDictionary *mapAnnotations;
@property (nonatomic, retain) NSDictionary *stopAnnotations;
@property (nonatomic, assign) id <MobitransitDelegate> delegate;
@property (nonatomic, retain) Utils *utils;
@property (nonatomic, assign) BOOL adjustView;
@property (nonatomic, assign) BOOL locationRequested;
@property (nonatomic, retain) RouteOverlays *overlays;
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@property (nonatomic, retain) IBOutlet ShareMessageController *shareView;
@property (nonatomic, retain) MKPlacemark *placemark;

@end
