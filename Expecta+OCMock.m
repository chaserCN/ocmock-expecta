#import "Expecta+OCMock.h"
#import "ORExpectaOCMockMatcher.h"

@interface EXPExpect (receiveMatcherPrivate)
@property (nonatomic, strong) ORExpectaOCMockMatcher *matcher;
@end

@implementation EXPExpect (receiveMatcher)

@dynamic selector;

- (EXPExpect *(^) (SEL)) selector {
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


@dynamic returningObj;

- (EXPExpect *(^) (id)) returningObj {
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

