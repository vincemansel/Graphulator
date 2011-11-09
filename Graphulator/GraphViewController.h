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
    CGFloat scale;      // TODO: TBD. Start with 0.01 to 155. Mod by Zoom Out/In
    GraphView *graphView;
}

@property (nonatomic) CGFloat scale;
@property (retain) IBOutlet GraphView *graphView;

- (IBAction)zoomPressed:(UIButton *)sender;

@end
