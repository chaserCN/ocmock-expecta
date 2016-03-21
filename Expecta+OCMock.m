#import "Expecta+OCMock.h"
#import "EXPMatcherHelpers.h"
#import <OCMock/OCMock.h>
#import <OCMock/OCPartialMockObject.h>
#import <OCMock/OCMExpectationRecorder.h>
#import <OCMock/OCMStubRecorder.h>
#import <OCMock/OCMInvocationStub.h>
#import <OCMock/OCMInvocationExpectation.h>

#import <objc/runtime.h>
#import <XCTest/XCTest.h>

#import "EXPMatchers+equal.h"

NSUInteger KWSelectorParameterCount(SEL selector);

@interface OCMExpectationRecorder (Private)
- (OCMInvocationStub *)stub;
@end

@interface ORExpectaOCMockMatcher : NSObject <EXPMatcher>
- (instancetype)initWithExpectation:(EXPExpect *)expectation;
@end

@interface ORExpectaOCMockMatcher()
@property (nonatomic, weak) EXPExpect *expectation;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, copy) NSArray *arguments;
@property (nonatomic, strong) id returning;

@property (nonatomic, strong) OCMExpectationRecorder *selectorCheckRecorder;
@property (nonatomic, strong) OCPartialMockObject *mock;
@end

@implementation ORExpectaOCMockMatcher

- (instancetype)initWithExpectation:(EXPExpect *)expectation
{
    self = [super init];
    if (!self) { return nil; }

    _expectation = expectation;

    _mock = expectation.actual;
    _selectorCheckRecorder = [_mock expect];

    [self.selectorCheckRecorder andForwardToRealObject];

    return self;
}

- (void)updateMatcher
{
    [(NSMutableArray *)self.selectorCheckRecorder.stub.invocationActions removeAllObjects];
    
    // Yeah, I'm doing it. I know what it is under the hood.

    NSInvocation *invocation = [self representedInvocation];
    [invocation invoke];
}

- (NSInvocation *)representedInvocation
{
    NSMethodSignature *mySignature = [self.mock.realObject.class instanceMethodSignatureForSelector:self.selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:mySignature];

    invocation.selector = self.selector;
    invocation.target = self.selectorCheckRecorder;

    for (__unsafe_unretained id object in self.arguments) {
        [invocation setArgument:&object atIndex:[self.arguments indexOfObject:object] +2];
    }

    return invocation;
}

- (BOOL)matches:(id)actual
{
    OCMInvocationExpectation *exp = (OCMInvocationExpectation *)[_selectorCheckRecorder invocationMatcher];
    return !self.expectation.asynchronous || [exp isSatisfied];
}

- (void)dealloc
{
    id mock = self.mock;
    NSException *theException = nil;

    @try {
        [mock verify];
    }
    @catch (NSException *exception) {
        theException = exception;
    }

    if (_returning) {


        // The return value is checked at the end
        NSInvocation *invocation = [self representedInvocation];
        [invocation setTarget:self.mock.realObject];
        [invocation invoke];

        const char *retType = [invocation.methodSignature methodReturnType];
        BOOL resultIsObject = (strcmp(retType, @encode(id)) == 0 || strcmp(retType, @encode(void)) == 0);

        id result;
        if (resultIsObject) {
            CFTypeRef cfResult;
            [invocation getReturnValue:&cfResult];
            result = (__bridge_transfer id)cfResult;
            CFRetain(cfResult);

        } else {
            // This is a really simple implementation, only supports NSIntegers
            NSInteger resultValue;
            [invocation getReturnValue:&resultValue];
            result = [NSNumber numberWithInteger:resultValue];
        }

        if (![result isEqual:self.returning]) {
            _XCTFailureHandler(self.expectation.testCase, YES, self.expectation.fileName , self.expectation.lineNumber, FALSE, @"Expected a match on the return value");
        }

    }

    if (theException) {
        EXPFail(self.expectation.testCase, self.expectation.lineNumber, self.expectation.fileName, @"Fail");
        [theException raise];
    }

    [mock stopMocking];
}

