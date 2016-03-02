//
//  ConfigurationController.h
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 28/03/11.
//  Copyright 2011 Okode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobitransitDelegate.h"

@interface ConfigurationController : UIViewController {
    
    id <MobitransitDelegate> delegate;
 
    UISegmentedControl *segControl;
    UISwitch *locationControl;
    
    UIImageView *stompLight;
    
    UILabel *networkLabel;
    UILabel *serverStatusLabel;
    UILabel *mapPropertiesLabel;
    UILabel *typeLabel;
    UILabel *userLocationLabel;
	
	UILabel *socialNetworkLabel;
	UILabel *loginFacebookLabel;
	UILabel *loginTwitterLabel;
	UISwitch *facebookLogin;
	UISwitch *twitterLogin;
    
}

-(void)stompConnectionStart;
-(void)stompConnectionStop;
-(IBAction)changeMapType:(id)sender;
-(IBAction)locationSwitchChanged:(id)sender;
-(IBAction)twitterConnectChanged:(id)sender;
-(IBAction)facebookConnectChanged:(id)sender;
-(void)changeTwitterSwitch:(BOOL)enable;
-(void)changeFacebookSwitch:(BOOL)enable;
-(void)enableUserLocation:(BOOL)enable;

@property (nonatomic, assign) IBOutlet id <MobitransitDelegate> delegate;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segControl;
@property (nonatomic, retain) IBOutlet UISwitch *locationControl;
@property (nonatomic, retain) IBOutlet UIImageView *stompLight;
@property (nonatomic, retain) IBOutlet UILabel *networkLabel;
@property (nonatomic, retain) IBOutlet UILabel *serverStatusLabel;
@property (nonatomic, retain) IBOutlet UILabel *mapPropertiesLabel;
@property (nonatomic, retain) IBOutlet UILabel *typeLabel;
@property (nonatomic, retain) IBOutlet UILabel *userLocationLabel;
@property (nonatomic, retain) IBOutlet UILabel *socialNetworkLabel;
@property (nonatomic, retain) IBOutlet UILabel *loginFacebookLabel;
@property (nonatomic, retain) IBOutlet UILabel *loginTwitterLabel;
@property (nonatomic, retain) IBOutlet UISwitch *facebookLogin;
@property (nonatomic, retain) IBOutlet UISwitch *twitterLogin;

@end
