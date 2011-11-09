//
//  CalculatorBrain.h
//  
//
//  Created by Vince Mansel on 11/1/11.
//  Copyright (c) 2011 Wave Ocean Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject
{
    double operand;
    NSString *waitingOperation;
    double waitingOperand;
    
    NSMutableArray *internalExpression;
}

//@property double operand;
@property (retain) NSString *waitingOperation;
@property double waitingOperand;
@property double memoryStore;
@property (nonatomic) BOOL degOrRad;
@property BOOL isTwoOperandOperationPending;
@property BOOL isClearAllFlagUp;

-(void)setOperand:(double)aDouble;
-(void)setVariableAsOperand:(NSString *)variableName;
-(double)performOperation:(NSString *)operation;

@property (readonly) id expression;

+(double)evaluateExpression:(id)anExpression
         usingVariableValues:(NSDictionary *)values;

+(NSSet *)variablesInExpression:(id)anExpression;
+(NSString *)descriptionOfExpression:(id)anExpression;

//+(id)propertyListForExpression:(id)anExpression;
//+(id)expressionForPropertyList:(id)propertyList;

@end
