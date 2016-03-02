//
//  RootViewController_iPad.h
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 01/10/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MobitransitDelegate.h"
#import "RouteOverlays.h"
#import "Utils.h"


@interface RootViewController_iPad : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, MKMapViewDelegate> {

	UIPopoverController *popoverController;
    MKMapView *mapView;
	UISegmentedControl *segControl;
	UIBarItem *okodeInfo;
	UIBarItem *locationButton;
	
	NSDictionary *mapAnnotations;
	NSDictionary *stopAnnotations;
	
	id <MobitransitDelegate> delegate;
	Utils *utils;
	
	BOOL adjustView;
	RouteOverlays* overlays;
	
	BOOL locationEnabled;
	BOOL locationRequested;
	UIActivityIndicatorView *activityLoader;
	
	UIButton *pressedButton;
	UIImageView *stompLight;
	
}

-(IBAction)changeMapType:(id)sender;
-(void)initLocation;
-(void)loadInfo;
-(void)initLocation;
-(void)setLatitude:(float)latitude andLongitude:(float)longitude;
-(IBAction)showUserLocation;
-(void)showStopInformation:(id)sender;
-(void)delayStopInfo:(NSTimer*)theTimer;

-(void)updateAnnotations;
-(void)updateMarker:(NSString*)nPlate;
-(void)updateOverlays;
-(void)updateStops;
-(void)deselectMarker:(NSString*)nPlate;
-(void)removeOverlays;
-(void)enableButtons;
-(void)disableUserLocation;
-(void)enableUserLocationButton;
-(void)disableUserLocationButton;

-(void)stompConnectionStart;
-(void)stompConnectionStop;

-(IBAction)showOkodeInfo;

@property (nonatomic, retain) UIPopoverController *popoverController;

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segControl;
@property (nonatomic, retain) IBOutlet UIBarItem *okodeInfo;
@property (nonatomic, retain) IBOutlet UIBarItem *locationButton;
@property (nonatomic, retain) NSDictionary *mapAnnotations;
@property (nonatomic, retain) NSDictionary *stopAnnotations;
@property (nonatomic, assign) id <MobitransitDelegate> delegate;
@property (nonatomic, retain) Utils *utils;
@property (nonatomic, assign) BOOL adjustView;
@property (nonatomic, retain) RouteOverlays *overlays;
@property (nonatomic, assign) BOOL locationEnabled;
@property (nonatomic, assign) BOOL locationRequested;
@property (nonatomic, retain) UIButton *pressedButton;
@property (nonatomic, retain) IBOutlet UIImageView *stompLight;
@property (nonatomic, retain) UIActivityIndicatorView *activityLoader;

@end
