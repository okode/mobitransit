//
//  AppDelegate_iPad.m
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 01/10/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import "AppDelegate_iPad.h"

#import "RootViewController_iPad.h"
#import "DetailTableViewController_iPad.h"

@implementation AppDelegate_iPad

@synthesize window, splitViewController, firstView, detailView, stopView;
@synthesize data;
@synthesize network;
@synthesize utils;
@synthesize currentMarker;
@synthesize okodeInfo;
@synthesize popoverController;
@synthesize tempButton;

#pragma mark -
#pragma mark Application lifecycle

 /*
 /	@method: application:didFinishLaunchingWithOptions:
 /	@description: Main function, used to create utils, data and network instace classes and give delegate references.
 /	@param: application - current application reference
 /	@param: launchOptions - initial launch options
 /  @return: BOOL - success of the process.
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	utils = [Utils new];
	[utils loadImages];
	[utils beginTrackTime];

	
	data = [MobitransitData new];
	[data setUtils:utils];
	
	[detailView setDelegate:self];
	
	network = [MobitransitNetwork new];
	[network setDelegate:self];
	[network loadReachabilityManager:kMobHost];
    
	[firstView setDelegate:self];
	[firstView setUtils:utils];
	
	[window addSubview:splitViewController.view];
    [window makeKeyAndVisible];
	
	[self showLoading];
	
	return YES;
}


 /*
 /	@method: applicationWillTerminate:
 /	@description: Managed by the UIApplicationDelegate. Called when the application did enter in Background.
 /				  This method is used to save the user preferences and stop and disconnect the stomp service.
 /	@param: application - current application reference
 */

- (void)applicationWillTerminate:(UIApplication *)application {
	[self endApplication];
}

 /*
 /	@method: applicationWillResignActive:
 /	@description: Managed by the UIApplicationDelegate. Called when the application will be inactive.
 /	@param: application - current application reference
 */

- (void)applicationWillResignActive:(UIApplication *)application {
    [self performSelector:@selector(showInactive) withObject:nil afterDelay:30];
    [self performSelector:@selector(endApplication) withObject:nil afterDelay:60];
}

 /*
 /	@method: applicationDidBecomeActive:
 /	@description: Managed by the UIApplicationDelegate. Called when the application returns from Background.
 /	@param: application - current application reference
 */

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [utils removeModalView];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showInactive) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endApplication) object:nil];
}

 /*
 /	@method: applicationDidEnterBackground:
 /	@description: Managed by the UIApplicationDelegate. Called when the application will enter in Background.
 /	@param: application - current application reference
 */

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self endApplication];
}

 /*
 /	@method: endApplication:
 /	@description: Saves the current preferences if it's correctly loaded, stops the stomp connection
 /				  and ends the application
 */

-(void)endApplication {
    
	if([data dataLoaded]){
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		
		MKCoordinateRegion currentRegion = firstView.mapView.region;	
		NSData *regionData= [NSData dataWithBytes: &currentRegion length: sizeof(currentRegion)];
		[prefs setObject:regionData forKey:@"Helsinki_region"];
		
		NSMutableArray *inactiveLines = [NSMutableArray new];
		NSMutableArray *inactiveRoutes = [NSMutableArray new];
		NSMutableArray *inactiveStops = [NSMutableArray new];
		
		for(id key in [data lines]){
			LineProperties *properties = [data getLine:key];
			if(!properties.active){
				[inactiveLines addObject:key];
			}
			if(properties.activeRoute){
				[inactiveRoutes addObject:key];
			}
			if(properties.activeStops){
				[inactiveStops addObject:key];
			}
		}
		NSArray *inactive = [NSArray arrayWithArray:inactiveLines];
		NSArray *inactiveR = [NSArray arrayWithArray:inactiveRoutes];
		NSArray *inactiveS = [NSArray arrayWithArray:inactiveStops];
		[prefs setObject:inactive forKey:@"Helsinki_inactive"];
		[prefs setObject:inactiveR forKey:@"Helsinki_routes"];
		[prefs setObject:inactiveS forKey:@"Helsinki_stops"];
		[prefs synchronize];
		[Utils stopTracker];
	}
	[network stopStompConnection:kMobQueue];
	exit(1);

}

