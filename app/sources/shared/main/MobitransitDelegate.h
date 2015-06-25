/*
 *  MobitransitDelegate.h
 *  Mobitransit
 *
 *  Created by Daniel Soro Coicaud on 24/09/10.
 *  Copyright Okode S.L. 2010. All rights reserved.
 *
 */

#import "MobitransitData.h"
#import "Constants.h"

@protocol MobitransitDelegate <NSObject>

-(void)onlineApp;
-(void)offlineApp;
-(MobitransitData*)data;
-(void)setCurrentMarker:(NSString*)markerId;
-(void)updateFiltering;
-(void)updateMarker:(NSDictionary *)message;
-(NSString *)getCurrentMarker;
-(void)showStopInfo:(NSString *)stopId;

@optional
-(void)showDetails;
-(void)finishListProperties;
-(void)showOkodeInfoView;
-(void)lineSelection;
-(void)routeSelection;
-(void)stopSelection;
-(void)enableUserLocation;
-(void)disableUserLocation;
-(void)enableUserLocationButton;
-(void)disableUserLocationButton;
-(void)stompConnectionStop;
-(void)stompConnectionStart;
-(BOOL)locationEnabled;

-(void)changeMapTypeNormal;
-(void)changeMapTypeSatellite;
-(void)changeMapTypeHybrid;
-(BOOL)isUserLocationActive;
-(void)changeUserLocationState;

-(void)twitterLogin:(BOOL)connect;
-(void)twitMessage:(NSString *)message;
-(BOOL)twitterConnected;

-(UIImage*)facebookUserPic;
-(NSString*)facebookUserName;
-(void)facebookLoggin:(BOOL)connect;
-(void)facebookMessage:(NSString *)message;
-(BOOL)facebookConnected;
-(void)updateInfoBadgeValue;

-(void)saveLocationState:(BOOL)enable;
-(BOOL)loadLocationState;
-(void)changeUserLocationStateTo:(BOOL)enable;
-(void)startReverseGeocoding;
-(void)reverseGeocodingEnded:(BOOL)success;

@end
