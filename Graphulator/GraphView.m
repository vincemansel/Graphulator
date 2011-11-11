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
    
    //NSLog(@"Width:Height=%g:%g", self.bounds.size.width, self.bounds.size.height);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    [[UIColor blueColor] setStroke]; 
    
    // use delegate here to get scale
    
    CGFloat graphScale = [self.delegate scaleForGraphView:self];
    //graphScale = 160.0; // Zoomed In
    //graphScale = 1.0   // Zoomed Out
    
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:midPoint scale:graphScale];
    
    //NSLog(@"GraphView.m > drawRect: Pixels per Point=%g", self.contentScaleFactor);
    //NSLog(@"GraphView.m > drawRect: midPoint=%g:%g", midPoint.x, midPoint.y);
    
    CGFloat widthInPixel = self.bounds.size.width;
    CGFloat heightInPixel = self.bounds.size.height;
    CGFloat halfPixelWidth = widthInPixel/2;
    CGFloat halfPixelHeight = heightInPixel/2;
//    CGFloat xSpread = halfPixelWidth/graphScale;
//    CGFloat ySpread = halfPixelHeight/graphScale;
    
    int dataRangeBoundary; //self.contentScaleFactor;
    int xAxisBoundary;
    
    switch ((int)graphScale) {
        case 1: // Zoomed Out
            dataRangeBoundary = halfPixelWidth;          //160
            xAxisBoundary = dataRangeBoundary/graphScale; //160
            break;
        case 2:
            dataRangeBoundary = halfPixelWidth;          //160
            xAxisBoundary = dataRangeBoundary/graphScale; //80
            
            break;
        case 4:
            dataRangeBoundary = halfPixelWidth;          //160
            xAxisBoundary = dataRangeBoundary/graphScale; //40
            break;
        case 8:
            dataRangeBoundary = halfPixelWidth;          //160
            xAxisBoundary = dataRangeBoundary/graphScale; //20
            break;
        case 16:
            dataRangeBoundary = halfPixelWidth;          //160
            xAxisBoundary = dataRangeBoundary/graphScale; //10
            break;
        case 32:
            dataRangeBoundary = 160;
            xAxisBoundary = 5;
            break;
        case 80:
            dataRangeBoundary = 160;
            xAxisBoundary = 2;
            break;
        case 160: // Zoomed In
            dataRangeBoundary = 160;
            xAxisBoundary = 1;
            break;
        default:
            break;
    }
    
    CGContextSetLineWidth(context, 1.0);
    [[UIColor blackColor] setStroke];
    CGContextBeginPath(context);
    
    CGPoint p;
    p.x = 0;
    CGFloat yC = [self.delegate yValueForGraphView:self forX:p.x];
    p.y = halfPixelHeight - (yC * graphScale);
    
    //CGFloat xIncrement = graphScale / (dataRangeBoundary / xAxisBoundary);
    
    CGContextMoveToPoint(context, p.x, p.y);
    
    for (int x = 1; x <= dataRangeBoundary * 2; x += 1) {
        //p.x = x * xIncrement;
        p.x = x;
        yC = [self.delegate yValueForGraphView:self forX:(CGFloat)x];
        p.y = halfPixelHeight - (yC * graphScale);
        if (x == dataRangeBoundary-1)
            NSLog(@"GraphView.m > drawRect: x = %d, p.x = %g, yC = %g, p.y = %g", x, p.x, yC, p.y);
        CGContextAddLineToPoint(context, p.x, p.y);
    }
    CGContextStrokePath(context);
    NSLog(@" ");
}

- (void)dealloc
{
    [super dealloc];
}


@end
