//
//  GraphViewController.h
//  Graphulator
//
//  Created by Vince Mansel on 11/8/11.
//  Copyright (c) 2011 Wave Ocean Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphViewController : UIViewController <GraphViewDelegate>
{
    CGFloat scale;              // 1 to 100. Mod by Zoom Out/In
    GraphView *graphView;
    NSArray *graphData;
}

@property (nonatomic) CGFloat scale;
@property (retain) IBOutlet GraphView *graphView;
@property (retain, nonatomic) NSArray *graphData;

- (IBAction)zoomPressed:(UIButton *)sender;

@end
