//
//  Utils.m
//  Mobitransit_Helsinki
//
//  Created by Daniel Soro Coicaud on 16/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import "Utils.h"
#import "NSData+Gzip.h"

//TODO: Solve the CLLocationCoordinate2DMake problem otherway
static inline CLLocationCoordinate2D CLLocationCoordinate2DInlineMake(CLLocationDegrees latitude, CLLocationDegrees longitude)
{
	CLLocationCoordinate2D coord;
	coord.latitude = latitude;
	coord.longitude = longitude;
	return coord;
}

#define CLLocationCoordinate2DMake CLLocationCoordinate2DInlineMake

@implementation Utils

@synthesize orientationImages;
@synthesize lineImages;
@synthesize modalView;
@synthesize showingModalView;
@synthesize timeReference;

#pragma mark Initialization

 /*
 /	@method: loadImages
 /	@description: Loads all the static images.
 */

-(void)loadImages {

	orientationImages = [[NSArray alloc] initWithObjects:	[UIImage imageNamed:@"bus0.png"],[UIImage imageNamed:@"bus45.png"],
															[UIImage imageNamed:@"bus90.png"],[UIImage imageNamed:@"bus135.png"],
															[UIImage imageNamed:@"bus180.png"],[UIImage imageNamed:@"bus225.png"],
															[UIImage imageNamed:@"bus270.png"],[UIImage imageNamed:@"bus315.png"],
															[UIImage imageNamed:@"tram0.png"],[UIImage imageNamed:@"tram45.png"],
															[UIImage imageNamed:@"tram90.png"],[UIImage imageNamed:@"tram135.png"],
															[UIImage imageNamed:@"tram180.png"],[UIImage imageNamed:@"tram225.png"],
															[UIImage imageNamed:@"tram270.png"],[UIImage imageNamed:@"tram315.png"],
															nil];
	
	lineImages = [[NSArray alloc] initWithObjects:	[UIImage imageNamed:@"bgnum-bus.png"],[UIImage imageNamed:@"bgnum-tram.png"],
													nil];
	
	showingModalView = NO;
}

#pragma mark -
#pragma mark Get static resources methods

 /*
 /	@method: getIcon:orientedTo:
 /	@description: Returns the reference to the static image corresponding to a line type and orientation
 /	@param: lineType - type of line. @see: Utils' enum tTypes
 /	@param: orientation - marker orientation (0,45,90,135,180,225,270 or 315).
 /  @return: UIImage - Static image reference.
 */

-(UIImage *)getIcon:(TransportType)lineType orientedTo:(int)orientation {

	int index = orientation/45;
	index += 8*lineType;
	
	return (UIImage*)[orientationImages objectAtIndex:index];
}

 /*
 /	@method: getLineImage:
 /	@description: Returns the reference to the static image corresponding to a line type for label square.
 /	@param: lineType - type of line. @see: Utils' enum tTypes
 /  @return: UIImage - Static image reference.
 */

-(UIImage *)getLineImage:(TransportType) lineType {
	return [lineImages objectAtIndex:lineType];
}

/*
 /	@method: getStopmage:
 /	@description: Returns the stop icon corresponding to a line type for annotations.
 /	@param: lineType - type of line. @see: Utils' enum tTypes
 /  @return: UIImage - Stop annotation icon reference.
 */

+(UIImage *)getStopImage:(TransportType)lineType{
	UIImage *checked;
	switch (lineType) {
		case BUS: checked = [UIImage imageNamed:@"busStop.png"];break;
		case TRAMWAY: checked = [UIImage imageNamed:@"tramStop.png"];break;
		case SUBWAY: checked = [UIImage imageNamed:@"subStop.png"];break;
		case TAXI: checked = [UIImage imageNamed:@"taxStop.png"];break;
		default: checked = [UIImage imageNamed:@"busStop.png"];break;
	}
	return checked;
}

 /*
 /	@method: getColor:
 /	@description: Gets the UIColor object from a RGBA string separated by ','
 /	@param: colorString - RGBA string in format: R,G,B,A. example: RedStringColor -> "1.0,0.0,0.0,1.0"
 /  @return: UIColor - The UIColor object corresponding to the string.
 */

-(UIColor *)getColor:(NSString *)colorString{
	NSArray *colors = [colorString componentsSeparatedByString: @","];
	return [UIColor colorWithRed:[[colors objectAtIndex:0] floatValue] 
						   green:[[colors objectAtIndex:1] floatValue] 
							blue:[[colors objectAtIndex:2] floatValue] 
						   alpha:[[colors objectAtIndex:3] floatValue]];
	
}

 /*
 /	@method: getCheckIcon:
 /	@description: Returns the check icon corresponding to a line type.
 /	@param: lineType - type of line. @see: Utils' enum tTypes
 /  @return: UIImage - Check icon reference.
 */

