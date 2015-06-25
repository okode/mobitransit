//
//  NSData+Gzip.h
//  Mobitransit
//
//  Created by Brad Larson on 7/1/2008.
//
//  This extension is adapted from the examples present at the CocoaDevWiki at http://www.cocoadev.com/index.pl?NSDataCategory

#import <Foundation/Foundation.h>


@interface NSData (Gzip)
- (id)initWithGzippedData: (NSData *)gzippedData;
- (NSData *) gzipDeflate;

@end
