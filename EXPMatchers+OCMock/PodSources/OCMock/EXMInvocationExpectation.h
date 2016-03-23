//
//  ORInvocationExpectation.h
//  Pods
//
//  Created by Nicolas on 3/22/16.
//
//

#import "OCMInvocationExpectation.h"

@interface EXMInvocationExpectation : OCMInvocationExpectation
@property (nonatomic, strong) NSArray *objectifiedArguments;
@property (nonatomic, strong) id objectifiedReturning;

- (void)checkReturnValueForInvocation:(NSInvocation *)anInvocation;

@end
