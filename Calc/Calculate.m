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

- (id)init{ // 初期化
    [self clearAll];

    // 3桁区切りありのNSNumberFormatter(例:1,000)
    numberFormatterFormal = [[NSNumberFormatter alloc] init];
    [numberFormatterFormal setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatterFormal setGroupingSeparator:@","];
    [numberFormatterFormal setGroupingSize:3];
    [numberFormatterFormal setMaximumFractionDigits:MAX_DIGIT];

    // 3桁区切りなしのNSNumberFormatter(例:1000)
    numberFormatterNatural = [numberFormatterFormal copy];
    [numberFormatterNatural setGroupingSize:0];
    return self;
}

- (NSString *)clearAll{ // Cボタンの動作
    state = Normal;
    _currentValue = @0;
    _previousValue = @0;
    return @"0";
}

- (NSString *)addNumber:(NSNumber *)number ToString:(NSString *)valueString{ // 与えられた数値（文字列）に数値を追加して返す
    // 桁数制限 - 何もしない
    if (valueString.length >= MAX_DIGIT)
        return valueString;

    // イコール直後 - 表示されていた値を破棄して新規の計算を開始する
    if(state == Equal){
        state = Normal;
        return [numberFormatterFormal stringFromNumber:number];
    }
    
    // 与えられた値に小数点無し - 桁区切り記号を考慮
    if ([valueString rangeOfString:@"."].location == NSNotFound){
        valueString = [valueString stringByReplacingOccurrencesOfString:@"," withString:@""]; // 桁区切り記号の削除
        valueString = [valueString stringByAppendingFormat:@"%@",number];
        return [numberFormatterFormal stringFromNumber:[numberFormatterNatural numberFromString:valueString]]; // 整形
    }

    // 与えられた値に小数点有り - 追加するだけ
    return [valueString stringByAppendingFormat:@"%@",number]; // 末尾に文字を追加
}

- (NSString *)addDecimalPointToString:(NSString *)valueString{ // 与えられた数値（文字列）に小数点を追加して返す
    // イコール直後 - 何もしない
    if(state == Equal)
        return valueString;

    // .が無い - .を追加
    if ([valueString rangeOfString:@"."].location == NSNotFound){
        return [valueString stringByAppendingString:@"."]; // 末尾に.を追加
    }

    // .が末尾にある - .を削除
    if([valueString hasSuffix:@"."])
        return [valueString substringToIndex:valueString.length - 1]; // 末尾から一文字削除

    // .が途中にある - 何もしない
    return valueString;
}

- (NSString *)addPlusMinusToString:(NSString *)valueString{ // ±ボタンの動作
    if ([valueString hasPrefix:@"-"]) // -がある
        valueString = [valueString substringFromIndex:1]; // 先頭から一文字削除
    else
        valueString = [@"-" stringByAppendingString:valueString]; // 先頭に-を追加

    return valueString;
}

- (NSString *)calculateValueToString:(NSString *)valueString ForType:(enum State)type{ // 演算と
    _currentValue = [numberFormatterFormal numberFromString:valueString]; // 現在の値を取得
    
    [self calculateValue]; // 演算
    state = type;          // 状態を変更

    if (state != Equal){
        _previousValue = _currentValue; // 現在の値を保存
        _currentValue = @0;
    }
    return [numberFormatterFormal stringFromNumber:_currentValue]; // 計算後の値を返す
}

- (void)calculateValue{ // 演算の本体
    // !!!: 桁数制限を超える場合の数値の扱いをどうにかする
    switch (state) { // 状態に応じた演算を行い_currentValueに格納する
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