#pragma mark -
#pragma mark Initialization Methods

 /*
 /	@method: loadData
 /	@description: This method is used to load all the Mobitransit's data (configuration information, lines and markers).
 /				  Once loaded, creates the table cells, map annotations and overlays. Then starts the stomp connection.
 /				  Finally removes the loading modal box showed during the load process.
 */

- (int)loadData{
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *firstAlert = [prefs objectForKey:@"Helsinki_firstRun"];
	
	int dataStatus = [data requestProperties];
	
	if([data staticResourcesLoaded]){
		[data loadMarkerProperties:kMobMarkersURL];
		if([data dataLoaded]){
			[self populateContents];
		}
	}
	
	[utils removeModalView];
	
	if([data dataLoaded]){
		[Utils startTrackerWithAccountID:kGANAccountId withPeriod:kGANPeriodSec];
		double elapsedTime = [utils elapsedTrackTime];
		[prefs setObject:[data lastModified] forKey:@"Helsinki_lastModified"];
		if(firstAlert == nil){
			UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"WELCOME_TITLE", @"")
															message:NSLocalizedString(@"WELCOME_MESSAGE", @"")
														   delegate:self
												  cancelButtonTitle:NSLocalizedString(@"ACCEPT_MESSAGE", @"")
												  otherButtonTitles:nil] autorelease];
			[alert show];
			[prefs setObject:@"firstRunOk" forKey:@"Helsinki_firstRun"];
		}
		
		[Utils trackEvent:kAppCategory forAction:kLoadAction withDescription:@"Elapsed time" withValue:(int)elapsedTime];
	}
	
	return dataStatus;
}

-(void)populateContents{
	[self loadLinesDetail];
	[firstView loadInfo];
	[firstView enableButtons];
	[firstView initLocation];
	[firstView updateOverlays];
	[firstView updateAnnotations];
	[firstView updateStops];
	[network startStompConnection:kMobHost 
						   onPort:kMobPort 
						 withUser:kMobUser 
						 withPass:kMobPass];
}

 /*
 /	@method: loadLinesDetail
 /	@description: Create the necessary arrays to fill the lines table (detailTableViewController) 
 */

- (void)loadLinesDetail{
	
	NSMutableArray *busL = [[NSMutableArray alloc] init];
	NSMutableArray *traL = [[NSMutableArray alloc] init];
	NSMutableArray *subL = [[NSMutableArray alloc] init];
	NSMutableArray *taxL = [[NSMutableArray alloc] init];
	
	for(id key in [data lines]){
		LineProperties *properties  = [data getLine:key];
		switch(properties.type){
			case BUS:		[busL addObject:properties];break;
			case TRAMWAY:	[traL addObject:properties];break;
			case SUBWAY:	[subL addObject:properties];break;
			case TAXI:		[taxL addObject:properties];break;
			default: 		break;
		}
	}
	
	NSSortDescriptor *firstDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES] autorelease];
	NSArray *descriptors = [NSArray arrayWithObject:firstDescriptor];
	
	
	NSMutableArray *ordered = [[NSMutableArray alloc] init];
	NSMutableArray *names = [[NSMutableArray alloc] init];
	for(int i=0; i<kNumTransportTypes; i++){
		NSArray *line = nil;
		NSString *name;
		switch(i){
			case 0:	line = [NSArray arrayWithArray:busL]; [busL release]; 
				name = NSLocalizedString(@"BUSES", @""); line = [line sortedArrayUsingDescriptors:descriptors];
				[detailView setBusLines:line]; break;
			case 1:	line = [NSArray arrayWithArray:traL]; [traL release]; 
				name = NSLocalizedString(@"TRAMWAYS", @""); line = [line sortedArrayUsingDescriptors:descriptors];
				[detailView setTramwayLines:line]; break;
			case 2:	line = [NSArray arrayWithArray:subL]; [subL release]; 
				name = NSLocalizedString(@"SUBWAYS", @""); line = [line sortedArrayUsingDescriptors:descriptors];
				[detailView setSubwayLines:line]; break;
			case 3:	line = [NSArray arrayWithArray:taxL]; [taxL release]; 
				name = NSLocalizedString(@"TAXIS", @""); line = [line sortedArrayUsingDescriptors:descriptors];
				[detailView setTaxiLines:line]; break;
			default: break;
		}
		if([data getTypeAtIndex:i]){
			[ordered addObject:line];
			[names addObject:name];
		}
	}	
	
	NSArray *orderedLines = [[NSArray alloc] initWithArray: ordered]; [ordered release];
	NSArray * orderedNames = [[NSArray alloc] initWithArray: names]; [names release];
	
	[detailView setOrderedLines:orderedLines];
	[detailView setLineNames:orderedNames];
}


