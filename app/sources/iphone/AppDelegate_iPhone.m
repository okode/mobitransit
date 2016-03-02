//
//  AppDelegate_iPhone.m
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 24/09/10.
//  Copyright Okode S.L. 2010. All rights reserved.
//

#import "AppDelegate_iPhone.h"
#import "RootViewController.h"

#pragma mark -
#pragma mark MobitransitAppDelegate implementation

@implementation AppDelegate_iPhone

@synthesize window;
@synthesize tabController;
@synthesize navigationController;
@synthesize firstView;
@synthesize detailView;
@synthesize stopView;
@synthesize configView;
@synthesize data;
@synthesize network;
@synthesize utils;
@synthesize currentMarker;
@synthesize locationEnabled;
@synthesize newsView;
@synthesize infoView;
@synthesize infoBarItem;
@synthesize twitter;
@synthesize twitterConnected;
@synthesize facebook;
@synthesize facebookUserPic;
@synthesize facebookUserName;
@synthesize facebookConnected;
@synthesize permissions;

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
	
	data = [[MobitransitData alloc] init];
	[data setUtils:utils];
	[data checkDataFiles];
	
	network = [MobitransitNetwork new];
	[network setDelegate:self];
	[network loadReachabilityManager:kMobHost];
    
	[firstView setDelegate:self];
	[firstView setUtils:utils];
    
    [configView setTitle:NSLocalizedString(@"CONFIG_TITLE",@"")];
    [infoView setTitle:NSLocalizedString(@"INFO_TITLE",@"")];
    [detailView setTitle:NSLocalizedString(@"LINES",@"")];
    
    [window addSubview:tabController.view];
    [window makeKeyAndVisible];
	[self showLoading];
	
	twitterConnected = [self getTwitterLoggin];
	    
    facebookConnected = [self getFacebookLoggin];
	if(facebookConnected){
        [self checkFacebookPicture];
        [self checkFacebookUserName];
	}
    
    [configView enableUserLocation:[self loadLocationState]];
    return YES;
}

/*
 /	@method: applicationDidEnterBackground:
 /	@description: Managed by the UIApplicationDelegate. Called when the application did enter in Background.
 /				  This method is used to save the user preferences and stop and disconnect the stomp service.
 /	@param: application - current application reference
 */

- (void)applicationDidEnterBackground:(UIApplication *)application {
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
 /	@description: Managed by the UIApplicationDelegate. Called when the application returns from inactive State.
 /	@param: application - current application reference
 */

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [utils removeModalView];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showInactive) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endApplication) object:nil];
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
	locationEnabled = [self loadLocationState];
	
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
    
    [self performSelector:@selector(readAdvices) withObject:nil afterDelay:2];
    
	return dataStatus;
}

-(void)populateContents{
	[self loadLinesDetail];
	[firstView loadInfo];
    
	[firstView initLocation];
	[firstView updateOverlays];
	[firstView updateAnnotations];
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
	[configView stompConnectionStart];
}

-(void)stompConnectionStop{
	[configView stompConnectionStop];
}

#pragma mark -
#pragma mark View Navigation Controller Methods


/*
 /	@method: showDetails
 /	@description: Pushes the lines table viewController on the navigationController.
 */

-(void)showDetails {
	[firstView removeOverlays];
	[Utils trackPageView:kLinesPage];
	
    [self.navigationController pushViewController:detailView animated:YES];
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
	
	
	
	[self setStopView:[[StopTableViewController alloc] init]];
	[stopView setUtils:utils];
	[stopView setStopInfo:stopInfo];
	[stopView setCurrentStopId:stopId];
	[stopView setType:properties.type];
	
	if(properties.stopId == properties.secondId){
		[self.navigationController pushViewController:stopView animated:YES];
	}else{
		stringURL = [NSString stringWithFormat:@"%@?id=%d", kMobStopsURL, properties.secondId];	
		traceURL = [NSURL URLWithString:stringURL];
		stopInfo = [[[NSArray alloc] initWithContentsOfURL: traceURL] autorelease];
		StopTableViewController *secondView = [[[StopTableViewController alloc] init] autorelease];
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
        
		[self.navigationController pushViewController:tabBarController animated:YES];
		
	}
	
}

#pragma mark -
#pragma mark User Properties Methods