+(UIImage *)getCheckIcon:(TransportType)lineType{
	UIImage *checked;
	switch (lineType) {
		case BUS: checked = [UIImage imageNamed:@"checked-bus.png"];break;
		case TRAMWAY: checked = [UIImage imageNamed:@"checked-tram.png"];break;
		case SUBWAY: checked = [UIImage imageNamed:@"checked-sub.png"];break;
		case TAXI: checked = [UIImage imageNamed:@"checked-tax.png"];break;
		default: checked = [UIImage imageNamed:@"checked-bus.png"];break;
	}
	return checked;
}

 /*
 /	@method: getRouteIcon:
 /	@description: Returns the route icon corresponding to a line type.
 /	@param: lineType - type of line. @see: Utils' enum tTypes
 /  @return: UIImage - Route icon reference.
 */

+(UIImage *)getRouteIcon:(TransportType)lineType{
	UIImage *checked;
	switch (lineType) {
		case BUS: checked = [UIImage imageNamed:@"selectedRouteBus.png"];break;
		case TRAMWAY: checked = [UIImage imageNamed:@"selectedRouteTram.png"];break;
		case SUBWAY: checked = [UIImage imageNamed:@"selectedRouteSub.png"];break;
		case TAXI: checked = [UIImage imageNamed:@"selectedRouteTax.png"];break;
		default: checked = [UIImage imageNamed:@"selectedRouteBus.png"];break;
	}
	return checked;
}

/*
 /	@method: getStopIcon:
 /	@description: Returns the stop icon corresponding to a line type.
 /	@param: lineType - type of line. @see: Utils' enum tTypes
 /  @return: UIImage - Stop icon reference.
 */

+(UIImage *)getStopIcon:(TransportType)lineType{
	UIImage *checked;
	switch (lineType) {
		case BUS: checked = [UIImage imageNamed:@"selectedStopBus.png"];break;
		case TRAMWAY: checked = [UIImage imageNamed:@"selectedStopTram.png"];break;
		case SUBWAY: checked = [UIImage imageNamed:@"selectedStopSub.png"];break;
		case TAXI: checked = [UIImage imageNamed:@"selectedStopTax.png"];break;
		default: checked = [UIImage imageNamed:@"selectedStopBus.png"];break;
	}
	return checked;
}

/*
 /	@method: getSmallStopIcon:
 /	@description: Returns the stop icon corresponding to a line type.
 /	@param: lineType - type of line. @see: Utils' enum tTypes
 /  @return: UIImage - Stop icon reference.
 */

+(UIImage *)getSmallStopIcon:(TransportType)lineType{
	UIImage *checked;
	switch (lineType) {
		case BUS: checked = [UIImage imageNamed:@"selectedStopBus-Small.png"];break;
		case TRAMWAY: checked = [UIImage imageNamed:@"selectedStopTram-Small.png"];break;
		case SUBWAY: checked = [UIImage imageNamed:@"selectedStopSub-Small.png"];break;
		case TAXI: checked = [UIImage imageNamed:@"selectedStopTax-Small.png"];break;
		default: checked = [UIImage imageNamed:@"selectedStopBus-Small.png"];break;
	}
	return checked;
}

+(NSString *)getTypeName:(TransportType)lineType{
	
	switch (lineType) {
		case BUS: return @"bus";
		case TRAMWAY: return @"tramway";
		case SUBWAY: return @"subway";
		case TAXI: return @"taxi";
		default: break;
	}
	return @"unknow";
}

+(NSString *)getTypeLocalizedName:(TransportType)lineType{
	
	switch (lineType) {
		case BUS: return NSLocalizedString(@"BUS", @"");
		case TRAMWAY: return NSLocalizedString(@"TRAMWAY", @"");
		case SUBWAY: return NSLocalizedString(@"SUBWAY", @"");
		case TAXI: return NSLocalizedString(@"TAXI", @"");
		default: break;
	}
	return @"unknow";
}

 /*
 /	@method: getBackgroundWithMaxLimits:andMinLimits:
 /	@description: Returns the MKPolygon object for the black background. This background produces a hole for the specified limits
 /	@param: max - Maximum coordinates for the hole. Specifies maximum latitude and maximum longitude.
 /	@param: min - Minimum coordinates for the hole. Specifies minimum latitude and minimum longitude.
 /  @return: MKPolygon - The holed background's MKPolygon.
 */

