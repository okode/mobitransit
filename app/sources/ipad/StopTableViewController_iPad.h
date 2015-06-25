//
//  StopTableViewController_iPad.h
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 14/10/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"

@interface StopTableViewController_iPad : UITableViewController {
	
	NSArray *stopInfo;
	NSString *currentStopId;
	TransportType type;
	BOOL firstStops;
	
	
	Utils *utils;

}

@property (nonatomic, retain) NSArray *stopInfo;
@property (nonatomic, assign) TransportType type;
@property (nonatomic, assign) BOOL firstStops;
@property (nonatomic, retain) NSString *currentStopId;
@property (nonatomic, retain) Utils *utils;

@end
