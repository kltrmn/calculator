//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Brian Kolterman on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()

@property (nonatomic, strong) NSMutableArray *programStack;



@end



@implementation CalculatorBrain

@synthesize validOperations = _validOperations;

+ (NSSet *)validOperations
{
    NSSet *validOperations = [[NSSet alloc] initWithObjects:@"+",@"-",@"×",@"÷",@"Sin",@"Cos",@"Sqrt", nil];
    return validOperations;
    
}




@synthesize programStack = _programStack;

- (NSMutableArray *)programStack 
{
    
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
    
}


- (id)program
{
    
    return [self.programStack copy];
    
} 


+ (BOOL)isOperation:(id)operator
{
    if (![operator isKindOfClass:[NSString class]]) return NO;

    return [[CalculatorBrain validOperations] containsObject:operator];
    
}




+ (BOOL)isVariable:(id)operator
{
    
    if (![operator isKindOfClass:[NSString class]]) return NO;
    
    if (![operator isEqualToString:@"π"]) {
        
        return ![CalculatorBrain isOperation:operator];
    }
    
    return NO;
}

+ (int)numberOfOperands:(id)operator
{
    int num = 0;
    
    if ([operator isKindOfClass:[NSNumber class]] || operator == nil) {
        
        return num;
        
    } else {
        
        NSSet *oneOperandOps = [[NSSet alloc] initWithObjects:@"Sin",@"Cos",@"Sqrt", nil];
        NSSet *twoOperandOps = [[NSSet alloc] initWithObjects:@"+",@"-",@"×",@"÷",nil];
        
        if ([oneOperandOps containsObject:operator]) num = 1;
        if ([twoOperandOps containsObject:operator]) num = 2;
        
        return num;
    }
    
}

         
         
         
- (void)pushOperand:(double)operand 
{

    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
    
}




- (void)pushOperation:(NSString *)operation
{
    
    NSString *description;
    NSMutableArray *stack;
    
    [self.programStack addObject:operation];
    stack = [self.programStack mutableCopy];
    description = [CalculatorBrain descriptionOfProgram:stack];
    
    if ([description isEqualToString:@""]) {
        
        [self.programStack removeLastObject];
    }

}


- (void)removeObjectfromProgram
{
    [self.programStack removeLastObject];
}



- (double)performOperation:(NSString *)operation
       usingVariableValues:(NSDictionary *)variableValues
{
    
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program usingVariableValues:variableValues];
    
}


+ (NSString *)returnOperationIfPresent:(NSString *)expression
{
    
    for (int i = 0; i < [expression length]; i++) {
        
        NSString *op = [NSString stringWithFormat:@"%C",[expression characterAtIndex:i]];
        
        if ([CalculatorBrain isOperation:op]) return op;
    }
    
    return nil;
}


+ (NSString *)descriptionOfProgram:(NSMutableArray *)stack
{
    
    NSString *op1, *op2, *operation;
    NSMutableString *description;
    
    int n;
    
    
    description = [[NSMutableString alloc] initWithString:@""];
    
    if (![stack lastObject]) return description;
    
    if ([[stack lastObject] isKindOfClass:[NSNumber class]]) {
        
        operation = [[stack lastObject] stringValue];
        
    } else {
        
        operation = [stack lastObject];
    }
    
    if (operation) [stack removeLastObject];
    
    
    n = [self numberOfOperands:operation];
    
    if (n == 0) {
        
        [description appendFormat:@"%@",operation];
        
    }
    
    
    if (n == 1) {
        
        op1 = [self descriptionOfProgram:stack];
        
        if ([op1 isEqualToString:@""]) op1 = @"0";
        
        [description appendFormat:@"%@(%@) ",operation, op1];
        
    }
    
    if (n == 2) {
                
        op1 = [self descriptionOfProgram:stack];
        op2 = [self descriptionOfProgram:stack];
      
        if (![op1 isEqualToString:@""] && ![op2 isEqualToString:@""]) {
        
       
            if (![CalculatorBrain returnOperationIfPresent:op2] && [CalculatorBrain returnOperationIfPresent:op1] && ![operation isEqualToString:[CalculatorBrain returnOperationIfPresent:op1]]) {
                
                [description appendFormat:@"%@ %@ (%@)",op2,operation,op1];
                
            } else if ([CalculatorBrain returnOperationIfPresent:op2] && ![CalculatorBrain returnOperationIfPresent:op1] && ![operation isEqualToString:[CalculatorBrain returnOperationIfPresent:op2]]) {
                
                [description appendFormat:@"(%@) %@ %@",op2,operation,op1];
                
            } else if ([CalculatorBrain returnOperationIfPresent:op2] && [CalculatorBrain returnOperationIfPresent:op1] && ![operation isEqualToString:[CalculatorBrain returnOperationIfPresent:op1]] && ![operation isEqualToString:[CalculatorBrain returnOperationIfPresent:op2]]) {
                
                [description appendFormat:@"(%@) %@ (%@)",op2,operation,op1];
                
            } else {
                
                [description appendFormat:@"%@ %@ %@",op2,operation,op1];
                
            }
        }
    }
    
        
    return description;
    
}



