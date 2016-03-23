//
//  ECMVarArgHelpers.m
//  Pods
//
//  Created by Nicolas on 3/22/16.
//
//

#import "EXMVarArgHelper.h"
#import "ExpectaObject.h"
#import "EXMStubs.h"

// TODO: delete
#import "ExpectaSupport.h"

@implementation EXMVarArgHelper

+ (NSArray *)objectifiedArgumentsOfSelector:(SEL)aSelector firstArgument:(id)firstArgument argumentList:(va_list)argumentList {
    NSUInteger count = [self selectorParameterCount:aSelector];

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    [array addObject:[self objectFromArgument:firstArgument]];
    
    for (NSUInteger i = 1; i < count; ++i) {
        id argument = va_arg(argumentList, id);
        
        if (argument == [EXMArgStop value])
            break;
            
        id object = [self objectFromArgument:argument];
        [array addObject:object];
    }
    
    va_end(argumentList);
    return array;
}

+ (id)objectFromArgument:(id)anArgument {
    return anArgument ? EXPObjectify(anArgument) : [EXMNil value];
}

// Copied from Kiwi
+ (NSUInteger)selectorParameterCount:(SEL)aSelector {
    NSString *selectorString = NSStringFromSelector(aSelector);
    NSUInteger length = [selectorString length];
    NSUInteger parameterCount = 0;
    
    for (NSUInteger i = 0; i < length; ++i) {
        if ([selectorString characterAtIndex:i] == ':')
            ++parameterCount;
    }
    
    return parameterCount;
}

@end
