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
    
//    NSLog(@"Width:Height=%g:%g", self.bounds.size.width, self.bounds.size.height);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    [[UIColor blueColor] setStroke]; 
    
    // use delegate here to get scale
    
    CGFloat graphScale = [self.delegate scaleForGraphView:self];
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:midPoint scale:graphScale];
    
//    NSLog(@"GraphView.m > drawRect: Pixels per Point=%g", self.contentScaleFactor);
//    NSLog(@"GraphView.m > drawRect: midPoint=%g:%g", midPoint.x, midPoint.y);
    
    CGFloat widthInPixel = self.bounds.size.width * self.contentScaleFactor;
    CGFloat heightInPixel = self.bounds.size.height * self.contentScaleFactor;
    CGFloat halfPixelWidth = widthInPixel/2;
    CGFloat halfPixelHeight = heightInPixel/2;
    
    int dataRangeBoundary; //self.contentScaleFactor;
    int xAxisBoundary;
    
    switch ((int)graphScale) {
        case 1: // Zoomed Out
        case 2:
        case 4:
        case 8:
        case 16:
            dataRangeBoundary = halfPixelWidth;           //160, 80, 40, 20, 10 * ContentScaleFactor
            xAxisBoundary = dataRangeBoundary/graphScale; //10
            break;
        case 32:
            dataRangeBoundary = 80 * self.contentScaleFactor;
            xAxisBoundary = 5 * self.contentScaleFactor;
            break;
        case 80:
            dataRangeBoundary = 32 * self.contentScaleFactor;
            xAxisBoundary = 2 * self.contentScaleFactor;
            break;
        case 160: // Zoomed In
            dataRangeBoundary = 16 * self.contentScaleFactor;
            xAxisBoundary = 1 * self.contentScaleFactor;
            break;
        default:
            break;
    }
    
    CGFloat xIncrement = (graphScale / (dataRangeBoundary / xAxisBoundary));
    int xMove = 2/self.contentScaleFactor;
    
    CGContextSetLineWidth(context, 1.0);
    [[UIColor blackColor] setStroke];
    CGContextBeginPath(context);
    
    CGPoint p;
    p.x = 0;
    CGFloat yC = [self.delegate yValueForGraphView:self forX:0];
    p.y = (halfPixelHeight/self.contentScaleFactor) - (yC * graphScale);
    CGContextMoveToPoint(context, p.x, p.y);
    
    for (int x = xMove; x <= dataRangeBoundary * xMove; x += xMove) {
        p.x = x * xIncrement;
        yC = [self.delegate yValueForGraphView:self forX:(CGFloat)x];
        p.y = (halfPixelHeight/self.contentScaleFactor) - (yC * graphScale);
//        if (x == dataRangeBoundary-1)
//            NSLog(@"GraphView.m > drawRect: x = %d, p.x = %g, yC = %g, p.y = %g", x, p.x, yC, p.y);
        CGContextAddLineToPoint(context, p.x, p.y);
    }
    CGContextStrokePath(context);
//    NSLog(@" ");
}

- (void)dealloc
{
    [super dealloc];
}


@end
