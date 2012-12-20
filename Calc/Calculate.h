//
//  Calculate.h
//  Calc
//
//  Created by Takeshi on 2012/11/15.
//  Copyright (c) 2012年 Takeshi Yasunaga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Calculate : NSObject{
    enum State {Normal,Plus,Minus,Multiple,Divide,Equal};
}

@property (nonatomic, readonly) NSNumber* currentValue;
@property (nonatomic, readonly) NSNumber* previousValue;

- (NSString *)clearAll:(NSString *)valueString;

- (NSString *)addNumber:(NSNumber *)number ToString:(NSString *)valueString;
- (NSString *)addDecimalPointToString:(NSString *)valueString;
- (NSString *)addPlusMinusToString:(NSString *)valueString;
- (NSString *)calculateValueToString:(NSString *)valueString ForType:(enum State)type;

@end