-(MKPolygon*) getBackgroundWithMaxLimits:(MKCoordinateRegion)max andMinLimits:(MKCoordinateRegion)min{
	CLLocationCoordinate2D  points[10];
	
    points[0] = CLLocationCoordinate2DMake(84.834225,-178.242187);
    points[1] = CLLocationCoordinate2DMake(-84.897147,-178.59375);
	points[2] = CLLocationCoordinate2DMake(-84.897147,178.242188); 
	points[3] = CLLocationCoordinate2DMake(84.834225,178.242188);
	points[4] = CLLocationCoordinate2DMake(84.834225,-178.242187);
	points[5] = CLLocationCoordinate2DMake(min.center.latitude,max.center.longitude);
	points[6] = CLLocationCoordinate2DMake(max.center.latitude,max.center.longitude);
	points[7] = CLLocationCoordinate2DMake(max.center.latitude,min.center.longitude);
	points[8] = CLLocationCoordinate2DMake(min.center.latitude,min.center.longitude);
	points[9] = CLLocationCoordinate2DMake(min.center.latitude,max.center.longitude);
	
	return [MKPolygon polygonWithCoordinates:points count:10];
}

 /*
 /	@method: getBorderWithMaxLimits:andMinLimits:
 /	@description: Returns the MKPolygon object for the decorative border of the hole
 /	@param: max - Maximum coordinates for the hole. Specifies maximum latitude and maximum longitude.
 /	@param: min - Minimum coordinates for the hole. Specifies minimum latitude and minimum longitude.
 /  @return: MKPolygon - The border's MKPolygon.
 */

-(MKPolygon*) getBordersWithMaxLimits:(MKCoordinateRegion)max andMinLimits:(MKCoordinateRegion)min{
	CLLocationCoordinate2D  decor[16];
	
	decor[0] = CLLocationCoordinate2DMake(min.center.latitude - 0.0025,max.center.longitude + 0.005);
    decor[1] = CLLocationCoordinate2DMake(max.center.latitude + 0.0025,max.center.longitude + 0.005);
	decor[2] = CLLocationCoordinate2DMake(max.center.latitude + 0.0025,min.center.longitude - 0.005); 
	decor[3] = CLLocationCoordinate2DMake(min.center.latitude - 0.0025,min.center.longitude - 0.005); 
	decor[4] = CLLocationCoordinate2DMake(min.center.latitude - 0.0025,max.center.longitude + 0.005);
	decor[5] = CLLocationCoordinate2DMake(min.center.latitude,max.center.longitude);
	decor[6] = CLLocationCoordinate2DMake(max.center.latitude,max.center.longitude);
	decor[7] = CLLocationCoordinate2DMake(max.center.latitude + 0.0025,max.center.longitude + 0.005);
	decor[8] = CLLocationCoordinate2DMake(max.center.latitude,max.center.longitude);
	decor[9] = CLLocationCoordinate2DMake(max.center.latitude,min.center.longitude);
	decor[10] = CLLocationCoordinate2DMake(max.center.latitude + 0.0025,min.center.longitude - 0.005); 
	decor[11] = CLLocationCoordinate2DMake(max.center.latitude,min.center.longitude);
	decor[12] = CLLocationCoordinate2DMake(min.center.latitude,min.center.longitude);
	decor[13] = CLLocationCoordinate2DMake(min.center.latitude - 0.0025,min.center.longitude - 0.005);
	decor[14] = CLLocationCoordinate2DMake(min.center.latitude,min.center.longitude);
	decor[15] = CLLocationCoordinate2DMake(min.center.latitude,max.center.longitude);
	
	return [MKPolygon polygonWithCoordinates:decor count:16];
}

#pragma mark -
#pragma mark Unzip and parsing methods

/*
 /	@method: unzipData:
 /	@description: Returns the unzipped data loaded from a zipped file.
 /	@param: iData - The zipped Data file.
 /  @return: NSData - Unzipped Data File.
 */

+(NSData *)allocUnzipData:(NSData *)iData{
	NSData *oData = [[NSData alloc] initWithGzippedData:iData];
	return oData;
}

 /*
 /	@method: unzipDataFromURL:
 /	@description: Returns the unzipped data loaded from a zipped file stored on an URL.
 /	@param: dataURL - URL where the zipped file is stored.
 /  @return: NSData - Unzipped Data File.
 */

+(NSData *)allocUnzipDataFromURL:(NSString *)dataURL{
	
	//The zipped data must be as '.gz' extension
	NSURL *traceURL = [NSURL URLWithString:dataURL];
	NSData *iData = [NSData dataWithContentsOfURL:traceURL];
	NSData *oData = [[NSData alloc] initWithGzippedData:iData];
	return oData;
	
}

 /*
 /	@method: parseDataToDictionary:
 /	@description: Makes the convertion of a NSData to a NSDictionary Object.
 /	@param: data - Data to convert.
 /  @return: NSDictionary - Converted data.
 */