#pragma mark -
#pragma mark Connectivity Delegate Methods

 /*
 /	@method: onlineApp
 /	@description: Managed by the Network's reachability methods. Indicates that the application is Online.
 /				  Removes the posible modal boxes shown, and starts the data loading. In case the data doesn't loads
 /				  properly, will show a modal box with a server error message.
 */

- (void)onlineApp{
	if([utils showingModalView]){
		[utils removeModalView];
	}
	NSLog(@"Online App");
	int dataStatus = 1;
	if(![data dataLoaded]){
		dataStatus = [self loadData];
	}
	if(dataStatus == -1){
		[self showServerError];
	}else if(dataStatus == 0){
		[self showConnectionError];
	}else{
		if(![network serviceActive]){
			[network startStompConnection:kMobHost 
								   onPort:kMobPort 
								 withUser:kMobUser 
								 withPass:kMobPass];
		}
	}
}

 /*
 /	@method: offlineApp
 /	@description: Managed by the Network's reachability methods. Indicates that the application is Offline.
 /				  In this case, the application will show a modal box warning to check the connection.
 */

- (void)offlineApp{
	NSLog(@"Offline App");
	if([utils showingModalView]){
		[utils removeModalView];
	}
	[firstView initLocation];
	[self showConnectionError];
}


-(void)stompConnectionStart{
	[firstView stompConnectionStart];
}

-(void)stompConnectionStop{
	[firstView stompConnectionStop];
}


#pragma mark -
#pragma mark Updating Information Methods

 /*
 /	@method: updateFiltering
 /	@description: Check the current information: Map region and selected lines to create a NSString filter.
 /				  Created the string, it's used in the network's updateStompFiltering 
 */

-(void)updateFiltering{
	
	if([network serviceActive]){
		
		CLLocationCoordinate2D mapCenter = firstView.mapView.region.center;
		CLLocationCoordinate2D northWestCorner, southEastCorner;
		northWestCorner.latitude  = mapCenter.latitude  + (firstView.mapView.region.span.latitudeDelta  / 2.0);
		northWestCorner.longitude = mapCenter.longitude - (firstView.mapView.region.span.longitudeDelta / 2.0);
		southEastCorner.latitude  = mapCenter.latitude  - (firstView.mapView.region.span.latitudeDelta  / 2.0);
		southEastCorner.longitude = mapCenter.longitude + (firstView.mapView.region.span.longitudeDelta / 2.0);
		
		NSMutableString *filter = [NSMutableString stringWithFormat:@"(longitude < %f and longitude > %f and latitude < %f and latitude > %f)",
								   southEastCorner.longitude,
								   northWestCorner.longitude,
								   northWestCorner.latitude,
								   southEastCorner.latitude];
		
		BOOL otherFilters = NO;
		for(id key in [data lines]){
			LineProperties *properties = [data getLine:key];
			if(properties.active){
				if(!otherFilters){
					[filter appendFormat:@" and ("];
					[filter appendFormat:@"line = '%@'",key];
					otherFilters = YES;
				}else{
					[filter appendFormat:@" or line = '%@'",key];
				}
			}
		}
		if(otherFilters){
			[filter appendFormat:@" or line='-')"];
		}	
		
		[network updateStompFiltering:kMobQueue withFilter:filter];
	}
}

 /*
 /	@method: updateMarker
 /	@description: Used to update a single marker information. Called from network's method "messageReceived".
 /	@param: message - NSDictionary with the updated marker information
 */

