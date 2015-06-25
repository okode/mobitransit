//
//  StopAnnotation.m
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 13/10/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import "StopAnnotation.h"
#import "LineProperties.h"


@implementation StopAnnotation

@synthesize properties, coordinate;


/*	
 /	@method: setCoordinate
 /	@description: the current coordinate to set on the annotation. Updates the model's coordinate
 /	@param: newCoordinate - coordinate to set
 */
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
	coordinate = newCoordinate;
	properties.coordinate = newCoordinate;
}

/*	
 /  @method: title
 /  @description: returns the annotation title (showed at the pop-up)
 /	@return: NSString - stop customized title.
 */
-(NSString *)title{
	return [NSString stringWithFormat:@"%@",properties.name];
}

/*	
 /	@method: subtitle
 /  @description: returns the annotation subtitle (showed at the pop-up)
 /  @return: NSString - marker's plate number
 */
-(NSString *)subtitle{
	NSMutableString *sub = [[NSMutableString alloc] init];
	[sub appendFormat:@"%@ ",NSLocalizedString(@"LINES", @"")];
	for(int i =0; i < [properties.lines count] - 1; i ++){
		LineProperties *lProp = [properties.lines objectAtIndex:i];
		[sub appendFormat:@" %@ -", lProp.name];
	}
	LineProperties *lProp = [properties.lines objectAtIndex:([properties.lines count]-1)];
	[sub appendFormat:@" %@",lProp.name];
	NSString *fSubtitle = [NSString stringWithFormat:@"%@",sub];
	[sub release];
	return fSubtitle;
}


- (void)dealloc{
	[properties release];
    [super dealloc];
}

@end
