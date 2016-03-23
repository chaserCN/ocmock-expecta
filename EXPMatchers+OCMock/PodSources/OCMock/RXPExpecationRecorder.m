//
//  ORExpecationRecorder.m
//  Pods
//
//  Created by Nicolas on 3/22/16.
//
//

#import "RXPExpecationRecorder.h"
#import "RXPInvocationExpectation.h"

@interface RXPExpecationRecorder()
@property (nonatomic, strong, readonly) RXPInvocationExpectation *invocationExpectation;
@end

@implementation RXPExpecationRecorder

- (instancetype)init {
    self = [super init];
    if (self) {
        invocationMatcher = [[RXPInvocationExpectation alloc] init];
    }
    return self;
}

- (void)recordArguments:(NSArray *)theArguments {
    self.invocationExpectation.objectifiedArguments = theArguments;
}

- (void)recordReturning:(id)aReturning {
    __weak typeof(self) weakSelf = self;
    
    self.invocationExpectation.objectifiedReturning = aReturning;
    
    [self andDo:^(NSInvocation *invocation) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.invocationExpectation checkReturnValueForInvocation:invocation];
    }];
}

- (BOOL)isExpectationSatisfied {
    return self.invocationExpectation.isSatisfied;
}

- (RXPInvocationExpectation *)invocationExpectation {
    return (RXPInvocationExpectation *)invocationMatcher;
}

@end
