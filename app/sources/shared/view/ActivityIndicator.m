//
//  ActivityIndicator.m
//  Lladro
//
//  Created by Daniel Soro Coicaud on 07/03/11.
//  Copyright 2011 Okode. All rights reserved.
//

#import "ActivityIndicator.h"
#import <QuartzCore/QuartzCore.h>

#define DegreesToRadians(x) (M_PI * x / 180.0)

@implementation ActivityIndicator

@synthesize centerMessageLabel, subMessageLabel;
@synthesize spinner;

static ActivityIndicator *currentIndicator = nil;


+(ActivityIndicator *)currentIndicator{
	if (currentIndicator == nil){
		UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
		
		CGFloat width = 160;
		CGFloat height = 120;
		CGRect centeredFrame = CGRectMake(round(keyWindow.bounds.size.width/2 - width/2),
										  round(keyWindow.bounds.size.height/2 - height/2),
										  width,
										  height);
		
		currentIndicator = [[[ActivityIndicator alloc] initWithFrame:centeredFrame] autorelease];
		currentIndicator.opaque = NO;
		currentIndicator.alpha = 0;
		
		currentIndicator.layer.cornerRadius = 20;
		currentIndicator.userInteractionEnabled = NO;
		currentIndicator.autoresizesSubviews = YES;
		currentIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |  UIViewAutoresizingFlexibleTopMargin |  UIViewAutoresizingFlexibleBottomMargin;
	}
	
	return currentIndicator;
}

- (void)drawRect:(CGRect)rect {
	
	[super drawRect:rect];
	
    CGGradientRef gradient = [self allocNormalGradient];
	
    CGContextRef ctx = UIGraphicsGetCurrentContext(); 
    CGMutablePathRef outlinePath = CGPathCreateMutable(); 
    float offset = 8.0;
    float w  = [self bounds].size.width; 
    float h  = [self bounds].size.height; 
    CGPathMoveToPoint(outlinePath, nil, offset*2.0, offset); 
    CGPathAddArcToPoint(outlinePath, nil, offset, offset, offset, offset*2, offset); 
    CGPathAddLineToPoint(outlinePath, nil, offset, h - offset*2.0); 
    CGPathAddArcToPoint(outlinePath, nil, offset, h - offset, offset *2.0, h-offset, offset); 
    CGPathAddLineToPoint(outlinePath, nil, w - offset *2.0, h - offset); 
    CGPathAddArcToPoint(outlinePath, nil, w - offset, h - offset, w - offset, h - offset * 2.0, offset); 
    CGPathAddLineToPoint(outlinePath, nil, w - offset, offset*2.0); 
    CGPathAddArcToPoint(outlinePath, nil, w - offset , offset, w - offset*2.0, offset, offset); 
    CGPathCloseSubpath(outlinePath); 

	CGColorRef blackColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0].CGColor;

    
    CGContextAddPath(ctx, outlinePath); 
    CGContextClip(ctx);
    CGPoint start = CGPointMake(rect.origin.x, rect.origin.y);
    CGPoint end = CGPointMake(rect.origin.x, rect.size.height);
    CGContextDrawLinearGradient(ctx, gradient, start, end, 0);
	
	CGGradientRef glossGradient = [self allocNormalGradient:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.35] 
								   toColor: [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1]];
	
	end = CGPointMake(rect.origin.x, rect.size.height/2);
    CGContextDrawLinearGradient(ctx, glossGradient, start, end, 0);
	
	CGContextSetLineWidth(ctx, 1.3);
	CGContextSetStrokeColorWithColor(ctx, blackColor);
    CGContextAddPath(ctx, outlinePath);
	CGContextStrokePath(ctx);
	
	
	CGGradientRelease(gradient);
    CGGradientRelease(glossGradient);
	
    CGPathRelease(outlinePath);
	
}

- (CGGradientRef)allocNormalGradient:(UIColor*)startColor toColor:(UIColor*)endColor{
	
    NSMutableArray *normalGradientLocations = [NSMutableArray arrayWithObjects:
                                               [NSNumber numberWithFloat:0.0f],
                                               [NSNumber numberWithFloat:1.0f],
                                               nil];
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:2];
    [colors addObject:(id)[startColor CGColor]];
	[colors addObject:(id)[endColor CGColor]];
    NSMutableArray  *normalGradientColors = colors;
	
    int locCount = [normalGradientLocations count];
    CGFloat locations[locCount];
    for (int i = 0; i < [normalGradientLocations count]; i++){
        NSNumber *location = [normalGradientLocations objectAtIndex:i];
        locations[i] = [location floatValue];
    }
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	
    CGGradientRef normalGradient = CGGradientCreateWithColors(space, (CFArrayRef)normalGradientColors, locations);
    CGColorSpaceRelease(space);
	
    return normalGradient;
}



