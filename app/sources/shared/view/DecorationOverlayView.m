//
//  DecorationOverlayView.m
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 30/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import "DecorationOverlayView.h"
#import "MultipleOverlays.h"


@implementation DecorationOverlayView

 /*	
 /   @method: polyPath:
 /	 @description: Gets the path reference from a specific polygon.
 /	 @param: polygon - polyline to parse.
 /	 @return: CGPathRef - generated polyline's path.
 */

- (CGPathRef)allocPolyPath:(MKPolygon *)polygon
{
    MKMapPoint *points = [polygon points];
    NSUInteger pointCount = [polygon pointCount];
    NSUInteger i;
	
    if (pointCount < 3)
        return NULL;
	
    CGMutablePathRef path = CGPathCreateMutable();
	
    for (MKPolygon *interiorPolygon in polygon.interiorPolygons) {
        CGPathRef interiorPath = [self allocPolyPath:interiorPolygon];
        CGPathAddPath(path, NULL, interiorPath);
        CGPathRelease(interiorPath);
    }
	
    CGPoint relativePoint = [self pointForMapPoint:points[0]];
    CGPathMoveToPoint(path, NULL, relativePoint.x, relativePoint.y);
    for (i = 1; i < pointCount; i++) {
        relativePoint = [self pointForMapPoint:points[i]];
        CGPathAddLineToPoint(path, NULL, relativePoint.x, relativePoint.y);
    }
	
    return path;
}

 /*	
 /   @method: drawMapRect:zoomScale:inContext:
 /	 @description: Draws the overlay property on the map.
 /	 @param: mapRect - current map region.
 /	 @param: zoomScale - current zoomScale.
 /	 @param: context - current context.
 */

- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)context
{
    // Decoration overlay disabled (black square around the map)
    
    /*
    MultipleOverlays *multiPolygon = (MultipleOverlays *)self.overlay;
	CGFloat lineWidth = 100;

	for(int i=0; i< [multiPolygon.polygons count]; i++){
		MKPolygon *polygon = (MKPolygon *)[multiPolygon.polygons objectAtIndex: i];
        CGPathRef path = [self allocPolyPath:polygon];
        if (path) {
	
            CGContextAddPath(context, path);
			if(i==1){
			CGContextSetRGBFillColor(context, 0.4, 0.4, 0.4, 0.5);
			} else {
				CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
			}
			
            CGContextDrawPath(context, kCGPathEOFill);
			if(i==1){
				CGContextAddPath(context, path);
				CGContextSetRGBStrokeColor(context, 0.6, 0.6, 0.6, 1.0);
				CGContextSetLineWidth(context, lineWidth);
				CGContextSetLineJoin(context, kCGLineJoinBevel);
				CGContextFlush(context);
				CGContextStrokePath(context);
			}
			CGPathRelease(path);
        }
    }
    */
}



@end
