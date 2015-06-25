//
//  MobitransitData.m
//  Mobitransit_Helsinki
//
//  Created by Daniel Soro Coicaud on 23/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import "MobitransitData.h"
#import "LineProperties.h"
#import "MarkerProperties.h"
#import "StopProperties.h"
#import "MobitransitDelegate.h"

NSString * const kTempConfig	= @"TempConfig";
NSString * const kTempLines		= @"TempLines";
NSString * const kTempStops		= @"TempStops";

@implementation MobitransitData

@synthesize cityRegion;
@synthesize maxRegion;
@synthesize minRegion;
@synthesize appConfig;
@synthesize lines;
@synthesize markers;
@synthesize stops;
@synthesize docDirectory;
@synthesize lastModified;
@synthesize utils;

@synthesize configFile, linesFile, stopsFile;
@synthesize configLoaded, linesLoaded, markersLoaded, stopsLoaded;

#pragma mark Init

-(id)init{
	[super init];
	
	[self setConfigFile:NO];
	[self setLinesFile:NO];
	[self setStopsFile:NO];
	[self setConfigLoaded:NO];
	[self setLinesLoaded:NO];
	[self setStopsLoaded:NO];
	[self setMarkersLoaded:NO];
	for(int i=0;i<kNumTransportTypes;i++) types[i] = NO;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	[self setDocDirectory:[paths objectAtIndex:0]];
	
	return self;
}


#pragma mark File Manager

-(NSString *)getPath:(ProcessType)type{
	NSString *resPath;
	switch (type) {
		case CONFIG: resPath = [NSString stringWithFormat:@"%@_config.plist", kMobPrefix]; break;
		case LINES:	 resPath = [NSString stringWithFormat:@"%@_lines.plist", kMobPrefix]; break;
		case STOPS:	 resPath = [NSString stringWithFormat:@"%@_stops.plist", kMobPrefix]; break;
		default:	break;
	}
	return [docDirectory stringByAppendingPathComponent:resPath];
}

-(void)checkDataFiles{
	configFile = [self fileManagement:[self getPath:CONFIG] forProcess:CONFIG];
	linesFile = [self fileManagement:[self getPath:LINES] forProcess:LINES];
	stopsFile = [self fileManagement:[self getPath:STOPS] forProcess:STOPS];
}

-(BOOL)fileManagement:(NSString*)path forProcess:(ProcessType)proc{
	
	NSError *error;		
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if(![fileManager fileExistsAtPath:path]){
		NSString *extResource;
		switch (proc) {
			case CONFIG: extResource = kTempConfig; break;
			case LINES:	 extResource = kTempLines; break;
			case STOPS:	 extResource = kTempStops; break;
			default:	break;
		}
		NSString *bundle = [[NSBundle mainBundle] pathForResource:extResource ofType:@"plist"];
		[fileManager copyItemAtPath:bundle toPath:path error:&error];
		return NO;
	}else{
		return YES;
	}
}

-(BOOL)saveFileInformation:(id)information forProcess:(ProcessType)proc{
	if([information isKindOfClass:[NSDictionary class]]){
		NSDictionary *dict = (NSDictionary *)information;
		return [dict writeToFile:[self getPath:proc] atomically:NO];
	}else if([information isKindOfClass:[NSArray class]]){
		NSArray *array = (NSArray *)information;
		return [array writeToFile:[self getPath:proc] atomically:NO];
	}else{
		return NO;
	}
}

#pragma mark -
#pragma mark Load Information Methods

