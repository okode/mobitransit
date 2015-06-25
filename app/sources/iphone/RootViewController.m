//
//  RootViewController.m
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 24/09/10.
//  Copyright Okode S.L. 2010. All rights reserved.
//

#import "RootViewController.h"
#import "MapAnnotation.h"
#import "StopAnnotation.h"
#import "RouteOverlays.h"
#import "RouteOverlayView.h"
#import "DecorationOverlayView.h"
#import "MultipleOverlays.h"

@implementation RootViewController


@synthesize mapView;
@synthesize mapAnnotations;
@synthesize delegate;
@synthesize utils;
@synthesize adjustView;
@synthesize locationRequested;
@synthesize overlays;
@synthesize orientation;
@synthesize stopAnnotations;
@synthesize shareView;
@synthesize placemark;

#pragma mark -
#pragma mark View lifecycle

 /*	
 /   @method: viewDidLoad
 /	 @description: Managed from ViewControllerDelegate. Called when the view has loaded. Used to call mapView's initialization.
 */

- (void)viewDidLoad {
    [super viewDidLoad];
	
	adjustView = NO;
	locationRequested = [delegate loadLocationState];
	mapView.showsUserLocation = YES;
	mapView.mapType = MKMapTypeStandard;
	
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
    
	[overlay release];
    [limits release];
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
 /					Also adds the selected stops.
 */

-(void)updateOverlays{
		
	NSMutableArray *routes = [[NSMutableArray alloc] init];
	NSMutableArray *colors = [[NSMutableArray alloc] init];
	
	[mapView removeAnnotations:[stopAnnotations allValues]];
	
	for(id key in [[delegate data]lines]){
		LineProperties *properties = [[[delegate data] lines] objectForKey:key];
		if(properties.route != nil){
			if(properties.activeRoute){
				[routes addObject:properties.route];
				[colors addObject:properties.color];
			}
		}
		if(properties.activeStops){
			if(properties.stops != nil){
				for(int i=0; i < [properties.stops count]; i++){
					StopProperties *stopPrp = [properties.stops objectAtIndex:i];
					StopAnnotation *stopAnn = [stopAnnotations objectForKey:[NSString stringWithFormat:@"%d",stopPrp.stopId]];
					[mapView addAnnotation:stopAnn];
				}
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
#pragma mark IBActions and user operations

-(void)changeUserLocationTo:(BOOL)enable{
    locationRequested = enable;
    if(enable){
        [utils beginTrackTime];
    }
    mapView.showsUserLocation = enable;
}

 /*	
 /   @method: showStopInformation
 /	 @description: Calls the delegate to show the Stop information
 /	 @param: sender - references the UIButton.
 */

-(void)showStopInformation:(id)sender{
	
	[[ActivityIndicator currentIndicator] displayActivity:NSLocalizedString(@"LOADING",@"")];
	
	int stopId = ((UIButton *)sender).tag;

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
	[[ActivityIndicator currentIndicator] hide];
}


-(void)mapTypeNormal {
    [mapView setMapType:MKMapTypeStandard];
}

-(void)mapTypeSatellite {
    [mapView setMapType:MKMapTypeSatellite];
}

-(void)mapTypeHybrid {
    [mapView setMapType:MKMapTypeHybrid];
}

 /*	
 /   @method: disableUserLocation
 /	 @description: Disables the User location button and functionallity and shows an alert warning about this fact.
 */

-(void)disableUserLocation{
	mapView.showsUserLocation = NO;
	[delegate disableUserLocationButton];
	UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"NO_LOCATION_TITLE", @"")
													message:NSLocalizedString(@"NO_LOCATION_MESSAGE", @"")
												   delegate:self
										  cancelButtonTitle:NSLocalizedString(@"ACCEPT_MESSAGE", @"")
										  otherButtonTitles:nil] autorelease];
	[alert show];
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
	
	if([annotation isKindOfClass:[MapAnnotation class]]){
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
		for (id ann in [mapView annotations]) {
			MKAnnotationView *annView = [mapView viewForAnnotation:ann];
			[[annView superview]  bringSubviewToFront:busView];
		}
		
		if([delegate twitterConnected] || [delegate facebookConnected]){
			UIButton *moreInfo = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			[moreInfo addTarget:self action:@selector(loadShareMessageView) forControlEvents:UIControlEventTouchUpInside];
			busView.rightCalloutAccessoryView = moreInfo;
		}else{
			busView.rightCalloutAccessoryView = nil;
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
    }else if([[view annotation] isKindOfClass:[MKUserLocation class]]){
        if([delegate facebookConnected]){
            if([delegate facebookUserPic]){
                
                view.leftCalloutAccessoryView = [[[UIImageView alloc] initWithImage:[delegate facebookUserPic]] autorelease];
                view.leftCalloutAccessoryView.frame = CGRectMake(0,0,32,32);
            }
            if([delegate facebookUserName]){
                MKUserLocation *user = (MKUserLocation*)[view annotation];
                user.subtitle = [delegate facebookUserName];
            }
            UIButton *moreInfo = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [moreInfo addTarget:self action:@selector(loadSharePositionView) forControlEvents:UIControlEventTouchUpInside];
            view.rightCalloutAccessoryView = moreInfo;
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
		
		
		if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
			if(mapView.region.span.latitudeDelta > max.span.latitudeDelta || mapView.region.span.longitudeDelta > max.span.longitudeDelta){
				ZoomChanged = YES;
				span = MKCoordinateSpanMake(max.span.latitudeDelta - 0.2,max.span.longitudeDelta - 0.2);
			}
		}else{
			if(mapView.region.span.latitudeDelta > min.span.latitudeDelta || mapView.region.span.longitudeDelta > min.span.longitudeDelta){
				ZoomChanged = YES;
				span = MKCoordinateSpanMake(min.span.latitudeDelta - 0.12,min.span.longitudeDelta - 0.2);
			}
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
			[mapView setCenterCoordinate:CLLocationCoordinate2DMake(tmpLat, tmpLong) animated:YES];
		}
		if(ZoomChanged){
			MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(tmpLat, tmpLong), span);
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
		[delegate enableUserLocation];
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
		[delegate disableUserLocation];
        self.mapView.showsUserLocation = NO;
	}
}

-(void)loadShareMessageView {
	MarkerProperties *properties = [[[delegate data] markers] objectForKey:[delegate getCurrentMarker]];
	NSString *message = [NSString stringWithFormat:@"%@ %@ %@ %@ %@.\n%@\nhttp://www.mobitransit.com",
						 NSLocalizedString(@"SHARE_MESSAGE_TRANSPORT_1", @""),[Utils getTypeLocalizedName:properties.line.type],properties.numberPlate,  NSLocalizedString(@"SHARE_MESSAGE_TRANSPORT_2", @""),properties.line.name, NSLocalizedString(@"SHARE_MESSAGE_TRANSPORT_3", @"")];
	[shareView.textView setText:message];
	[self.navigationController pushViewController:shareView animated:YES];
}

-(void)loadSharePositionView {
    MKUserLocation *userLocation = [mapView userLocation];
	NSString *message = [NSString stringWithFormat:@"%@ (%f,%f).\n%@\nhttp://www.mobitransit.com",
						 NSLocalizedString(@"SHARE_MESSAGE_LOCATION_1", @""),userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude,  NSLocalizedString(@"SHARE_MESSAGE_LOCATION_2", @"")];
	[shareView.textView setText:message];
	[self.navigationController pushViewController:shareView animated:YES];
}


-(void)reverseGeocoderCurrentLocation{
    if(mapView.showsUserLocation){
        MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:[mapView.userLocation coordinate]];
        [geocoder setDelegate:self];
        [geocoder start];
    }else{
        [delegate reverseGeocodingEnded:NO];
    }
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
    [delegate reverseGeocodingEnded:NO];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)resultPlacemark{
    [self setPlacemark:resultPlacemark];
    [delegate reverseGeocodingEnded:YES];
}

-(NSString*)currentCityName {
    if(placemark){
        return placemark.locality;
    }
    return nil;
}

-(NSString*)currentStreetName {
    if(placemark){
        return placemark.thoroughfare;
    }
    return nil;
}

-(NSString*)currentNumber {
    if(placemark){
        return placemark.subThoroughfare;
    }
    return nil;
}

#pragma mark -
#pragma mark ViewController Delegate methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	orientation = interfaceOrientation;
	return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {}

- (void)dealloc {
	[mapView release];
	[mapAnnotations release];
	[overlays release];
	[shareView release];
    [placemark release];
    [super dealloc];
}


@end

