//
//  ConfigurationController.m
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 28/03/11.
//  Copyright 2011 Okode. All rights reserved.
//

#import "ConfigurationController.h"


@implementation ConfigurationController

@synthesize segControl;
@synthesize locationControl;
@synthesize stompLight;
@synthesize networkLabel;
@synthesize serverStatusLabel;
@synthesize mapPropertiesLabel;
@synthesize typeLabel;
@synthesize userLocationLabel;
@synthesize socialNetworkLabel;
@synthesize loginFacebookLabel;
@synthesize loginTwitterLabel;
@synthesize facebookLogin;
@synthesize twitterLogin;
@synthesize delegate;

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
    [super viewDidLoad];
    [segControl setTitle:NSLocalizedString(@"MAP", @"") forSegmentAtIndex:0];
	[segControl setTitle:NSLocalizedString(@"SATELLITE", @"") forSegmentAtIndex:1];
	[segControl setTitle:NSLocalizedString(@"HYBRID", @"") forSegmentAtIndex:2];
    
    if(![delegate locationEnabled]){
        [locationControl setOn:YES];
        [locationControl setEnabled:NO];
    }
    
    [networkLabel setText:NSLocalizedString(@"CONFIG_NETWORK",@"")];
    [serverStatusLabel setText:NSLocalizedString(@"CONFIG_SERVER_STATUS",@"")];
    [mapPropertiesLabel setText:NSLocalizedString(@"CONFIG_MAP_PROPERTIES",@"")];
    [typeLabel setText:NSLocalizedString(@"CONFIG_TYPE",@"")];
    [userLocationLabel setText:NSLocalizedString(@"CONFIG_USER_LOCATION",@"")];
	[loginTwitterLabel setText:NSLocalizedString(@"CONFIG_LOGIN",@"")];
	[loginFacebookLabel setText:NSLocalizedString(@"CONFIG_LOGIN",@"")];
	[socialNetworkLabel setText:NSLocalizedString(@"CONFIG_SOCIAL",@"")];

}

-(void)enableUserLocation:(BOOL)enable{
    [locationControl setEnabled:enable];
}

- (void)viewWillAppear:(BOOL)animated{
    [locationControl setOn:[delegate isUserLocationActive]];
}


-(void)changeTwitterSwitch:(BOOL)enable{
	[twitterLogin setOn:enable];
}

-(void)changeFacebookSwitch:(BOOL)enable{
    [facebookLogin setOn:enable];
}

-(IBAction)changeMapType:(id)sender {
	int type = ((UISegmentedControl *)sender).selectedSegmentIndex;
	switch (type) {
		case 0:	[delegate changeMapTypeNormal];	break;
		case 1:	[delegate changeMapTypeSatellite]; break;
		case 2:	[delegate changeMapTypeHybrid]; break;
		default: break;
	}
}

-(IBAction)locationSwitchChanged:(id)sender {
    UISwitch *locationSwitch = (UISwitch *)sender;
    [delegate changeUserLocationStateTo:locationSwitch.on];
}


-(IBAction)twitterConnectChanged:(id)sender {
	UISwitch *twitterSwitch = (UISwitch *)sender;
	[delegate twitterLogin:twitterSwitch.on];
}

-(IBAction)facebookConnectChanged:(id)sender {
	UISwitch *facebookSwitch = (UISwitch *)sender;
    [delegate facebookLoggin:facebookSwitch.on];
}

-(void)stompConnectionStart{
	[stompLight setImage:[UIImage imageNamed:@"stompConnectionOk.png"]];
}

-(void)stompConnectionStop{
	[stompLight setImage:[UIImage imageNamed:@"stompConnectionFail.png"]];
}


- (void)dealloc {
    [segControl release];
    [locationControl release];
    [stompLight release];
    [networkLabel release];
    [serverStatusLabel release];
    [mapPropertiesLabel release];
    [typeLabel release];
    [userLocationLabel release];
	[loginFacebookLabel release];
	[loginTwitterLabel release];
    [facebookLogin release];
	[twitterLogin release];	
	[socialNetworkLabel release];
	[super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
