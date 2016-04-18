//
//  AppDelegate_iPhone.h
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 24/09/10.
//  Copyright Okode S.L. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobitransitDelegate.h"
#import "RootViewController.h"
#import "DetailTableViewController.h"
#import "OkodeInfo.h"
#import "Utils.h"
#import "MobitransitData.h"
#import "MobitransitNetwork.h"
#import "StopTableViewController.h"
#import "ConfigurationController.h"
#import "NewslettersController.h"
#import "InformationController.h"
//#import "SA_OAuthTwitterEngine.h"
//#import "SA_OAuthTwitterController.h"
#import "FBConnect.h"
#import "ActivityIndicator.h"


@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate, MobitransitDelegate, UITabBarControllerDelegate, FBDialogDelegate, FBRequestDelegate, FBSessionDelegate> {
    
    UIWindow *window;
    UITabBarController *tabController;
    UINavigationController *navigationController;
	RootViewController *firstView;
	DetailTableViewController *detailView;
	StopTableViewController *stopView;
    ConfigurationController *configView;
    NewslettersController *newsView;
    InformationController *infoView;
	
	MobitransitData *data;
	MobitransitNetwork *network;
	
	Utils *utils;
	
	BOOL locationEnabled;
	NSString *currentMarker;
    
    UITabBarItem *infoBarItem;
	
	BOOL twitterConnected;
    
    Facebook *facebook;
    UIImage *facebookUserPic;
    NSString *facebookUserName;
    BOOL facebookConnected;
    NSArray* permissions;

}

#pragma mark MobitransitDelegate methods

-(void)onlineApp;
-(void)offlineApp;
-(void)showDetails;
-(void)finishListProperties;
-(void)updateFiltering;
-(void)updateMarker:(NSDictionary *)message;
-(void)setCurrentMarker:(NSString*)markerId;
-(NSString *)getCurrentMarker;
-(void)showStopInfo:(NSString *)stopId;

-(void)enableUserLocation;
-(void)disableUserLocation;
-(void)stompConnectionStart;
-(void)stompConnectionStop;	
-(void)endApplication;

-(void)changeMapTypeNormal;
-(void)changeMapTypeSatellite;
-(void)changeMapTypeHybrid;
-(BOOL)isUserLocationActive;

-(void)facebookLoggin:(BOOL)connect;
-(void)facebookMessage:(NSString *)message;
-(void)updateInfoBadgeValue;
-(void)saveLocationState:(BOOL)enable;
-(BOOL)loadLocationState;
-(void)changeUserLocationStateTo:(BOOL)enable;
-(void)startReverseGeocoding;
-(void)reverseGeocodingEnded:(BOOL)success;

#pragma mark MobitransitAppDelegate methods

-(int)loadData;
-(void)populateContents;
-(void)loadLinesDetail;
-(void)showServerError;
-(void)showConnectionError;
-(void)showLoading;
-(void)showInactive;
-(void)initFacebook;
-(void)requestFacebookUserPicture;
-(void)requestFacebookUserName;
-(void)setFacebookLoggin:(BOOL)login;
-(BOOL)getFacebookLoggin;
-(void)checkFacebookPicture;
-(void)checkFacebookUserName;
-(void)readAdvices;




#pragma mark MobitransitAppDelegate properties

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet RootViewController *firstView;
@property (nonatomic, retain) IBOutlet ConfigurationController *configView;
@property (nonatomic, retain) IBOutlet DetailTableViewController *detailView;
@property (nonatomic, retain) StopTableViewController *stopView;
@property (nonatomic, retain) IBOutlet NewslettersController *newsView;
@property (nonatomic, retain) IBOutlet InformationController *infoView;

@property (nonatomic, retain) MobitransitData *data;
@property (nonatomic, retain) MobitransitNetwork *network;
@property (nonatomic, retain) Utils *utils;

@property (nonatomic, retain) NSString *currentMarker;
@property (nonatomic, assign) BOOL locationEnabled;
@property (nonatomic, retain) IBOutlet UITabBarItem *infoBarItem;

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) UIImage *facebookUserPic;
@property (nonatomic, retain) NSString *facebookUserName;
@property (nonatomic, assign) BOOL facebookConnected;
@property (nonatomic, retain) NSArray* permissions;

@end

