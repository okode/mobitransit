    //
//  RootViewController_iPad.m
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 01/10/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import "RootViewController_iPad.h"
#import "MapAnnotation.h"
#import "StopAnnotation.h"
#import "RouteOverlays.h"
#import "RouteOverlayView.h"
#import "DecorationOverlayView.h"
#import "MultipleOverlays.h"

@implementation RootViewController_iPad

@synthesize popoverController;

@synthesize mapView;
@synthesize segControl;
@synthesize mapAnnotations;
@synthesize stopAnnotations;
@synthesize delegate;
@synthesize utils;
@synthesize adjustView;
@synthesize overlays;
@synthesize okodeInfo;
@synthesize locationButton;
@synthesize locationEnabled;
@synthesize locationRequested;
@synthesize activityLoader;
@synthesize pressedButton;
@synthesize stompLight;


#pragma mark -
#pragma mark Split view support

 /*	
 /   @method: splitViewController:willHideViewController:withBarButtonItem:forPopoverController:
 /	 @description: Called when the device will change orientation to Portrait, hidding the DetailTableViewController and showing the navigationBar button.
 /	 @param: svc - current splitViewController.
 /	 @param: aViewController - viewController to hide (DetailTable)
 /	 @param: barButton - button to create on the navigation bar.
 /	 @param: pc - current popoverController.
 */

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = NSLocalizedString(@"LINES",@"");
	[[self navigationItem] setLeftBarButtonItem:barButtonItem];
	[self setPopoverController:pc];

}

 /*	
 /   @method: splitViewController:willShowViewController:invalidatingBarButtonItem:
 /	 @description: Called when the device will change orientation to Landscape, showing the DetailTableViewController and removing the navigationBar button.
 /	 @param: svc - current splitViewController.
 /	 @param: aViewController - viewController to show (DetailTable)
 /	 @param: barButton - button to remove on the navigation bar.
 */

- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	
	[[self navigationItem] setLeftBarButtonItem:nil];
	[self setPopoverController:nil];

}

#pragma mark -
#pragma mark Application lifecycle

 /*	
 /   @method: viewDidLoad
 /	 @description: Called when the view has just been loaded.
 */

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setTitle:@"Mobitransit Helsinki"];
	[[self navigationController] navigationBar].barStyle = UIBarStyleBlackOpaque;
	
	[segControl setTitle:NSLocalizedString(@"MAP", @"") forSegmentAtIndex:0];
	[segControl setTitle:NSLocalizedString(@"SATELLITE", @"") forSegmentAtIndex:1];
	[segControl setTitle:NSLocalizedString(@"HYBRID", @"") forSegmentAtIndex:2];
	
	adjustView = NO;
	locationEnabled = NO;
	locationRequested = NO;
	mapView.showsUserLocation = YES;
	mapView.mapType = MKMapTypeStandard;	
	
	activityLoader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[activityLoader setHidesWhenStopped:YES];

}

 /*	
 /   @method: shouldAutorotateToInterfaceOrientation
 /	 @description: Specifies if the view controller can or cannot rotate the view. On this iPad App, the view needs to be on protrait orientation
 /					until all the data has been loaded.
 /	 @param: interfaseOrientation - current device orientation.
 /	 @return: BOOL - If the value is YES, the controller must rotate the view. Otherwise the view must rest in portrait.
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if([[delegate data] dataLoaded]){
		return YES;
	} else {
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
	}

}

 /*	
 /   @method: viewDidUnload
 /	 @description: Called when the view dissapears. Used to remove the popOverController.
 */

- (void)viewDidUnload {
    [super viewDidUnload];
	self.popoverController = nil;
}


#pragma mark -
#pragma mark Initialization

 /*	
 /   @method: loadInfo
 /	 @description: Initialization method. Creates annotations from AppDelegate data, creates the background limits
 /					and decoration border.
 */

