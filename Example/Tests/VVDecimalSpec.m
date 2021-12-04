//
//  KTDecimalSpecSpec.m
//  VOVA
//
//  Created by KOTU on 2020/2/7.
//  Copyright 2020 iOS. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <KTDecimal/KTDecimal.h>

SPEC_BEGIN(KTDecimalSpec)
 
describe(@"KTDecimalSpec", ^{
		 
	it(@"test init with correct string & result", ^{
		{
			NSString *value = @"1.6";
			KTDecimal *decimal = [[KTDecimal alloc] initWithValue:value];
			NSString *resultString = decimal.stringValue;
			NSNumber *resultNumber = decimal.number;
			[[resultString should] equal:@"1.6"];
			[[resultNumber should] equal:@1.6];
		}
	
		{
			NSString *value = @"1.233";
			KTDecimal *decimal = [[KTDecimal alloc] initWithValue:value];
			NSString *resultString = decimal.stringValue;
			NSNumber *resultNumber = decimal.number;
			[[resultString should] equal:@"1.233"];
			[[resultNumber should] equal:[NSDecimalNumber decimalNumberWithString:@"1.233"]];
		}
	});
		 
	it(@"test init with correct number & result", ^{
		{
			NSNumber *value = @1.6;
			KTDecimal *decimal = [[KTDecimal alloc] initWithValue:value];
			NSString *resultString = decimal.stringValue;
			NSNumber *resultNumber = decimal.number;
			
			[[resultString should] equal:@"1.6"];
			[[resultNumber should] equal:@1.6];
		}
	
		{
			NSNumber *value = @1.233;
			KTDecimal *decimal = [[KTDecimal alloc] initWithValue:value];
			NSString *resultString = decimal.stringValue;
			NSNumber *resultNumber = decimal.number;
			
			[[resultString should] equal:@"1.233"];
			[[resultNumber should] equal:[NSDecimalNumber decimalNumberWithString:@"1.233"]];
		}
	});
		 
	it(@"test init with decimal decimal & result", ^{
		{
			NSNumber *value = @1.6;
			KTDecimal *tempdecimal = [[KTDecimal alloc] initWithValue:value];
			KTDecimal *decimal = [[KTDecimal alloc] initWithValue:tempdecimal];
			NSString *resultString = decimal.stringValue;
			NSNumber *resultNumber = decimal.number;
			
			[[resultString should] equal:@"1.6"];
			[[resultNumber should] equal:@1.6];
		}
	
		{
			NSNumber *value = @1.233;
			KTDecimal *tempdecimal = [[KTDecimal alloc] initWithValue:value];
			KTDecimal *decimal = [[KTDecimal alloc] initWithValue:tempdecimal];
			NSString *resultString = decimal.stringValue;
			NSNumber *resultNumber = decimal.number;
			
			[[resultString should] equal:@"1.233"];
			[[resultNumber should] equal:[NSDecimalNumber decimalNumberWithString:@"1.233"]];
		}
	});
		 
		 
	it(@"test calculate", ^{
		KTDecimal *decimal = [[KTDecimal alloc] initWithValue:@1.2];
		decimal = decimal.add(@2.1);
		[[decimal.stringValue should] equal:@"3.3"];
	
		decimal = decimal.subtract(@1.3);
		[[decimal.stringValue should] equal:@"2"];
	
		decimal = decimal.multiplyingBy(@6);
		[[decimal.stringValue should] equal:@"12"];
	
		decimal = decimal.dividingBy(@3);
		[[decimal.stringValue should] equal:@"4"];
	
		decimal = decimal.raisingToPower(2);
		[[decimal.stringValue should] equal:@"16"];
	
		decimal = decimal.multiplyingByPowerOf10(1);
		[[decimal.stringValue should] equal:@"160"];
	});
		 
		 
	it(@"test round", ^{
		KTDecimal *decimal = [[KTDecimal alloc] initWithValue:@1.051];
		KTDecimal *decimal2 = decimal.round(2, NSRoundDown);
		[[decimal2.stringValue should] equal:@"1.05"];
		[[@(decimal.currentBehavior.roundingMode) should] equal:@(decimal2.currentBehavior.roundingMode)];
		
		KTDecimal *decimal3 = decimal.roundWithScale(1);
		[[decimal3.stringValue should] equal:@"1.1"];
		[[@(decimal.currentBehavior.roundingMode) should] equal:@(decimal3.currentBehavior.roundingMode)];
	});
		 
	
	it(@"test compare", ^{
		KTDecimal *decimal = [[KTDecimal alloc] initWithValue:@1];
		
		[[theValue(decimal.isEqualTo(@1)) should] beYes];
		[[theValue(decimal.isEqualTo(@1.1)) should] beNo];

		[[theValue(decimal.isGreaterThan(@0.9)) should] beYes];
		[[theValue(decimal.isGreaterThan(@1)) should] beNo];

		[[theValue(decimal.isGreaterThanOrEqualTo(@0.9)) should] beYes];
		[[theValue(decimal.isGreaterThanOrEqualTo(@1)) should] beYes];
		[[theValue(decimal.isGreaterThanOrEqualTo(@1.1)) should] beNo];

		[[theValue(decimal.isLessThan(@1.1)) should] beYes];
		[[theValue(decimal.isLessThan(@1)) should] beNo];

		[[theValue(decimal.isLessThanOrEqualTo(@1.1)) should] beYes];
		[[theValue(decimal.isLessThanOrEqualTo(@1)) should] beYes];
		[[theValue(decimal.isLessThanOrEqualTo(@0.9)) should] beNo];
	});
		 
	
	it(@"test config", ^{
		{
			KTDecimal *decimal = KTDecimalWith(@1.11111);
			KTDecimal *decimal2 = decimal.scale(3);
			KTDecimal *decimal3 = decimal2.roundingMode(NSRoundDown);
			KTDecimal *decimal4 = decimal3.subtract(@1);
			[[@(decimal2.currentBehavior.scale) shouldNot] equal:@(decimal.currentBehavior.scale)];
			[[@(decimal3.currentBehavior.roundingMode) shouldNot] equal:@(decimal2.currentBehavior.roundingMode)];
			[[@(decimal4.currentBehavior.scale) should] equal:@(decimal3.currentBehavior.scale)];
			[[@(decimal4.currentBehavior.roundingMode) should] equal:@(decimal3.currentBehavior.roundingMode)];

			[[decimal4.stringValue should] equal:@"0.111"];
		}
	
		{
			KTDecimal *decimal = KTDecimalWith(@1.11111);
			decimal = decimal.scale(2);
			decimal = decimal.roundingMode(NSRoundDown);
			[[decimal.subtract(@1).stringValue should] equal:@"0.11"];
		}
	
		{
			KTDecimal *decimal = KTDecimalWith(@1.55555);
			decimal = decimal.scale(3);
			decimal = decimal.roundingMode(NSRoundDown);
			[[decimal.subtract(@1).stringValue should] equal:@"0.555"];
		}
	
		{
			KTDecimal *decimal = KTDecimalWith(@1.55555);
			decimal = decimal.scale(2);
			decimal = decimal.roundingMode(NSRoundDown);
			[[decimal.subtract(@1).stringValue should] equal:@"0.55"];
		}
	
		{
			KTDecimal *decimal = KTDecimalWith(@1.11111);
			decimal = decimal.scale(3);
			decimal = decimal.roundingMode(NSRoundUp);
			[[decimal.subtract(@1).stringValue should] equal:@"0.112"];
		}
		
		{
			KTDecimal *decimal = KTDecimalWith(@1.11111);
			decimal = decimal.scale(2);
			decimal = decimal.roundingMode(NSRoundUp);
			[[decimal.subtract(@1).stringValue should] equal:@"0.12"];
		}
		
		{
			KTDecimal *decimal = KTDecimalWith(@1.55555);
			decimal = decimal.scale(3);
			decimal = decimal.roundingMode(NSRoundUp);
			[[decimal.subtract(@1).stringValue should] equal:@"0.556"];
		}
		
		{
			KTDecimal *decimal = KTDecimalWith(@1.55555);
			decimal = decimal.scale(2);
			decimal = decimal.roundingMode(NSRoundUp);
			[[decimal.subtract(@1).stringValue should] equal:@"0.56"];
		}
	
		{
			id <NSDecimalNumberBehaviors> behavior = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
			KTDecimal *decimal = KTDecimalWith(@1.55555);
			decimal = decimal.behavior(behavior);
			[[decimal.subtract(@1).stringValue should] equal:@"0.55"];
		}
	
		{
			id <NSDecimalNumberBehaviors> behavior = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundUp scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
			KTDecimal *decimal = KTDecimalWith(@1.11111);
			decimal = decimal.behavior(behavior);
			[[decimal.subtract(@1).stringValue should] equal:@"0.12"];
		}
	});
		 
	it(@"test copy", ^{
		KTDecimal *decimal = [[KTDecimal alloc] initWithValue:@1];
		KTDecimal *cpDecimal = [decimal copy];
		[[decimal shouldNot] equal:cpDecimal];
	});
	
	it(@"test decimal", ^{
		NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:@"1.1"];
		[[[KTDecimal decimalNumberWithValue:@"1.1"] should] equal:number];
		[[[KTDecimal decimalNumberWithValue:@1.1] should] equal:number];
		KTDecimal *decimal = KTDecimalWith(@1.1);
		[[[KTDecimal decimalNumberWithValue:decimal] should] equal:number];
	
		NSDecimalNumber *number1 = [NSDecimalNumber decimalNumberWithString:@"1.0"];
		[[[KTDecimal decimalNumberWithValue:@"1.1" defaultNumber:number1] should] equal:number];
		[[[KTDecimal decimalNumberWithValue:@1.1 defaultNumber:number1] should] equal:number];
		[[[KTDecimal decimalNumberWithValue:decimal defaultNumber:number1] should] equal:number];
//		[[[KTDecimal decimalNumberWithValue:@"ABC" defaultNumber:number1] should] equal:number1];

		[[theValue([KTDecimal valueIsAValidNumber:@"1"]) should] beYes];
		[[theValue([KTDecimal valueIsAValidNumber:@1]) should] beYes];
		[[theValue([KTDecimal valueIsAValidNumber:decimal]) should] beYes];
//		[[theValue([KTDecimal valueIsAValidNumber:@"ABC"]) should] beNo];

//		NSDecimalNumber *number2 = [NSDecimalNumber decimalNumberWithString:@"ABC"];
		[[theValue([KTDecimal isNotAValidNumber:number]) should] beNo];
		[[theValue([KTDecimal isNotAValidNumber:number1]) should] beNo];
//		[[theValue([KTDecimal isNotAValidNumber:number2]) should] beYes];
	});
});


SPEC_END
