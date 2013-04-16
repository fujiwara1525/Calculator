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
    STAssertEqualObjects(value, @"0", @"失敗時に表示されるメッセージ");
    value = [test addNumber:@1 ToString:value];
    STAssertEqualObjects(value, @"1", @"失敗時に表示されるメッセージ");
    value = [test addNumber:@0 ToString:value];
    STAssertEqualObjects(value, @"10", @"失敗時に表示されるメッセージ");
    value = [test addNumber:@0 ToString:value];
    STAssertEqualObjects(value, @"100", @"失敗時に表示されるメッセージ");
    value = [test addNumber:@0 ToString:value];
    STAssertEqualObjects(value, @"1,000", @"失敗時に表示されるメッセージ");
    value = [test addDecimalPointToString:value];
    STAssertEqualObjects(value, @"1,000.", @"失敗時に表示されるメッセージ");
    value = [test addNumber:@1 ToString:value];
    STAssertEqualObjects(value, @"1,000.1", @"失敗時に表示されるメッセージ");
    value = [test addNumber:@1 ToString:value];
    STAssertEqualObjects(value, @"1,000.11", @"失敗時に表示されるメッセージ");
    value = [test addNumber:@1 ToString:value];
    STAssertEqualObjects(value, @"1,000.111", @"失敗時に表示されるメッセージ");
    value = [test addNumber:@1 ToString:value];
    STAssertEqualObjects(value, @"1,000.1111", @"失敗時に表示されるメッセージ");
    
    value = [test clearAll];
    value = [test addNumber:@0 ToString:value];
    STAssertEqualObjects(value, @"0", @"失敗時に表示されるメッセージ");
    value = [test addDecimalPointToString:value];
    STAssertEqualObjects(value, @"0.", @"失敗時に表示されるメッセージ");
    value = [test addDecimalPointToString:value];
    STAssertEqualObjects(value, @"0.", @"失敗時に表示されるメッセージ");
    value = [test addNumber:@0 ToString:value];
    STAssertEqualObjects(value, @"0.0", @"失敗時に表示されるメッセージ");
    value = [test addNumber:@1 ToString:value];
    STAssertEqualObjects(value, @"0.01", @"失敗時に表示されるメッセージ");
    
}
- (void)testCalculatePlus{
    NSString* value = @"0";
    value = @"999";
    value = [test calculateValueToString:value ForType:Plus];
    value = @"1";
    value = [test calculateValueToString:value ForType:Equal];
    STAssertEqualObjects(value, @"1,000", @"失敗時に表示されるメッセージ");
    }

- (void)testCalculateMinus{
    NSString* value = @"0";
    value = @"1";
    value = [test calculateValueToString:value ForType:Minus];
    value = @"0.01";
    value = [test calculateValueToString:value ForType:Equal];
    STAssertEqualObjects(value, @"0.99", @"失敗時に表示されるメッセージ");
}

- (void)testCalculateMultiple{
    NSString* value = @"0";
    value = @"1.5";
    value = [test calculateValueToString:value ForType:Multiple];
    value = @"1.5";
    value = [test calculateValueToString:value ForType:Equal];
    STAssertEqualObjects(value, @"2.25", @"失敗時に表示されるメッセージ");
}

- (void)testCalculateDivide{
    NSString* value = @"0";
    value = @"5";
    value = [test calculateValueToString:value ForType:Divide];
    value = @"3";
    value = [test calculateValueToString:value ForType:Equal];
    STAssertEqualObjects(value, @"1.66666666666667", @"失敗時に表示されるメッセージ");
    
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
    STAssertEqualObjects(value, @"0", @"失敗時に表示されるメッセージ");
    value = [test addDecimalPointToString:value];
    STAssertEqualObjects(value, @"0.", @"失敗時に表示されるメッセージ");
    value = [test addDecimalPointToString:value];
    STAssertEqualObjects(value, @"0.", @"失敗時に表示されるメッセージ");
    value = [test addNumber:@1 ToString:value];
    STAssertEqualObjects(value, @"0.1", @"失敗時に表示されるメッセージ");
}

- (void)testAddPlusMinus{
    NSString* value = @"-1";
    value = [test addPlusMinusToString:value];
    STAssertEqualObjects(value, @"1", @"失敗時に表示されるメッセージ");
    value = [test addPlusMinusToString:value];
    STAssertEqualObjects(value, @"-1", @"失敗時に表示されるメッセージ");
}

@end