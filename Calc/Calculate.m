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
    NSNumberFormatter *numberFormatFormal;
    NSNumberFormatter *numberFormatNatural;

    enum State state;
}

- (id)init{
    state = Normal;
    _currentValue = @0;

    numberFormatFormal = [[NSNumberFormatter alloc] init];
    [numberFormatFormal setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatFormal setGroupingSeparator:@","];
    [numberFormatFormal setGroupingSize:3];
    [numberFormatFormal setMaximumFractionDigits:MAX_DIGIT];

    numberFormatNatural = [[NSNumberFormatter alloc] init];
    [numberFormatNatural setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatNatural setGroupingSeparator:@""];
    [numberFormatNatural setMaximumFractionDigits:MAX_DIGIT];
    
    return self;
}

- (NSString *)clearAll:(NSString *)valueString{
    _currentValue = @0;
    _previousValue = @0;
    valueString = @"0";
    return valueString;
}

- (NSString *)addNumber:(NSNumber *)number ToString:(NSString *)valueString{
    // 桁数制限
    if (valueString.length >= MAX_DIGIT)
        return valueString;

    // イコール直後
    if(state == Equal){
        _currentValue = number;
        valueString = [numberFormatFormal stringFromNumber:_currentValue];
        state = Normal;
        return valueString;
    }

    if([valueString hasSuffix:@"."] == TRUE){
        _currentValue = [numberFormatFormal numberFromString:
                         [[numberFormatNatural stringFromNumber:_currentValue] stringByAppendingFormat:@".%@",number]];
        valueString = [numberFormatFormal stringFromNumber:_currentValue];
        return valueString;
    }

    // 値が0の時
    if ([_currentValue isEqualToNumber:@0]) {
        _currentValue = number;
        valueString = [numberFormatFormal stringFromNumber:_currentValue];
        return valueString;
    }

    // .が末尾にある // FIXME: 小数点以下に0が入力できないバグ
    if([valueString hasSuffix:@"."] == TRUE){
        _currentValue = [numberFormatFormal numberFromString:[valueString stringByAppendingFormat:@"%@",number]];
    }else{
        _currentValue = [numberFormatFormal numberFromString:
                         [[numberFormatNatural stringFromNumber:_currentValue] stringByAppendingFormat:@"%@",number]];
    }
    
    valueString = [numberFormatFormal stringFromNumber:_currentValue];
    return valueString;
}

- (NSString *)addDecimalPointToString:(NSString *)valueString{
    // .が末尾にある
    if([valueString hasSuffix:@"."] == TRUE){
        valueString = [valueString substringFromIndex:valueString.length - 1];
        return valueString;
    }
    // .が無い
    if ([[numberFormatFormal stringFromNumber:_currentValue] rangeOfString:@"."].location == NSNotFound) {
        valueString = [valueString stringByAppendingString:@"."];
    }else{ // .がある
        return valueString;
    }
    return valueString;
}

- (NSString *)addPlusMinusToString:(NSString *)valueString{
    if ([[numberFormatFormal numberFromString:valueString] compare:@0] == NSOrderedDescending){
        valueString = [@"-" stringByAppendingString:valueString];
    }else if([[numberFormatFormal numberFromString:valueString] compare:@0] == NSOrderedAscending){
        valueString = [valueString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]];
    }else{
        if ([valueString isEqualToString:@"0"]) {
            valueString = @"-0";
        }else{
            valueString = @"0";
        }
    }
    return valueString;
}

- (NSString *)calculateValueToString:(NSString *)valueString ForType:(enum State)type{
    [self calculateValue];
    state = type;

    valueString = [numberFormatFormal stringFromNumber:_currentValue];
    if (state == Equal){
        return valueString;
    }else{
        _previousValue = _currentValue;
        _currentValue = @0;
    }
    return valueString;
}

- (void)calculateValue{
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
