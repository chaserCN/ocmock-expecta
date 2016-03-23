#import "Expecta+Receive.h"
#import "RXPExpectaMatcher.h"

@interface EXPExpect (receiveMatcherPrivate)
@property (nonatomic, strong) RXPExpectaMatcher *matcher;
@end

@implementation EXPExpect (receiveMatcher)

@dynamic method;

- (EXPExpect *(^) (SEL)) method {
    self.matcher = [[RXPExpectaMatcher alloc] initWithExpectation:self];

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
        RXPExpectaMatcher *matcher = self.matcher;
        id mock = matcher.mock;

        [matcher setNegative:self.negative];
        [matcher setAsynchronous:self.asynchronous];

        [self applyMatcher:matcher to:&mock];
        
        return self;
    };
}

#pragma mark -

- (RXPExpectaMatcher *)matcher {
    return objc_getAssociatedObject(self, @selector(matcher));
}

- (void)setMatcher:(RXPExpectaMatcher *)aMatcher {
    objc_setAssociatedObject(self, @selector(matcher), aMatcher, OBJC_ASSOCIATION_RETAIN);
}

@end

