//
//  GraphViewController.m
//  Graphulator
//
//  Created by Vince Mansel on 11/8/11.
//  Copyright (c) 2011 Wave Ocean Software. All rights reserved.
//

#import "GraphViewController.h"

@implementation GraphViewController

@synthesize scale, dataWidth, dataResolution;
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

#define MIN_SCALE 1.0
#define MAX_SCALE 160.0

- (void)setScale:(CGFloat)newScale
{
    if (newScale < MIN_SCALE) newScale = MIN_SCALE;
    if (newScale > MAX_SCALE) newScale = MAX_SCALE;
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
//    NSLog(@"scaleForGraphView: graphScale = %g", graphScale);
    return graphScale;
}

- (CGFloat)yValueForGraphView:(GraphView *)requestor
                         forX:(CGFloat)x
{
    CGFloat indexSpan = dataWidth * dataResolution;
    CGFloat index = 0;
    if (self.scale <= self.dataResolution) {
        index = ((indexSpan/2) - ((indexSpan/2)/self.scale)) + (x * (self.dataResolution/self.scale));
        if (x > 0 && self.scale != 16) index -= 1;
    }
    else if (self.scale >= 32) {
        index = ((indexSpan/2) - ((indexSpan/2)/self.scale)) + x;
    }
    
//    CGFloat arrayIndex = index * dataResolution;
    CGFloat arrayIndex = index;
    CGFloat result = [[graphData objectAtIndex:(NSInteger)arrayIndex] doubleValue];
    
//    if (index == 2560)
//        NSLog(@"GraphViewController.m : yValueForGraphView: x = %g, index = %g, arrayIndex = %g, result = %g", x, index, arrayIndex, result);
    return result;
}

- (IBAction)zoomPressed:(UIButton *)sender
{
    //NSLog(@"Zoom Pressed: %@", sender.titleLabel.text);
    
    NSString *zoom= sender.titleLabel.text;
    
    if ([zoom isEqual:@"Zoom In"]) {
        if      (self.scale < 32)  self.scale *= 2;
        else if (self.scale == 32) self.scale = MAX_SCALE/2;
        else if (self.scale == MAX_SCALE/2) self.scale = MAX_SCALE;
    }
    else if ([zoom isEqual:@"Zoom Out"]) {
        if      (self.scale == MAX_SCALE) self.scale = MAX_SCALE/2;
        else if (self.scale == MAX_SCALE/2)  self.scale = 32;
        else if (self.scale == MIN_SCALE)   self.scale = MIN_SCALE;
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
