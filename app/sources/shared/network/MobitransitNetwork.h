//
//  MobitransitNetwork.h
//  Mobitransit_Helsinki
//
//  Created by Daniel Soro Coicaud on 23/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobitransitDelegate.h"
#import "Reachability.h"
#import "CRVStompClient.h"

@class MobitransitAppDelegate;

@interface MobitransitNetwork : NSObject <CRVStompClientDelegate> {

	Reachability *reachability;
	CRVStompClient *stompService;
		
	BOOL connected;
	BOOL serviceActive;
	BOOL firstConnection;
	
	id <MobitransitDelegate> delegate;
	
	int countEvents;
	
}

#pragma mark MobitransitNetwork methods

-(void)loadReachabilityManager:(NSString *)host;
-(void)reachabilityChanged:(NSNotification*)notification;
-(void)stopReachabilityManager;

-(void)startStompConnection:(NSString *)host onPort:(int)porNumber withUser:(NSString *)user withPass:(NSString *)pass;
-(void)stopStompConnection:(NSString *)currentSubscription;
-(void)updateStompFiltering:(NSString *)currentSubscription withFilter:(NSString *)filter;
-(void)stompClientDidConnect:(CRVStompClient *)stService;
-(void)stompClient:(CRVStompClient *)stompService messageReceived:(NSString *)body withHeader:(NSDictionary *)messageHeader;
-(void)stompClientConnectionError:(NSError *)err;

#pragma mark MobitransitNetwork properties

@property (nonatomic, retain) Reachability *reachability;
@property (nonatomic, retain) CRVStompClient *stompService;
@property (nonatomic, assign) BOOL connected;
@property (nonatomic, assign) BOOL serviceActive;
@property (nonatomic, assign) BOOL firstConnection;
@property (nonatomic, assign) int countEvents;
@property (nonatomic, assign) id<MobitransitDelegate> delegate;

@end
