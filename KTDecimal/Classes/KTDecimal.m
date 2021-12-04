//
//  KTDecimal.m
//  Airyclub
//
//  Created by KOTU on 2020/1/15.
//  Copyright © 2020 Lebbay. All rights reserved.
//

#import "KTDecimal.h"

@interface KTDecimal ()

@property (strong, nonatomic) NSDecimalNumber *number;
@property (strong, nonatomic) id <NSDecimalNumberBehaviors> currentBehavior;

@end

@implementation KTDecimal

#pragma mark - Init
- (instancetype)initWithValue:(id)value
{
    return [self initWithValue:value behavior:[KTDecimal defaultDecimalNumberHandler]];
}

- (instancetype)initWithValue:(id)value behavior:(id <NSDecimalNumberBehaviors>)behavior
{
#if DEBUG
    NSAssert(behavior, @"KTDecimal: don't have a behavior");
#endif
    
    NSDecimalNumber *number = [KTDecimal decimalNumberWithValue:value];
    if (![KTDecimal valueIsAValidNumber:number]) {
#if DEBUG
        NSAssert(NO, @"KTDecimal: value is not a valid number");
#endif
        return KTDecimalZero;
    }
    
	if (self = [super init]) {
		self.currentBehavior = behavior;
		self.number = number;
	 }
	 return self;
}

#pragma mark - Calculate
- (KTDecimalValueBlock)add
{
    KTDecimalValueBlock block = ^KTDecimal *(id value) {
        if (![KTDecimal valueIsAValidNumber:value]) {
#if DEBUG
            NSAssert(NO, @"KTDecimal: value to add is not a valid number");
#endif
            return self;
        }
       
		KTDecimal *decimal = nil;
		NSDecimalNumber *number = [KTDecimal decimalNumberWithValue:value];
		NSDecimalNumber *rs = [self.number decimalNumberByAdding:number withBehavior:self.currentBehavior];
		decimal = [[KTDecimal alloc] initWithValue:rs behavior:self.currentBehavior];
	
        return decimal;
    };
    return block;
}

- (KTDecimalValueBlock)subtract
{
    KTDecimalValueBlock block = ^KTDecimal *(id value) {
        if (![KTDecimal valueIsAValidNumber:value]) {
#if DEBUG
            NSAssert(NO, @"KTDecimal: value to subtract is not a valid number");
#endif
            return self;
        }
		
		KTDecimal *decimal = nil;
		NSDecimalNumber *number = [KTDecimal decimalNumberWithValue:value];
		NSDecimalNumber *rs = [self.number decimalNumberBySubtracting:number withBehavior:self.currentBehavior];
		decimal = [[KTDecimal alloc] initWithValue:rs behavior:self.currentBehavior];

        return decimal;
    };
    return block;
}

- (KTDecimalValueBlock)multiplyingBy
{
    KTDecimalValueBlock block = ^KTDecimal *(id value) {
        if (![KTDecimal valueIsAValidNumber:value]) {
#if DEBUG
            NSAssert(NO, @"KTDecimal: value to multiplyingBy is not a valid number");
#endif
            return self;
        }

		KTDecimal *decimal = nil;
		NSDecimalNumber *number = [KTDecimal decimalNumberWithValue:value];
		NSDecimalNumber *rs = [self.number decimalNumberByMultiplyingBy:number withBehavior:self.currentBehavior];
		decimal = [[KTDecimal alloc] initWithValue:rs behavior:self.currentBehavior];

        return decimal;
    };
    return block;
}