-(void)enableUserLocation{
	locationEnabled = YES;
    [configView enableUserLocation:YES];
}

-(void)disableUserLocation{
	locationEnabled = NO;
    [configView enableUserLocation:NO];
}

-(BOOL)isUserLocationActive{
    return [firstView.mapView showsUserLocation];
}

-(void)changeMapTypeNormal {
    [firstView mapTypeNormal];
}

-(void)changeMapTypeSatellite{
    [firstView mapTypeSatellite];
}

-(void)changeMapTypeHybrid{
    [firstView mapTypeHybrid];
}

-(void)saveLocationState:(BOOL)enable{
    if(enable){
        [[NSUserDefaults standardUserDefaults]  setObject:@"ENABLE" forKey: @"locationState"];
    }else{
        [[NSUserDefaults standardUserDefaults]  setObject:@"DISABLE" forKey: @"locationState"];
    }
    [NSUserDefaults standardUserDefaults];
}

-(BOOL)loadLocationState{
	NSString *result = [[NSUserDefaults standardUserDefaults] objectForKey:@"locationState"];
    if(result == nil || [result isEqualToString:@"ENABLE"]){
        return YES;
    }else{
        return NO;
    }
}

-(void)changeUserLocationStateTo:(BOOL)enable{
    [self saveLocationState:enable];
    if(enable){
		if(currentMarker != nil){
			[firstView deselectMarker:currentMarker];
		}
    }
    [firstView changeUserLocationTo:enable];
}


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
	UIView *modal =[utils getLoadView:window.bounds];
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
	[Utils trackPageView:kServerError];
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

-(void)updateInfoBadgeValue{
    if([newsView newAdvices]){
        [infoBarItem setBadgeValue:[NSString stringWithFormat:@"%d",[newsView unreadNewsletter]]];
    }
}

-(void)readAdvices{
    if(newsView.newsletters == nil){
        [newsView requestNews];
    }
}

#pragma -
#pragma TabBarController delegate methods

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    UINavigationController *cover = (UINavigationController *)viewController;
    UIViewController *content = [[cover viewControllers] objectAtIndex:0];
    
    if([content isKindOfClass:[DetailTableViewController class]]){
        [firstView removeOverlays];
        [Utils trackPageView:kLinesPage];
    }
    else if([content isKindOfClass:[InformationController class]]){
        [newsView.tableView reloadData];
        [infoBarItem setBadgeValue:nil];
    }else if([content isKindOfClass:[ConfigurationController class]]){
		if(!twitter){
            [self initTwitter];
		}
        if(!facebook){
            [self initFacebook];
        }
		[configView changeTwitterSwitch:[self getTwitterLoggin]];
        [configView changeFacebookSwitch:[self getFacebookLoggin]];
	}
}

#pragma mark -
#pragma mark Twitter delegate methods

-(void)initTwitter{
    twitter = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];  
    twitter.consumerKey    = kOAuthConsumerKey;  
    twitter.consumerSecret = kOAuthConsumerSecret; 
}

-(void)twitterLogin:(BOOL)connect{
	if(connect){
		if(![twitter isAuthorized]){  
			UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:twitter delegate:self];  
			if (controller){  
				[tabController presentModalViewController:controller animated: YES];  
			}  
		}else{
			[self setTwitterLoggin:YES];
		}
	}else{
		[self setTwitterLoggin:NO];
	}
}

-(void)setTwitterLoggin:(BOOL)login{
	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
	if(login){
		[defaults setObject:@"LOGGED" forKey: @"loggedOnTwitter"];
		twitterConnected = YES;
	}else{
		[defaults setObject:@"NOT_LOGGED" forKey: @"loggedOnTwitter"];
        [twitter clearAccessToken];
        twitterConnected = NO;
	}
	[defaults synchronize];
}


-(BOOL)getTwitterLoggin{
	NSString *result = [[NSUserDefaults standardUserDefaults] objectForKey:@"loggedOnTwitter"];
	if(result == nil || [result isEqualToString:@"NOT_LOGGED"]){
		return NO;
	}else{
		return YES;
	}
}

-(void)storeCachedTwitterOAuthData:(NSString *)theData forUsername: (NSString *) username {
	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:theData forKey: @"authData"];
	[defaults synchronize];
}

