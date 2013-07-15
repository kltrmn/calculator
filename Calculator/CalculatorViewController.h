//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Brian Kolterman on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *operationHistory;
@property (weak, nonatomic) IBOutlet UILabel *variableDisplay;

@end