- (void)loadInfo{
	NSMutableDictionary *tempMarkers = [[NSMutableDictionary alloc] init];
	MapAnnotation *mockBus;
	for(id key in [[delegate data] markers]){
		mockBus = [[MapAnnotation alloc] init];
		mockBus.properties = [[[delegate data] markers] objectForKey:key];
		[mockBus setCoordinate:mockBus.properties.coordinate];
		[tempMarkers setObject:mockBus forKey:key];
		[mockBus release];
	}
	
	mapAnnotations = [[NSDictionary dictionaryWithDictionary:tempMarkers] retain];
	[tempMarkers release];
	
	NSMutableDictionary *tempStops = [[NSMutableDictionary alloc] init];
	StopAnnotation *mockStop;
	for(id key in [[delegate data] stops]){
		mockStop = [[StopAnnotation alloc] init];
		mockStop.properties = [[[delegate data] stops] objectForKey:key];
		[mockStop setCoordinate:mockStop.properties.coordinate];
		[tempStops setObject:mockStop forKey:key];
		[mockStop release];
	}
	
	stopAnnotations = [[NSDictionary dictionaryWithDictionary:tempStops] retain];
	[tempStops release];
	
	
	NSMutableArray *limits = [[NSMutableArray alloc]initWithCapacity:2];
	MKCoordinateRegion max = [[delegate data] maxRegion];
	MKCoordinateRegion min = [[delegate data] minRegion];
	
	MKPolygon *poly = [utils getBackgroundWithMaxLimits:max andMinLimits:min];
	[limits addObject:poly];
	MKPolygon* decPoly = [utils getBordersWithMaxLimits:max andMinLimits:min];
	[limits addObject:decPoly];
	
	MultipleOverlays *overlay = [[MultipleOverlays alloc] initWithPolyLines:limits];
	
    [mapView addOverlay:overlay];
	[limits release];
    [overlay release];
}

 /*	
 /   @method: initLocation
 /	 @description: Centers the map on the default city region or the last referenced position when the App ended.
 */

- (void)initLocation{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSData *userRegion = [prefs objectForKey:@"Helsinki_region"];
	if(userRegion!=nil){
		MKCoordinateRegion tempRegion;
		[userRegion getBytes: &tempRegion];
		[mapView setRegion:tempRegion animated:NO];
	}else{
		MKCoordinateRegion newRegion = [[delegate data] cityRegion];
		[mapView setRegion:newRegion animated:NO];
	}	
}

 /*	
 /   @method: setLatitude:andLongitude
 /	 @description: Specifies the center of the map using the latitude and longitude params.
 /	 @param: latitude - latitude to center.
 /	 @param: longitude - longitude to center.
 */

- (void)setLatitude:(float)latitude andLongitude:(float)longitude{
	
	MKCoordinateRegion newRegion = [mapView region];
	newRegion.center.latitude = latitude;
	newRegion.center.longitude = longitude;
	[mapView setRegion:newRegion animated:YES];	
}


#pragma mark -
#pragma mark Annotations and Markers operations

 /*	
 /   @method: updateAnnotations
 /	 @description: Adds all the current annotations on the map and removes those with inactive line property.
 */

-(void)updateAnnotations{
	[mapView addAnnotations:[mapAnnotations allValues]];
	MapAnnotation *busNote;
	for(id key in mapAnnotations){
		busNote = (MapAnnotation *) [mapAnnotations objectForKey:key];
		if(!busNote.properties.line.active){
			[mapView removeAnnotation:busNote];
		}
	}
}

 /*	
 /   @method: updateMarker:
 /	 @description: Updates the marker properties on the map. The marker to update is specified by his ID (numberPlate)
 /	 @param: nPlate - The marker ID.
 */

-(void)updateMarker:(NSString*)nPlate{
	MapAnnotation *busNote = (MapAnnotation *) [mapAnnotations objectForKey:nPlate];
	if(busNote != nil){
		UIImage *orImage = [utils getIcon:busNote.properties.line.type orientedTo:busNote.properties.orientation];
		[busNote.orientImage setImage:orImage];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.2];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		
		CLLocationCoordinate2D newCoord = {busNote.properties.coordinate.latitude, busNote.properties.coordinate.longitude};
		[busNote setCoordinate:newCoord];
		
		busNote.lineName.text = busNote.properties.line.name;
		
		[mapView addAnnotation:busNote];
		
		[UIView commitAnimations];
	}
}

 /*	
 /   @method: deselectMarker:
 /	 @description: Closes the annotation Pop-up.
 /	 @param: nPlate - The marker ID.
 */

-(void)deselectMarker:(NSString*)nPlate{
	MapAnnotation *busNote = (MapAnnotation *) [mapAnnotations objectForKey:nPlate];
	if(busNote != nil){
		[mapView deselectAnnotation:busNote animated:YES];
	}
}

 /*	
 /   @method: updateStops
 /	 @description: Adds all the current annotations on the map and removes those with inactive line property.
 */

