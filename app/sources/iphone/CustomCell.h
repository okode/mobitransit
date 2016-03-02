//
//  CustomCell.h
//  Mobitransit_Helsinki
//
//  Created by Daniel Soro Coicaud on 14/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineProperties.h"

@interface CustomCell : UITableViewCell {
	
	LineProperties *properties;
	UIButton *checkButton;
	UIButton *stopsButton;
	UIButton *routeButton;

}

-(void)checkAction:(id)sender;
-(void)checkStops:(id)sender;
-(void)checkRoute:(id)sender;
-(NSString *)title;

@property (nonatomic, retain) LineProperties *properties;
@property (nonatomic, retain) UIButton *checkButton;
@property (nonatomic, retain) UIButton *stopsButton;
@property (nonatomic, retain) UIButton *routeButton;


@end
