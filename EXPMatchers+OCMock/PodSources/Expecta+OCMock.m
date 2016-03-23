#import "Expecta+OCMock.h"
#import "ORExpectaOCMockMatcher.h"

@interface EXPExpect (receiveMatcherPrivate)
@property (nonatomic, strong) ORExpectaOCMockMatcher *matcher;
@end

@implementation EXPExpect (receiveMatcher)

@dynamic method;

- (EXPExpect *(^) (SEL)) method {
    self.matcher = [[ORExpectaOCMockMatcher alloc] initWithExpectation:self];

    return ^(SEL selector) {
        self.matcher.selector = selector;
        return self;
    };
}

@dynamic with;

- (EXPExpect *(^) (id firstObject, ...)) with {
    return ^(id firstArgument, ...) {
        va_list argumentList;
        va_start(argumentList, firstArgument);

        [self.matcher setArgument:firstArgument list:argumentList];
        
        return self;
    };
}


@dynamic returning;

- (EXPExpect *(^) (id)) returning {
    return ^(id object) {
        self.matcher.returning = object;
        return self;
    };
}

@dynamic beCalled;

- (EXPExpect *(^) (void)) beCalled {
    return ^{
        ORExpectaOCMockMatcher *matcher = self.matcher;
        id mock = matcher.mock;

        [matcher setNegative:self.negative];
        [matcher setAsynchronous:self.asynchronous];

        [self applyMatcher:matcher to:&mock];
        
        return self;
    };
}

#pragma mark -

- (ORExpectaOCMockMatcher *)matcher {
    return objc_getAssociatedObject(self, @selector(matcher));
}

- (void)setMatcher:(ORExpectaOCMockMatcher *)aMatcher {
    objc_setAssociatedObject(self, @selector(matcher), aMatcher, OBJC_ASSOCIATION_RETAIN);
}

@end