- (CGGradientRef)allocNormalGradient{
	
    NSMutableArray *normalGradientLocations = [NSMutableArray arrayWithObjects:
                                               [NSNumber numberWithFloat:0.0f],
                                               [NSNumber numberWithFloat:1.0f],
                                               nil];
	
	
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:2];
	
	UIColor *color = [UIColor colorWithRed:kBaseRGB_R green:kBaseRGB_G blue:kBaseRGB_B alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:kGradientRGB_R green:kGradientRGB_R blue:kGradientRGB_R alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    NSMutableArray  *normalGradientColors = colors;
	
    int locCount = [normalGradientLocations count];
    CGFloat locations[locCount];
    for (int i = 0; i < [normalGradientLocations count]; i++){
        NSNumber *location = [normalGradientLocations objectAtIndex:i];
        locations[i] = [location floatValue];
    }
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	
    CGGradientRef normalGradient = CGGradientCreateWithColors(space, (CFArrayRef)normalGradientColors, locations);
    CGColorSpaceRelease(space);
	
    return normalGradient;
}



#pragma mark Creating Message

- (void)show {	
	if ([self superview] != [[UIApplication sharedApplication] keyWindow]) 
		[[[UIApplication sharedApplication] keyWindow] addSubview:self];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	self.alpha = 1;
	
	[UIView commitAnimations];
}

- (void)hideAfterDelay {
	[self performSelector:@selector(hide) withObject:nil afterDelay:1.0];
}

- (void)hideAfterLongDelay {
	[self performSelector:@selector(hide) withObject:nil afterDelay:5.0];
}

- (void)hide {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hidden)];
	
	self.alpha = 0;
	
	[UIView commitAnimations];
}

- (void)persist {	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.1];
	
	self.alpha = 1;
	
	[UIView commitAnimations];
}

- (void)hidden {
	if (currentIndicator.alpha > 0)
		return;
	
	[currentIndicator removeFromSuperview];
	currentIndicator = nil;
}

- (void)displayActivity:(NSString *)m {		
	[self setSubMessage:m];
	[self showSpinner];	
	
	[centerMessageLabel removeFromSuperview];
	centerMessageLabel = nil;
	
	if ([self superview] == nil)
		[self show];
	else
		[self persist];
}

- (void)displayCompleted:(NSString *)m {	
	[self setCenterMessage:@"✓"];
	[self setSubMessage:m];
	
	[spinner removeFromSuperview];
	spinner = nil;
	
	if ([self superview] == nil)
		[self show];
	else
		[self persist];
	
	[self hideAfterDelay];
}

- (void)displayError:(NSString *)m {	
	[self setCenterMessage:@"!"];
	[self setSubMessage:m];
	
	[spinner removeFromSuperview];
	spinner = nil;
	
	if ([self superview] == nil)
		[self show];
	else
		[self persist];
	
	[self hideAfterLongDelay];
}

- (void)setCenterMessage:(NSString *)message {	
	if (message == nil && centerMessageLabel != nil)
		self.centerMessageLabel = nil;
	
	else if (message != nil){
		if (centerMessageLabel == nil){
			self.centerMessageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(12,round(self.bounds.size.height/2.4-50/2),self.bounds.size.width-24,50)] autorelease];
			centerMessageLabel.backgroundColor = [UIColor clearColor];
			centerMessageLabel.opaque = NO;
			centerMessageLabel.textColor = [UIColor whiteColor];
			centerMessageLabel.font = [UIFont boldSystemFontOfSize:50];
			centerMessageLabel.textAlignment = UITextAlignmentCenter;
			centerMessageLabel.shadowColor = [UIColor darkGrayColor];
			centerMessageLabel.shadowOffset = CGSizeMake(1,1);
			centerMessageLabel.adjustsFontSizeToFitWidth = YES;
			
			[self addSubview:centerMessageLabel];
		}
		centerMessageLabel.text = message;
	}
}

- (void)setSubMessage:(NSString *)message {	
	if (message == nil && subMessageLabel != nil)
		self.subMessageLabel = nil;
	
	else if (message != nil){
		if (subMessageLabel == nil){
			self.subMessageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(16,self.bounds.size.height-50,self.bounds.size.width-32,30)] autorelease];
			subMessageLabel.backgroundColor = [UIColor clearColor];
			subMessageLabel.opaque = NO;
			subMessageLabel.textColor = [UIColor whiteColor];
			subMessageLabel.font = [UIFont boldSystemFontOfSize:16];
			subMessageLabel.textAlignment = UITextAlignmentCenter;
			subMessageLabel.shadowColor = [UIColor darkGrayColor];
			subMessageLabel.shadowOffset = CGSizeMake(1,1);
			subMessageLabel.adjustsFontSizeToFitWidth = YES;
			
			[self addSubview:subMessageLabel];
		}
		subMessageLabel.text = message;
	}
}

- (void)showSpinner {	
	if (spinner == nil){
		self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		
		spinner.frame = CGRectMake(round(self.bounds.size.width/2 - (spinner.frame.size.width*1.0)/2),
								   round(self.bounds.size.height/2.5 - (spinner.frame.size.height*1.0)/2),
								   spinner.frame.size.width*1.0,
								   spinner.frame.size.height*1.0);		
		[spinner release];	
	}
	
	[self addSubview:spinner];
	[spinner startAnimating];
}

- (void)dealloc {
	[centerMessageLabel release];
	[subMessageLabel release];
	[spinner release];
    [super dealloc];
}


@end
