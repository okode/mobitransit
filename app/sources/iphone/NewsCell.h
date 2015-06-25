//
//  NewsCell.h
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 14/10/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewsCell : UITableViewCell {
	
	UILabel *line;
    UITextView *textView;
	UIImageView *imgDecor;

}


@property (nonatomic, retain) UILabel *line;
@property (nonatomic, retain) UIImageView *imgDecor;
@property (nonatomic, retain) UITextView *textView;

@end
