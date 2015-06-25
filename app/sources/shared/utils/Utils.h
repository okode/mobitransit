//
//  Utils.h
//  Mobitransit_Helsinki
//
//  Created by Daniel Soro Coicaud on 16/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModalView.h"
#import "GANTracker.h"
#import <MapKit/MapKit.h>


#pragma mark Line Types' Definition

#define kNumTransportTypes	4
typedef enum {
    BUS = 0,
	TRAMWAY,
	SUBWAY,
	TAXI
} TransportType;

#pragma mark -
#pragma mark Utils' Object

@interface Utils : NSObject {
	
	NSArray *orientationImages;
	NSArray *lineImages;
	
	ModalView *modalView;
	BOOL showingModalView;
	
	NSDate *timeReference;
	
}

#pragma mark -
#pragma mark Utils methods

-(void)loadImages;
-(UIImage *)getIcon:(TransportType)lineType orientedTo:(int)orientation;
-(UIImage *)getLineImage:(TransportType)lineType;
-(UIColor *)getColor:(NSString *)colorString;
-(ModalView *)getLoadView:(CGRect)frame;
-(ModalView *)getiPadLoadView:(CGRect)frame;
-(ModalView *)getModalView:(CGRect)frame withTitle:(NSString *)title withMessage:(NSString *)message andIcon:(NSString *)iconName;
-(void)removeModalView;
-(MKPolygon *)getBackgroundWithMaxLimits:(MKCoordinateRegion)max andMinLimits:(MKCoordinateRegion)min;
-(MKPolygon*) getBordersWithMaxLimits:(MKCoordinateRegion)max andMinLimits:(MKCoordinateRegion)min;
-(void)beginTrackTime;
-(double)elapsedTrackTime;

+(NSDictionary *)allocParseDataToDictionary:(NSData *)data;
+(NSArray *)allocParseDataToArray:(NSData *)data;
+(NSData *)allocUnzipData:(NSData *)iData;
+(NSData *)allocUnzipDataFromURL:(NSString *)dataURL;
+(UIImage *)getCheckIcon:(TransportType)lineType;
+(UIImage *)getRouteIcon:(TransportType)lineType;
+(UIImage *)getStopIcon:(TransportType)lineType;
+(UIImage *)getStopImage:(TransportType)lineType;
+(UIImage *)getSmallStopIcon:(TransportType)lineType;
+(NSString *)getTypeLocalizedName:(TransportType)lineType;
+(NSString *)getTypeName:(TransportType)lineType;

+(void)startTrackerWithAccountID:(NSString *)accountId withPeriod:(NSInteger)period;
+(void)filteringEvent:(NSString *)category forAction:(NSString *)action onType:(TransportType)type withKey:(id)key andValue:(BOOL)value;
+(void)trackEvent:(NSString *)category forAction:(NSString *)action withDescription:(NSString *)description withValue:(NSInteger)value;
+(void)trackPageView:(NSString *)page;
+(void)stopTracker;

#pragma mark -
#pragma mark Utils properties

@property (nonatomic, retain) NSArray *orientationImages;
@property (nonatomic, retain) NSArray *lineImages;
@property (nonatomic, retain) ModalView *modalView;
@property (nonatomic, assign) BOOL showingModalView;
@property (nonatomic, retain) NSDate *timeReference;

@end



