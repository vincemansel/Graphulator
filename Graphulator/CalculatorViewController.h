//
//  CalculatorViewController.h
//  Smallculator
//
//  Created by Vince Mansel on 11/1/11.
//  Copyright (c) 2011 Wave Ocean Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"

@interface CalculatorViewController : UIViewController
{
    IBOutlet UILabel *display;
//    IBOutlet UILabel *status;
//    IBOutlet UILabel *memDisplay;
//    IBOutlet UILabel *degOrRadUISwitchStatus;
    BOOL userIsInTheMiddleOfTypingANumber;
}

//@property (retain) CalculatorBrain *brain;

@property (nonatomic, retain) IBOutlet UILabel *display;
//@property (nonatomic, retain) IBOutlet UILabel *status;
//@property (nonatomic, retain) IBOutlet UILabel *memDisplay;
//@property (nonatomic, retain) IBOutlet UILabel *degOrRadUISwitchStatus;


-(IBAction)digitPressed:(UIButton *)sender;
-(IBAction)operationPressed:(UIButton *)sender;
-(IBAction)variablePressed:(UIButton *)sender;
-(IBAction)graphPressed:(UIButton *)sender;
//-(IBAction)solvedPressed:(UIButton *)sender;

//-(IBAction)toggleDegRadSwitch:(UISwitch *)sender;

@end
