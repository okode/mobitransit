//
//  MobitransitData.h
//  Mobitransit_Helsinki
//
//  Created by Daniel Soro Coicaud on 23/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "LineProperties.h"
#import "MarkerProperties.h"
#import "StopProperties.h"
#import "Utils.h"

typedef enum {
    CONFIG = 0,
	LINES,
	STOPS
} ProcessType;

@interface MobitransitData : NSObject {
	
	BOOL types[kNumTransportTypes];
	MKCoordinateRegion cityRegion;
	
	MKCoordinateRegion maxRegion;
	MKCoordinateRegion minRegion;
	
	NSDictionary *appConfig;
	NSDictionary *lines;
	NSDictionary *markers;
	NSDictionary *stops;
	
	NSString *docDirectory;
	NSString *lastModified;
	
	BOOL configFile;
	BOOL linesFile;
	BOOL stopsFile;
	
	BOOL configLoaded;
	BOOL linesLoaded;
	BOOL markersLoaded;
	BOOL stopsLoaded;
	
	Utils *utils;

}

#pragma mark MobitransitData methods

-(id)init;
-(BOOL)getTypeAtIndex:(int)index;
-(int)requestProperties;
-(void)loadConfigurationProperties: (NSDictionary*)configURL;
-(void)loadLineProperties: (NSArray*)linesURL;
-(void)loadStopsProperties: (NSArray*)stopsURL;
-(void)loadMarkerProperties: (NSString*)markersURL;
-(LineProperties *)getLine:(id)lineKey;
-(MarkerProperties *)getMarker:(id)markerKey;
-(StopProperties *)getStop:(id)stopKey;

-(NSString *)getPath:(ProcessType)type;
-(BOOL)fileManagement:(NSString*)path forProcess:(ProcessType)proc;
-(BOOL)saveFileInformation:(id)information forProcess:(ProcessType)proc;
-(void)checkDataFiles;
-(BOOL)staticResourcesLoaded;
-(BOOL)dataLoaded;

#pragma mark MobitransitData properties

@property (nonatomic, assign) MKCoordinateRegion cityRegion;
@property (nonatomic, assign) MKCoordinateRegion maxRegion;
@property (nonatomic, assign) MKCoordinateRegion minRegion;
@property (nonatomic, retain) NSDictionary *appConfig;
@property (nonatomic, retain) NSDictionary *lines;
@property (nonatomic, retain) NSDictionary *markers;
@property (nonatomic, retain) NSDictionary *stops;
@property (nonatomic, retain) NSString *docDirectory;
@property (nonatomic, retain) NSString *lastModified;
@property (nonatomic, assign) BOOL configFile;
@property (nonatomic, assign) BOOL linesFile;
@property (nonatomic, assign) BOOL stopsFile;
@property (nonatomic, assign) BOOL configLoaded;
@property (nonatomic, assign) BOOL linesLoaded;
@property (nonatomic, assign) BOOL markersLoaded;
@property (nonatomic, assign) BOOL stopsLoaded;
@property (nonatomic, retain) Utils *utils;

@end
