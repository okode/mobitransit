//
//  AppDelegate_iPad.h
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 01/10/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobitransitDelegate.h"
#import "Utils.h"
#import "MobitransitData.h"
#import "MobitransitNetwork.h"
#import "StopTableViewController_iPad.h"
#import "OkodeInfo_iPad.h"

@class RootViewController_iPad;
@class DetailTableViewController_iPad;

@interface AppDelegate_iPad : NSObject <UIApplicationDelegate, MobitransitDelegate, UIPopoverControllerDelegate> {
    UIWindow *window;
	
	UISplitViewController *splitViewController;
	
	RootViewController_iPad *firstView;
	DetailTableViewController_iPad *detailView;
	StopTableViewController_iPad *stopView;
	OkodeInfo_iPad *okodeInfo;
	
	MobitransitData *data;
	MobitransitNetwork *network;
	
	Utils *utils;
		
	NSString *currentMarker;
	
	UIPopoverController *popoverController;
	UIBarButtonItem *tempButton;
	
}

#pragma mark MobitransitDelegate methods

-(void)onlineApp;								
-(void)offlineApp;									
-(void)updateFiltering;
-(void)updateMarker:(NSDictionary *)message;
-(void)setCurrentMarker:(NSString*)markerId;	
-(NSString *)getCurrentMarker;	
-(void)finishListProperties;
-(void)showOkodeInfoView;
-(void)lineSelection;
-(void)showStopInfo:(NSString *)stopId;
-(void)routeSelection;
-(void)stopSelection;
-(void)stompConnectionStart;
-(void)stompConnectionStop;	
-(void)endApplication;

#pragma mark MobitransitAppDelegate methods

-(int)loadData;
-(void)populateContents;
-(void)loadLinesDetail;
-(void)showServerError;
-(void)showConnectionError;
-(void)showLoading;
-(void)showInactive;


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet RootViewController_iPad *firstView;
@property (nonatomic, retain) IBOutlet DetailTableViewController_iPad *detailView;
@property (nonatomic, retain) StopTableViewController_iPad *stopView;
@property (nonatomic, retain) MobitransitData *data;
@property (nonatomic, retain) MobitransitNetwork *network;
@property (nonatomic, retain) Utils *utils;
@property (nonatomic, retain) NSString *currentMarker;
@property (nonatomic, retain) IBOutlet OkodeInfo_iPad *okodeInfo;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *tempButton;
@end

