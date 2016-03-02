//
//  ActivityIndicator.h
//  Lladro
//
//  Created by Daniel Soro Coicaud on 07/03/11.
//  Copyright 2011 Okode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface ActivityIndicator : UIView {
	UILabel *centerMessageLabel;
	UILabel *subMessageLabel;
	UIActivityIndicatorView *spinner;
}

+ (ActivityIndicator *)currentIndicator;
- (CGGradientRef)allocNormalGradient;
- (CGGradientRef)allocNormalGradient:(UIColor*)startColor toColor:(UIColor*)endColor;
- (void)show;
- (void)hideAfterDelay;
- (void)hideAfterLongDelay;
- (void)hide;
- (void)hidden;
- (void)displayActivity:(NSString *)m;
- (void)displayCompleted:(NSString *)m;
- (void)displayError:(NSString *)m;
- (void)setCenterMessage:(NSString *)message;
- (void)setSubMessage:(NSString *)message;
- (void)showSpinner;


@property (nonatomic, retain) UILabel *centerMessageLabel;
@property (nonatomic, retain) UILabel *subMessageLabel;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;

@end
