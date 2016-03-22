//
//  ORInvocationExpectation.m
//  Pods
//
//  Created by Nicolas on 3/22/16.
//
//

#import "ORInvocationExpectation.h"
#import "EXMExpectifyHelper.h"
#import "EXMStubs.h"

@implementation ORInvocationExpectation

- (BOOL)matchesInvocation:(NSInvocation *)anInvocation {
    id target = [anInvocation target];
    
    BOOL isClassMethodInvocation = (target != nil) && (target == [target class]);
    if (isClassMethodInvocation != recordedAsClassMethod)
        return NO;
    
    if (![self matchesSelector:[anInvocation selector]])
        return NO;
    
    NSMethodSignature *signature = [recordedInvocation methodSignature];
    NSUInteger n = [signature numberOfArguments];

    for (NSUInteger i = 2; i < n; i++) {
        __autoreleasing id recordedArg;
        [recordedInvocation getArgument:&recordedArg atIndex:i];

        if (recordedArg == [EXMAny any])
            continue;
        
        id arg = [EXMExpectifyHelper objectifyArgOfInvocation:anInvocation atIndex:i];
        if (![EXMExpectifyHelper objectified:arg equalTo:recordedArg])
            return NO;
    }

    return YES;
}

@end
