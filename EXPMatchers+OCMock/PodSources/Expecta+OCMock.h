#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import "EXMStubs.h"

#define any() [EXMAny any]
#define method(x)  method(@selector(x))
#define returning(x) returning(EXPObjectify(x))


#define VA_NARGS_IMPL(_1, _2, _3, _4, _5, N, ...) N
#define VA_NARGS(...) VA_NARGS_IMPL(__VA_ARGS__, 5, 4, 3, 2, 1)

#define ENCODE0(x) EXPObjectify(x)
#define ENCODE1(x,...) EXPObjectify(x), ENCODE0(__VA_ARGS__)
#define ENCODE2(x,...) EXPObjectify(x), ENCODE1(__VA_ARGS__)
#define ENCODE3(x,...) EXPObjectify(x), ENCODE2(__VA_ARGS__)
#define ENCODE4(x,...) EXPObjectify(x), ENCODE3(__VA_ARGS__)
#define ENCODE5(x,...) EXPObjectify(x), ENCODE4(__VA_ARGS__)
#define ENCODE6(x,...) EXPObjectify(x), ENCODE5(__VA_ARGS__)
//Add more pairs if required. 6 is the upper limit in this case.
#define ENCODE(i,...) ENCODE##i(__VA_ARGS__) //i is the number of arguments (max 6 in this case)

#define FOO_IMPL2(count,...) with(ENCODE(count,__VA_ARGS__))

#define FOO_IMPL(count, ...) FOO_IMPL2(count, __VA_ARGS__) 
#define with(...) FOO_IMPL(VA_NARGS(__VA_ARGS__), __VA_ARGS__, [EXMArgStop value])

//#define with(...) with(ENCODE(count,__VA_ARGS__), [EXMArgStop value])

@interface EXPExpect (receiveMatcher)

@property (nonatomic, readonly) EXPExpect *(^ method) (SEL);

/// If you need to pass a scalar, you may wrap it by EXPObjectify. Or use EXPObjectify's output, like @3 for 3
@property (nonatomic, readonly) EXPExpect *(^ with) (id firstObject, ...);

@property (nonatomic, readonly) EXPExpect *(^ returning) (id);

@property (nonatomic, readonly) EXPExpect *(^ beCalled) (void);

@end;

