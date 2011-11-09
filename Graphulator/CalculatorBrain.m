//
//  CalculatorBrain.m
//  Smallculator
//
//  Created by Vince Mansel on 11/1/11.
//  Copyright (c) 2011 Wave Ocean Software. All rights reserved.
//

#import "CalculatorBrain.h"

#define VARIABLE_PREFIX @"%"

@implementation CalculatorBrain

//@synthesize operand;
@synthesize waitingOperand;
@synthesize waitingOperation;
@synthesize memoryStore;
@synthesize degOrRad;
@synthesize isClearAllFlagUp;
@synthesize isTwoOperandOperationPending;

NSString *vp = VARIABLE_PREFIX;

-(void)addToExpression:(id)anObject
{
    if (!internalExpression) internalExpression = [[NSMutableArray alloc] init];
    [internalExpression addObject:anObject];
    //NSLog(@"expression = %@", internalExpression);
}

-(void)setOperand:(double)aDouble
{
    operand = aDouble;
    [self addToExpression:[NSNumber numberWithDouble:aDouble]];
}

-(void)setVariableAsOperand:(NSString *)variableName
{
    /*A string in the array has to have a length of
     at least 1 + the length of your prepended string
     to be considered a variable.
     */
    [self addToExpression:[NSString stringWithFormat:@"%@%@", vp, variableName]];
}

-(id)expression
{
//    id returnExpression = [internalExpression  copy];
//    [returnExpression autorelease];
//    return returnExpression;
    return [NSArray arrayWithArray:internalExpression];
}

+(double)evaluateExpression:(id)anExpression
         usingVariableValues:(NSDictionary *)values
{
    CalculatorBrain * evalBrain = [[CalculatorBrain alloc] init];
    
    //NSLog(@"evaluateExpression = %@", anExpression);
    
    double result;
    
    for (id obj in anExpression) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            [evalBrain setOperand:[obj doubleValue]];
        }
        else if ([obj isKindOfClass:[NSString class]]) {
            NSString * s = (NSString *) obj;
            if ((s.length == vp.length + 1) && ([[s substringToIndex:1] isEqual:vp])) {
                NSString * key = [s substringFromIndex:1];
                //NSLog(@"evaluateExpression: key = %@, %@", key, values);
                [evalBrain setOperand:[[values objectForKey:key] doubleValue]];
            }
            else {
                result = [evalBrain performOperation:obj];
            }
        }
    }
    
    //NSLog(@"evaluateExpression: evalBrain.expression = %@", evalBrain.expression);
    [evalBrain autorelease];
    return result;
}

+(NSSet *)variablesInExpression:(id)anExpression
{
    NSMutableSet * varSet = nil;
    
    for (id obj in anExpression) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString * s = (NSString *) obj;
            if ((s.length == vp.length + 1) && ([[s substringToIndex:1] isEqual:vp])) {
                if (!varSet) varSet = [[NSMutableSet alloc] init];
                NSString * key = [s substringFromIndex:1];
                //NSLog(@"variablesInExpression: key = %@", key);
                //if (![varSet member:key])
                    [varSet addObject:key];
            }
        }
    }
    //NSLog(@"variablesInExpression: %@", varSet);
    
    [varSet autorelease];
    return varSet;
}

+(NSString *)descriptionOfExpression:(id)anExpression
{
    //NSLog(@"descriptionOfExpression: %@", anExpression);
    NSString * expressionDescription = @"";
        
    for (id obj in anExpression) {
        if ([obj isKindOfClass:[NSNumber class]])
            expressionDescription = [expressionDescription stringByAppendingFormat:@"%@ ", obj];
        else {
            NSString * str = (NSString *) obj;
            if ((str.length == vp.length + 1) && ([[str substringToIndex:1] isEqual:vp])) {
                str = [str substringFromIndex:1];
            }
            expressionDescription = [expressionDescription stringByAppendingFormat:@"%@ ", str];
        }
        
    }
    NSLog(@"descriptionOfExpression: %@", expressionDescription);
    return expressionDescription;
}

//+(id)propertyListForExpression:(id)anExpression
//{
//    
//}
//
//+(id)expressionForPropertyList:(id)propertyList
//{
//    
//}

-(void)setDegOrRad:(BOOL)switchSetting
{
    degOrRad = switchSetting;
}

-(void)performWaitingOperation
{
    if ([waitingOperation isEqual:@"*"])
    {
        operand = waitingOperand * operand;
    }
    else if ([waitingOperation isEqual:@"+"])
    {
        operand = waitingOperand + operand;
    }
    else if ([waitingOperation isEqual:@"-"])
    {
        operand = waitingOperand - operand;
    }
    else if ([waitingOperation isEqual:@"/"])
    {
        operand = waitingOperand / operand;
    }
    else {
        //NSLog(@"performWaitingOperation: first time");
    }
}

-(double)performOperation:(NSString *)operation
{
    isClearAllFlagUp = NO;
    
    [self addToExpression:operation];

    if ([operation isEqual:@"sqrt"])
    {
        operand = sqrt(operand);
    }
    else if ([operation isEqual:@"+/-"])
    {
        operand = - operand;
    }
    else if ([operation isEqual:@"1/x"])
    {
        operand = 1 / operand;
    }
    else if ([operation isEqual:@"sin"])
    {
        // sin(x) in this context is accurate to ~10-16
        // i.e. values that should evaluate to zero are very small instead
        if (degOrRad)
            operand = sin((operand/180) * M_PI);
        else
            operand = sin(operand);
    }
    else if ([operation isEqual:@"cos"])
    {
        // cos(x) in this context is accurate to ~10-16
        if (degOrRad)
            operand = cos((operand/180) * M_PI);
        else
            operand = cos(operand);
    }
    else if ([operation isEqual:@"Store"])
    {
        memoryStore = operand;
    }
    else if ([operation isEqual:@"Recall"])
    {
        operand = memoryStore;
    }
    else if ([operation isEqual:@"Mem+"])
    {
        memoryStore += operand;
    }
    else if ([operation isEqual:@"Clear"])
    {
        memoryStore = 0;
        operand = 0;
        waitingOperation = 0;
        waitingOperand = 0;
        isClearAllFlagUp = YES;
        
        //NSLog(@"performOperation: Before internalExpression = %@", internalExpression);
        //NSLog(@"performOperation: Before internalExpression removeAllObjects");
        if ([internalExpression lastObject]) {
            //NSLog(@"performOperation: do internalExpression removeAllObjects");
            [internalExpression removeAllObjects];
        }
        //NSLog(@"performOperation: After internalExpression = %@", internalExpression);
    }
    else if ([operation isEqual:@"clearStatus"])
    {
        operand = 0;
    }
    else if ([operation isEqual:@"MC"])
    {
        memoryStore = 0;
    }
    else
    {
        [self performWaitingOperation];
        waitingOperation = operation;
        waitingOperand = operand;
        if ([operation isEqual:@"="])
            isTwoOperandOperationPending = NO;
        else
            isTwoOperandOperationPending = YES;
    }
    return operand;
}

- (void)dealloc {
    [waitingOperation release];
    [internalExpression release];
    [super dealloc];
}

@end
