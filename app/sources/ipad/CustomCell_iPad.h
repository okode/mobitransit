//
//  CustomCell_iPad.h
//  Mobitransit_Helsinki
//
//  Created by Daniel Soro Coicaud on 14/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineProperties.h"
#import "DetailTableViewController_iPad.h"

@interface CustomCell_iPad : UITableViewCell {
	
	LineProperties *properties;
	UIButton *checkButton;
	UIButton *routeButton;
	UIButton *stopsButton;
	
	DetailTableViewController_iPad *table;

}

-(void)checkAction:(id)sender;
-(void)checkRoute:(id)sender;
-(void)checkStops:(id)sender;
-(NSString *)title;

@property (nonatomic, retain) LineProperties *properties;
@property (nonatomic, retain) UIButton *checkButton;
@property (nonatomic, retain) UIButton *routeButton;
@property (nonatomic, retain) UIButton *stopsButton;
@property (nonatomic, retain) DetailTableViewController_iPad *table;


@end
