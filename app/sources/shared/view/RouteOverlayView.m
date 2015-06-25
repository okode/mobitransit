//
//  RouteOverlayView.m
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 29/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import "RouteOverlayView.h"
#import "RouteOverlays.h"


@implementation RouteOverlayView

 /*	
 /   @method: polyPath:
 /	 @description: Gets the path reference from a specific polyline.
 /	 @param: polyline - polyline to parse.
 /	 @return: CGPathRef - generated polyline's path.
 */

- (CGPathRef)allocPolyPath:(MKPolyline *)polyline
{
    MKMapPoint *points = [polyline points];
    NSUInteger pointCount = [polyline pointCount];
    NSUInteger i;
	
    if (pointCount < 3)
        return NULL;
	
    CGMutablePathRef path = CGPathCreateMutable();
	
	
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

-(void)drawMapRect:(MKMapRect)mapRect
		 zoomScale:(MKZoomScale)zoomScale
		 inContext:(CGContextRef)context{

	RouteOverlays *route = (RouteOverlays *)self.overlay;
	
	CGFloat lineWidth = MKRoadWidthAtZoomScale(zoomScale) + 200;

	for(int i=0; i< [route.routes count]; i++){
		MKPolyline *routeLine = (MKPolyline*)[route.routes objectAtIndex:i];
		UIColor *routeColor = (UIColor *)[route.colors objectAtIndex:i];
		const CGFloat* components = CGColorGetComponents(routeColor.CGColor);
		CGPathRef path = [self allocPolyPath:routeLine];
		if(path){
			CGContextAddPath(context, path);
			CGContextSetRGBStrokeColor(context, components[0], components[1], components[2], CGColorGetAlpha(routeColor.CGColor));
			CGContextSetLineJoin(context, kCGLineJoinRound);
			CGContextSetLineCap(context, kCGLineCapRound);
			CGContextSetLineWidth(context, lineWidth);
			CGContextFlush(context);
			CGContextStrokePath(context);
		}
        CGPathRelease(path);
	}

}

@end