-(NSString *)cachedTwitterOAuthDataForUsername:(NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"authData"];
}

-(void)requestSucceeded:(NSString *) requestIdentifier {
	NSLog(@"Request %@ succeeded", requestIdentifier);
	[[ActivityIndicator currentIndicator] displayCompleted:NSLocalizedString(@"SHARE_COMPLETE",@"")];
}

-(void)requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
	[[ActivityIndicator currentIndicator] displayError:NSLocalizedString(@"UNEXPECTED_ERROR",@"")];
}

-(void)OAuthTwitterController:(SA_OAuthTwitterController *)controller authenticatedWithUsername:(NSString *)username {
	[self setTwitterLoggin:YES];
	[configView changeTwitterSwitch:YES];
}

-(void)OAuthTwitterControllerFailed:(SA_OAuthTwitterController *)controller {
	[self setTwitterLoggin:NO];
	[configView changeTwitterSwitch:NO];
}

-(void)OAuthTwitterControllerCanceled:(SA_OAuthTwitterController *)controller {
	[self setTwitterLoggin:NO];
	[configView changeTwitterSwitch:NO];

}

-(void)twitMessage:(NSString *)message {
	if(!twitter){
		[self initTwitter]; 
	}if(![twitter isAuthorized]){
		[self twitterLogin:YES];
	}
	
	[twitter sendUpdate:message];
    [[ActivityIndicator currentIndicator] displayActivity:NSLocalizedString(@"SENDING",@"")];
}

#pragma mark -
#pragma mark Facebook delegate methods

-(void)initFacebook{
    facebook = [[Facebook alloc] initWithAppId:kFacebookAppId];
    facebook.accessToken    = [[NSUserDefaults standardUserDefaults] stringForKey:@"FBAccessToken"];
    facebook.expirationDate = (NSDate *) [[NSUserDefaults standardUserDefaults] objectForKey:@"FBExpirationDate"];
    permissions = [[NSArray alloc] initWithObjects: @"publish_stream", nil];
}


-(void)facebookLoggin:(BOOL)connect{
    if(connect){
		if(![facebook isSessionValid]){  
            [facebook authorize:permissions delegate:self]; 
		}else{
			[self setFacebookLoggin:YES];
		}
	}else{
		[self setFacebookLoggin:NO];
	}
}

-(void)setFacebookLoggin:(BOOL)login{
	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
	if(login){
		[defaults setObject:@"LOGGED" forKey: @"loggedOnFacebook"];
		facebookConnected = YES;
        if(!facebookUserPic){
            [self checkFacebookPicture];
        }
        if(!facebookUserName){
            [self requestFacebookUserName];
        }
	}else{
		[defaults setObject:@"NOT_LOGGED" forKey: @"loggedOnFacebook"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FBAccessToken"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FBExpirationDate"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"facebookUserPic"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"facebookUserName"];
        [facebook logout:self];
        facebookConnected = NO;
        [self setFacebookUserName:nil];
        [self setFacebookUserPic:nil];
	}
	[defaults synchronize];
}

-(BOOL)getFacebookLoggin{
	NSString *result = [[NSUserDefaults standardUserDefaults] objectForKey:@"loggedOnFacebook"];
	if(result == nil || [result isEqualToString:@"NOT_LOGGED"]){
		return NO;
	}else{
		return YES;
	}
}

-(void)checkFacebookPicture {
    NSData *pic = [[NSUserDefaults standardUserDefaults] objectForKey:@"facebookUserPic"];
    if(!pic){
        if(!facebook){
            [self initFacebook];
        }
        [self requestFacebookUserPicture];
    }else{
        [self setFacebookUserPic:[UIImage imageWithData:pic]];
    }
}

-(void)requestFacebookUserPicture {
    [facebook requestWithGraphPath:@"me/picture" andDelegate:self];
}

-(void)checkFacebookUserName {
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"facebookUserName"];
    if(!name){
        if(!facebook){
            [self initFacebook];
        }
        [self requestFacebookUserName];
    }else{
        [self setFacebookUserName:name];
    }
}

-(void)requestFacebookUserName {
    [facebook requestWithGraphPath:@"me" andDelegate:self];
}

