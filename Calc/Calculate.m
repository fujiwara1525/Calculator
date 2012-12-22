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
    [self clearAll];

    // 3桁区切りあり
    numberFormatFormal = [[NSNumberFormatter alloc] init];
    [numberFormatFormal setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatFormal setGroupingSeparator:@","];
    [numberFormatFormal setGroupingSize:3];
    [numberFormatFormal setMaximumFractionDigits:MAX_DIGIT];

    // 3桁区切りなし
    numberFormatNatural = [numberFormatFormal copy];
    [numberFormatNatural setGroupingSeparator:@""];
    
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
        _currentValue = number;
        valueString = [numberFormatFormal stringFromNumber:_currentValue];
        state = Normal;
        return valueString;
    }

    // 値が0の時
    if ([valueString isEqualToString:@"0"]) {
        _currentValue = number;
        valueString = [numberFormatFormal stringFromNumber:_currentValue];
        return valueString;
    }

    // 小数点以下の入力
    if ([valueString rangeOfString:@"."].location != NSNotFound) {
        valueString = [valueString stringByAppendingFormat:@"%@",number];
        _currentValue = [numberFormatFormal numberFromString:valueString];
        return valueString;
    }

    // 通常時
    NSString* naturalValueString = [numberFormatNatural stringFromNumber:[numberFormatFormal numberFromString:valueString]];

    if([valueString hasSuffix:@"."] == TRUE)
        naturalValueString = [naturalValueString stringByAppendingFormat:@".%@",number];
    else
        naturalValueString = [naturalValueString stringByAppendingFormat:@"%@",number];

    valueString = [numberFormatFormal stringFromNumber:[numberFormatNatural numberFromString:naturalValueString]];
    _currentValue = [numberFormatNatural numberFromString:naturalValueString];
    return valueString;
}

- (NSString *)addDecimalPointToString:(NSString *)valueString{
    // イコール直後
    if(state == Equal){
        return valueString;
    }

    // .が末尾にある
    if([valueString hasSuffix:@"."] == TRUE){
        valueString = [valueString substringToIndex:valueString.length - 1];
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

    if (state != Equal){
        _previousValue = _currentValue;
        _currentValue = @0;
    }
    valueString = [numberFormatFormal stringFromNumber:_currentValue];
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
