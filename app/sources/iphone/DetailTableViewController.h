//
//  DetailTableViewController.h
//  Mobitransit_Helsinki
//
//  Created by Daniel Soro Coicaud on 14/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobitransitDelegate.h"

@interface DetailTableViewController : UITableViewController {

	NSArray *busLines;
	NSArray *tramwayLines;
	NSArray *subwayLines;
	NSArray *taxiLines;
	
	NSArray *orderedLines;
	NSArray *lineNames;
	
	id <MobitransitDelegate> delegate;
}

@property (nonatomic, retain) NSArray* busLines;
@property (nonatomic, retain) NSArray* tramwayLines;
@property (nonatomic, retain) NSArray *subwayLines;
@property (nonatomic, retain) NSArray *taxiLines;
@property (nonatomic, retain) NSArray *orderedLines;
@property (nonatomic, retain) NSArray *lineNames;
@property (nonatomic, assign) IBOutlet id <MobitransitDelegate> delegate;

@end
