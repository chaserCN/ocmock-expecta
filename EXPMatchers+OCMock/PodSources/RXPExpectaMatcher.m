//
//  ORExpectaOCMockMatcher.m
//  Pods
//
//  Created by Nicolas on 3/22/16.
//
//

#import "RXPExpectaMatcher.h"

#import <OCMock/OCPartialMockObject.h>
#import <OCMock/OCMFunctionsPrivate.h>

#import "RXPExpecationRecorder.h"

#import "RXPVarArgHelper.h"

@interface RXPExpectaMatcher()
@property (nonatomic, assign) SEL selector;

@property (nonatomic, assign) int lineNumber;
@property (nonatomic, assign) const char *fileName;

@property (nonatomic, assign) BOOL negative; // expecta resets its negative and async properties. still need them in dealloc
@property (nonatomic, assign) BOOL asynchronous;

@property (nonatomic, weak) EXPExpect *expectation;
@property (nonatomic, strong) RXPExpecationRecorder *expectRecorder;

@end


@implementation RXPExpectaMatcher

- (instancetype)initWithExpectation:(EXPExpect *)expectation {
    self = [super init];
    if (self) {
        _lineNumber = expectation.lineNumber;
        _fileName = expectation.fileName;
        
        _expectation = expectation;
    
        _mock = OCMGetAssociatedMockForObject(expectation.actual);
        if (!_mock)
            _mock = [OCMockObject partialMockForObject:expectation.actual];

        _expectRecorder = [[RXPExpecationRecorder alloc] initWithMockObject:_mock];
        [_expectRecorder andForwardToRealObject];
    }
    
    return self;
}

- (void)dealloc {
    if (self.asynchronous && self.negative)
        EXPFail(nil, self.lineNumber, self.fileName, @"willNot is not supported");
    else if (self.negative == [self.expectRecorder isExpectationSatisfied])
        EXPFail(nil, self.lineNumber, self.fileName, @"beCalled failed");
    
    [_mock stopMocking];
}

#pragma mark -

- (void)setSelector:(SEL)aSelector {
    _selector = aSelector;
    [self installExpectationForSelector:aSelector];
}

- (void)installExpectationForSelector:(SEL)aSelector {
    NSMethodSignature *mySignature = [self.mock.realObject.class instanceMethodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:mySignature];
    
    invocation.selector = self.selector;
    invocation.target = self.expectRecorder;
    
    [invocation invoke];
}

- (void)setArgument:(id)firstArgument list:(va_list)argumentList {
    NSArray *args = [RXPVarArgHelper objectifiedArgumentsOfSelector:self.selector
                                                      firstArgument:firstArgument
                                                       argumentList:argumentList];
    [self.expectRecorder recordArguments:args];
}

- (void)setReturning:(id)aReturning {
    [self.expectRecorder recordReturning:aReturning];
}

#pragma mark -

- (BOOL)matches:(id)actual {
    if (self.asynchronous)
        return [self.expectRecorder isExpectationSatisfied];
    return !self.negative;
}

@end