-(int)requestProperties{
	
	NSDictionary *configProperties = nil;
	NSArray *lineProperties = nil;
	NSArray *stopProperties = nil;
	
	NSData *zippedData;
	NSData *unzippedData;
	NSDictionary *staticData;
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSURL *traceURL = [NSURL URLWithString:kMobDataURL];
	NSMutableURLRequest *dataRequest = [[NSMutableURLRequest alloc] initWithURL:traceURL];
	dataRequest.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;

	[dataRequest setHTTPMethod:@"GET"];
	[dataRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];

	[self setLastModified:[prefs objectForKey:@"Helsinki_lastModified"]];
	if(lastModified != nil){
		[dataRequest setValue:lastModified forHTTPHeaderField:@"if-modified-since"];
	}
	
	NSHTTPURLResponse *response = nil;  
	NSError *error = nil;
	
	zippedData = [NSURLConnection sendSynchronousRequest:dataRequest returningResponse:&response error:&error];
	[dataRequest release];
	if(error){
		NSLog(@"CONNECTION ERROR: %@",[error localizedDescription]);
		return 0;
	}else{
		NSLog(@"Status code: %d",[response statusCode]);
		NSString *modifResponse = [[response allHeaderFields] objectForKey:@"Last-Modified"];
		if(modifResponse != nil){
			[self setLastModified:modifResponse];
		}
		if ([response statusCode] == 304){
			NSLog(@"Resources not modified since %@",lastModified);
			configProperties = [[NSDictionary alloc] initWithContentsOfFile:[self getPath:CONFIG]]; 
			lineProperties = [[NSArray alloc] initWithContentsOfFile:[self getPath:LINES]]; 
			stopProperties = [[NSArray alloc] initWithContentsOfFile:[self getPath:STOPS]];
		}else if([response statusCode] == 200){
			NSLog(@"Updated resources on %@",lastModified);
			unzippedData =[Utils allocUnzipData:zippedData];
			staticData = [Utils allocParseDataToDictionary:unzippedData];
			if(staticData != nil){
				if([[staticData objectForKey:@"mConfig"] boolValue]){
					configProperties = [[NSDictionary alloc] initWithDictionary:[staticData objectForKey:@"updatedConfig"]];
					if([self saveFileInformation:configProperties forProcess:CONFIG]) NSLog(@"Loaded configuration properties");
					else NSLog(@"Config save failed");
				}else{
					configProperties = [[NSDictionary alloc] initWithContentsOfFile:[self getPath:CONFIG]]; 
				}
				if([[staticData objectForKey:@"mLines"] boolValue]){
					lineProperties = [[NSArray alloc] initWithArray:[staticData objectForKey:@"updatedLines"]];
					if([self saveFileInformation:lineProperties forProcess:LINES]) NSLog(@"Loaded line properties");
					else NSLog(@"Line save failed");
				}else{
					lineProperties = [[NSArray alloc] initWithContentsOfFile:[self getPath:LINES]]; 
				}
				if([[staticData objectForKey:@"mStops"] boolValue]){
					stopProperties = [[NSArray alloc] initWithArray:[staticData objectForKey:@"updatedStops"]];
					if([self saveFileInformation:stopProperties forProcess:STOPS]) NSLog(@"Loaded stop properties");
					else NSLog(@"Stops save failed");
				}else{
					stopProperties = [[NSArray alloc] initWithContentsOfFile:[self getPath:STOPS]];
				}
			}
			[staticData release];
			[unzippedData release];
		}else{
			NSLog(@"CONTENT ERROR: %d",[response statusCode]);
			return -1;
		}
	}

	if(configProperties != nil && lineProperties != nil && stopProperties){
		[self loadConfigurationProperties:configProperties];
		[self loadLineProperties:lineProperties];
		[self loadStopsProperties:stopProperties];
	}
	
	[configProperties release];
	[lineProperties release];
	[stopProperties release];
	
	return 1;
}

 /*
 /	@method: loadConfigurationProperties:
 /	@description: Loads the application configuration properties from a zipped file from an URL.
 /                The configuration properties are: Default map region and line types to show.
 /	@param: configURL - String url where the configuration file is stored.
 /  @return: BOOL - success of the loading process.
 */

-(void)loadConfigurationProperties: (NSDictionary*)configProperties{
	
		cityRegion.center.latitude = [[configProperties objectForKey:@"latitude"] doubleValue];
		cityRegion.center.longitude = [[configProperties objectForKey:@"longitude"] doubleValue];
		cityRegion.span.latitudeDelta = [[configProperties objectForKey:@"latitudeDelta"] doubleValue];
		cityRegion.span.longitudeDelta = [[configProperties objectForKey:@"longitudeDelta"] doubleValue];
		
		maxRegion.center.latitude = [[configProperties objectForKey:@"maxLat"] doubleValue];
		maxRegion.center.longitude = [[configProperties objectForKey:@"maxLong"] doubleValue];
		maxRegion.span.latitudeDelta = [[configProperties objectForKey:@"portraitLatDelta"] doubleValue];
		maxRegion.span.longitudeDelta = [[configProperties objectForKey:@"portraitLonDelta"] doubleValue];
		
		minRegion.center.latitude = [[configProperties objectForKey:@"minLat"] doubleValue];
		minRegion.center.longitude = [[configProperties objectForKey:@"minLong"] doubleValue];
		minRegion.span.latitudeDelta = [[configProperties objectForKey:@"landscapeLatDelta"] doubleValue];
		minRegion.span.longitudeDelta = [[configProperties objectForKey:@"landscapeLonDelta"] doubleValue];
	
		NSMutableArray *tempTypes = [[NSMutableArray alloc] initWithArray:[configProperties objectForKey:@"lineTypes"]];
		for(int i=0; i<[tempTypes count];i++){
			int index = [[tempTypes objectAtIndex:i] intValue];
			types[index] = YES;
		}
		[tempTypes release];
				
		configLoaded = YES;
	
}

 /*
 /	@method: loadLineProperties:
 /	@description: Loads the application line properties from a zipped file from an URL.
 /                The line properties specifies the id, name, type, route and color of each line.
 /	@param: linesURL - String url where the lines file is stored.
 /  @return: BOOL - success of the loading process.
 */

