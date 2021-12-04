//
//  KTDecimal.h
//  Airyclub
//
//  Created by KOTU on 2020/1/15.
//  Copyright © 2020 Lebbay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTDecimal.h"

#define KTDecimalWith(value) [[KTDecimal alloc] initWithValue:value]
#define KTDecimalZero        [[KTDecimal alloc] initWithValue:@0]

@class KTDecimal;

NS_ASSUME_NONNULL_BEGIN

typedef KTDecimal * _Nonnull(^KTDecimalValueBlock)(id _Nullable value);

typedef KTDecimal * _Nonnull(^KTDecimalRaisingToPowerBlock)(NSUInteger power);
typedef KTDecimal * _Nonnull(^KTDecimalMultiplyingByPowerOf10Block)(short power);

typedef KTDecimal * _Nonnull(^KTDecimalScaleBlock)(short scale);
typedef KTDecimal * _Nonnull(^KTDecimalRoundBlock)(NSRoundingMode mode);
typedef KTDecimal * _Nonnull(^KTDecimalBehaviorBlock)(id <NSDecimalNumberBehaviors> behavior);

typedef BOOL (^KTDecimalCompareBlock)(id value);

@interface KTDecimal : NSObject

#pragma mark - Init

/// 初始化
/// @param value 初始化的值，如果传入的不是数值会初始化为0，只支持NSString/NSNumber/KTDecimal
- (instancetype)initWithValue:(id _Nullable)value;

/// 初始化
/// @param value 初始化的值，如果传入的不是数值会初始化为0，只支持NSString/NSNumber/KTDecimal
/// @param behavior 计算过程中的行为表示
- (instancetype)initWithValue:(id)value behavior:(id <NSDecimalNumberBehaviors>)behavior;

#pragma mark - Calculate

/// 加法 如果传入的不是数值不做处理
@property (weak, nonatomic, readonly) KTDecimalValueBlock add;
/// 减法 如果传入的不是数值不做处理
@property (weak, nonatomic, readonly) KTDecimalValueBlock subtract;
/// 乘法 如果传入的不是数值不做处理
@property (weak, nonatomic, readonly) KTDecimalValueBlock multiplyingBy;
/// 除法 1. release下除数为0时，会忽略改次计算；debug下除数为0时，会强制崩溃 2. 如果传入的不是数值不做处理
@property (weak, nonatomic, readonly) KTDecimalValueBlock dividingBy;
/// 幂运算
@property (weak, nonatomic, readonly) KTDecimalRaisingToPowerBlock raisingToPower;
/// 乘以10的n次方
@property (weak, nonatomic, readonly) KTDecimalMultiplyingByPowerOf10Block multiplyingByPowerOf10;

#pragma mark - Round

/// 四舍五入  scale表示小数点后的有效位数，mode表示模式(详见官方文档)，不会改变当前的behavior
@property (weak, nonatomic, readonly) KTDecimal * _Nonnull(^round)(short scale, NSRoundingMode mode);
/// 四舍五入  scale表示小数点后的有效位数，mode取currentRoundingMode，不会改变当前的behavior
@property (weak, nonatomic, readonly) KTDecimal * _Nonnull(^roundWithScale)(short scale);
/// 四舍五入  scale取currentScale，mode表示模式(详见官方文档)，不会改变当前的behavior
@property (weak, nonatomic, readonly) KTDecimal * _Nonnull(^roundWithMode)(NSRoundingMode mode);

#pragma mark - Compare

/// 当前值是否等于传入的值
@property (weak, nonatomic, readonly) KTDecimalCompareBlock isEqualTo;
/// 当前值是否大于传入的值
@property (weak, nonatomic, readonly) KTDecimalCompareBlock isGreaterThan;
/// 当前值是否大于等于传入的值
@property (weak, nonatomic, readonly) KTDecimalCompareBlock isGreaterThanOrEqualTo;
/// 当前值是否小于传入的值
@property (weak, nonatomic, readonly) KTDecimalCompareBlock isLessThan;
/// 当前值是否小于等于传入的值
@property (weak, nonatomic, readonly) KTDecimalCompareBlock isLessThanOrEqualTo;

#pragma mark - Config
/// 当前计算过程中使用的模式(含四舍五入，精度，及异常处理)，可以修改
@property (strong, nonatomic, readonly) id <NSDecimalNumberBehaviors> currentBehavior;

/// 修改计算过程中使用四舍五入的模式
@property (weak, nonatomic, readonly) KTDecimalRoundBlock roundingMode;
/// 修改计算过程中保留小数点的有效位数
@property (weak, nonatomic, readonly) KTDecimalScaleBlock scale;
/// 修改计算过程中使用的模式(含四舍五入，精度，及异常处理)
@property (weak, nonatomic, readonly) KTDecimalBehaviorBlock behavior;

#pragma mark - Result

/// 返回计算结果，NSString格式
@property (strong, nonatomic, nullable, readonly) NSString *stringValue;
/// 返回计算结果，NSDecimalNumber格式
@property (strong, nonatomic, nullable, readonly) NSDecimalNumber *number;

#pragma mark - Util

/// 将一个对象转成decimal number，异常时返回nil
/// @param value 被转换的对象，只支持NSString/NSNumber/KTDecimal
+ (NSDecimalNumber * _Nullable)decimalNumberWithValue:(id _Nullable)value;

/// 将一个对象转成decimal number，default number
/// @param value 被转换的对象，只支持NSString/NSNumber/KTDecimal
/// @param defaultNumber 默认的返回值
+ (NSDecimalNumber * _Nullable)decimalNumberWithValue:(id _Nullable)value defaultNumber:(NSDecimalNumber * _Nullable)defaultNumber;

/// 判断一个对象是否是数字类型，非NSString/NSNumber/KTDecimal固定返回NO
/// @param value 对象
+ (BOOL)valueIsAValidNumber:(id)value;

/// 判断是否是一个有效的数字
/// @param number 被检查的对象
+ (BOOL)isNotAValidNumber:(NSNumber * _Nullable)number;

/// 计算过程中默认使用的模式
/// rounding mode: NSRoundPlain
/// scale: No defined scale (full precision)
/// ignore exactnessException (return nil)
/// raise on nothing.
+ (NSDecimalNumberHandler *)defaultDecimalNumberHandler;

@end

NS_ASSUME_NONNULL_END
