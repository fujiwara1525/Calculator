//
//  CalcTests.m
//  CalcTests
//
//  Created by Takeshi on 12/10/20.
//  Copyright (c) 2012年 Takeshi Yasunaga. All rights reserved.
//

#import "CalcTests.h"
#import "../Calc/Calculate.m"
#import "Calculate.h"
@implementation CalcTests{
    Calculate *test;
}

- (void)setUp{
    [super setUp];
    test = [[Calculate alloc] init];
}

- (void)tearDown{
    [super tearDown];
}

- (void)testAddNumber{
    //STFail(@"失敗時に表示されるメッセージ");
    NSString* value = @"0";
    value = [test addNumber:@0 ToString:value];
    STAssertEqualObjects(value, @"0", @"Correct value has not been assigned.");
    value = [test addNumber:@1 ToString:value];
    STAssertEqualObjects(value, @"1", @"Correct value has not been assigned.");
    value = [test addNumber:@0 ToString:value];
    STAssertEqualObjects(value, @"10", @"Correct value has not been assigned.");
    value = [test addNumber:@0 ToString:value];
    STAssertEqualObjects(value, @"100", @"Correct value has not been assigned.");
    value = [test addNumber:@0 ToString:value];
    STAssertEqualObjects(value, @"1,000", @"It is not already in the thousands separator.");
    value = [test addDecimalPointToString:value];
    STAssertEqualObjects(value, @"1,000.", @"Dot does not exist.");
    value = [test addNumber:@1 ToString:value];
    STAssertEqualObjects(value, @"1,000.1", @"Correct value has not been assigned.");
    value = [test addNumber:@1 ToString:value];
    STAssertEqualObjects(value, @"1,000.11", @"Correct value has not been assigned.");
    value = [test addNumber:@1 ToString:value];
    STAssertEqualObjects(value, @"1,000.111", @"Correct value has not been assigned.");
    value = [test addNumber:@1 ToString:value];
    STAssertEqualObjects(value, @"1,000.1111", @"Two dots exist.");
    
    value = [test clearAll];
    value = [test addNumber:@0 ToString:value];
    STAssertEqualObjects(value, @"0", @"Correct value has not been assigned.");
    value = [test addDecimalPointToString:value];
    STAssertEqualObjects(value, @"0.", @"Dot does not exist.");
    value = [test addNumber:@0 ToString:value];
    STAssertEqualObjects(value, @"0.0", @"Correct value has not been assigned.");
    value = [test addNumber:@1 ToString:value];
    STAssertEqualObjects(value, @"0.01", @"Correct value has not been assigned.");
    
    value = [test clearAll];
    value = [test addNumber:@2 ToString:value];
    STAssertEqualObjects(value, @"2", @"Correct value has not been assigned.");
    
    value = [test clearAll];
    value = [test addNumber:@3 ToString:value];
    STAssertEqualObjects(value, @"3", @"Correct value has not been assigned.");
    
    value = [test clearAll];
    value = [test addNumber:@4 ToString:value];
    STAssertEqualObjects(value, @"4", @"Correct value has not been assigned.");
    
    value = [test clearAll];
    value = [test addNumber:@5 ToString:value];
    STAssertEqualObjects(value, @"5", @"Correct value has not been assigned.");
    
    value = [test clearAll];
    value = [test addNumber:@6 ToString:value];
    STAssertEqualObjects(value, @"6", @"Correct value has not been assigned.");
    
    value = [test clearAll];
    value = [test addNumber:@7 ToString:value];
    STAssertEqualObjects(value, @"7", @"Correct value has not been assigned.");
    
    value = [test clearAll];
    value = [test addNumber:@8 ToString:value];
    STAssertEqualObjects(value, @"8", @"Correct value has not been assigned.");
    
    value = [test clearAll];
    value = [test addNumber:@9 ToString:value];
    STAssertEqualObjects(value, @"9", @"Correct value has not been assigned.");
    
}
- (void)testCalculatePlus{
    NSString* value = @"0";
    value = @"999";
    value = [test calculateValueToString:value ForType:Plus];
    value = @"1";
    value = [test calculateValueToString:value ForType:Equal];
    STAssertEqualObjects(value, @"1,000", @"Not been able to addition.");
    }

- (void)testCalculateMinus{
    NSString* value = @"0";
    value = @"1";
    value = [test calculateValueToString:value ForType:Minus];
    value = @"0.01";
    value = [test calculateValueToString:value ForType:Equal];
    STAssertEqualObjects(value, @"0.99", @"Not been able to subtract.");
}

- (void)testCalculateMultiple{
    NSString* value = @"0";
    value = @"1.5";
    value = [test calculateValueToString:value ForType:Multiple];
    value = @"1.5";
    value = [test calculateValueToString:value ForType:Equal];
    STAssertEqualObjects(value, @"2.25", @"Position of the dot is wrong.");
    
    value = [test clearAll];
    value = @"2";
    value = [test calculateValueToString:value ForType:Multiple];
    value = @"3";
    value = [test calculateValueToString:value ForType:Equal];
    STAssertEqualObjects(value, @"6", @"Not been able to multply.");
}

- (void)testCalculateDivide{
    //最大桁数が丸められる
    NSString* value = @"0";
    value = @"5";
    value = [test calculateValueToString:value ForType:Divide];
    value = @"3";
    value = [test calculateValueToString:value ForType:Equal];
    STAssertEqualObjects(value, @"1.66666666666667", @"Maximum number of digits is not rounded.");
    
    //0と表示されるはずが実際には+∞と表示されている．エラーはでていない．
    //Error表示させる
    value = [test clearAll];
    value = @"2";
    value = [test calculateValueToString:value ForType:Divide];
    value = @"0";
    value = [test calculateValueToString:value ForType:Equal];
    STAssertEqualObjects(value, @"エラー", @"Value exists.");
    
    //"0","÷"が機能していない．2から始まることになっているためにエラー
    //0÷2=0となるように
    value = [test clearAll];
    value = @"0";
    value = [test calculateValueToString:value ForType:Divide];
    value = @"2";
    value = [test calculateValueToString:value ForType:Equal];
    STAssertEqualObjects(value, @"0", @"Value other than 0 is displayed.");
    
    //NSNumberはdouble型を含む？最大桁数目を四捨五入する
    /*value = [test clearAll];
    value = @"5";
    value = [test calculateValueToString:value ForType:Divide];
    value = @"3";
    value = [test calculateValueToString:value ForType:Equal];
    STAssertEqualObjects(value, @"1.66666666666666", @"失敗時に表示されるメッセージ");*/
}

- (void)testAddDecimalPoint{
    NSString* value = @"0";
    value = [test addNumber:@0 ToString:value];
    STAssertEqualObjects(value, @"0", @"Correct value has not been assigned.");
    value = [test addDecimalPointToString:value];
    STAssertEqualObjects(value, @"0.", @"Dot does not exist.");
    value = [test addDecimalPointToString:value];
    STAssertEqualObjects(value, @"0.", @"Two dots exist.");
    value = [test addNumber:@1 ToString:value];
    STAssertEqualObjects(value, @"0.1", @"Correct value has not been assigned.");
}

- (void)testAddPlusMinus{
    NSString* value = @"-1";
    value = [test addPlusMinusToString:value];
    STAssertEqualObjects(value, @"1", @"Plus or minus is not inverted.");
    value = [test addPlusMinusToString:value];
    STAssertEqualObjects(value, @"-1", @"Plus or minus is not inverted.");
}

@end