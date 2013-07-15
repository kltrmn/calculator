//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Brian Kolterman on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL isUserEnteringNumber;
@property (nonatomic) BOOL isUserEnteringFloat;
@property (nonatomic, strong) NSDictionary *testVariableValues;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController


@synthesize isUserEnteringNumber = _isUserEnteringNumber;
@synthesize isUserEnteringFloat = _isUserEnteringFloat;
@synthesize display = _display;
@synthesize operationHistory = _operationHistory;
@synthesize variableDisplay = _variableDisplay;


@synthesize testVariableValues = _testVariableValues;

- (NSDictionary *)testVariableValues 
{
    
    if (!_testVariableValues) _testVariableValues = [[NSDictionary alloc] init];
    return _testVariableValues;
    
}

@synthesize brain = _brain;

- (CalculatorBrain *)brain 
{

    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}


- (void)setVariableDisplay
{
    
    NSSet *vars = [[NSSet alloc] initWithSet:[CalculatorBrain variablesUsedInProgram:[self.brain program]]];
    
    
    int numberOfVars = [vars count];
    
    NSEnumerator *enumerator = [vars objectEnumerator];
    
    
    NSString *variable;
    
    self.variableDisplay.text = @"";
    
    while ((variable = [enumerator nextObject])) {
        
        numberOfVars--;
        
        NSString *value;
        value = [[self.testVariableValues objectForKey:variable]stringValue];
        
        if (value == nil) value = @"0";
        
        
        self.variableDisplay.text = [self.variableDisplay.text stringByAppendingFormat:@"%@ = %@",variable,value];
        
        if (numberOfVars) {
            
            self.variableDisplay.text = [self.variableDisplay.text stringByAppendingString:@", "];
            
        }
    }
    
}



-(void)updateUI
{
    
    double result = [CalculatorBrain runProgram:[self.brain program] usingVariableValues:self.testVariableValues];
    
    self.display.text = [NSString stringWithFormat:@"%g",result];
    
    self.operationHistory.text = [CalculatorBrain describeProgram:[self.brain program]];  
    
    [self setVariableDisplay];
    
}



- (IBAction)digitPress:(UIButton *)sender 
{
    
    NSString *digit = [sender currentTitle];
    
    if ([digit isEqualToString:@"."])
    {
        if (self.isUserEnteringFloat) return;
        self.isUserEnteringFloat = YES;
    }
    
    
    if (self.isUserEnteringNumber) 
    {
        
        self.display.text = [self.display.text stringByAppendingString:digit];
        
    } else 
    
    {
        self.display.text = digit;
        self.isUserEnteringNumber = YES;
    }
    
    
    
    
    
}



- (IBAction)enterPressed 
{
    
    [self.brain pushOperand:[self.display.text doubleValue]];
    
    //self.operationHistory.text = [self.operationHistory.text stringByAppendingFormat:@" %@",self.display.text];
    
    //self.operationHistory.text = [CalculatorBrain describeProgram:[self.brain program]];
    
    [self updateUI];
    
    self.isUserEnteringNumber = NO;
    self.isUserEnteringFloat = NO;
}




- (IBAction)pmPressed 
{
    
    if ([self.display.text length] == 1 && [self.display.text characterAtIndex:0] == '0') return;
    
    if ([self.display.text characterAtIndex:0] != '-')
    {
        
        self.display.text = [@"-" stringByAppendingString:self.display.text];
        
    }   else    {
        
        self.display.text = [self.display.text substringFromIndex:1];
    }
    
    if (!self.isUserEnteringNumber) [self enterPressed];
    
}






- (IBAction)operationPress:(UIButton *)sender 
{
    
    if (self.isUserEnteringNumber) [self enterPressed];
    [self.brain pushOperation:sender.currentTitle];
    [self updateUI];
      
}



- (IBAction)clearPressed 
{

    self.display.text = @"0";
    [self.brain clearOperands];
    self.operationHistory.text = @"";
    self.variableDisplay.text = @"";
    self.isUserEnteringNumber = NO;
    self.isUserEnteringFloat = NO;

    
}






- (IBAction)backPressed 
{
 
    if (self.isUserEnteringNumber) {
        
        if ([self.display.text length] > 1)
        {
            
            if ([self.display.text characterAtIndex:([self.display.text length]-1)] == '.') self.isUserEnteringFloat = NO;
            
            self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];
            
            
        } else if ([self.display.text length] == 1)
        {
            
            [self updateUI];
            
            
        }
    } else {
        
        [self.brain removeObjectfromProgram];
        [self updateUI];
    }
    
    self.isUserEnteringNumber = NO;

}



- (IBAction)testPressed:(UIButton *)sender {
    
    if ([sender.currentTitle isEqualToString:@"T1"]) {
        
        self.testVariableValues = nil;
    }
    
    if ([sender.currentTitle isEqualToString:@"T2"]) {
        
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:20],@"r",[NSNumber numberWithDouble:-10],@"θ",[NSNumber numberWithDouble:5],@"z",nil];
    }
    
    if ([sender.currentTitle isEqualToString:@"T3"]) {
        
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:110],@"r",[NSNumber numberWithDouble:45],@"θ",[NSNumber numberWithDouble:0],@"z",nil];
    }
    
    [self updateUI];
    
    
}

- (IBAction)variablePressed:(id)sender 
{
    
    
    if (self.isUserEnteringNumber) [self enterPressed];
    
    NSString *variable = [sender currentTitle];
    [self.brain pushOperation:variable];
    
    [self updateUI];

}


- (void)viewDidUnload {
    [self setOperationHistory:nil];
    [self setVariableDisplay:nil];
    [super viewDidUnload];
}
@end
