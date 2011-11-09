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
    
    CGFloat size = (self.bounds.size.height < self.bounds.size.width) ?
        self.bounds.size.height/2 : self.bounds.size.width/2;
    size *= 0.90;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    [[UIColor blueColor] setStroke];
    //[[UIFont 
    
    // use delegate here to get scale
    
    CGFloat graphScale = [self.delegate scaleForGraphView:self];
    //graphScale = 155.0; // Zoomed In
    //graphScale = 0.01   // Zoomed Out
    
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:midPoint scale:graphScale];
}

- (void)dealloc
{
    [super dealloc];
}


@end
