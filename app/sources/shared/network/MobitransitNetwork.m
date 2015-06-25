//
//  MobitransitNetwork.m
//  Mobitransit_Helsinki
//
//  Created by Daniel Soro Coicaud on 23/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import "MobitransitNetwork.h"


@implementation MobitransitNetwork

@synthesize reachability;
@synthesize stompService;
@synthesize connected;
@synthesize serviceActive;
@synthesize firstConnection;
@synthesize countEvents;
@synthesize delegate;

#pragma mark Reachability Methods

 /*
 /	@method: loadReachabilityManager:
 /	@description: Starts the reachability notifier
 /	@param: host - Host name to make the first connection.
 */

-(void)loadReachabilityManager:(NSString *)host{
	serviceActive = NO;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
	self.reachability = [Reachability reachabilityWithHostName:host];
	[reachability startNotifier];	
}

 /*
 /	@method: reachabilityChanged:
 /	@description: Managed by the reachabilityManager. Indicates if the device has or not internet connection.
 /				  This event delegates Online-Offline funcionality on the MobitransitAppDelegate.
 /	@param: notification - Reachability's new notification
 */

-(void)reachabilityChanged:(NSNotification*)notification{
	NSLog(@"Reachability changed");
	if ([reachability currentReachabilityStatus] == NotReachable){
		connected = NO;
		[delegate offlineApp];
		if(serviceActive){
			[self stopStompConnection:nil];
		}
	}else{
		connected = YES;
		[delegate onlineApp];
	}
}

 /*
 /	@method: stopReachabilityManager
 /	@description: Stops the reachabilityManager. 
 */

-(void)stopReachabilityManager{
	[reachability stopNotifier];
}

#pragma mark -
#pragma mark Stomp service methods

 /*
 /	@method: startStompConnection:
 /	@description: Creates the CRVStompClient and starts the connection.
 /	@param: host - host name.
 /	@param: portNumber - port number to connect.
 /	@param: user - User name.
 /  @param: pass - User password.
 */

-(void)startStompConnection:(NSString *)host onPort:(int)portNumber withUser:(NSString *)user withPass:(NSString *)pass {
	
	BOOL useTSL = NO;
	
	if(stompService == nil){
		
			if (useTSL) {
				NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
										(NSString *)kCFStreamSocketSecurityLevelNegotiatedSSL,(NSString *)kCFStreamSSLLevel,
										(NSString *)kCFBooleanTrue,(NSString *)kCFStreamSSLAllowsExpiredCertificates,
										(NSString *)kCFBooleanTrue,(NSString *)kCFStreamSSLAllowsExpiredRoots,
										(NSString *)kCFBooleanTrue,(NSString *)kCFStreamSSLAllowsAnyRoot,
										(NSString *)kCFBooleanFalse,(NSString *)kCFStreamSSLValidatesCertificateChain,
										nil ];
				stompService = [[CRVStompClient alloc]
								initWithHost:host
								port:portNumber 
								login:user 
								passcode:pass
								delegate:self
								autoconnect:NO
								withTSL:params];
			} else {
				stompService = [[CRVStompClient alloc]
								initWithHost:host
								port:portNumber 
								login:user 
								passcode:pass
								delegate:self
								autoconnect:NO];
			}
		
			[stompService connect];
		}
	firstConnection = YES;
	countEvents = 0;
}

 /*
 /	@method: stopStompConnection:currentSubscription
 /	@description: Unsubscribe the current topic, disconnects the stomp service and deletes the CRVSStompClient.
 /	@param: currentSubscription - topic subscription.
 */

-(void)stopStompConnection:(NSString *)currentSubscription{

	serviceActive = NO;
	if(currentSubscription != nil){
		[stompService unsubscribeFromDestination:currentSubscription];
        [stompService unsubscribeFromDestination:kMobQueueAlerts];
	}
	[stompService disconnect];
	[stompService release];
	stompService = nil;

}

 /*
 /	@method: updateStompFiltering:withFilter
 /	@description: Unsubscribes the last topic and subscribes again with a new filtering.
 /	@param: currentSubscription - topic subscription.
 /	@param: filter - new filtering.
 */

-(void)updateStompFiltering:(NSString *)currentSubscription withFilter:(NSString *)filter{
	
	if(!firstConnection){[stompService unsubscribeFromDestination:currentSubscription];}
	NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:     
							 @"auto", @"ack", 
							 @"true", @"activemq.dispatchAsync",
							/*filter, @"selector",*/
							 @"50", @"activemq.prefetchSize", nil];
	
	[stompService subscribeToDestination:currentSubscription withHeader: headers];
    if(firstConnection) {
        [stompService subscribeToDestination:kMobQueueAlerts withHeader: headers];
        firstConnection = NO;
    }
}

 /*
 /	@method: stompClientDidConnect:
 /	@description: Callback from Stomp service connection.
 /	@param: stService - current stomp service.
 */

- (void)stompClientDidConnect:(CRVStompClient *)stService {
	serviceActive = YES;
	NSLog(@"stompServiceDidConnect");
	[delegate updateFiltering];
	if([delegate respondsToSelector: @selector(stompConnectionStart)]){
		[delegate stompConnectionStart];
	}
	
	
}

-(void)stompClientConnectionError:(NSError *)err{
	
	if([delegate respondsToSelector: @selector(stompConnectionStop)]){
		[delegate stompConnectionStop];
	}
}

 /*
 /	@method: stompClient:messageReceived:withHeader
 /	@description: Stomp service message receiver. The header is delegated to the MobitransitAppDelegate.
 /	@param: stompService - current stomp service.
 /	@param: body - message body.
 /	@param: messageHeader - message header.
 */

- (void)stompClient:(CRVStompClient *)stompService messageReceived:(NSString *)body withHeader:(NSDictionary *)messageHeader {
	countEvents++;
    NSString* destination = [messageHeader valueForKey:@"destination"];
    if([destination compare:kMobQueueAlerts] != NSOrderedSame) {
        [delegate updateMarker:messageHeader];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobitransit Alert" 
                                                        message:body
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}


-(void) dealloc {
	[reachability release];
	[stompService release];
	[super dealloc];
}

@end