-(void)updateMarker:(NSDictionary *)message {
	
	NSString *markerId = [message objectForKey:@"numberPlate"];
	MarkerProperties *marker = [[data markers] objectForKey:markerId];	
	if(marker != nil){
		[marker parseLatitude:[[message objectForKey:@"latitude"] doubleValue] andLongitude:[[message objectForKey:@"longitude"] doubleValue]];
		marker.orientation = [[message objectForKey:@"orientation"] intValue];
		
		if(marker.line.active){
			NSString *lineId = [message objectForKey:@"line"];
			if(![lineId isEqual:@"-"]){
				LineProperties *properties = [[data lines] objectForKey:lineId];
				if(properties != nil){
					marker.line = properties;
				}
			}
			[firstView updateMarker:markerId];
		}
		if([markerId isEqual:currentMarker]){
			[firstView setLatitude:marker.coordinate.latitude andLongitude:marker.coordinate.longitude];
		}
	}
}

#pragma mark -
#pragma mark User Properties Methods

 /*
 /	@method: setCurrentMarker
 /	@description: Sets the markerId as current marker to follow him. Also centers the map on the marker's location.
 /  @param: markerId - marker's number plate. Could be nil.
 */

-(void)setCurrentMarker:(NSString*)markerId{
	currentMarker = markerId;
	if(markerId != nil){
		MarkerProperties *properties = [[data markers] objectForKey:currentMarker];
		[firstView setLatitude:properties.coordinate.latitude andLongitude:properties.coordinate.longitude];	
	}else{
		[firstView setLatitude: firstView.mapView.region.center.latitude andLongitude: firstView.mapView.region.center.longitude];
	}
}

 /*
 /	@method: getCurrentMarker
 /	@description: Gets the markerId as current marker to follow him.
 /  @return: currentMarker - marker's number plate. Could be nil.
 */

-(NSString *)getCurrentMarker{
	return currentMarker;
}

 /*
 /	@method: finishListProperties
 /	@description: Used to update the current filter, map annotations and overlays. Called from the detailViewController
 /                when it's going to disapear.
 */

-(void)finishListProperties{
	[self updateFiltering];
	[firstView updateAnnotations];
	[firstView updateOverlays];
}

 /*
 /	@method: lineSelection
 /	@description: Delegated method from DetailTableViewController, used to updateAnnotations.
 */

-(void)lineSelection{
	[firstView updateAnnotations];
}

 /*
 /	@method: routeSelection
 /	@description: Delegated method from DetailTableViewController, used to updateOverlays.
 */

-(void)routeSelection{
	[firstView updateOverlays];
}

 /*
 /	@method: stopsSelection
 /	@description: Delegated method from DetailTableViewController, used to updateStops.
 */

-(void)stopSelection{
	[firstView updateStops];
}

#pragma mark -
#pragma mark Modal Boxes Methods

 /*
 /	@method: showLoading
 /	@description: Shows the loading modal box.
 */

-(void)showLoading{
	if([utils showingModalView]){
		[utils removeModalView];
	}
	UIView *modal =[utils getiPadLoadView:window.bounds];
	[window addSubview:modal];
}

 /*
 /	@method: showServerError
 /	@description: Shows the server error modal box and stops the connection.
 */

-(void)showServerError{
	if([utils showingModalView]){
		[utils removeModalView];
	}
	UIView *modal = [utils getModalView:window.bounds
							  withTitle:NSLocalizedString(@"SERVER_ERROR_TITLE", @"")
							withMessage:NSLocalizedString(@"SERVER_ERROR_SUBTITLE", @"")
								andIcon:@"warnServer.png"];
	[window addSubview:modal];
	[network stopReachabilityManager];
	//[Utils trackPageView:kServerError];
}

 /*
 /	@method: showConnectionError
 /	@description: Shows the connection error modal box.
 */

-(void)showConnectionError{
	if([utils showingModalView]){
		[utils removeModalView];
	}
	UIView *modal = [utils getModalView:window.bounds
							  withTitle:NSLocalizedString(@"CONNECTION_ERROR_TITLE", @"")
							withMessage:nil
								andIcon:@"warnConnection.png"];
	[Utils trackPageView:kConnectError];
	[window addSubview:modal];
}

 /*
 /	@method: showInactive
 /	@description: Shows the inactive app modal box.
 */

