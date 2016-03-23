//
//  EXMStubs.m
//  Pods
//
//  Created by Nicolas on 3/22/16.
//
//

#import "RXPObjectify.h"
#import "EXPMatcherHelpers.h"

// Implementation copied from Expecta
BOOL RXPObjectifiedEqual(id o1, id o2) {
    if ((o1 == o2) || [o1 isEqual:o2]) {
        return YES;
    } else if([o1 isKindOfClass:[NSNumber class]] && [o2 isKindOfClass:[NSNumber class]]) {
        if([o1 isKindOfClass:[NSDecimalNumber class]] || [o2 isKindOfClass:[NSDecimalNumber class]]) {
            NSDecimalNumber *o1DecimalNumber = [NSDecimalNumber decimalNumberWithDecimal:[(NSNumber *) o1 decimalValue]];
            NSDecimalNumber *o2DecimalNumber = [NSDecimalNumber decimalNumberWithDecimal:[(NSNumber *) o2 decimalValue]];
            return [o1DecimalNumber isEqualToNumber:o2DecimalNumber];
        }
        else {
            if(EXPIsNumberFloat((NSNumber *)o1) || EXPIsNumberFloat((NSNumber *)o2)) {
                return [(NSNumber *)o1 floatValue] == [(NSNumber *)o2 floatValue];
            }
        }
    }
    return NO;
}

id RXPWrapNil(id obj) {
    return obj ? obj : [EXMNil value];
}

@implementation EXMNil

+ (instancetype)value {
    static EXMNil *value;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        value = [self new];
    });

    return value;
}

@end


@implementation EXMAny : NSObject

+ (instancetype)any {
    static EXMAny *value;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        value = [self new];
    });
    
    return value;
}

@end

@implementation EXMArgStop : NSObject

+ (instancetype)value {
    static EXMArgStop *value;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        value = [self new];
    });
    
    return value;
}

@end

