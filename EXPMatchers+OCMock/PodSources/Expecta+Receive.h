#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import "RXPObjectify.h"
#import "RXPMacros.h"

#define any() [EXMAny any]
#define method(x)  method(@selector(x))
#define returning(x) returning(RXPObjectify(x))

#define with(...) RXP_OBJECTIFY_ARGS(RXP_VA_NARGS(__VA_ARGS__), __VA_ARGS__, [EXMArgStop value])

//#define with(...) with(ENCODE(count,__VA_ARGS__), [EXMArgStop value])

@interface EXPExpect (receiveMatcher)

@property (nonatomic, readonly) EXPExpect *(^ method) (SEL);

/// If you need to pass a scalar, you may wrap it by EXPObjectify. Or use EXPObjectify's output, like @3 for 3
@property (nonatomic, readonly) EXPExpect *(^ with) (id firstObject, ...);

@property (nonatomic, readonly) EXPExpect *(^ returning) (id);

@property (nonatomic, readonly) EXPExpect *(^ beCalled) (void);

@end;