-(void)facebookMessage:(NSString *)message {
    if(!facebook){
        [self initFacebook];
    }if(![facebook isSessionValid]){
		[self facebookLoggin:YES];
	}
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithCapacity:1];
    [params setObject:@"Mobintransit connect" forKey:@"name"];
    [params setObject:message forKey:@"message"];
    [facebook requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:self];
    [[ActivityIndicator currentIndicator] displayActivity:NSLocalizedString(@"SENDING",@"")];
    [params release];
}

#pragma mark -
#pragma mark FBSessionDelegate methods

- (void)fbDidLogin {
	NSLog(@"Logged User");
	[[NSUserDefaults standardUserDefaults] setObject:facebook.accessToken forKey:@"FBAccessToken"];
	[[NSUserDefaults standardUserDefaults] setObject:facebook.expirationDate forKey:@"FBExpirationDate"];
    [[NSUserDefaults standardUserDefaults] setObject:@"LOGGED" forKey: @"loggedOnFacebook"];
    facebookConnected = YES;
    [configView changeFacebookSwitch:YES];
    [self requestFacebookUserPicture];
    [self requestFacebookUserName];
}

-(void)fbDidNotLogin:(BOOL)cancelled{
	NSLog(@"Not Logged User");
    [self setFacebookLoggin:NO];
	[configView changeFacebookSwitch:NO];
}

-(void)fbDidLogout {
	NSLog(@"User Logout");
	facebookConnected = NO;	
    [[NSUserDefaults standardUserDefaults] setObject:@"NOT_LOGGED" forKey: @"loggedOnFacebook"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FBAccessToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FBExpirationDate"];
    [configView changeFacebookSwitch:NO];
}

#pragma mark -
#pragma mark FBRequestDelegate methods

- (void)request:(FBRequest*)request didLoad:(id)result {
    if([result isKindOfClass:[NSData class]]){
        NSLog(@"Image loaded");
        [self setFacebookUserPic:[UIImage imageWithData:result]];
        if(facebookUserPic){
            [[NSUserDefaults standardUserDefaults] setObject:result forKey: @"facebookUserPic"];
        }
    }else{
        NSDictionary *info = (NSDictionary *)result;
        NSString *name = [info objectForKey:@"name"];
        if(name){
            NSLog(@"Name loaded: %@",name);
            [self setFacebookUserName:name];
            [[NSUserDefaults standardUserDefaults] setObject:name forKey: @"facebookUserName"];
        }else{
            [[ActivityIndicator currentIndicator] displayCompleted:NSLocalizedString(@"SHARE_COMPLETE",@"")];
        }
    }
}

-(void)startReverseGeocoding{
    [[ActivityIndicator currentIndicator] displayActivity:NSLocalizedString(@"LOADING",@"")];
    [firstView reverseGeocoderCurrentLocation];
}

-(void)reverseGeocodingEnded:(BOOL)success{
    [[ActivityIndicator currentIndicator] hide];
    
    NSString *city = NSLocalizedString(@"SMS_INPUT_CITY",@"");
    NSString *street = NSLocalizedString(@"SMS_INPUT_STREET_NAME",@"");
    NSString *number = NSLocalizedString(@"SMS_INPUT_STREET_NUMBER",@"");
    
    BOOL allLoaded = success;
    
    if(success){
        if([firstView currentCityName]){
            city = [firstView currentCityName];
        }else{
            allLoaded = NO;
        }
        if([firstView currentStreetName]){
            street = [firstView currentStreetName];
        }else{
             allLoaded = NO;
        }
        if([firstView currentNumber]){
            number = [firstView currentNumber];
        }else{
             allLoaded = NO;
        }
    }
    
    if(!allLoaded){
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SMS_ALERT_TITLE",@"") message:NSLocalizedString(@"SMS_ALERT_MESSAGE",@"") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
     [alert show];
    }
    
    [infoView.smsInfo populateTaxiSMS:city onStreet:street andNumber:number];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[navigationController release];
    [tabController release];
	[window release];
	[firstView release];
	[detailView release];
    [configView release];
	[data release];
	[network release];
	[utils release];
	[currentMarker release];
    [infoBarItem release];
    [infoView release];
    [newsView release];
	[twitter release];
    [facebook release];
    [facebookUserPic release];
    [facebookUserName release];
    [permissions release];
	[super dealloc];
}


@end

