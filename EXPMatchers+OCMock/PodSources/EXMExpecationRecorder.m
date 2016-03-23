//
//  ORExpecationRecorder.m
//  Pods
//
//  Created by Nicolas on 3/22/16.
//
//

#import "EXMExpecationRecorder.h"

@interface EXMExpecationRecorder()
@property (nonatomic, strong, readonly) EXMInvocationExpectation *invocationExpectation;
@end

@implementation EXMExpecationRecorder

- (instancetype)init {
    self = [super init];
    if (self) {
        invocationMatcher = [[EXMInvocationExpectation alloc] init];
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

- (EXMInvocationExpectation *)invocationExpectation {
    return (EXMInvocationExpectation *)invocationMatcher;
}

@end