-(void)loadLineProperties: (NSArray *)lineProperties{
		
		NSMutableDictionary *tempLines = [[NSMutableDictionary alloc] init];
		
		for(NSDictionary *line in lineProperties) {
			LineProperties *properties = [[LineProperties alloc] init];
			TransportType lineType = [[line objectForKey:@"type"] intValue];
			NSString *lineID = [line objectForKey:@"line"];
			NSString *name = [line objectForKey:@"name"];
			[properties setName:name];
			[properties setType:lineType];
			[properties setActive:YES];
			[properties setOrder:[[line objectForKey:@"order"] intValue]];
			[properties setImage:[utils getLineImage:lineType]];
			[properties setActiveChanged:NO];
			[properties setActiveRouteChanged:NO];
			[properties setActiveStopsChanged:NO];
			
			 NSArray *route = [line objectForKey:@"route"];
			 if(route != nil){
				 MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * route.count);
				 for(int i=0;i<[route count];i++){
					 NSArray *coords = [[route objectAtIndex:i] componentsSeparatedByString: @","];
					 CLLocationCoordinate2D coordinate;
					 coordinate.latitude = [[coords objectAtIndex:1] doubleValue];
					 coordinate.longitude = [[coords objectAtIndex:0] doubleValue];
					 MKMapPoint point = MKMapPointForCoordinate(coordinate);
					 pointArr[i] = point;
				 }
				 MKPolyline *coordinatedRoute = [MKPolyline polylineWithPoints:pointArr count:route.count];
				 free(pointArr);
				 [properties setRoute:coordinatedRoute];
				 NSString *routeColor = [line objectForKey:@"color"];
				 UIColor *rColor = [utils getColor:routeColor];
				 [properties setColor:rColor];
				 [properties setActiveRoute:NO];
			 }else{
				 [properties setRoute:nil];
				 [properties setActiveRoute:NO];
				 [properties setActiveStops:NO];
				 [properties setColor:nil];
			 }
		
			[tempLines setObject:properties forKey:lineID];
			[properties release];
		}
	
		lines = [[NSDictionary alloc] initWithDictionary:tempLines];
		
		[tempLines release];
	
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSArray *userLines = [prefs objectForKey:@"Helsinki_inactive"];
		for(id key in userLines){
			LineProperties *properties = [lines objectForKey:key];
			[properties setActive:NO];
		}
	
		NSArray *userRoutes = [prefs objectForKey:@"Helsinki_routes"];
		for(id key in userRoutes){
			LineProperties *properties = [lines objectForKey:key];
			[properties setActiveRoute:YES];
		}
		
		NSArray *userStops = [prefs objectForKey:@"Helsinki_stops"];
		for(id key in userStops){
			LineProperties *properties = [lines objectForKey:key];
			[properties setActiveStops:YES];
		}
		
		linesLoaded = YES;
	
}

 /*
 /	@method: loadStopsProperties:
 /	@description: Loads the application stops properties from a zipped file from an URL.
 /                The stops properties specifies the stopId, coordinate, name and lines.
 /	@param: stopsURL - String url where the markers file is stored.
 /  @return: BOOL - success of the loading process.
 /	TODO: Currently using a Stops.plist from the project. Must get it from server.
 */