-(void)updateStops{
	[mapView removeAnnotations:[stopAnnotations allValues]];
	for(id key in [[delegate data]lines]){
		LineProperties *properties = [[[delegate data] lines] objectForKey:key];
		if(properties.activeStops){
			if(properties.stops != nil){
				for(int i=0; i < [properties.stops count]; i++){
					StopProperties *stopPrp = [properties.stops objectAtIndex:i];
					StopAnnotation *stopAnn = [stopAnnotations objectForKey:[NSString stringWithFormat:@"%d",stopPrp.stopId]];
					[mapView addAnnotation:stopAnn];
				}
			}
		}
	}
}



#pragma mark -
#pragma mark Overlay operations

 /*	
 /   @method: removeOverlays
 /	 @description: Removes all the route overlays
 */

-(void)removeOverlays{
	if(overlays != nil)
	[mapView removeOverlay:overlays];
}

 /*	
 /   @method: updateOverlays
 /	 @description: Creates a single overlay with all the selected lines and adds it to the map
 */

-(void)updateOverlays{
	
	[self removeOverlays];
	
	NSMutableArray *routes = [[NSMutableArray alloc] init];
	NSMutableArray *colors = [[NSMutableArray alloc] init];
	
	for(id key in [[delegate data]lines]){
		LineProperties *properties = [[[delegate data] lines] objectForKey:key];
		if(properties.route != nil){
			if(properties.activeRoute){
				[routes addObject:properties.route];
				[colors addObject:properties.color];
			}
		}
		if(properties.activeChanged){
			[Utils filteringEvent:kLineCategory 
						forAction:kFilterAction 
						   onType:properties.type 
						  withKey:key 
						 andValue:properties.active];
			properties.activeChanged = NO;
		}
		if(properties.activeRouteChanged){
			[Utils filteringEvent:kRouteCategory 
						forAction:kFilterAction 
						   onType:properties.type 
						  withKey:key 
						 andValue:properties.activeRoute];
			properties.activeRouteChanged = NO;
		}
		if(properties.activeStopsChanged){
			[Utils filteringEvent:kStopCategory 
						forAction:kFilterAction 
						   onType:properties.type 
						  withKey:key 
						 andValue:properties.activeStops];
			properties.activeStopsChanged = NO;
		}
	}
	
	if([routes count] != 0){
		RouteOverlays *routeOv = [[RouteOverlays alloc] initWithPolyLines:routes withColors:colors];
		[self setOverlays:routeOv];
		[routeOv release];
		[mapView addOverlay:overlays];
	}
    [routes release];
    [colors release];
}

#pragma mark -
#pragma mark MapView Delegate methods

 /*	
 /   @method: mapView:viewForAnnotation:
 /	 @description: Managed from MKMapViewDelegate. Specifies the view for a new annotation addition on the map.
 /   @param: mapView - Current mapView.  
 /   @param: annotation - Annotation reference to insert on the map.
 /	 @return: MKAnnotationView - The customized annotationView created from the overlay reference.
 */

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MapAnnotation class]]){
		MapAnnotation *busNote = annotation;
		MKAnnotationView *annotationView = [[[MKAnnotationView alloc] initWithAnnotation:busNote
																	 reuseIdentifier:nil] autorelease];
		annotationView.canShowCallout = YES;
		annotationView.image = busNote.properties.line.image;
		annotationView.opaque = NO;
	
		UIImage *imgOr = [utils getIcon:busNote.properties.line.type orientedTo:busNote.properties.orientation];	
		busNote.orientImage = [UIImageView alloc];
		[busNote.orientImage initWithImage:imgOr];
	
		[annotationView addSubview:busNote.orientImage];
	
		busNote.lineName = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 57, 23)];
		busNote.lineName.text = busNote.properties.line.name;	
		busNote.lineName.opaque = YES;
		busNote.lineName.backgroundColor = [UIColor clearColor];
		busNote.lineName.textColor = [UIColor whiteColor];
		busNote.lineName.highlightedTextColor = [UIColor whiteColor];
		busNote.lineName.textAlignment =  UITextAlignmentCenter;
		busNote.lineName.font = [UIFont boldSystemFontOfSize:17.0];
	
		[annotationView addSubview:busNote.lineName];
		return annotationView;
	}else if([annotation isKindOfClass:[StopAnnotation class]]){
		StopAnnotation *stopNote = annotation;
		MKAnnotationView *annotationView = [[[MKAnnotationView alloc] initWithAnnotation:stopNote
																		 reuseIdentifier:nil] autorelease];
		annotationView.canShowCallout = YES;
		annotationView.image = [Utils getStopImage:stopNote.properties.type];
		annotationView.opaque = NO;
		
		UIButton *moreInfo = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		[moreInfo addTarget:self action:@selector(showStopInformation:) forControlEvents:UIControlEventTouchUpInside];
		moreInfo.tag = stopNote.properties.stopId;
		annotationView.rightCalloutAccessoryView = moreInfo;
		
		
		UIImage *img = [Utils getSmallStopIcon:stopNote.properties.type];
		
		UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
		annotationView.leftCalloutAccessoryView = imgView ;
		
		return annotationView;
		
	}
	
	return nil;
}

 /*	
 /   @method: mapView:didSelectAnnotationView
 /	 @description: Managed from MKMapViewDelegate. Shoots when an annotation has been selected, brings to the front the view and starts the "follow feature"
 /   @param: mapView - mapView where the annotation is.  
 /   @param: view - annotationView to bring to top and began to follow.  
 */

