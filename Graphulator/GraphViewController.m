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


- (void)updateUI
{
    [self.graphView setNeedsDisplay];
}

-(void)setScale:(CGFloat)newScale
{
    if (newScale < 1.0) newScale = 1.0;
    if (newScale > 100.0) newScale = 100.0;
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

- (IBAction)zoomPressed:(UIButton *)sender
{
    NSLog(@"Zoom Pressed: %@", sender.titleLabel.text);
    
    NSString *zoom= sender.titleLabel.text;
    
    if ([zoom isEqual:@"Zoom In"]) {
        if (self.scale < 0.9)
            self.scale += 0.1;
        else if (self.scale < 5.0)
            self.scale += 1.0;
        else if (self.scale < 11)
            self.scale += 5.0;
        else
            self.scale += 10;
    }
    else if ([zoom isEqual:@"Zoom Out"]) {
        if (self.scale < 0.9)
            self.scale -= 0.1;
        else if (self.scale < 5.1)
            self.scale -= 1.0;
        else if (self.scale < 11.0)
            self.scale -= 5.0;
        else
            self.scale -= 10.0;
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
    self.scale = 35.0;
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
    [super dealloc];
}

@end
