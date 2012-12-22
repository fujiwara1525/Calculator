//
//  CalcTests.m
//  CalcTests
//
//  Created by Takeshi on 12/10/20.
//  Copyright (c) 2012年 Takeshi Yasunaga. All rights reserved.
//

#import "CalcTests.h"
#import "../Calc/Calculate.m"
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
    NSString* value = @"0";

    value = [test addNumber:@0 ToString:value];
    STAssertEqualObjects(value, @"0", @"Add Number Failed");
    value = [test addNumber:@1 ToString:value];
    STAssertEqualObjects(value, @"1", @"Add Number Failed");
    value = [test addNumber:@0 ToString:value];
    STAssertEqualObjects(value, @"10", @"Add Number Failed");
    value = [test addNumber:@0 ToString:value];
    STAssertEqualObjects(value, @"100", @"Add Number Failed");
    value = [test addNumber:@0 ToString:value];
    STAssertEqualObjects(value, @"1,000", @"Add Number Failed");

    // 末尾に.ありの場合
    value = [test addDecimalPointToString:value];
    value = [test addNumber:@5 ToString:value];
    STAssertEqualObjects(value, @"1,000.5", @"Add Dot Failed.");

    // 0.5
    value = [test clearAll];
    value = [test addNumber:@0 ToString:value];
    value = [test addDecimalPointToString:value];
    value = [test addNumber:@5 ToString:value];
    STAssertEqualObjects(value, @"0.5", @"Add Dot Failed.");

    // 0.05
    value = [test clearAll];
    value = [test addNumber:@0 ToString:value];
    value = [test addDecimalPointToString:value];
    value = [test addNumber:@0 ToString:value];
    value = [test addNumber:@5 ToString:value];
    STAssertEqualObjects(value, @"0.05", @"Add Dot Failed.");
}

- (void)testCalculatePlus{
    NSString* value = @"0";

    // 200 + 200 = 400
    test.currentValue = @200;
    value = [test calculateValueToString:value ForType:Plus];
    test.currentValue = @200;
    value = [test calculateValueToString:value ForType:Equal];
    STAssertEqualObjects(value, @"400", @"Plus Failed");
}

- (void)testCalculateMinus{
    NSString* value = @"0";

    // 200 - 100 = 100
    test.currentValue = @200;
    value = [test calculateValueToString:value ForType:Minus];
    test.currentValue = @100;
    value = [test calculateValueToString:value ForType:Equal];
    STAssertEqualObjects(value, @"100", @"Minus Failed.");
}

- (void)testCalculateMultiple{
    NSString* value = @"0";

    // 200 * 100 = 20000
    test.currentValue = @200;
    value = [test calculateValueToString:value ForType:Multiple];
    test.currentValue = @100;
    value = [test calculateValueToString:value ForType:Equal];
    STAssertEqualObjects(value, @"20,000", @"Multiple Failed.");
}

- (void)testCalculateDivide{
    NSString* value = @"0";

    // 200/100 = 2
    test.currentValue = @200;
    value = [test calculateValueToString:value ForType:Divide];
    test.currentValue = @100;
    value = [test calculateValueToString:value ForType:Equal];
    STAssertEqualObjects(value, @"2", @"Divide Failed.");

    // 200/3 = 66.6666...
    test.currentValue = @200;
    value = [test calculateValueToString:value ForType:Divide];
    test.currentValue = @3;
    value = [test calculateValueToString:value ForType:Equal];

    NSString *testString = @"66.";
    for (int i = 0; i < MAX_DIGIT - 3; i++)
        testString = [testString stringByAppendingString:@"6"];
    testString = [testString stringByAppendingString:@"7"];
    
    STAssertEqualObjects(value, testString, @"Divide Failed.");
}

- (void)testAddDecimalPoint{
    NSString* value = @"0";

    // 2.5
    value = [test addNumber:@2 ToString:value];
    value = [test addDecimalPointToString:value];
    value = [test addNumber:@5 ToString:value];
    STAssertEqualObjects(value, @"2.5", @"Add Dot Failed.");
    
    // 2.5.
    value = [test addDecimalPointToString:value];
    STAssertEqualObjects(value, @"2.5", @"Add Dot Failed.");

    // 二回押す
    value = @"25";
    value = [test addDecimalPointToString:value];
    value = [test addDecimalPointToString:value];
    STAssertEqualObjects(value, @"25", @"Add Dot Failed.");
}

- (void)testAddPlusMinus{
    NSString* value = @"0";

    // 0 → -0
    value = [test addPlusMinusToString:value];
    STAssertEqualObjects(value, @"-0", @"Add Plus Minus Failed.");
    // -0 → 0
    value = [test addPlusMinusToString:value];
    STAssertEqualObjects(value, @"0", @"Add Plus Minus Failed.");

    value = @"0";
    // 1,000 → -1,000
    value = [test addNumber:@1 ToString:value];
    value = [test addNumber:@0 ToString:value];
    value = [test addNumber:@0 ToString:value];
    value = [test addNumber:@0 ToString:value];
    value = [test addPlusMinusToString:value];
    STAssertEqualObjects(value, @"-1,000", @"Add Plus Minus Failed.");

    // -1,000 → 1,000
    value = [test addPlusMinusToString:value];
    STAssertEqualObjects(value, @"1,000", @"Add Plus Minus Failed.");
}

@end