- (void)mapView:(MKMapView *)mView didSelectAnnotationView:(MKAnnotationView *)view {
	
	if ([[view annotation] isKindOfClass:[MapAnnotation class]]){
		MapAnnotation *busNote = [view annotation];
		[delegate setCurrentMarker:busNote.properties.numberPlate];
		
		MKAnnotationView *busView = [mapView viewForAnnotation:busNote];
		for (MapAnnotation *ann in [mapView annotations]) {
			MKAnnotationView *annView = [mapView viewForAnnotation:ann];
			[[annView superview]  bringSubviewToFront:busView];
		}
		
		NSString *description = [NSString stringWithFormat:@"Selected %@: %@",[Utils getTypeName:busNote.properties.line.type],busNote.properties.numberPlate]; 
		[Utils trackEvent:kMarkerCategory forAction:kSelectAction withDescription:description withValue:1];
		
		if(mapView.showsUserLocation && locationRequested){
			description = [NSString stringWithFormat:@"Distance to %@: %@",[Utils getTypeName:busNote.properties.line.type],busNote.properties.numberPlate];
			CLLocation *destination = [[CLLocation alloc] initWithLatitude:busNote.coordinate.latitude longitude:busNote.coordinate.longitude];
			CLLocationDistance distance = [mapView.userLocation.location distanceFromLocation:destination];
			[Utils trackEvent:kMarkerCategory forAction:kLocationAction withDescription:description withValue:(int)distance];
			[destination release];
		}
		
	}else if ([[view annotation] isKindOfClass:[StopAnnotation class]]){
		StopAnnotation *stopNote = [view annotation];
		MKAnnotationView *stopView = [mapView viewForAnnotation:stopNote];
		
		for (id ann in [mapView annotations]) {
			MKAnnotationView *annView = [mapView viewForAnnotation:ann];
			[[annView superview]  bringSubviewToFront:stopView];
		}
		
		NSString *description = [NSString stringWithFormat:@"Selected stop: %d",stopNote.properties.stopId];
		[Utils trackEvent:kStopCategory forAction:kSelectAction withDescription:description withValue:[stopNote.properties.lines count]];
		
		if(mapView.showsUserLocation && locationRequested){
			description = [NSString stringWithFormat:@"Distance from stop: %d",stopNote.properties.stopId];
			CLLocation *destination = [[CLLocation alloc] initWithLatitude:stopNote.coordinate.latitude longitude:stopNote.coordinate.longitude];
			CLLocationDistance distance = [mapView.userLocation.location distanceFromLocation:destination];
			[Utils trackEvent:kStopCategory forAction:kLocationAction withDescription:description withValue:(int)distance];
			[destination release];
		}
	}
}

 /*	
 /   @method: mapView:didDeselectAnnotationView
 /	 @description: Managed from MKMapViewDelegate. Called when a map annnotation is deselected.
 /   @param: mapView - mapView where the annotation is.  
 /   @param: view - annotationView to bring to top and began to follow.  
 */

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
	if ([[view annotation] isKindOfClass:[MapAnnotation class]]){
		MapAnnotation *mA = (MapAnnotation *)[view annotation];
		if([mA.properties.numberPlate isEqual:[delegate getCurrentMarker]])
			[delegate setCurrentMarker:nil];
	}
}

 /*	
 /   @method: mapView:viewForOverlay:
 /	 @description: Managed from MKMapViewDelegate. Specifies the view for a new overlay addition on the map.
 /   @param: mapView - Current mapView.  
 /   @param: overlay - Overlay reference to insert on the map.
 /	 @return: MKOverlayView - The customized overlayView created from the overlay reference.
 */

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay{
	
	if ([overlay isKindOfClass:[MultipleOverlays class]]){
		DecorationOverlayView *view = [[DecorationOverlayView alloc] initWithOverlay:overlay];
		return [view autorelease];
		
    }else{
		RouteOverlayView *view = [[RouteOverlayView alloc] initWithOverlay:overlay];
		return [view autorelease];
	}
}

 /*	
 /   @method: mapView:regionDidChangeAnimated:
 /	 @description: Managed from MKMapViewDelegate. Called when the map region has changed. Manages the application limits.
 /   @param: mapView - Current mapView.  
 /   @param: animated.
 */

