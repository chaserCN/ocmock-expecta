//
//  ORExpectaOCMockMatcher.h
//  Pods
//
//  Created by Nicolas on 3/22/16.
//
//

#import <Expecta/Expecta.h>
#import <OCMock/OCPartialMockObject.h>

@interface ORExpectaOCMockMatcher : NSObject <EXPMatcher>
@property (nonatomic, assign) SEL selector;
@property (nonatomic, copy) NSArray *arguments;
@property (nonatomic, strong) id returning;

@property (nonatomic, strong) OCPartialMockObject *mock;

- (instancetype)initWithExpectation:(EXPExpect *)expectation;

- (void)setArgument:(id)firstArgument list:(va_list)argumentList;

@end
