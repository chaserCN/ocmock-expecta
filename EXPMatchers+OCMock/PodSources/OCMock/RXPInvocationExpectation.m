//
//  ORInvocationExpectation.m
//  Pods
//
//  Created by Nicolas on 3/22/16.
//
//

#import "RXPInvocationExpectation.h"
#import "NSInvocation+expecta_receive.h"
#import "RXPObjectify.h"

@interface RXPInvocationExpectation()
@property (nonatomic, assign) BOOL argumentsSatisfied;
@property (nonatomic, assign) BOOL returningSatisfied;
@end

@implementation RXPInvocationExpectation

- (BOOL)isSatisfied {
    return self.argumentsSatisfied && self.returningSatisfied;
}

#pragma mark -

- (BOOL)matchesInvocation:(NSInvocation *)anInvocation {
    if ([self needToCheckInvocation:anInvocation]) {
        self.argumentsSatisfied = [self matchesArgumentsOfInvocation:anInvocation];
        self.returningSatisfied = ([self expectingMethodToReturnVoid] == YES);
        return self.argumentsSatisfied;
    }
    return NO;
}

// not called if the method does not return anything
- (void)checkReturnValueForInvocation:(NSInvocation *)anInvocation {
    if ([self needToCheckInvocation:anInvocation])
        self.returningSatisfied = [self matchesReturningOfInvocation:anInvocation];
}

- (BOOL)needToCheckInvocation:(NSInvocation *)anInvocation {
    id target = [anInvocation target];
    
    BOOL isClassMethodInvocation = (target != nil) && (target == [target class]);
    if (isClassMethodInvocation != recordedAsClassMethod)
        return NO;
    
    if (![self matchesSelector:[anInvocation selector]])
        return NO;

    return YES;
}

- (BOOL)expectingMethodToReturnVoid {
    return self.objectifiedReturning == nil;
}

#pragma mark -

- (BOOL)matchesArgumentsOfInvocation:(NSInvocation *)anInvocation {
    NSMethodSignature *signature = [recordedInvocation methodSignature];
    NSArray *recordedArguments = self.objectifiedArguments;

    NSUInteger limit = MIN(signature.numberOfArguments, recordedArguments.count+2);
    
    for (NSUInteger i = 2; i < limit; i++) {
        id recorded = recordedArguments[i-2];
        id passed = [anInvocation rxp_objectifyArgWithIndex:i];
        
        if (![self matchesRecordedArgument:recorded withPassed:passed])
            return NO;
    }
    
    return YES;
}

- (BOOL)matchesRecordedArgument:(id)aRecorded withPassed:(id)aPassed {
    if (aRecorded == [EXMAny any])
        return YES;
    
    if ([aRecorded isProxy])
        return [aRecorded isEqual:aPassed];
    
    return RXPObjectifiedEqual(aRecorded, aPassed);
}

#pragma mark -

- (BOOL)matchesReturningOfInvocation:(NSInvocation *)aInvocation {
    id recorded = self.objectifiedReturning;

    if (!recorded)
        return YES;
    
    id passed = [aInvocation rxp_objectifyReturnValue];
    return RXPObjectifiedEqual(recorded, passed);
}

@end
