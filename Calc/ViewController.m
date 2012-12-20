//
//  ViewController.m
//  Calc
//
//  Created by Takeshi on 12/10/20.
//  Copyright (c) 2012年 Takeshi Yasunaga. All rights reserved.
//

#import "ViewController.h"
#import "Calculate.h"

@interface ViewController (){
    Calculate *calculate;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    calculate = [[Calculate alloc] init];
    numberDisplay.text = @"0";
}

#pragma mark - IBAction
- (IBAction)pushNumberButton:(id)sender {
    numberDisplay.text = [calculate addNumber:[[[NSNumberFormatter alloc] init] numberFromString:[sender accessibilityLabel]] ToString:numberDisplay.text];
}

- (IBAction)pushClearButton:(id)sender {
    numberDisplay.text = [calculate clearAll:numberDisplay.text];
}

- (IBAction)pushPlusMinusButton:(id)sender {
    numberDisplay.text = [calculate addPlusMinusToString:numberDisplay.text];
}

- (IBAction)pushCalcSymbolButton:(id)sender {
    enum State state;
    if ([[sender accessibilityLabel] isEqualToString:@"Plus"]) {
        state = Plus;
    }else if ([[sender accessibilityLabel] isEqualToString:@"Minus"]){
        state = Minus;
    }else if ([[sender accessibilityLabel] isEqualToString:@"Multiple"]){
        state = Multiple;
    }else if ([[sender accessibilityLabel] isEqualToString:@"Divide"]){
        state = Divide;
    }else if ([[sender accessibilityLabel] isEqualToString:@"Equal"]){
        state = Equal;
    }
    numberDisplay.text = [calculate calculateValueToString:numberDisplay.text ForType:state];
}

- (IBAction)pushDotButton:(id)sender {
    numberDisplay.text = [calculate addDecimalPointToString:numberDisplay.text];
}

@end
