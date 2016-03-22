//
//  ORExpectaOCMockMatcher.m
//  Pods
//
//  Created by Nicolas on 3/22/16.
//
//

#import "ORExpectaOCMockMatcher.h"

#import <OCMock/OCMock.h>
#import <OCMock/OCPartialMockObject.h>

#import "ORExpecationRecorder.h"

#import "EXMExpectifyHelper.h"
#import "EXMVarArgHelper.h"

// todo: delete
#import <OCMock/OCMock.h>
#import <OCMock/OCPartialMockObject.h>
#import <OCMock/OCMExpectationRecorder.h>
#import <OCMock/OCMStubRecorder.h>
#import <OCMock/OCMInvocationStub.h>
#import <OCMock/OCMInvocationExpectation.h>

@interface OCMExpectationRecorder (Private)
- (OCMInvocationStub *)stub;
- (OCMInvocationExpectation *)invocationMatcher;
@end


@interface ORExpectaOCMockMatcher()
@property (nonatomic, weak) EXPExpect *expectation;
@property (nonatomic, strong) OCMExpectationRecorder *expectRecorder;
@end


@implementation ORExpectaOCMockMatcher

- (instancetype)initWithExpectation:(EXPExpect *)expectation {
    self = [super init];
    if (self) {
        _expectation = expectation;
    
        _mock = [OCMockObject partialMockForObject:expectation.actual];

        _expectRecorder = [[ORExpecationRecorder alloc] initWithMockObject:_mock];
        [_expectRecorder andForwardToRealObject];
    }
    
    return self;
}

- (void)dealloc {
    NSException *theException = nil;
    
    @try {
        [_mock verify];
    }
    @catch (NSException *exception) {
        theException = exception;
    }
    
    if (_returning)
        [self verifyReturning];
    
    if (theException) {
        EXPFail(self.expectation.testCase, self.expectation.lineNumber, self.expectation.fileName, @"beCalled() failed");
        [theException raise];
    }
    
    [_mock stopMocking];
}

- (void)verifyReturning {
    NSInvocation *invocation = [self representedInvocation];
    [invocation setTarget:self.mock.realObject];
    [invocation invoke];

    id value = [EXMExpectifyHelper objectifyReturnOfInvocation:invocation];
    
    if (![EXMExpectifyHelper objectified:value equalTo:self.returning]) {
        EXPFail(self.expectation.testCase, self.expectation.lineNumber, self.expectation.fileName, @"returning() failed");
    }
}

#pragma mark -

- (void)setSelector:(SEL)aSelector {
    _selector = aSelector;
    [self updateMatcher];
}

- (void)setArgument:(id)firstArgument list:(va_list)argumentList {
    self.arguments = [EXMVarArgHelper argumentsAsArrayForSelector:self.selector
                                                    firstArgument:firstArgument
                                                     argumentList:argumentList];
}

- (void)setArguments:(NSArray *)theArguments {
    _arguments = theArguments;
    [self updateMatcher];
}

- (void)setReturning:(id)aReturning {
    _returning = aReturning;
    [self updateMatcher];
}

- (void)updateMatcher {
    [(NSMutableArray *)self.expectRecorder.stub.invocationActions removeAllObjects];
    
    // Yeah, I'm doing it. I know what it is under the hood.
    
    NSInvocation *invocation = [self representedInvocation];
    [invocation invoke];
}

- (NSInvocation *)representedInvocation {
    NSMethodSignature *mySignature = [self.mock.realObject.class instanceMethodSignatureForSelector:self.selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:mySignature];
    
    invocation.selector = self.selector;
    invocation.target = self.expectRecorder;
    
    for (__unsafe_unretained id object in self.arguments) {
        [invocation setArgument:&object atIndex:[self.arguments indexOfObject:object] +2];
    }
    
    return invocation;
}

#pragma mark -

- (BOOL)matches:(id)actual {
    OCMInvocationExpectation *exp = [self.expectRecorder invocationMatcher];
    return !self.expectation.asynchronous || [exp isSatisfied];
}

@end
