//
//  CalculatorViewController.h
//  Smallculator
//
//  Created by Vince Mansel on 11/1/11.
//  Copyright (c) 2011 Wave Ocean Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"
#import "GraphViewController.h"

@interface CalculatorViewController : UIViewController
{
    IBOutlet UILabel *display;
    BOOL userIsInTheMiddleOfTypingANumber;
}


@property (nonatomic, retain) IBOutlet UILabel *display;


-(IBAction)digitPressed:(UIButton *)sender;
-(IBAction)operationPressed:(UIButton *)sender;
-(IBAction)variablePressed:(UIButton *)sender;
-(IBAction)graphPressed:(UIButton *)sender;

@end