@end

/// For passing data between recieve and with

@interface EXPExpect (receiveMatcherPrivate)
@property (nonatomic, strong) id _expectaOCMatcher;
@end

@implementation EXPExpect (receiveMatcherPrivate)
@dynamic _expectaOCMatcher;
@end

@implementation EXPExpect (receiveMatcher)

@dynamic selector;

- (EXPExpect *(^) (SEL)) selector {
    ORExpectaOCMockMatcher *matcher = [[ORExpectaOCMockMatcher alloc] initWithExpectation:self];
    objc_setAssociatedObject(self, @selector(_expectaOCMatcher), matcher, OBJC_ASSOCIATION_RETAIN);

    EXPExpect *(^matcherBlock) (SEL selector) = [^ (SEL selector) {

        matcher.selector = selector;
        [matcher updateMatcher];

        return self;

    } copy];

    return  matcherBlock;
}

@dynamic with;

- (EXPExpect *(^) (NSArray *)) with {

    EXPExpect *(^matcherBlock) (id object) = [^ (id object) {

        ORExpectaOCMockMatcher *matcher = objc_getAssociatedObject(self, @selector(_expectaOCMatcher));
        matcher.arguments = object;
        [matcher updateMatcher];

        return self;

    } copy];
    
    return  matcherBlock;
}

@dynamic with2;

- (EXPExpect *(^) (id firstObject, ...)) with2 {
    
    EXPExpect *(^matcherBlock) (id firstObject, ...) = [^ (id firstArgument, ...) {
        
        ORExpectaOCMockMatcher *matcher = objc_getAssociatedObject(self, @selector(_expectaOCMatcher));

        va_list argumentList;
        va_start(argumentList, firstArgument);

        matcher.arguments = [self argumentsAsArrayForSelector:matcher.selector firstArgument:firstArgument argumentList:argumentList];

        [matcher updateMatcher];
        
        return self;
        
    } copy];
    
    return  matcherBlock;
}

- (NSArray *)argumentsAsArrayForSelector:(SEL)aSelector firstArgument:(id)firstArgument argumentList:(va_list)argumentList {
    NSUInteger count = KWSelectorParameterCount(aSelector);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    [array addObject:(firstArgument != nil) ? firstArgument : [OCMArg isNil]];
    
    for (NSUInteger i = 1; i < count; ++i)
    {
        id object = va_arg(argumentList, id);
        [array addObject:(object != nil) ? [self checkerForObject:object] : [OCMArg isNil]];
    }
    
    va_end(argumentList);
    return array;
}

- (id)checkerForObject:(id)anObject {
    return [OCMArg checkWithBlock:^BOOL(id value) {
        expect(value)._equal(anObject);
        return true;
    }];
}

@dynamic returning;

- (EXPExpect *(^) (id)) returning {

    EXPExpect *(^matcherBlock) (id object) = [^ (id object) {

        ORExpectaOCMockMatcher *matcher = objc_getAssociatedObject(self, @selector(_expectaOCMatcher));
        matcher.returning = object;
        [matcher updateMatcher];

        return self;

    } copy];

    return  matcherBlock;
}

@dynamic beCalled;

- (EXPExpect *(^) (void)) beCalled {
    
    EXPExpect *(^matcherBlock) (void) = [^ (void) {
        
        ORExpectaOCMockMatcher *matcher = objc_getAssociatedObject(self, @selector(_expectaOCMatcher));
        id actual = matcher.mock;
        [self applyMatcher:matcher to:&actual];
        
        return self;
        
    } copy];
    
    return  matcherBlock;
}

@end

NSUInteger KWSelectorParameterCount(SEL selector) {
    NSString *selectorString = NSStringFromSelector(selector);
    NSUInteger length = [selectorString length];
    NSUInteger parameterCount = 0;
    
    for (NSUInteger i = 0; i < length; ++i) {
        if ([selectorString characterAtIndex:i] == ':')
            ++parameterCount;
    }
    
    return parameterCount;
}