- (void)mapView:(MKMapView *)mView regionDidChangeAnimated:(BOOL)animated{
	[delegate updateFiltering];
	
	if([[delegate data] dataLoaded] && !adjustView){
		
		MKCoordinateRegion max = [[delegate data] maxRegion];
		MKCoordinateRegion min = [[delegate data] minRegion];
		MKCoordinateSpan span = mapView.region.span;
		CLLocationDegrees tmpLat = mapView.region.center.latitude;
		CLLocationDegrees tmpLong = mapView.region.center.longitude;
		BOOL ZoomChanged = NO;
		
		if(mapView.region.span.latitudeDelta > max.span.latitudeDelta || mapView.region.span.longitudeDelta > max.span.longitudeDelta){
				ZoomChanged = YES;
				span = MKCoordinateSpanMake(max.span.latitudeDelta - 0.18,max.span.longitudeDelta - 0.2);
		}
		
		if(!ZoomChanged && [delegate getCurrentMarker] == nil){
			if((mapView.region.center.latitude + span.latitudeDelta/2) > max.center.latitude){
				tmpLat = max.center.latitude - span.latitudeDelta/2;
				adjustView = YES;
			}
			
			if((mapView.region.center.longitude + span.longitudeDelta/2) > max.center.longitude){
				tmpLong = max.center.longitude - span.longitudeDelta/2;
				adjustView = YES;
			}
			
			if((tmpLat - span.latitudeDelta/2)  < min.center.latitude){
				tmpLat = min.center.latitude + span.latitudeDelta/2;
				adjustView = YES;
			}
			
			if((tmpLong - span.longitudeDelta/2) < min.center.longitude){
				tmpLong = min.center.longitude + span.longitudeDelta/2;
				adjustView = YES;
			}
		}
		if(adjustView){
			//TODO: Solve CLLocationMaker
			CLLocationCoordinate2D location;
			location.latitude = tmpLat;
			location.longitude = tmpLong;
			[mapView setCenterCoordinate:location animated:YES];
		}
		if(ZoomChanged){
			//TODO: Solve CLLocationMaker
			CLLocationCoordinate2D location;
			location.latitude = tmpLat;
			location.longitude = tmpLong;
			MKCoordinateRegion region = MKCoordinateRegionMake(location, span);
			[mapView setRegion:region animated:YES];
		}
		
	}else{
		adjustView = NO;
	}
}

 /*	
 /   @method: mapView:didUpdateUserLocation:
 /	 @description: Managed from MKMapViewDelegate. Called when the location operation has ended.
 /   @param: mapView - Current mapView.  
 /   @param: userLocation - The user location results.
 */

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
	
	MKCoordinateRegion max = [[delegate data] maxRegion];
	MKCoordinateRegion min = [[delegate data] minRegion];
	
	if((userLocation.coordinate.latitude < max.center.latitude && userLocation.coordinate.longitude < max.center.longitude 
		&& userLocation.coordinate.latitude > min.center.latitude && userLocation.coordinate.longitude > min.center.longitude)){
		locationEnabled = YES;
		[self enableUserLocationButton];
		if(locationRequested){
			[self setLatitude:userLocation.coordinate.latitude andLongitude:userLocation.coordinate.longitude];	
			double elapsedTime = [utils elapsedTrackTime];
			
			int latkRegion = (int)((userLocation.coordinate.latitude - min.center.latitude)/kRegionLatSize);
			int lonkRegion = (int)((userLocation.coordinate.longitude - min.center.longitude)/kRegionLonSize);
			
			float userLatRegion = kRegionLatSize*latkRegion + min.center.latitude;
			float userLonRegion = kRegionLonSize*lonkRegion + min.center.longitude;
			
			NSString *uLocationString = [NSString stringWithFormat:@"Region: %.2d,%.2d  Coords: %.3f,%.3f",latkRegion,lonkRegion,userLatRegion,userLonRegion];
			[Utils trackEvent:kUserCategory forAction:kRegionAction withDescription:uLocationString withValue:(int)elapsedTime];
		}else{
			self.mapView.showsUserLocation = NO;
		}
	}else{
		locationEnabled = NO;
	}
}

