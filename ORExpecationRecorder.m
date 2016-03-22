//
//  ORExpecationRecorder.m
//  Pods
//
//  Created by Nicolas on 3/22/16.
//
//

#import "ORExpecationRecorder.h"
#import "ORInvocationExpectation.h"

@implementation ORExpecationRecorder

- (id)init {
    self = [super init];
    invocationMatcher = [[ORInvocationExpectation alloc] init];
    return self;
}


@end