-(void)loadStopsProperties: (NSArray *)stopsProperties{
	
	NSMutableDictionary *tempStops = [[NSMutableDictionary alloc] init];
	
	for(NSDictionary *stop in stopsProperties) {
		int stopId = [[stop objectForKey:@"stopId"] intValue];
		int secondId = [[stop objectForKey:@"stopId2"] intValue];
		TransportType stopType = [[stop objectForKey:@"type"] intValue];
		NSString *name = [stop objectForKey:@"name"];
		
		double latitude = [[stop objectForKey:@"latitude"] doubleValue];
		double longitude = [[stop objectForKey:@"longitude"] doubleValue];
		
		NSArray *stopLines = [stop objectForKey:@"lines"];
		
		StopProperties *properties = [[StopProperties alloc] init];
		[properties setStopId:stopId];
		[properties setSecondId:secondId];
		[properties setType:stopType];
		[properties setName:name];
		[properties parseLatitude:latitude andLongitude:longitude];
		
		NSMutableArray *tempLines = [[NSMutableArray alloc] init];
		for(int i=0; i < [stopLines count]; i++){
			NSString *lineId = [stopLines objectAtIndex:i];
			LineProperties *lProp = [lines objectForKey:lineId];
			if(lProp != nil){
				NSMutableArray *tempStops;
				if(lProp.stops == nil){
					tempStops = [[NSMutableArray alloc] init];
				}else{
					tempStops = [[NSMutableArray alloc] initWithArray:lProp.stops];
				}
				[tempStops addObject:properties];
				[lProp setStops:tempStops];
				[tempStops release];
				[tempLines addObject:lProp];
			}
		}
		
		[properties setLines:tempLines];
		[tempLines release];
		[tempStops setObject:properties forKey:[NSString stringWithFormat:@"%d",stopId]];
		[properties release];
	}
	stops = [[NSDictionary dictionaryWithDictionary:tempStops] retain];
	
	[tempStops release];
	stopsLoaded = YES;
	
	
}


 /*
 /	@method: loadMarkerProperties:
 /	@description: Loads the application marker properties from a zipped file from an URL.
 /                The marker properties specifies the numberplate, coordinate, orientation and line of each marker.
 /	@param: markersURL - String url where the markers file is stored.
 /  @return: BOOL - success of the loading process.
 */

-(void)loadMarkerProperties: (NSString *)markersURL{
	
	NSData *unzippedData = [Utils allocUnzipDataFromURL:markersURL];
	NSArray *markerProperties = [Utils allocParseDataToArray:unzippedData];
	if(markerProperties != nil){
		NSMutableDictionary *tempMarkers = [[NSMutableDictionary alloc] init];
	
		for(NSDictionary *marker in markerProperties) {
			NSString *numberPlate = [marker objectForKey:@"numberPlate"];
			
			double latitude = [[marker objectForKey:@"latitude"] doubleValue];
			double longitude = [[marker objectForKey:@"longitude"] doubleValue];			
			int orientation = [[marker objectForKey:@"orientation"] intValue];
			NSString *line = [marker objectForKey:@"line"];
			
			MarkerProperties *properties = [[MarkerProperties alloc] init];
			[properties setNumberPlate:numberPlate];
			[properties setOrientation:orientation];
			[properties parseLatitude:latitude andLongitude:longitude];
			[properties setLine:[lines objectForKey:line]];
		
			[tempMarkers setObject:properties forKey:numberPlate];
			[properties release];
		}
		markers = [[NSDictionary dictionaryWithDictionary:tempMarkers] retain];
		[tempMarkers release];
		markersLoaded = YES;
	}
	
	[unzippedData release];
	[markerProperties release];

}


-(BOOL)staticResourcesLoaded{
	return (configLoaded && linesLoaded && stopsLoaded);
}

-(BOOL)dataLoaded{
	return (configLoaded && linesLoaded && stopsLoaded && markersLoaded);
}

#pragma mark -
#pragma mark Single get methods

 /*
 /	@method: getLine:
 /	@description: Gets a line from the Lines' NSDictionary from his key.
 /	@param: lineKey - Line id.
 /  @return: LineProperties - The corresponding line to the given key.
 */

-(LineProperties *)getLine:(id)lineKey{
	return [lines objectForKey:lineKey];
}

 /*
 /	@method: getMarker:
 /	@description: Gets a marker from the Markers' NSDictionary from his key.
 /	@param: markerKey - Marker id.
 /  @return: MarkerProperties - The corresponding marker to the given key.
 */

-(MarkerProperties *)getMarker:(id)markerKey{
	MarkerProperties *properties = [markers objectForKey:markerKey];
	return properties;
}

 /*
 /	@method: getStop:
 /	@description: Gets a stop from the Stops' NSDictionary from his key.
 /	@param: stopKey - Marker id.
 /  @return: StopProperties - The corresponding stop to the given key.
 */

-(StopProperties *)getStop:(id)stopKey{
	StopProperties *properties = [stops objectForKey:stopKey];
	return properties;
}

 /*
 /	@method: getTypeAtIndex:
 /	@description: Indicates if the application is configured to manage a specified type of line.
 /	@param: index - Type index. @See Utils' enum tTypes.
 /  @return: BOOL - The type support for the index.
 */

-(BOOL)getTypeAtIndex:(int)index{
	return types[index];
}

-(void) dealloc{
	[appConfig release];
	[lines release];
	[markers release];
	[stops release];
	[docDirectory release];
	[lastModified release];
    [super dealloc];
}

@end