- (KTDecimalValueBlock)dividingBy
{
    KTDecimalValueBlock block = ^KTDecimal *(id value) {
        if (![KTDecimal valueIsAValidNumber:value]) {
#if DEBUG
            NSAssert(NO, @"KTDecimal: value to dividingBy is not a valid number");
#endif
            return self;
        }
        
        NSDecimalNumber *number = [KTDecimal decimalNumberWithValue:value];
        if ([number isEqualToNumber:[NSDecimalNumber zero]]) {
#if DEBUG
            NSAssert(NO, @"KTDecimal: dividing by value cannot be zero");
#endif
        }
		
		KTDecimal *decimal = nil;
		NSDecimalNumber *rs = [self.number decimalNumberByDividingBy:number withBehavior:self.currentBehavior];
		decimal = [[KTDecimal alloc] initWithValue:rs behavior:self.currentBehavior];

        return decimal;
    };
    return block;
}

- (KTDecimalRaisingToPowerBlock)raisingToPower
{
    KTDecimalRaisingToPowerBlock block = ^KTDecimal *(NSUInteger power) {
        NSDecimalNumber *rs = [self.number decimalNumberByRaisingToPower:power withBehavior:self.currentBehavior];
		KTDecimal *decimal = [[KTDecimal alloc] initWithValue:rs behavior:self.currentBehavior];
        return decimal;
	};
    return block;
}

- (KTDecimalMultiplyingByPowerOf10Block)multiplyingByPowerOf10
{
    KTDecimalMultiplyingByPowerOf10Block block = ^KTDecimal *(short power) {
        NSDecimalNumber *rs = [self.number decimalNumberByMultiplyingByPowerOf10:power withBehavior:self.currentBehavior];
		KTDecimal *decimal = [[KTDecimal alloc] initWithValue:rs behavior:self.currentBehavior];
        return decimal;
    };
    return block;
}

#pragma mark - Round
- (KTDecimal * _Nonnull (^)(short, NSRoundingMode))round
{
    return ^KTDecimal *(short scale, NSRoundingMode mode){
        NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:mode
                                                                                                 scale:scale
                                                                                      raiseOnExactness:NO
                                                                                       raiseOnOverflow:NO
                                                                                      raiseOnUnderflow:NO
                                                                                   raiseOnDivideByZero:NO];
		NSDecimalNumber *rs = [self.number decimalNumberByRoundingAccordingToBehavior:handler];
		KTDecimal *decimal = [[KTDecimal alloc] initWithValue:rs behavior:self.currentBehavior];
		return decimal;
    };
}

- (KTDecimal * _Nonnull (^)(NSRoundingMode))roundWithMode
{
    return ^KTDecimal *(NSRoundingMode mode){
        NSDecimalNumberHandler *handler = [NSDecimalNumberHandler
										   decimalNumberHandlerWithRoundingMode:mode
										   scale:self.currentBehavior.scale
										   raiseOnExactness:NO
										   raiseOnOverflow:NO
										   raiseOnUnderflow:NO
										   raiseOnDivideByZero:NO];
		NSDecimalNumber *rs = [self.number decimalNumberByRoundingAccordingToBehavior:handler];
		KTDecimal *decimal = [[KTDecimal alloc] initWithValue:rs behavior:self.currentBehavior];
		return decimal;
    };
}

- (KTDecimal * _Nonnull (^)(short))roundWithScale
{
    return ^KTDecimal *(short scale){
		NSDecimalNumberHandler *handler = [NSDecimalNumberHandler
										   decimalNumberHandlerWithRoundingMode:self.currentBehavior.roundingMode
										   scale:scale
										   raiseOnExactness:NO
										   raiseOnOverflow:NO
										   raiseOnUnderflow:NO
										   raiseOnDivideByZero:NO];
		NSDecimalNumber *rs = [self.number decimalNumberByRoundingAccordingToBehavior:handler];
		KTDecimal *decimal = [[KTDecimal alloc] initWithValue:rs behavior:self.currentBehavior];
		return decimal;
    };
}

#pragma mark - Compare
- (KTDecimalCompareBlock)isEqualTo
{
    KTDecimalCompareBlock block = ^BOOL (id value) {
        if (![KTDecimal valueIsAValidNumber:value]) {
#if DEBUG
            NSAssert(NO, @"KTDecimal: value to isEqualTo is not a valid number");
#endif
            return NO;
        }
        NSDecimalNumber *number = [KTDecimal decimalNumberWithValue:value];
        BOOL isEqual = [self.number compare:number] == NSOrderedSame;
        return isEqual;
    };
    return block;
}

