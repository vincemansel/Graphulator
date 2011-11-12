//
//  GraphView.h
//  Graphulator
//
//  Created by Vince Mansel on 11/8/11.
//  Copyright (c) 2011 Wave Ocean Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphViewDelegate
- (CGFloat)scaleForGraphView:(GraphView *)requestor; // 1.0 (Zoomed Out) to 160 (Zoomed In)
                                                     // 1, 2, 4, 8, 16, 32, 80, 160
- (CGFloat)yValueForGraphView:(GraphView *)requestor
                         forX:(CGFloat)x;           // depends on graphScale
@end

@interface GraphView : UIView
{
    id <GraphViewDelegate> delegate;
}

@property (assign) id <GraphViewDelegate> delegate;

@end
