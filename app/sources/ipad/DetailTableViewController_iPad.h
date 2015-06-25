//
//  DetailTableViewController_iPad.h
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 01/10/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobitransitDelegate.h"

@class RootViewController_iPad;

@interface DetailTableViewController_iPad : UITableViewController {
	RootViewController_iPad *firstView;
	NSArray *busLines;
	NSArray *tramwayLines;
	NSArray *subwayLines;
	NSArray *taxiLines;
	
	NSArray *orderedLines;
	NSArray *lineNames;
	
	id <MobitransitDelegate> delegate;
}

-(void)lineSelection;
-(void)routeSelection;
-(void)stopSelection;

@property (nonatomic, retain) NSArray* busLines;
@property (nonatomic, retain) NSArray* tramwayLines;
@property (nonatomic, retain) NSArray *subwayLines;
@property (nonatomic, retain) NSArray *taxiLines;
@property (nonatomic, retain) NSArray *orderedLines;
@property (nonatomic, retain) NSArray *lineNames;
@property (nonatomic, assign) id <MobitransitDelegate> delegate;
@property (nonatomic, retain) IBOutlet RootViewController_iPad *firstView;

@end
