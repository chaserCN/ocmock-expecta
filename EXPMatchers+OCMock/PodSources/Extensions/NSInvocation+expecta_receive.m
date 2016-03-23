//
//  NSInvocation+expecta_receive.m
//  Pods
//
//  Created by Nicolas on 3/23/16.
//
//

#import "NSInvocation+expecta_receive.h"
#import "RXPObjectify.h"

@implementation NSInvocation (expecta_receive)

- (id)rxp_objectifyReturnValue {
    #define WRAP_AND_RETURN(type) \
    do { \
        type val; \
        [self getReturnValue:&val]; \
        return _RXPObjectify(returnType, val); \
    } while (0)
    
    const char *returnType = self.methodSignature.methodReturnType;

    // Skip const type qualifier.
    if (returnType[0] == 'r') {
        returnType++;
    }
    
    if (strcmp(returnType, @encode(id)) == 0 || strcmp(returnType, @encode(Class)) == 0 || strcmp(returnType, @encode(void (^)(void))) == 0) {
        __autoreleasing id returnObj;
        [self getReturnValue:&returnObj];
        return RXPObjectify(returnObj);
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
    } else if (strcmp(returnType, @encode(SEL)) == 0) {
        WRAP_AND_RETURN(SEL);
    } else if (strcmp(returnType, @encode(NSRange)) == 0) {
        WRAP_AND_RETURN(NSRange);
    } else if (strcmp(returnType, @encode(CGPoint)) == 0) {
        WRAP_AND_RETURN(CGPoint);
    } else if (strcmp(returnType, @encode(CGSize)) == 0) {
        WRAP_AND_RETURN(CGSize);
    } else if (strcmp(returnType, @encode(CGRect)) == 0) {
        WRAP_AND_RETURN(CGRect);
    } else if (strcmp(returnType, @encode(CGColorRef)) == 0) {
        WRAP_AND_RETURN(CGColorRef);
    } else {
        NSUInteger valueSize = 0;
        NSGetSizeAndAlignment(returnType, &valueSize, NULL);
        
        unsigned char valueBytes[valueSize];
        [self getReturnValue:valueBytes];
        
        return _RXPObjectify(returnType, valueBytes);
    }
    
    #undef WRAP_AND_RETURN
}

- (id)rxp_objectifyArgWithIndex:(NSUInteger)index {
    #define WRAP_AND_RETURN(type) \
    do { \
        type val; \
        [self getArgument:&val atIndex:(NSInteger)index]; \
        return _RXPObjectify(argType, val); \
    } while (0)

    const char *argType = [self.methodSignature getArgumentTypeAtIndex:index];
    // Skip const type qualifier.
    if (argType[0] == 'r') {
        argType++;
    }
    
    if (strcmp(argType, @encode(id)) == 0 || strcmp(argType, @encode(Class)) == 0) {
        __autoreleasing id returnObj;
        [self getArgument:&returnObj atIndex:(NSInteger)index];
        return RXPObjectify(returnObj);
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
    } else if (strcmp(argType, @encode(SEL)) == 0) {
        WRAP_AND_RETURN(SEL);
    } else if (strcmp(argType, @encode(NSRange)) == 0) {
        WRAP_AND_RETURN(NSRange);
    } else if (strcmp(argType, @encode(CGPoint)) == 0) {
        WRAP_AND_RETURN(CGPoint);
    } else if (strcmp(argType, @encode(CGSize)) == 0) {
        WRAP_AND_RETURN(CGSize);
    } else if (strcmp(argType, @encode(CGRect)) == 0) {
        WRAP_AND_RETURN(CGRect);
    } else if (strcmp(argType, @encode(CGColorRef)) == 0) {
        WRAP_AND_RETURN(CGColorRef);
    } else if (strcmp(argType, @encode(void (^)(void))) == 0) {
        __unsafe_unretained id block = nil;
        [self getArgument:&block atIndex:(NSInteger)index];
        return RXPObjectify([block copy]);
    } else {
        NSUInteger valueSize = 0;
        NSGetSizeAndAlignment(argType, &valueSize, NULL);
        
        unsigned char valueBytes[valueSize];
        [self getArgument:valueBytes atIndex:(NSInteger)index];
        
        return _RXPObjectify(argType, valueBytes);
    }
    
    #undef WRAP_AND_RETURN
}

@end