+ (NSString *)describeProgram:(id)program
{
    NSMutableString *description = [[NSMutableString alloc] initWithString:@""];
    
    NSMutableArray *stack = nil;

    if (!program) return description;
        
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    [description appendFormat:@"%@", [self descriptionOfProgram:stack]];
    
    if ([stack lastObject]) {
        
        [description appendFormat:@", %@", [self describeProgram:stack]];
    }

    
    return description;
    
}




+ (NSSet *)variablesUsedInProgram:(id)program
{
    
    NSMutableSet *variables = [[NSMutableSet alloc] init];
    
    
    for (id obj in program)    {
        if ([CalculatorBrain isVariable:obj]) {
            
            [variables addObject:obj];
        }
        
    }

        
    return variables;
}





+ (double)popOperandOffStack:(NSMutableArray *)stack
{
 
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        
        return [topOfStack doubleValue];
    
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        
        NSString *operation = topOfStack;
        
        if ([operation isEqualToString:@"+"])
        {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
            
        } else if ([operation isEqualToString:@"-"])
            
        {
            result = ([self popOperandOffStack:stack] - [self popOperandOffStack:stack])*(-1.0);
            
        } else if ([operation isEqualToString:@"×"])
            
        {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
            
        } else if ([operation isEqualToString:@"÷"])
        {
            result = 1.0/([self popOperandOffStack:stack] / [self popOperandOffStack:stack]);
            
        } else if ([operation isEqualToString:@"π"])
        {
            result = 3.14159;
            
        } else if ([operation isEqualToString:@"Sin"])
        {
            result = sin([self popOperandOffStack:stack]);
            
        } else if ([operation isEqualToString:@"Cos"])
        {
            result = cos([self popOperandOffStack:stack]);
            
        } else if ([operation isEqualToString:@"Sqrt"])
        {
            result = sqrt([self popOperandOffStack:stack]);
            
        }

        
    }
    
    return result;
    
}

+ (double)runProgram:(id)program
{
    
    NSMutableArray *stack = nil;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    return [self popOperandOffStack:stack];
    
}



+ (double)runProgram:(id)program
usingVariableValues:(NSDictionary *)variableValues

{
    NSNumber *replacmentVal;
    NSMutableArray *stack = nil;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    for (int i = 0; i < [stack count]; i++) {
        
        id operator = [stack objectAtIndex:i];
        
        if ([CalculatorBrain isVariable:operator]) {
            
            if (variableValues) {
                
                replacmentVal = [variableValues objectForKey:operator];
                if (replacmentVal == nil) {
                    
                    replacmentVal = 0;
                } else {
                
                [stack replaceObjectAtIndex:i withObject:replacmentVal];
                
                }
                
            } else {
                
                replacmentVal = 0;
            }
        
            
        }
    }
    
    return [self popOperandOffStack:stack];
    
}



   
-(void)clearOperands
{
    
    [self.programStack removeAllObjects];

    
}

@end