-(void)showInactive{
	if([utils showingModalView]){
		[utils removeModalView];
	}
	UIView *modal = [utils getModalView:window.bounds
							  withTitle:NSLocalizedString(@"INACTIVE_APP_TITLE", @"")
							withMessage:NSLocalizedString(@"INACTIVE_APP_SUBTITLE", @"")
								andIcon:@"warnInactive.png"];
	[window addSubview:modal];
}

 /*
 /	@method: showStopInfo
 /	@description: Pushes the stop viewController on the navigationController.
 */

-(void)showStopInfo:(NSString *)stopId{
	
	
	StopProperties *properties = [data getStop:stopId];
	
	[utils beginTrackTime];
	
	NSString *stringURL = [NSString stringWithFormat:@"%@?id=%@", kMobStopsURL, stopId];	
	NSURL *traceURL = [NSURL URLWithString:stringURL];
	NSArray *stopInfo = [[[NSArray alloc] initWithContentsOfURL: traceURL] autorelease];
	
	if(popoverController != nil){
		[popoverController release];
		[tempButton release];
	}
	
	[self setStopView:[[StopTableViewController_iPad alloc] init]];
	[stopView setUtils:utils];
	[stopView setStopInfo:stopInfo];
	[stopView setType:properties.type];
	
	if(properties.stopId == properties.secondId){
		
		[self setPopoverController: [[UIPopoverController alloc] initWithContentViewController:stopView]];
		[popoverController setDelegate: self];
		
		[self setTempButton: [[UIBarButtonItem alloc]initWithCustomView:[firstView pressedButton]]]; 
		[popoverController setPopoverContentSize:CGSizeMake(300, 400) animated:YES];
		[popoverController presentPopoverFromBarButtonItem:tempButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
				
	}else{
		stringURL = [NSString stringWithFormat:@"%@?id=%d", kMobStopsURL, properties.secondId];	
		traceURL = [NSURL URLWithString:stringURL];
		stopInfo = [[[NSArray alloc] initWithContentsOfURL: traceURL] autorelease];
		StopTableViewController_iPad *secondView = [[[StopTableViewController_iPad alloc] init] autorelease];
		[secondView setUtils:utils];
		[secondView setStopInfo:stopInfo];
		[secondView setType:properties.type];
		UITabBarController *tabBarController = [[[UITabBarController alloc] init] autorelease];
		NSArray *controllers = [NSArray arrayWithObjects:stopView,secondView,nil];
		
		[tabBarController setViewControllers:controllers];
		UITabBarItem *item = [[tabBarController tabBar].items objectAtIndex:0];
		item.image = [UIImage imageNamed:@"UpDown.png"];
		item.title = [NSString stringWithFormat:@"%@ A",NSLocalizedString(@"DIRECTION", @"")];
		item = [[tabBarController tabBar].items objectAtIndex:1];
		item.image = [UIImage imageNamed:@"DownUp.png"];
		item.title = [NSString stringWithFormat:@"%@ B",NSLocalizedString(@"DIRECTION", @"")];
		
		[self setPopoverController:[[UIPopoverController alloc] initWithContentViewController:tabBarController]];
		[popoverController setDelegate: self];
		
		[self setTempButton: [[UIBarButtonItem alloc]initWithCustomView:[firstView pressedButton]]];
		[popoverController setPopoverContentSize:CGSizeMake(300, 400) animated:YES];
		[popoverController presentPopoverFromBarButtonItem:tempButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
	}

}

#pragma mark -
#pragma mark View Navigation Controller Methods

 /*
 /	@method: showOkodeInfo
 /	@description: Pushes the Okode information viewController on the navigationController.
 /  @return: IBAction - Connected to the info button on MainWindow.xib
 */

-(void)showOkodeInfoView{
	[Utils trackPageView:kOkodePage];
	[[splitViewController.viewControllers objectAtIndex:1] pushViewController:okodeInfo animated:YES];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {}


- (void)dealloc {
	[splitViewController release];
	[detailView release];
	[firstView release];
	[stopView release];
    [window release];
	[data release];
	[network release];
	[utils release];
	[currentMarker release];
	[okodeInfo release];
	[popoverController release];
	[tempButton release];
    [super dealloc];
}


@end
