//
//  GraphView.m
//  Graphulator
//
//  Created by Vince Mansel on 11/8/11.
//  Copyright (c) 2011 Wave Ocean Software. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
//    CGFloat size = (self.bounds.size.height < self.bounds.size.width) ?
//        self.bounds.size.height/2 : self.bounds.size.width/2;
//    size *= 0.90;
    
    //NSLog(@"Width:Height=%g:%g", self.bounds.size.width, self.bounds.size.height);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    [[UIColor blueColor] setStroke]; 
    
    // use delegate here to get scale
    
    CGFloat graphScale = [self.delegate scaleForGraphView:self];
    //graphScale = 100.0; // Zoomed In
    //graphScale = 1.0   // Zoomed Out
    
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:midPoint scale:graphScale];
    
    //NSLog(@"GraphView.m > drawRect: Pixels per Point=%g", self.contentScaleFactor);
    //NSLog(@"GraphView.m > drawRect: midPoint=%g:%g", midPoint.x, midPoint.y);
    
    CGFloat widthInPixel = self.bounds.size.width * self.contentScaleFactor;
    CGFloat heightInPixel = self.bounds.size.height * self.contentScaleFactor;
    CGFloat halfPixelWidth = widthInPixel/2;
    CGFloat halfPixelHeight = heightInPixel/2;
//    CGFloat xSpread = halfPixelWidth/graphScale;
//    CGFloat ySpread = halfPixelHeight/graphScale;
    
    CGContextSetLineWidth(context, 1.0);
    [[UIColor blackColor] setStroke];
    
    int xAxisBounds = self.contentScaleFactor;
    
    switch ((int)graphScale) {
        case 1: // Zoomed Out
            xAxisBounds *= 160;
            break;
        case 2:
            xAxisBounds *= 80;
            break;
        case 4:
            xAxisBounds *= 40;
            break;
        case 8:
            xAxisBounds *= 20;
            break;
        case 16:
            xAxisBounds *= 10;
            break;
        case 32:
            xAxisBounds *= 5;
            break;
        case 80:
            xAxisBounds *= 2;
            break;
        case 160: // Zoomed In
            xAxisBounds *= 1;
            break;
        default:
            break;
    }
    
    CGContextBeginPath(context);
    CGPoint p;
    p.x = 0;
    p.y = [self.delegate yValueForGraphView:self forX:halfPixelWidth - xAxisBounds];
    CGContextMoveToPoint(context, p.x, p.y);
    
    for (int x = halfPixelWidth - xAxisBounds + graphScale; x <= halfPixelWidth + xAxisBounds; x += graphScale) {
        p.x += pow(graphScale,2);
        p.y = [self.delegate yValueForGraphView:self forX:(CGFloat)x];
        NSLog(@"GraphView.m > drawRect: x = %d, p.x = %g, p.y = %g", x, p.x, p.y);
        CGContextAddLineToPoint(context, p.x, halfPixelHeight - p.y);
    }
    CGContextStrokePath(context);}

- (void)dealloc
{
    [super dealloc];
}


@end
