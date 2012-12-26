//
//  Calculate.m
//  Calc
//
//  Created by Takeshi on 2012/11/15.
//  Copyright (c) 2012年 Takeshi Yasunaga. All rights reserved.
//

#import "Calculate.h"

#define MAX_DIGIT 15 // 最大桁数

@implementation Calculate{
    NSNumberFormatter *numberFormatterFormal;
    NSNumberFormatter *numberFormatterNatural;

    enum State state;
}

- (id)init{
    [self clearAll];

    // 3桁区切りあり
    numberFormatterFormal = [[NSNumberFormatter alloc] init];
    [numberFormatterFormal setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatterFormal setGroupingSeparator:@","];
    [numberFormatterFormal setGroupingSize:3];
    [numberFormatterFormal setMaximumFractionDigits:MAX_DIGIT];

    // 3桁区切りなし
    numberFormatterNatural = [numberFormatterFormal copy];
    [numberFormatterNatural setGroupingSeparator:@""];
    
    return self;
}

- (NSString *)clearAll{
    state = Normal;
    _currentValue = @0;
    _previousValue = @0;
    return @"0";
}

- (NSString *)addNumber:(NSNumber *)number ToString:(NSString *)valueString{
    // 桁数制限
    if (valueString.length >= MAX_DIGIT)
        return valueString;

    // イコール直後
    if(state == Equal){
        valueString = [numberFormatterFormal stringFromNumber:number];
        state = Normal;
        return valueString;
    }

    // 値が0の時
    if ([valueString isEqualToString:@"0"]) {
        valueString = [numberFormatterFormal stringFromNumber:number];
        return valueString;
    }

    // 小数点以下の入力
    if ([valueString rangeOfString:@"."].location != NSNotFound) {
        valueString = [valueString stringByAppendingFormat:@"%@",number];
        return valueString;
    }

    // 通常時
    NSString* naturalValueString = [numberFormatterNatural stringFromNumber:[numberFormatterFormal numberFromString:valueString]];

    if([valueString hasSuffix:@"."] == TRUE)
        naturalValueString = [naturalValueString stringByAppendingFormat:@".%@",number];
    else
        naturalValueString = [naturalValueString stringByAppendingFormat:@"%@",number];

    valueString = [numberFormatterFormal stringFromNumber:[numberFormatterNatural numberFromString:naturalValueString]];
    _currentValue = [numberFormatterNatural numberFromString:naturalValueString];
    
    return valueString;
}

- (NSString *)addDecimalPointToString:(NSString *)valueString{
    // イコール直後
    if(state == Equal)
        return valueString;

    // .が無い
    if ([valueString rangeOfString:@"."].location == NSNotFound){
        valueString = [valueString stringByAppendingString:@"."];
        return valueString;
    }

    // .が末尾にある
    if([valueString hasSuffix:@"."])
        valueString = [valueString substringToIndex:valueString.length - 1];
    
    return valueString;
}

- (NSString *)addPlusMinusToString:(NSString *)valueString{
    if ([valueString hasPrefix:@"-"])
        valueString = [valueString substringFromIndex:1];
    else
        valueString = [@"-" stringByAppendingString:valueString];

    return valueString;
}

- (NSString *)calculateValueToString:(NSString *)valueString ForType:(enum State)type{
    _currentValue = [numberFormatterFormal numberFromString:valueString];
    
    [self calculateValue];
    state = type;

    if (state != Equal){
        _previousValue = _currentValue;
        _currentValue = @0;
    }
    valueString = [numberFormatterFormal stringFromNumber:_currentValue];
    return valueString;
}

- (void)calculateValue{
    // !!!: 桁数制限を超える場合の数値の扱いをどうにかする
    switch (state) {
        case Plus:
            _currentValue = [NSNumber numberWithDouble:[_previousValue doubleValue] + [_currentValue doubleValue]];
            break;
        case Minus:
            _currentValue = [NSNumber numberWithDouble:[_previousValue doubleValue] - [_currentValue doubleValue]];
            break;
        case Multiple:
            _currentValue = [NSNumber numberWithDouble:[_previousValue doubleValue] * [_currentValue doubleValue]];
            break;
        case Divide:
            _currentValue = [NSNumber numberWithDouble:[_previousValue doubleValue] / [_currentValue doubleValue]];
            break;
        default:
            break;
    }
}

@end
