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

- (void)testCalculatePlus{
    NSString* value = @"0";

    // 200 + 200 = 400
    value = [test addNumber:@2 ToString:value];
    value = [test addNumber:@0 ToString:value];
    value = [test addNumber:@0 ToString:value];
    value = [test calculateValueToString:value ForType:Plus];
    value = [test addNumber:@2 ToString:value];
    value = [test addNumber:@0 ToString:value];
    value = [test addNumber:@0 ToString:value];
    value = [test calculateValueToString:value ForType:Equal];
    DNSLog(@"%@",value);
    STAssertEqualObjects(value, @"400", @"Plus Failed");
}

- (void)testCalculateMinus{
    NSString* value = @"0";

    // 200 - 100 = 100
    value = [test addNumber:@2 ToString:value];
    value = [test addNumber:@0 ToString:value];
    value = [test addNumber:@0 ToString:value];
    value = [test calculateValueToString:value ForType:Minus];
    value = [test addNumber:@1 ToString:value];
    value = [test addNumber:@0 ToString:value];
    value = [test addNumber:@0 ToString:value];
    value = [test calculateValueToString:value ForType:Equal];
    DNSLog(@"%@",value);
    STAssertEqualObjects(value, @"100", @"Minus Failed.");
}

- (void)testCalculateMultiple{
    NSString* value = @"0";

    // 200 * 100 = 20000
    value = [test addNumber:@2 ToString:value];
    value = [test addNumber:@0 ToString:value];
    value = [test addNumber:@0 ToString:value];
    value = [test calculateValueToString:value ForType:Multiple];
    value = [test addNumber:@1 ToString:value];
    value = [test addNumber:@0 ToString:value];
    value = [test addNumber:@0 ToString:value];
    value = [test calculateValueToString:value ForType:Equal];
    DNSLog(@"%@",value);
    STAssertEqualObjects(value, @"20,000", @"Multiple Failed.");
}

- (void)testCalculateDivide{
    NSString* value = @"0";

    // 200/100 = 2
    value = [test addNumber:@2 ToString:value];
    value = [test addNumber:@0 ToString:value];
    value = [test addNumber:@0 ToString:value];
    value = [test calculateValueToString:value ForType:Divide];
    value = [test addNumber:@1 ToString:value];
    value =  [test addNumber:@0 ToString:value];
    value = [test addNumber:@0 ToString:value];
    value = [test calculateValueToString:value ForType:Equal];
    DNSLog(@"%@",value);
    STAssertEqualObjects(value, @"2", @"Divide Failed.");

    // 200/3 = 66.6666...
    value = [test addNumber:@2 ToString:value];
    value = [test addNumber:@0 ToString:value];
    value = [test addNumber:@0 ToString:value];
    value = [test calculateValueToString:value ForType:Divide];
    value = [test addNumber:@3 ToString:value];
    value = [test calculateValueToString:value ForType:Equal];
    DNSLog(@"%@",value);

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
    DNSLog(@"%@",value);
    STAssertEqualObjects(value, @"2.5", @"Add Dot Failed.");
    
    // 2.5.
    value = [test addDecimalPointToString:value];
    DNSLog(@"%@",value);
    STAssertEqualObjects(value, @"2.5", @"Add Dot Failed.");

    // 二回押す
    value = @"25";
    value = [test addDecimalPointToString:value];
    value = [test addDecimalPointToString:value];
    DNSLog(@"%@",value);
    STAssertEqualObjects(value, @"25", @"Add Dot Failed.");

    //2,500.5
    value = [test clearAll:value];
    value = [test addNumber:@2 ToString:value];
    value = [test addNumber:@5 ToString:value];
    value = [test addNumber:@0 ToString:value];
    value = [test addNumber:@0 ToString:value];
    value = [test addDecimalPointToString:value];
    value = [test addNumber:@5 ToString:value];
    DNSLog(@"%@",value);
    STAssertEqualObjects(value, @"2,500.5", @"Add Dot Failed.");

}

- (void)testAddPlusMinus{
    NSString* value = @"0";

    // 0 → -0
    value = [test addPlusMinusToString:value];
    DNSLog(@"%@",value);
    STAssertEqualObjects(value, @"-0", @"Add Plus Minus Failed.");
    // -0 → 0
    value = [test addPlusMinusToString:value];
    DNSLog(@"%@",value);
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