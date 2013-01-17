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
- (IBAction)pushNumberButton:(id)sender { // 数字のボタンを押された時の動作
    numberDisplay.text = [calculate addNumber:[[[NSNumberFormatter alloc] init] numberFromString:[sender restorationIdentifier]] ToString:numberDisplay.text];
}

- (IBAction)pushClearButton:(id)sender { // Cボタンを押された時の動作
    numberDisplay.text = [calculate clearAll];
}

- (IBAction)pushPlusMinusButton:(id)sender { // ±ボタンを押された時の動作
    numberDisplay.text = [calculate addPlusMinusToString:numberDisplay.text];
}

- (IBAction)pushCalcSymbolButton:(id)sender { // 演算子を押された時の動作
    enum State state;

    // 押された演算子をボタンのIDから判断して状態を変える
    if ([[sender restorationIdentifier] isEqualToString:@"Plus"]) {
        state = Plus;
    }else if ([[sender restorationIdentifier] isEqualToString:@"Minus"]){
        state = Minus;
    }else if ([[sender restorationIdentifier] isEqualToString:@"Multiple"]){
        state = Multiple;
    }else if ([[sender restorationIdentifier] isEqualToString:@"Divide"]){
        state = Divide;
    }else if ([[sender restorationIdentifier] isEqualToString:@"Equal"]){
        state = Equal;
    }

    // 状態と現在の値をcalculateに渡す
    numberDisplay.text = [calculate calculateValueToString:numberDisplay.text ForType:state];
}

- (IBAction)pushDotButton:(id)sender { // 小数点ボタンを押された時の動作
    numberDisplay.text = [calculate addDecimalPointToString:numberDisplay.text]; // 小数点を表示されている数値の最後に追加
}

@end
