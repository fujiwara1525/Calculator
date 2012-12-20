//
//  ViewController.h
//  Calc
//
//  Created by Takeshi on 12/10/20.
//  Copyright (c) 2012年 Takeshi Yasunaga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    __weak IBOutlet UILabel *numberDisplay;
}

- (IBAction)pushNumberButton:(id)sender;
- (IBAction)pushClearButton:(id)sender;
- (IBAction)pushPlusMinusButton:(id)sender;
- (IBAction)pushCalcSymbolButton:(id)sender;
- (IBAction)pushDotButton:(id)sender;

@end