- (KTDecimalCompareBlock)isGreaterThan
{
    KTDecimalCompareBlock block = ^BOOL (id value) {
        if (![KTDecimal valueIsAValidNumber:value]) {
#if DEBUG
            NSAssert(NO, @"KTDecimal: value to isGreaterThan is not a valid number");
#endif
            return YES;
        }
        
        NSDecimalNumber *number = [KTDecimal decimalNumberWithValue:value];
        BOOL isEqual = [self.number compare:number] == NSOrderedDescending;
        return isEqual;
    };
    return block;
}

- (KTDecimalCompareBlock)isGreaterThanOrEqualTo
{
    KTDecimalCompareBlock block = ^BOOL (id value) {
        if (![KTDecimal valueIsAValidNumber:value]) {
#if DEBUG
            NSAssert(NO, @"KTDecimal: value to isGreaterThanOrEqualTo is not a valid number");
#endif
            return YES;
        }
        
        NSDecimalNumber *number = [KTDecimal decimalNumberWithValue:value];
        BOOL isEqual = [self.number compare:number] != NSOrderedAscending;
        return isEqual;
    };
    return block;
}

- (KTDecimalCompareBlock)isLessThan
{
    KTDecimalCompareBlock block = ^BOOL (id value) {
        if (![KTDecimal valueIsAValidNumber:value]) {
#if DEBUG
            NSAssert(NO, @"KTDecimal: value to isLessThan is not a valid number");
#endif
            return NO;
        }
        
        NSDecimalNumber *number = [KTDecimal decimalNumberWithValue:value];
        BOOL isEqual = [self.number compare:number] == NSOrderedAscending;
        return isEqual;
    };
    return block;
}

- (KTDecimalCompareBlock)isLessThanOrEqualTo
{
    KTDecimalCompareBlock block = ^BOOL (id value) {
        if (![KTDecimal valueIsAValidNumber:value]) {
#if DEBUG
            NSAssert(NO, @"KTDecimal: value to isLessThanOrEqualTo is not a valid number");
#endif
            return NO;
        }
        
        NSDecimalNumber *number = [KTDecimal decimalNumberWithValue:value];
        BOOL isEqual = [self.number compare:number] != NSOrderedDescending;
        return isEqual;
    };
    return block;
}

#pragma mark - Config
- (KTDecimalRoundBlock)roundingMode
{
    KTDecimalRoundBlock block = ^KTDecimal * (NSRoundingMode mode) {
		NSDecimalNumberHandler *handler = [NSDecimalNumberHandler
										   decimalNumberHandlerWithRoundingMode:mode
										   scale:self.currentBehavior.scale
										   raiseOnExactness:NO
										   raiseOnOverflow:NO
										   raiseOnUnderflow:NO
										   raiseOnDivideByZero:NO];
		KTDecimal *decimal = [[KTDecimal alloc] initWithValue:self.number behavior:handler];
		return decimal;
    };
    return block;
}

- (KTDecimalScaleBlock)scale
{
	KTDecimalScaleBlock block = ^KTDecimal * (short scale) {
		NSDecimalNumberHandler *handler = [NSDecimalNumberHandler
										   decimalNumberHandlerWithRoundingMode:self.currentBehavior.roundingMode
										   scale:scale
										   raiseOnExactness:NO
										   raiseOnOverflow:NO
										   raiseOnUnderflow:NO
										   raiseOnDivideByZero:NO];
		KTDecimal *decimal = [[KTDecimal alloc] initWithValue:self.number behavior:handler];
		return decimal;
    };
    return block;
}

