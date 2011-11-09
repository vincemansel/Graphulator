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
- (CGFloat) scaleForGraphView:(GraphView *)requestor; // 1.0 (Zoomed Out) to 100 (Zoomed In)
@end

@interface GraphView : UIView
{
    id <GraphViewDelegate> delegate;
}

@property (assign) id <GraphViewDelegate> delegate;

@end
