//
//  CalculatorViewController.m
//  Smallculator
//
//  Created by Vince Mansel on 11/1/11.
//  Copyright (c) 2011 Wave Ocean Software. All rights reserved.
//

#import "CalculatorViewController.h"
#import "GraphViewController.h"

@interface CalculatorViewController()
@property (retain) CalculatorBrain *pBrain;
-(void)solveEquation:(double)result;
@end;

@implementation CalculatorViewController
@synthesize pBrain;
@synthesize display;
//@synthesize status;
//@synthesize memDisplay;
//@synthesize degOrRadUISwitchStatus;

//-(CalculatorBrain *)brain
//{
//    if (!self.pBrain) self.pBrain = [[CalculatorBrain alloc] init];
//    return self.pBrain;
//}

-(void)viewDidLoad
{
    pBrain = [[CalculatorBrain alloc] init];
    self.title = @"Graphulator";
}

-(void)viewDidUnLoad
{
    self.display = nil;
//    self.status = nil;
//    self.memDisplay = nil;
//    self.degOrRadUISwitchStatus = nil;
}

-(BOOL)isfloatingPointOK:(NSString *)displayText
{
    NSRange range = [displayText rangeOfString:@"."];
    if (range.location == NSNotFound) return YES;
    else return NO;
}

-(IBAction)graphPressed:(UIButton *)sender
{
    GraphViewController *gvc = [[GraphViewController alloc] init];
    gvc.scale = 1;
    gvc.title = @"Equation Goes Here";
    [self.navigationController pushViewController:gvc animated:YES];
    [gvc release];
}

-(IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.titleLabel.text;
    //NSLog(@"Digit Pressed = %@", digit);
    
    if ([digit isEqual:@"Back"])
    {
        NSUInteger index = [display.text length] - 1;
        if (index > 0)
            [display setText:[display.text substringToIndex:index]];
        else
            [display setText:@"0"];
    }
    else if ([digit isEqual:@"π"])
    {
        [display setText:[NSString stringWithFormat:@"%g", M_PI]];
        userIsInTheMiddleOfTypingANumber = YES;
    }
    else if (userIsInTheMiddleOfTypingANumber)
    {
        if (([digit isEqual:@"."] && [self isfloatingPointOK:display.text]) ||
            ![digit isEqual:@"."])
            [display setText:[display.text stringByAppendingString:digit]];
    }
    else
    {
        [display setText:digit];
//        [status setText:@""];
        userIsInTheMiddleOfTypingANumber = YES;
    }
}

-(IBAction)operationPressed:(UIButton *)sender
{   
//    if (![status.text isEqual:@""]
//     && ([status.text length] >= 6)
//     && [[status.text substringToIndex:6] isEqual:@"Error:"])
//    {
//        [pBrain performOperation:@"clearStatus"];
//        [status setText:@""];
//        [display setText:@"0"];
//    }
    
    if (userIsInTheMiddleOfTypingANumber)
    {
        [pBrain setOperand:[display.text doubleValue]];
        userIsInTheMiddleOfTypingANumber = NO;
    }
    
    // The old version without the alloc was causing a malloc_error in CalculatorBrain
    // during a performOperation:@"C". The command [internalExpression removeObjects] was double-free on the 1st @"="
    // for the sequence "3 * = Solve 3 * = Solve + x = Solve C"
    
    NSString *operation = [[NSString alloc] initWithString:sender.titleLabel.text];
    
    double result = [pBrain performOperation:operation];
    
    // Model(brain) exports memoryStore to Controller via API: getMemoryStore
//    [memDisplay setText:[NSString stringWithFormat:@"%g", pBrain.memoryStore]];
    
//    if (pBrain.isTwoOperandOperationPending)
//        [status setText:[NSString stringWithFormat:@"%g %@", pBrain.waitingOperand,
//                                                             pBrain.waitingOperation]];
   
    if ([CalculatorBrain variablesInExpression:pBrain.expression])
        [display setText:[CalculatorBrain descriptionOfExpression:pBrain.expression]];
    else
        [self solveEquation:result];
    
//    if ([pBrain isClearAllFlagUp])
//        [status setText:@""];    
}

-(void)variablePressed:(UIButton *)sender
{
    NSString *variable = sender.titleLabel.text;
    [pBrain setVariableAsOperand:variable];
}

-(void)solvedPressed:(UIButton *)sender
{   
    NSString * doe = [CalculatorBrain descriptionOfExpression:pBrain.expression];
    if (doe.length > 0) {
        NSLog(@"solvedPressed: Last Character = %@", [doe substringFromIndex:doe.length-2]);
        if (![[doe substringFromIndex:doe.length-2] isEqual:@"= "])
            [pBrain performOperation:@"="];
        double result = [CalculatorBrain evaluateExpression:pBrain.expression
                                        usingVariableValues:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [NSNumber numberWithDouble:2],@"x",
                                                             [NSNumber numberWithDouble:4],@"a",
                                                             [NSNumber numberWithDouble:6],@"b",
                                                             [NSNumber numberWithDouble:8],@"c",
                                                             nil]];
        NSLog(@"ViewController Solve result = %g",result);
        
        //[self solveEquation:result]; // This handles neg sqrt and divide by zero
        
        NSString * doe2 = [CalculatorBrain descriptionOfExpression:pBrain.expression];
        [display setText:[NSString stringWithFormat:@"%@ %g", doe2, result]];
    }
}

-(void)solveEquation:(double)result
{
    if (isnan(result))
        [display setText:@"Error: Negative square root not allowed"];
    else if (isinf(result))
        [display setText:@"Error: Divide by zero not allowed"];
    else
        [display setText:[NSString stringWithFormat:@"%g", result]];
}

// Sample Code Referenced: BreadcrumbViewController.m
//-(IBAction)toggleDegRadSwitch:(UISwitch *)sender
//{
//    UISwitch *degRadSwitch = (UISwitch *)sender;
//    if (degRadSwitch.isOn)
//    {
//        pBrain.degOrRad = YES;
//        [degOrRadUISwitchStatus setText:@"Deg"];
//    }
//    else
//    {
//        pBrain.degOrRad = NO;
//        [degOrRadUISwitchStatus setText:@"Rad"];
//    }
//}

- (void)dealloc {
    [self.pBrain release];
    [super dealloc];
}

@end