+(NSDictionary *)allocParseDataToDictionary:(NSData *)data{
	CFStringRef errorString;
	
	CFPropertyListRef plist =  CFPropertyListCreateFromXMLData(kCFAllocatorDefault, 
															   (CFDataRef)data,
															   kCFPropertyListImmutable,
															   &errorString);
	if ([(id)plist isKindOfClass:[NSDictionary class]]) {
		return (NSDictionary*) plist;
	}else{
		CFRelease(plist);
		return nil;
	}
}

 /*
 /	@method: parseDataToArray:
 /	@description: Makes the convertion of a NSData to a NSArray Object.
 /	@param: data - Data to convert.
 /  @return: NSArray - Converted data.
 */

+(NSArray *)allocParseDataToArray:(NSData *)data{
	CFStringRef errorString;

	CFPropertyListRef plist =  CFPropertyListCreateFromXMLData(kCFAllocatorDefault, 
															   (CFDataRef)data,
															   kCFPropertyListImmutable,
															   &errorString);
	if ([(id)plist isKindOfClass:[NSArray class]]){
		NSArray *parsedArray = [[NSArray alloc] initWithArray:(NSArray*)plist];
		CFRelease(plist);
		return parsedArray;
	}else{
		CFRelease(plist);
		return nil;
	}
	
}

#pragma mark -
#pragma mark Modal Boxes management

 /*
 /	@method: getModalView:
 /	@description: Creates the Loading Modal View
 /	@param: frame - Modal view's size.
 /  @return: ModalView - ModalView reference.
 */

-(ModalView *)getLoadView:(CGRect)frame{
	modalView = [[ModalView alloc] initLoadingBox:frame forDevice:0];
	showingModalView = YES;
	return modalView;
}

/*
 /	@method: getiPadModalView:
 /	@description: Creates the Loading Modal View for iPad Device
 /	@param: frame - Modal view's size.
 /  @return: ModalView - ModalView reference.
 */

-(ModalView *)getiPadLoadView:(CGRect)frame{
	modalView = [[ModalView alloc] initLoadingBox:frame forDevice:1];
	showingModalView = YES;
	return modalView;
}

 /*
 /	@method: getModalView:withTitle:withMessage:andIcon
 /	@description: Creates a customized Modal View with title, subtitle (optional), and image.
 /	@param: frame - Modal view's size.
 /	@param: title - Modal view's title. Simple Label.
 /	@param: message - Modal view's subtitle. It's a scrollable textView. (Optional)
 /	@param: iconName - Modal view's image name.
 /  @return: ModalView - ModalView reference.
 */

-(ModalView *)getModalView:(CGRect)frame withTitle:(NSString *)title withMessage:(NSString *)message andIcon:(NSString *)iconName{
	modalView = [[ModalView alloc] initModalBox:frame withImage:iconName withLabel:title];
	if(message != nil){
		[modalView addDescriptionLabel:message];
	}
	
	showingModalView = YES;
	return modalView;
}

 /*
 /	@method: removeModalView:
 /	@description: removes the current Loading Modal View
 */

-(void)removeModalView{
	[modalView removeFromSuperview];
	[modalView release];
	modalView = nil;
	showingModalView = NO;
}


+(void)startTrackerWithAccountID:(NSString *)accountId withPeriod:(NSInteger)period{
	[[GANTracker sharedTracker] startTrackerWithAccountID:accountId
										   dispatchPeriod:period
												 delegate:nil];

}

+(void)filteringEvent:(NSString *)category forAction:(NSString *)action onType:(TransportType)type withKey:(id)key andValue:(BOOL)value{
	NSString *description;
	switch (type) {
		case BUS: description = [NSString stringWithFormat:@"Buses from line: %@",key]; break;
		case TRAMWAY: description = [NSString stringWithFormat:@"Tramways from line: %@",key]; break;
		case SUBWAY: description = [NSString stringWithFormat:@"Subways from line: %@",key]; break;
		case TAXI: description = [NSString stringWithFormat:@"Taxis from line: %@",key]; break;
		default: break;
	}
	int numValue = -1;
	if(value) numValue = 1;
	
	[self trackEvent:category forAction:action withDescription:description withValue:numValue];
}

+(void)trackEvent:(NSString *)category forAction:(NSString *)action withDescription:(NSString *)description withValue:(NSInteger)value{
	NSError *error;
	[[GANTracker sharedTracker] trackEvent:category
									action:action
									 label:description
									 value:value
								 withError:&error];

}

+(void)trackPageView:(NSString *)page{
	NSError *error;
	[[GANTracker sharedTracker] trackPageview:page
									withError:&error];
}

+(void)stopTracker{
	[[GANTracker sharedTracker] stopTracker];
}

-(void)beginTrackTime{
	[self setTimeReference:[NSDate date]];
}

-(double)elapsedTrackTime{
	//Returned in miliseconds
	NSTimeInterval elapsed = -[timeReference timeIntervalSinceNow]*1000;
	return elapsed;
}

- (void)dealloc
{
	[orientationImages release];
	[lineImages release];
	[modalView release];
	[timeReference release];
    [super dealloc];
}

@end
