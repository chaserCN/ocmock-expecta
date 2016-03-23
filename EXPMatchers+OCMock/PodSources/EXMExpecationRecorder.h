//
//  ORExpecationRecorder.h
//  Pods
//
//  Created by Nicolas on 3/22/16.
//
//

#import "OCMExpectationRecorder.h"
#import "EXMInvocationExpectation.h"

@interface EXMExpecationRecorder : OCMExpectationRecorder

- (void)recordArguments:(NSArray *)theArguments;
- (void)recordReturning:(id)aReturning;
- (BOOL)isExpectationSatisfied;

@end
