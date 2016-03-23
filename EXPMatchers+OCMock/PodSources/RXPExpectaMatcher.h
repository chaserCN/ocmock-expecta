//
//  ORExpectaOCMockMatcher.h
//  Pods
//
//  Created by Nicolas on 3/22/16.
//
//

#import <Expecta/Expecta.h>
#import <OCMock/OCPartialMockObject.h>

@interface RXPExpectaMatcher : NSObject <EXPMatcher>

@property (nonatomic, strong) OCPartialMockObject *mock;

- (instancetype)initWithExpectation:(EXPExpect *)expectation;

- (void)setSelector:(SEL)selector;
- (void)setArgument:(id)firstArgument list:(va_list)argumentList;
- (void)setReturning:(id)aReturning;
- (void)setNegative:(BOOL)isNegative;
- (void)setAsynchronous:(BOOL)isAsynchronous;

@end