#pragma mark -
#pragma mark User Properties Methods

 /*
 /	@method: showUserLocation
 /	@description: Sets Enable/Disable the user location and updates the location button's image.
 /  @return: IBAction - Connected to the location button on MainWindow.xib
 */

-(IBAction)showUserLocation {
		
	locationRequested = !locationRequested;
	
	if(locationRequested){
		[utils beginTrackTime];
		[self disableUserLocationButton];
		[locationButton setImage:[UIImage imageNamed:@"locationInactive.png"]];
		if([delegate getCurrentMarker] != nil){
			[self deselectMarker: [delegate getCurrentMarker]];
		}
	}else{
		[self enableUserLocationButton];
		[locationButton setImage:[UIImage imageNamed:@"locationActive.png"]];
	}
	
	mapView.showsUserLocation = locationRequested;
}

 /*	
 /   @method: changeMapType
 /	 @description: Changes the mapView type to standard, satellite or hybrid view.
 /	 @param: sender - references the UISegmentedControl.
 /	 @return: IBAction - Connected to the segmented control on RootViewController.xib
 */

-(IBAction)changeMapType:(id)sender {
	int type = ((UISegmentedControl *)sender).selectedSegmentIndex;
	switch (type) {
		case 0:	[mapView setMapType:MKMapTypeStandard];	break;
		case 1:	[mapView setMapType:MKMapTypeSatellite]; break;
		case 2:	[mapView setMapType:MKMapTypeHybrid]; break;
		default: break;
	}
}

 /*	
 /   @method: enableButtons
 /	 @description: Enables all the interface Buttons
 */

-(void)enableButtons{
	okodeInfo.enabled = YES;
}

 /*
 /	@method: showOkodeInfo
 /	@description: Pushes the Okode information viewController on the Split's navigationController.
 /  @return: IBAction - Connected to the info button on MainWindow.xib
 */

-(IBAction)showOkodeInfo{
	[delegate showOkodeInfoView];
}

 /*	
 /   @method: showStopInformation
 /	 @description: Calls the delegate to show the Stop information
 /	 @param: sender - references the UIButton.
 */

-(void)showStopInformation:(id)sender{

	[activityLoader startAnimating];
	[activityLoader setCenter:CGPointMake(self.view.frame.size.width - 75,self.view.frame.size.height - 20)];
	[self.view addSubview:activityLoader];
	
	[self setPressedButton:((UIButton *)sender)];
	
	int stopId = pressedButton.tag;
	
	NSString *stopString = [NSString stringWithFormat:@"%d",stopId];
	[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(delayStopInfo:) userInfo:stopString repeats:NO];
}

/*	
 /   @method: delayStopInfo
 /	 @description: Loads the stop schedule table. Called from NSTimer.
 /	 @param: theTimer - Used timer to call the method.
 */

-(void)delayStopInfo:(NSTimer*)theTimer{
	[delegate showStopInfo:[theTimer userInfo]];
	[activityLoader stopAnimating];
}

 /*
 /	@method: enableUserLocationButton
 /	@description: Sets the user's location button enabled
 */

-(void)enableUserLocationButton {
	[locationButton setEnabled:YES];
}

-(void)stompConnectionStart{
	[stompLight setImage:[UIImage imageNamed:@"stompConnectionOk.png"]];
}

-(void)stompConnectionStop{
	[stompLight setImage:[UIImage imageNamed:@"stompConnectionFail.png"]];
}


/*
 /	@method: disbleUserLocationButton
 /	@description: Sets the user's location button disabled
 */

-(void)disableUserLocationButton {
	[locationButton setEnabled:NO];
}

 /*	
 /   @method: disableUserLocation
 /	 @description: Disables the User location button and functionallity and shows an alert warning about this fact.
 */

-(void)disableUserLocation {
	locationEnabled = NO;
	mapView.showsUserLocation = NO;
	[self disableUserLocationButton];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (void)dealloc {
	[popoverController release];
    [mapView release];
	[stompLight release];
	[segControl release];
	[mapAnnotations release];
	[stopAnnotations release];
	[overlays release];
	[locationButton release];
	[okodeInfo release];
	[pressedButton release];
	
    [super dealloc];
}


@end
