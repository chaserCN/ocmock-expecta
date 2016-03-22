//
//  ORExpectaOCMockSupport.m
//  Pods
//
//  Created by Nicolas on 3/22/16.
//
//

#import "EXMExpectifyHelper.h"
#import "EXPMatcherHelpers.h"
#import "ExpectaSupport.h"
#import "EXMStubs.h"

@implementation  EXMExpectifyHelper : NSObject

// Implementation copied from Expecta
+ (BOOL)objectified:(id)o1 equalTo:(id)o2 {
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

// Implementation is modified ReactiveCocoa's code
+ (id)objectifyReturnOfInvocation:(NSInvocation *)inv {
    #define WRAP_AND_RETURN(type) \
    do { \
        type val = 0; \
        [inv getReturnValue:&val]; \
        return _EXPObjectify(returnType, val); \
    } while (0)
    
    const char *returnType = inv.methodSignature.methodReturnType;
    // Skip const type qualifier.
    if (returnType[0] == 'r') {
        returnType++;
    }
    
    if (strcmp(returnType, @encode(id)) == 0 || strcmp(returnType, @encode(Class)) == 0 || strcmp(returnType, @encode(void (^)(void))) == 0) {
        __autoreleasing id returnObj;
        [inv getReturnValue:&returnObj];
        return returnObj;
    } else if (strcmp(returnType, @encode(char)) == 0) {
        WRAP_AND_RETURN(char);
    } else if (strcmp(returnType, @encode(int)) == 0) {
        WRAP_AND_RETURN(int);
    } else if (strcmp(returnType, @encode(short)) == 0) {
        WRAP_AND_RETURN(short);
    } else if (strcmp(returnType, @encode(long)) == 0) {
        WRAP_AND_RETURN(long);
    } else if (strcmp(returnType, @encode(long long)) == 0) {
        WRAP_AND_RETURN(long long);
    } else if (strcmp(returnType, @encode(unsigned char)) == 0) {
        WRAP_AND_RETURN(unsigned char);
    } else if (strcmp(returnType, @encode(unsigned int)) == 0) {
        WRAP_AND_RETURN(unsigned int);
    } else if (strcmp(returnType, @encode(unsigned short)) == 0) {
        WRAP_AND_RETURN(unsigned short);
    } else if (strcmp(returnType, @encode(unsigned long)) == 0) {
        WRAP_AND_RETURN(unsigned long);
    } else if (strcmp(returnType, @encode(unsigned long long)) == 0) {
        WRAP_AND_RETURN(unsigned long long);
    } else if (strcmp(returnType, @encode(float)) == 0) {
        WRAP_AND_RETURN(float);
    } else if (strcmp(returnType, @encode(double)) == 0) {
        WRAP_AND_RETURN(double);
    } else if (strcmp(returnType, @encode(BOOL)) == 0) {
        WRAP_AND_RETURN(BOOL);
    } else if (strcmp(returnType, @encode(char *)) == 0) {
        WRAP_AND_RETURN(const char *);
    } else if (strcmp(returnType, @encode(void)) == 0) {
        return nil;
    } else {
        NSUInteger valueSize = 0;
        NSGetSizeAndAlignment(returnType, &valueSize, NULL);
        
        unsigned char valueBytes[valueSize];
        [inv getReturnValue:valueBytes];
        
        return [NSValue valueWithBytes:valueBytes objCType:returnType];
    }
    
    return nil;
    
#undef WRAP_AND_RETURN
}

+ (id)objectifyArgOfInvocation:(NSInvocation *)inv atIndex:(NSUInteger)index {
    id obj = [self objectifyArgOfInvocation2:inv atIndex:index];
    return obj ? obj : [EXMNil value];
}

// Implementation is modified ReactiveCocoa's code
+ (id)objectifyArgOfInvocation2:(NSInvocation *)inv atIndex:(NSUInteger)index {
    #define WRAP_AND_RETURN(type) \
    do { \
        type val = 0; \
        [inv getArgument:&val atIndex:(NSInteger)index]; \
        return _EXPObjectify(argType, val); \
    } while (0)
    
    const char *argType = [inv.methodSignature getArgumentTypeAtIndex:index];
    // Skip const type qualifier.
    if (argType[0] == 'r') {
        argType++;
    }
    
    if (strcmp(argType, @encode(id)) == 0 || strcmp(argType, @encode(Class)) == 0) {
        __autoreleasing id returnObj;
        [inv getArgument:&returnObj atIndex:(NSInteger)index];
        return returnObj;
    } else if (strcmp(argType, @encode(char)) == 0) {
        WRAP_AND_RETURN(char);
    } else if (strcmp(argType, @encode(int)) == 0) {
        WRAP_AND_RETURN(int);
    } else if (strcmp(argType, @encode(short)) == 0) {
        WRAP_AND_RETURN(short);
    } else if (strcmp(argType, @encode(long)) == 0) {
        WRAP_AND_RETURN(long);
    } else if (strcmp(argType, @encode(long long)) == 0) {
        WRAP_AND_RETURN(long long);
    } else if (strcmp(argType, @encode(unsigned char)) == 0) {
        WRAP_AND_RETURN(unsigned char);
    } else if (strcmp(argType, @encode(unsigned int)) == 0) {
        WRAP_AND_RETURN(unsigned int);
    } else if (strcmp(argType, @encode(unsigned short)) == 0) {
        WRAP_AND_RETURN(unsigned short);
    } else if (strcmp(argType, @encode(unsigned long)) == 0) {
        WRAP_AND_RETURN(unsigned long);
    } else if (strcmp(argType, @encode(unsigned long long)) == 0) {
        WRAP_AND_RETURN(unsigned long long);
    } else if (strcmp(argType, @encode(float)) == 0) {
        WRAP_AND_RETURN(float);
    } else if (strcmp(argType, @encode(double)) == 0) {
        WRAP_AND_RETURN(double);
    } else if (strcmp(argType, @encode(BOOL)) == 0) {
        WRAP_AND_RETURN(BOOL);
    } else if (strcmp(argType, @encode(char *)) == 0) {
        WRAP_AND_RETURN(const char *);
    } else if (strcmp(argType, @encode(void (^)(void))) == 0) {
        __unsafe_unretained id block = nil;
        [inv getArgument:&block atIndex:(NSInteger)index];
        return [block copy];
    } else {
        NSUInteger valueSize = 0;
        NSGetSizeAndAlignment(argType, &valueSize, NULL);
        
        unsigned char valueBytes[valueSize];
        [inv getArgument:valueBytes atIndex:(NSInteger)index];
        
        return [NSValue valueWithBytes:valueBytes objCType:argType];
    }
    
    return nil;
    
#undef WRAP_AND_RETURN
}

@end

