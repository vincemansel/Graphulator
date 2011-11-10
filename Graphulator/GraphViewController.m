//
//  GraphViewController.m
//  Graphulator
//
//  Created by Vince Mansel on 11/8/11.
//  Copyright (c) 2011 Wave Ocean Software. All rights reserved.
//

#import "GraphViewController.h"

@implementation GraphViewController

@synthesize scale;
@synthesize graphView;
@synthesize graphData;

- (void)updateUI
{
    [self.graphView setNeedsDisplay];
}

//- (void)setGraphData:(NSArray *)newGraphData
//{
//    graphData = newGraphData;
//}

- (void)setScale:(CGFloat)newScale
{
    if (newScale < 1.0) newScale = 1.0;
    if (newScale > 160.0) newScale = 160.0;
    scale = round(newScale);
    //scale = newScale;
    [self updateUI];
}

- (CGFloat)scaleForGraphView:(GraphView *)requestor
{
    CGFloat graphScale = 0;

    if (requestor == self.graphView) {
        graphScale = self.scale;
    }
    NSLog(@"scaleForGraphView: graphScale = %g", graphScale);
    return graphScale;
}

- (CGFloat)yValueForGraphView:(GraphView *)requestor
                         forX:(CGFloat)x
{
    CGFloat result = [[graphData objectAtIndex:(NSInteger)x] doubleValue];
    //NSLog(@"GraphViewController.m : yValueForGraphView: x = %g, result = %g", x, result);
    return result;
}

- (IBAction)zoomPressed:(UIButton *)sender
{
    //NSLog(@"Zoom Pressed: %@", sender.titleLabel.text);
    
    NSString *zoom= sender.titleLabel.text;
    
    if ([zoom isEqual:@"Zoom In"]) {
        if      (self.scale < 32)  self.scale *= 2;
        else if (self.scale == 32) self.scale = 80;
        else if (self.scale == 80) self.scale = 160;
    }
    else if ([zoom isEqual:@"Zoom Out"]) {
        if      (self.scale == 160) self.scale = 80;
        else if (self.scale == 80)  self.scale = 32;
        else if (self.scale == 1)   self.scale = 1;
        else if (self.scale <= 32)  self.scale /= 2;
    }
}

- (void)releaseOutlets
{
    self.graphView = nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.graphView.delegate = self;
    [self updateUI];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self releaseOutlets];
}

- (void)dealloc
{
    [self releaseOutlets];
    [self.graphData release];
    [super dealloc];
}

@end
