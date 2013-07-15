//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Brian Kolterman on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (void)pushOperation:(NSString *)operation;
- (void)removeObjectfromProgram;
- (double)performOperation:(NSString *)operation
       usingVariableValues:(NSDictionary *)variableValues;
- (void)clearOperands;


@property (readonly) id program;
@property (readonly, strong) NSSet *validOperations;

+ (BOOL)isOperation:(NSString *)value;

+ (NSString *)returnOperationIfPresent:(NSString *)expression;

+ (double)runProgram:(id)program;

+ (double)runProgram:(id)program
 usingVariableValues:(NSDictionary *)variableValues;

+ (int)numberOfOperands:(id)program;

+ (NSString *)describeProgram:(id)program;

+ (NSSet *)variablesUsedInProgram:(id)program;

@end