- (KTDecimalBehaviorBlock)behavior
{
	KTDecimalBehaviorBlock block = ^KTDecimal * (id <NSDecimalNumberBehaviors> behavior) {
		KTDecimal *decimal = [[KTDecimal alloc] initWithValue:self.number behavior:behavior];
		return decimal;
    };
    return block;
}

#pragma mark - Result
- (NSString *)stringValue
{
	return [self.number stringValue];
}

#pragma mark - Description
- (NSString *)description
{
	return self.stringValue;
}

#pragma mark - copy
- (instancetype)copyWithZone:(NSZone *)zone
{
	KTDecimal *util = [[KTDecimal alloc] initWithValue:self.number behavior:self.currentBehavior];
	return util;
}

#pragma mark - Util
+ (NSDecimalNumber *)decimalNumberWithValue:(id)value
{
    if (![self valueIsAValidNumber:value]) {
        return nil;
    }
    return [self decimalNumberWithValue:value defaultNumber:[NSDecimalNumber zero]];
}

+ (NSDecimalNumber *)decimalNumberWithValue:(id)value defaultNumber:(NSDecimalNumber *)defaultNumber
{
    if (![defaultNumber isKindOfClass:[NSDecimalNumber class]]) {
        defaultNumber = nil;
    }
    
    NSDecimalNumber *number;
    if ([value isKindOfClass:[NSString class]]) {
        number = [[NSDecimalNumber alloc] initWithString:(NSString *)value];
        if ([self isNotAValidNumber:number]) {
#if DEBUG
            NSAssert(NO, @"KTDecimal: value not a valid string");
#endif
            number = defaultNumber;
        }
    } else if ([value isKindOfClass:[NSNumber class]]) {
        if ([self isNotAValidNumber:(NSNumber *)value]) {
#if DEBUG
            NSAssert(NO, @"KTDecimal: value not a valid number");
#endif
            number = defaultNumber;
        } else {
            if ([value isKindOfClass:[NSDecimalNumber class]]) {
                number = (NSDecimalNumber *)value;
            } else {
                NSNumber *valutToNumber = (NSNumber *)value;
                number = [[NSDecimalNumber alloc] initWithDecimal:valutToNumber.decimalValue];
            }
        }
    } else if ([value isKindOfClass:[KTDecimal class]]) {
        number = [(KTDecimal *)value number];
    } else {
#if DEBUG
        NSAssert(NO, @"KTDecimal: value type cannot be recognized");
#endif
        number = defaultNumber;
    }
    
    return number;
}

+ (BOOL)valueIsAValidNumber:(id)value
{
    if (!value) {
        return NO;
    }
    
    BOOL isANumber = NO;

    if ([value isKindOfClass:[NSString class]]) {
        NSDecimalNumber *number = [[NSDecimalNumber alloc] initWithString:(NSString *)value];
        if ([self isNotAValidNumber:number]) {
            isANumber = NO;
        } else {
            isANumber = YES;
        }
    } else if ([value isKindOfClass:[NSNumber class]]) {
        if ([self isNotAValidNumber:(NSNumber *)value]) {
            isANumber = NO;
        } else {
            isANumber = YES;
        }
    } else if ([value isKindOfClass:[KTDecimal class]]) {
        isANumber = YES;
    } else {
        isANumber = NO;
    }
    
    return isANumber;
}

+ (BOOL)isNotAValidNumber:(NSNumber *)number
{
    if (![number isKindOfClass:[NSNumber class]]) {
        return NO;
    }
    
    NSDecimal decimal = number.decimalValue;
    return NSDecimalIsNotANumber(&decimal);
}

+ (NSDecimalNumberHandler *)defaultDecimalNumberHandler
{
    NSDecimalNumberHandler *defaultDecimalNumberHandler = [NSDecimalNumberHandler defaultDecimalNumberHandler];
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:defaultDecimalNumberHandler.roundingMode
                                       scale:defaultDecimalNumberHandler.scale
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:NO];
    return handler;
}

@end
